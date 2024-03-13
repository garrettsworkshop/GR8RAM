module GR8RAM2(
	/* Clock signals */
	input C25M,
	input PHI0,
	input nRESin,
	output reg nRESout,
	input [1:0] SetFW,
	output reg nIRQout,
	input [15:0] BA,
	input nWE,
	inout [7:0] BD,
	output BDdir,
	/* Card select signals */
	input nIOSEL, 
	input nDEVSEL, 
	input nIOSTRB,
	/* SDRAM bus */
	output reg [1:0] RBA,
	output reg [12:0] RA,
	output nRCS,
	output reg nRAS,
	output reg nCAS,
	output reg nRWE,
	output reg DQML,
	output reg DQMH,
	output reg RCKE,
	output reg [7:0] RD,
	/* SPI NOR flash */
	output reg nFCS,
	output reg FCK,
	inout MISO,
	inout MOSI);

	/* PHI0 synchronization signals */
	reg PHI0r0, PHI0r1;
	always @(negedge C25M) begin PHI0r0 <= PHI0; end
	always @(posedge C25M) begin PHI0r1 <= PHI0r0; end
	
	/* Reset synchronization */
	reg nRESr0, nRESr;
	always @(negedge C25M) nRESr0 <= nRESin;
	always @(posedge C25M) nRESr <= nRESr0;
	wire RES = RES;

	/* Firmware select */
	input [1:0] SetFW;
	reg [1:0] SetFWr;
	reg SetFWLoaded = 0;
	always @(posedge C25M) begin
		if (!SetFWLoaded) begin
			SetFWLoaded <= 1;
			SetFWr[1:0] <= SetFW[1:0];
		end
	end
	wire [1:0] SetROM = ~SetFWr[1:0];
	wire SetEN16MB = SetROM[1:0]==2'b11;
	wire SetEN24b = SetROM[1];

	/* State counters */
	reg [2:0] IS = 0;
	reg [24:0] S = 0;
	wire Ready = IS[2];

	/* Reset output disable */
	assign nRESout = Ready;

	/* Init state counter control */
	// IS 0 - wait and issue NOP CKE (ends at S[19:0]==20'hFFFFF)
	// IS 1 - Load mode and AREF, issue SPI NOR read (ends at S[4:0]==5'h3F)
	// IS 2 - Write driver (ends at S[16:0]==17'h1FFFF)
	// IS 3 - Write image (ends at S[24:0]==25'h1FFFFFF)
	// IS 7 - Operating mode
	always @(posedge C25M) begin
		case (IS[2:0]) begin
			3'h0: if (S[19:0]==  20'hFFFFF) IS[2:0] <= 3'h1;
			3'h1: if (S[19:0]==      5'h3F) IS[2:0] <= 3'h2;
			3'h2: if (S[19:0]==  17'h1FFFF) IS[2:0] <= 3'h3;
			3'h3: if (S[19:0]==25'h1FFFFFF) IS[2:0] <= 3'h7;
		end
	end

	/* RAM state counter control */
	always @(posedge C25M) begin
		if (IS[2:0]==3'h0 && S[19:0]==  20'hFFFFF ||
			IS[2:0]==3'h1 && S[19:0]==      5'h3F ||
			IS[2:0]==3'h2 && S[19:0]==  17'h1FFFF ||
			IS[2:0]==3'h3 && S[19:0]==25'h1FFFFFF) S <= 0;
		else if (Ready) begin
			S[24:4] <= 0;
			if (S[3:0]==0 && PHI0r1) S[2:0] <= 4'h1;
			else if (S[3:0]!=0) S[3:0] <= S[3:0]+4'h1;
		end else S[24:0] <= S[24:0]+25'h1;
	end

	/* IOROMEN control */
	reg IOROMEN = 0;
	always @(posedge C25M) begin
		if (RES) IOROMEN <= 0;
		else if (S[2:0]==3'h2) begin
			if (!nIOSTRB && BA[10:0]==11'h7FF) IOROMEN <= 0;
			else if (!nIOSEL) IOROMEN <= 1;
		end
	end

	/* RegEN control */
	reg RegEN = 0;
	always @(posedge C25M) begin
		if (RES) RegEN <= 0;
		else if (S[2:0]==3'h2 && !nIOSEL) RegEN <= 1;
	end

	/* ROM bank register */
	reg Bank = 0;
	always @(posedge C25M, negedge nRESr) begin
		if (RES) Bank <= 0;
		else if (S[2:0]==3'h4 && BankSEL && !nWEr) begin
			Bank <= RD[0];
		end
	end

	/* RAMROMCS command signal */
	reg RAMROMCS;
	always @(posedge C25M) begin
		if (S[3:0]==4'h0) RAMROMCS <= !RES &&PHI0r1 && BA[15:12]==4'hC;
		else if S[3:0]==4'h1) begin
			RAMROMCS <= !RES && (
				(!nIOSEL) ||
				(!nIOSTRB && IOROMEN) ||
				(!nDEVSEL && RegEN && A[3:0]==4'h3));
		end else if (S[3:0]==4'h9) RAMROMCS <= !RES && RefC[2:0]==0;
	end

	/* Register select command signals */
	reg RAMRegSEL;
	reg AddrHWR, AddrMWR, AddrLWR;
	always @(posedge C25M) begin
		RAMRegSEL <= !RES && S[3:0]==4'h6 !nDEVSEL && BA[3:0]==4'h3;
		AddrHWR <=   !RES && S[3:0]==4'h6 !nDEVSEL && BA[3:0]==4'h2;
		AddrMWR <=   !RES && S[3:0]==4'h6 !nDEVSEL && BA[3:0]==4'h1;
		AddrLWR <=   !RES && S[3:0]==4'h6 !nDEVSEL && BA[3:0]==4'h0;
	end

	/* Slinky address registers */
	reg [23:0] Addr = 0;
	reg AddrIncL = 0;
	reg AddrIncM = 0;
	reg AddrIncH = 0;
	always @(posedge C25M, negedge nRESr) begin
		if (RES) begin
			Addr[23:0] <= 0;
			AddrIncL <= 0;
			AddrIncM <= 0;
			AddrIncH <= 0;
		end else begin
			if (RAMRegSEL) AddrIncL <= 1;
			else AddrIncL <= 0;

			if (AddrLWR) begin
				Addr[7:0] <= RD[7:0];
				AddrIncM <= Addr[7] && !RD[7];
			end else if (AddrIncL) begin
				Addr[7:0] <= Addr[7:0]+1;
				AddrIncM <= Addr[7:0]==8'hFF;
			end else AddrIncM <= 0;

			if (AddrMWR) begin
				Addr[15:8] <= RD[7:0];
				AddrIncH <= Addr[15] && !RD[7];
			end else if (AddrIncM) begin
				Addr[15:8] <= Addr[15:8]+1;
				AddrIncH <= Addr[15:8]==8'hFF;
			end else AddrIncH <= 0;

			if (AddrHWR) begin
				Addr[23:16] <= RD[7:0];
			end else if (AddrIncH) begin
				Addr[23:16] <= Addr[23:16]+1;
			end
		end
	end

	/* Apple II data output latch */
	reg [7:0] BDout;
	always @(negedge C25M) begin
		if (S[2:0]==4'h6) begin
			if (!nDEVSEL) case (BA[1:0])
				4'h3: BDout[7:0] <= RD[7:0];
				4'h2: BDout[7:0] <= SetEN24b ? Addr[23:16] { 4'hF, Addr[19:16] };
				4'h1: BDout[7:0] <= Addr[15:8];
				4'h0: BDout[7:0] <= Addr[7:0];
				defaut: BDout[7:0] <= 0;
			endcase else BDout[7:0] <= RD[7:0];
		end
	end

	always @(posedge C25M) begin
		case (IS[2:0])
			3'h0: begin
				// NOP CKE
			end 3'h1: case (S[4:0])
				5'h00: begin
					// PC all CKE
				end 5'h08: begin
					// LDM CKE
				end 5'h10, 5'h12, 5'h14, 5'h16,
					5'h18, 5'h1A, 5'h1C, 5'h1E: begin
					// AREF CKE
				end default: begin
					// NOP CKE
				end
			endcase 3'h2, 3'h3: case (S[2:0])
				3'h0: begin
					// NOP CKE
				end 3'h1: begin
					// AREF CKE
				end 3'h2: begin
					// NOP CKE
				end 3'h3: begin
					// ACT CKE
				end 3'h4: begin
					// WR CKE
				end 3'h5: begin
					// WR CKE
				end 3'h6: begin
					// NOP CKE
				end 3'h7: begin
					// PC all CKD
				end
			endcase default: case (S[3:0])
				4'h1: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// NOP CKE
					end else begin
						// NOP CKD
					end
				end 4'h2: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// ACT CKE
					end else begin
						// NOP CKD
					end
				end 4'h3: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// RD CKE
					end else begin
						// NOP CKD
					end
				end 4'h4: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// PC all CKE
					end else begin
						// NOP CKD
					end
				end 4'h5: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// NOP CKD
					end else begin
						// NOP CKE
					end
				end 4'h6: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// NOP CKD
					end else begin
						// ACT CKE
					end
				end 4'h7: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// NOP CKD
					end else begin
						// WR CKE
					end
				end 4'h8: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// NOP CKD
					end else begin
						// NOP CKE
					end
				end 4'h9: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else if (nWE) begin
						// NOP CKD
					end else begin
						// PC all CKD
					end
				end 4'hA: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else begin
						// NOP CKE
					end
				end 4'hB: begin
					if (!RAMROMCS) begin
						// NOP CKD
					end else begin
						// AREF CKE
					end
				end default: begin
					// NOP CKD
				end
			endcase
		endcase
	end

	/* DMA/INT in/out */
	input INTin, DMAin;
	output INTout = INTin;
	output DMAout = DMAin;

	/* Unused Pins */
	output RAdir = 1;
	output nDMAout = 1;
	output nNMIout = 1;
	output nINHout = 1;
	output nRDYout = 1;
	output nIRQout = 1;
	output RWout = 1;
endmodule
