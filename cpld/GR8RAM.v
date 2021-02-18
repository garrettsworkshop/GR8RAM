module GR8RAM(C25M, PHI0, nPBOD, nBOD, nRES,
			  nIOSEL, nDEVSEL, nIOSTRB,
			  RA, nWEin, nWEout, Adir,
			  RD, Ddir,
			  DMAin, DMAout, INTin, INTout,
			  nDMA, nRDY, nNMI, nIRQ, nINH, nRESout
			  SBA, SA, nRCS, nRAS, nCAS, nSWE, DQML, DQMH, RCKE, SD,
			  nFCS, FCK, MISO, MOSI);

	/* Clock signals */
	input C25M, PHI0;
	reg PHI0r1, PHI0r2, PHI0r3;
	always @(negedge C25M) begin PHI0r1 <= PHI0; end
	always @(posedge C25M) begin
		PHI0r2 <= PHI0r1; PHI0r3 <= PHI0r2;
	end

	/* Reset/brown-out detect inputs */
	input nRES, nPBOD, nBOD;
	reg PBODr1, PBODr2, BODr1, BODr2, RESr1, RESr2;
	always @(negedge C25M) begin
		PBODr1 <= ~nPBOD; BODr1 <= ~nBOD; RESr1 <= ~nRES;
	end
	always @(posedge C25M) begin
		PBODr2 <= PBODr1; BODr2 <= BODr1; RESr2 <= RESr1;
	end

	/* Apple IO area select signals */
	input nIOSEL, nDEVSEL, nIOSTRB;
	reg DEVSELr1, DEVSELr2;
	always @(negedge C25M) begin DEVSELr1 <= ~nDEVSEL; end
	always @(posedge C25M) begin DEVSELr2 <= DEVSELr1; end

	/* DMA/IRQ daisy chain */
	input DMAin, INTin;
	output DMAout = DMAin;
	output INTout = INTin;

	/* Apple open-drain outputs */
	output nDMA = 1;
	output nRDY = 1;
	output nNMI = 1;
	output nIRQ = 1;
	output nINH = 1;
	output nRESout = 0;

	/* Apple address bus */
	input [15:0] RA;
	input nWEin;
	output RAdir = 1;
	output nWEout = 1;
	reg [15:0] RAr1; reg nWEr1;
	reg [15:0] RAr2; reg nWEr2;
	reg [15:0] RAcur; reg nWEcur;
	always @(negedge C25M) begin RAr1 <= RA; nWEr1 <= nWE; end
	always @(posedge C25M) begin RAr2 <= RAr1; nWEr2 <= nWEr1; end
	always @(posedge C25M) begin
		if (S==0 && ~PHI0r2) begin
			RAcur <= RAr2;
			nWEcur <= nWER2;
		end
	end

	/* Apple select signals */
	wire ROMSpecSEL = RAcur[15:12]==4'hC && RAcur[11:8]!=4'h0;
	wire ROMSpecRD = ROMSpecSEL && nWE;
	wire RAMSpecSEL = RAcur[15:12]==4'hC && RAcur[11:8]==4'h0 && RAcur[7] && RAcur[7:4]!=4'h8 && RAcur[3:0]==4'h3;
	wire RAMSpecRD = RAMSpecSEL && nWE;
	wire RAMSpecWR = RAMSpecSEL && ~nWE;
	wire SpecRD = ROMSpecRD || RAMSpecRD;
	reg RAMRD = 0, RAMWR = 0;
	always @(posedge C25M) begin
		if (S==5) begin
			RAMRD <= RAMSpecRD && DEVSELr2;
			RAMWR <= RAMSpecWR && DEVSELr2;
		end else if (S==0) begin
			RAMRD <= 0;
			RAMWR <= 0;
		end
	end 

	/* Apple data bus */
	inout [7:0] RD = RDdir ? 8'bZ : RDout[7:0];
	reg RDdir = 1;
	reg [7:0] RDout;

	/* SDRAM data bus */
	inout [7:0] SD = SDOE ? RD[7:0] : 8'bZ;
	reg SDOE = 0;

	/* SDRAM address/command */
	output reg [1:0] SBA;
	output reg [12:0] SA;
	output reg RCKE = 1;
	output reg nRCS = 1;
	output reg nRAS = 1;
	output reg nCAS = 1;
	output reg nSWE = 1;
	output reg DQMH = 1;
	output reg DQML = 1;

	/* SPI flash */
	output reg nFCS = 1;
	output reg FCK = 0;
	output reg MOSI = MOSIOE ? MOSIout : 1'bZ;
	reg MOSIOE = 0;
	reg MOSIout;
	input MISO;

	/* State counters */
	reg [24:0] FS = 0;
	always @(posedge C25M) begin FS <= FS+1; end
	reg [2:0] S = 0;
	always @(posedge C25M) begin
		if (S==0 && PHI0r2 && ~PHI0r3 && ~RESr2 && ~BODr2) S <= 1;
		else if (S==0) S <= 0;
		else S <= S+1;
	end

	/* Refresh state */
	reg RefReady = 0;
	reg RefDone = 0;
	always @(posedge C25M) begin RefReady <= S==0; end
	always @(posedge C25M) begin
		if (FS[6:0]==7'h00) RefDone <= 0;
		else (S==0 && RefReady && RCKE && ~(PHI0r2 && ~PHI0r3)) RefDone <= 1;
	end

	/* Slinky registers */
	reg [24:0] Addr;
	wire AddrHSpecSEL = RAcur[3:0]==4'h2;
	wire AddrMSpecSEL = RAcur[3:0]==4'h1;
	wire AddrLSpecSEL = RAcur[3:0]==4'h0;
	always @(posedge C25M) begin
		if (S==7 && DEVSELr2) begin
			if (AddrHSpecSEL || AddrMSpecSEL || AddrLSpecSEL) begin
				Addr[24] <= 1'b0;
			end

			if (AddrHSpecSEL) begin
				Addr[23:16] <= RD[7:0];
			end else if (RAMRD || RAMWR || 
				(AddrMSpecSEL && Addr[15] && ~RD[7]) ||
				(AddrLSpecSEL && Addr[7]  && ~RD[7] && Addr[15:8]==8'hFF)) begin
				Addr[23:16] <= Addr[23:16]+1;
			end

			if (AddrMSpecSEL) begin
				Addr[15:8] <= RD[7:0];
			end else if (RAMRD || RAMWR || 
				(AddrLSpecSEL && Addr[7] && ~RD[7])) begin
				Addr[15:8] <= Addr[15:8]+1;
			end

			if (AddrLSpecSEL) begin
				Addr[7:0] <= RD[7:0];
			end else if (RAMRD || RAMWR) begin
				Addr[7:0] <= Addr[7:0]+1;
			end
		end
	end

	always @(posedge C25M) begin
		if (S==0) begin
			if ((PHI0r2 && ~PHI0r3 && ~RESr2 && ~BODr2 && SpecRD) || 
				(~RefReady && ~RefDone)) begin
				// NOP cken
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end else if (RefReady && ~RefDone && RCKE && 
				~(PHI0r2 && ~PHI0r3)) begin
				// AREF
				RCKE <= 1'b1;
				nRCS <= 1'b0;
				nRAS <= 1'b0;
				nCAS <= 1'b0;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end	
		end else if (S==4'h1) begin
			if (SpecRD) begin
				// ACT
				RCKE <= 1'b1;
				nRCS <= 1'b0;
				nRAS <= 1'b0;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;

				if (RAMSpecRD) begin
					RBA[1] <= Addr[24];
					RBA[0] <= Addr[23];
					RA[12:0] <= Addr[22:10];
				end else begin
					RBA[1] <= 1'b1;
					RBA[0] <= 1'b0;
					RA[12:10] <= 3'b000;
					RA[9:2] <= Bank[7:0];
					RA[1:0] <= RAcur[11:10];
				end
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
		end else if (S==4'h2) begin
			if (SpecRD) begin
				// RD auto-PC
				RCKE <= 1'b1;
				nRCS <= 1'b0;
				nRAS <= 1'b1;
				nCAS <= 1'b0;
				nSWE <= 1'b1;

				A[12:11] <= 1'b0; // don't care
				A[10] <= 1'b1; // auto-precharge
				A[9] <= 1'b0; // don't care
				if (RAMSpecRD) begin
					RBA[1] <= Addr[24];
					RBA[0] <= Addr[23];
					RA[8:0] <= Addr[9:1];
					DQMH <= ~Addr[0];
					DQML <= Addr[0];
				end else /* ROMSpecRD */ begin
					RBA[1] <= 1'b1;
					RBA[0] <= 1'b0;
					RA[8:0] <= RAcur[9:1];
					DQMH <= ~RAcur[0];
					DQML <= RAcur[0];
				end
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
		end else if (S==4'h3) begin
			if (SpecRD) begin
				// NOP cken
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
		end else if (S==4'h4) begin
			if (RAMSpecWR) begin
				// NOP cken
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
		end else if (S==4'h5) begin
			if (RAMSpecWR && DEVSELr2) begin
				// ACT
				RCKE <= 1'b1;
				nRCS <= 1'b0;
				nRAS <= 1'b0;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;

				BA[1] <= Addr[24];
				BA[0] <= Addr[23];
				A[12:0] <= Addr[22:10];
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
		end else if (s==4'h6) begin
			if (RAMWR) begin
				// WR auto-PC
				RCKE <= 1'b1;
				nRCS <= 1'b0;
				nRAS <= 1'b1;
				nCAS <= 1'b0;
				nSWE <= 1'b0;

				BA[1] <= Addr[24];
				BA[0] <= Addr[23];
				A[12:11] <= 1'b0; // don't care
				A[10] <= 1'b1; // auto-precharge
				A[9:0] <= Addr[9:0];
				DQMH <= ~Addr[10];
				DQML <= Addr[10];
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
		end else if (S==4'h7) begin
			if (RAMSpecWR) begin
				// NOP cken
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end else begin
				// NOP ckdis
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
		end
	end
endmodule
