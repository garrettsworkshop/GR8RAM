	module BusInterface(
		/* Clock signal inputs */
		input CLK,
		input PHI0,
		/* Apple II reset input */
		input nRES,
		/* Card select signal inputs */
		input nDEVSEL,
		input nIOSEL,
		input nIOSTRB,
		/* Buffered address, write enable inputs */
		input [10:0] BA,
		input nWE,
		/* Data bus mux inputs */
		input [7:0] RDD,
		input [23:0] Addr,
		/* Buffered data bus output and BD buffer control */
		inout [7:0] BD,
		output nDoutOE,
		output nDinOE,
		/* Write data output to slinky registers and RAM controller */
		output reg [7:0] WRD,
		/* Bus command enable input from initialization controller */
		input BusEnable,
		/* SDRAM command outputs */
		output reg RAMRD,
		output reg RAMWR,
		output reg ROMRD,
		output reg RAMRef,
		/* Register command outputs */
		output reg BankWR,
		output reg AddrInc,
		output reg AddrHWR,
		output reg AddrMWR,
		output reg AddrLWR,
		output reg RegReset);

	/* PHI0 synchronization */
	reg [4:0] PHI0r;
	always @(negedge CLK) PHI0r[0] <= PHI0;
	always @(posedge CLK) PHI0r[4:1] <= PHI0r[3:0];
	wire PHI0rise = !PHI0r[2] &&  PHI0r[1];

	/* Reset synchronization */
	reg nRESr; always @(negedge PHI0) nRESr <= nRES;

	/* Bus state counter
	 * S0 - idle/bus disabled
	 * S1-SB - PHI0
	 * SC - wait until PHI1
	 * SD-SF - PHI1 */
	reg [3:0] S = 0;
	always @(posedge CLK) begin
		if (S==4'h0 && BusEnable && PHI0rise) S <= 4'h1;
		else if (S==4'hC && !PHI0r[2]) S <= 4'hD;
		else S <= S+4'h1;
	end

	/* Refresh counter */
	reg [2:0] RefC;
	wire [2:0] RefCTC = RefC[2:0]==3'h6;
	always @(posedge CLK) begin
		if (RefC==RefCTC) RefC <= 3'h0;
		else RefC <= RefC+3'h1;
	end

	/* Register reset command generation */
	always @(posedge CLK) begin
		if (S==4'h0 && !BusEnable) RegReset <= 1;
		else if (S==4'h1) RegReset <= !nRESr;
	end

	/* Register enable */
	reg RegEN;
	always @(posedge CLK) begin 
		if (RegReset) RegEN <= 0;
		else if (S==4'h6 && !nIOSEL) RegEN <= 1;
	end

	/* IOSTRB ROM enable */
	reg IOROMEN;
	always @(posedge CLK) begin
		if (RegReset) IOROMEN <= 0;
		else if (S==4'h6 && !nIOSEL && BA[10:0]==11'h7FF) IOROMEN <= 0;
		else if (S==4'h6 && !nIOSEL) IOROMEN <= 1;
	end

	/* Write data latch */
	always @(negedge PHI0) WRD[7:0] <= BD[7:0];

	/* Register and RAM write command generation */
	reg BankWRpre;
	reg RAMWRpre;
	reg AddrHWRpre;
	reg AddrMWRpre;
	reg AddrLWRpre;
	always @(posedge CLK) begin
		if (S==6) begin
			BankWRpre <=  S==4'h6 && !nDEVSEL && BA[3:0]==4'hF && !nWE;
			RAMWRpre <=   S==4'h6 && !nDEVSEL && BA[3:0]==4'h3 && !nWE;
			AddrHWRpre <= S==4'h6 && !nDEVSEL && BA[3:0]==4'h2 && !nWE;
			AddrMWRpre <= S==4'h6 && !nDEVSEL && BA[3:0]==4'h1 && !nWE;
			AddrLWRpre <= S==4'h6 && !nDEVSEL && BA[3:0]==4'h0 && !nWE;
		end else if (S==0) begin
			BankWRpre <= 0;
			RAMWRpre <= 0;
			AddrHWRpre <= 0;
			AddrMWRpre <= 0;
			AddrLWRpre <= 0;
		end
		BankWR <=  S==4'hD && BankWRpre && RegEN;
		RAMWR <=   S==4'hD && RAMWRpre && RegEN;
		AddrHWR <= S==4'hD && AddrHWRpre && RegEN;
		AddrMWR <= S==4'hD && AddrMWRpre && RegEN;
		AddrLWR <= S==4'hD && AddrLWRpre && RegEN;
	end
	
	/* Address increment command generation after RAMWR */
	always @(posedge CLK) AddrInc <= S==4'hF && RAMWRpre;

	/* RAM read command generation */
	always @(posedge CLK) begin
		RAMRD <= S==4'h6 &&  !nDEVSEL && BA[3:0]==4'h3 &&  nWE;
		ROMRD <= S==4'h6 && (!nIOSEL || (!nIOSTRB && IOROMEN && BA[10:0]!=11'h7FF));
	end

	/* RAM refresh command generation */
	always @(posedge CLK) RAMRef <= S==4'h1 && RefCTC;

	/* Data bus output mux */
	reg [7:0] BDout;
	reg BDoutLE;
	always @(posedge CLK) BDoutLE <= S==4'hB;
	always @(posedge CLK) begin
		if (BDoutLE) begin
			if (nDEVSEL) BDout[7:0] <= RDD[7:0];
			else case (BA[3:0])
				4'hF: BDout[7:0] <= 0;
				4'hE: BDout[7:0] <= 0;
				4'hD: BDout[7:0] <= 0;
				4'hC: BDout[7:0] <= 0;
				4'hB: BDout[7:0] <= 0;
				4'hA: BDout[7:0] <= 0;
				4'h9: BDout[7:0] <= 0;
				4'h8: BDout[7:0] <= 0;
				4'h7: BDout[7:0] <= 8'h10; // Hex 10 (meaning firmware 1.0)
				4'h6: BDout[7:0] <= 8'h41; // ASCII "B" (meaning rev. B)
				4'h5: BDout[7:0] <= 8'h05; // Hex 05 (meaning "4205")
				4'h4: BDout[7:0] <= 8'h47; // ASCII "G" (meaning "GW")
				4'h3: BDout[7:0] <= RDD[7:0];
				4'h2: BDout[7:0] <= Addr[23:16];
				4'h1: BDout[7:0] <= Addr[15:8];
				4'h0: BDout[7:0] <= Addr[7:0];
			endcase
		end
	end

	/* Card select signal */
	wire CardSEL = !nDEVSEL || !nIOSEL || (!nIOSTRB && IOROMEN && BA[10:0]!=11'h7FF);

	/* Data bus buffer OE control */
	assign nDinOE =  !(PHI0 && !nWE);
	assign nDoutOE = !(CardSEL &&  nWE && PHI0r[4] && PHI0);
	wire BDOE =       (CardSEL &&  nWE && PHI0r[4]);
	assign BD[7:0] = BDOE ? BDout[7:0] : 8'bZ;

endmodule