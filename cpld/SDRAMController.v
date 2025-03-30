module SDRAMController(
	/* Clock signal */
	input CLK,
	/* POR input from init controller */
	input InitDone,
	/* Command inputs from bus interface */
	input BI_RAMRD,
	input BI_RAMWR,
	input BI_RAMRef,
	input [23:0] Addr,
	input [7:0] BD,
	/* Command inputs from init controller */
	input [2:0] IC_RAMCmd,
	input [24:0] IC_Addr,
	input [7:0] IC_WRD,
	/* SDRAM bus */
	output RCLK,
	output reg [1:0] RBA,
	output reg [12:0] RA,
	output reg RCKE,
	output nRCS,
	output reg nRAS,
	output reg nCAS,
	output reg nRWE,
	output reg DQML,
	output reg DQMH,
	inout [7:0] RD,
	/* SDRAM read data */
	output reg [7:0] RDD);

	`define RC_NOP (3'h0)
	`define RC_LDM (3'h1)
	`define RC_ACT (3'h2)
	`define RC_WR  (3'h3)
	`define RC_PC  (3'h4)
	`define RC_Ref (3'h5)

	reg [2:0] RS = 0;
	reg [1:0] CS = 0;

	always @(posedge CLK) begin
		case (RS)
			3'h0: begin // Power-on reset & initialization
				if (InitDone) RS <= 3'h2;
				CS <= 2'h0;
			end 3'h2: begin // Idle
				if (BI_RAMRD) RS <= 3'h3;
				else if (BI_RAMWR) RS <= 3'h4;
				else if (BI_RAMRef) RS <= 3'h5;
				CS <= 2'h0;
			end 3'h3, 3'h4, 3'h5: begin // Read, write, refresh
				if (CS==2'h3) RS <= 3'h2;
				CS <= CS+2'h1;
			end default: RS <= 2;
		endcase
	end

	always @(posedge CLK) begin
		case (RS)
			3'h0: case (IC_RAMCmd) // Power-on reset and initialization
				`RC_LDM: begin
					RCKE <= 1;
					nRAS <= 0;
					nCAS <= 0;
					nRWE <= 0;
					DQML <= 1;
					DQMH <= 1;
					RBA[1:0] <= 2'b00;
					RA[12:0] <= 13'b0001000100000;
				end `RC_ACT: begin
					RCKE <= 1;
					nRAS <= 0;
					nCAS <= 1;
					nRWE <= 1;
					RBA[1:0] <= IC_Addr[11:10];
					RA[12:0] <= IC_Addr[24:12];
				end `RC_WR: begin
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 0;
					nRWE <= 0;
					DQML <=  IC_Addr[0];
					DQMH <= !IC_Addr[0];
					RBA[1:0] <= IC_Addr[11:10];
					RA[12:11] <= 2'b00;
					RA[10] <= 1'b0; // no auto-precharge
					RA[9] <= 1'b0;
					RA[8:0] <= IC_Addr[9:1];
				end `RC_PC: begin
					RCKE <= 1;
					nRAS <= 0;
					nCAS <= 1;
					nRWE <= 0;
					RA[10] <= 1'b1; // precharge all
				end `RC_Ref: begin
					RCKE <= 1;
					nRAS <= 0;
					nCAS <= 0;
					nRWE <= 1;
				end `RC_NOP: begin
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 1;
					nRWE <= 1;
				end default: begin
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 1;
					nRWE <= 1;
				end
			endcase 3'h2: begin // Idle
				RCKE <= BI_RAMRD || BI_RAMWR || BI_RAMRef;
				nRAS <= 1;
				nCAS <= 1;
				nRWE <= 1;
			end 3'h3, 3'h4: case (CS) // Read, write
				2'h0: begin
					// ACT CKE
					RCKE <= 1;
					nRAS <= 0;
					nCAS <= 1;
					nRWE <= 1;
					RBA[1:0] <= Addr[11:10];
					RA[12] <= 1'b0;
					RA[11:0] <= Addr[23:12];
				end 2'h1: begin
					// RD/WR CKE
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 0;
					nRWE <= 0;
					DQML <=  Addr[0];
					DQMH <= !Addr[0];
					RBA[1:0] <= Addr[11:10];
					RA[12:11] <= 2'b00;
					RA[10] <= 1'b0; // no auto-precharge
					RA[9] <= 1'b0;
					RA[8:0] <= Addr[9:1];
				end 2'h2: begin
					// NOP CKE
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 1;
					nRWE <= 1;
				end 2'h3: begin
					// PC all CKD
					RCKE <= 1;
					nRAS <= 0;
					nCAS <= 1;
					nRWE <= 0;
					RA[10] <= 1'b1; // precharge all
				end
			endcase 3'h5: case (CS) // Refresh
				2'h0: begin
					// AREF CKE
					RCKE <= 1;
					nRAS <= 0;
					nCAS <= 0;
					nRWE <= 1;
				end 2'h1: begin
					// NOP CKD
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 1;
					nRWE <= 1;
				end 2'h2: begin
					// NOP CKD
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 1;
					nRWE <= 1;
				end 2'h3: begin
					// NOP CKD
					RCKE <= 1;
					nRAS <= 1;
					nCAS <= 1;
					nRWE <= 1;
				end
			endcase default: begin // Invalid state
				// NOP CKE
				RCKE <= 1;
				nRAS <= 1;
				nCAS <= 1;
				nRWE <= 1;
				DQML <= 1;
			end
		endcase
	end
	
	/* Write data OE control */
	reg RDOE = 0;
	always @(posedge CLK) RDOE <= RS==3'h4; 
	assign RD[7:0] = RDOE ? (InitDone ? BD[7:0] : IC_WRD[7:0]) : 8'bZ;
	
	/* Read data latch control */
	reg RDDLE;
	always @(posedge CLK) RDDLE <= RS==3'h3 && CS==2'h3; 
	always @(negedge CLK) if (RDDLE) RDD[7:0] <= RD[7:0];
		
	assign nRCS = 0;
	
	/* SDRAM clock output */
	ODDRXE rclk_oddr(.D0(1'b0), .D1(1'b1), 
		.SCLK(CLK), .RST(1'b0), .Q(RCLK));
endmodule