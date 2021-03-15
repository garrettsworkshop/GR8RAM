module GR8RAM(C25M, PHI0, nPBOD, nBOD, nRES,
			  nIOSEL, nDEVSEL, nIOSTRB,
			  RA, nWE, nWEout, Adir,
			  RD, Ddir,
			  DMAin, DMAout, INTin, INTout,
			  nDMA, nRDY, nNMI, nIRQ, nINH, nRESout
			  SBA, SA, nRCS, nRAS, nCAS, nSWE, DQML, DQMH, RCKE, SD,
			  nFCS, FCK, MISO, MOSI);

	/* Clock signals */
	/* Outputs: C25M, PHI0r1, PHI0r2, */
	input C25M, PHI0;
	reg PHI0r0, PHI0r1, PHI0r2;
	always @(negedge C25M) begin PHI0r0 <= PHI0; end
	always @(posedge C25M) begin PHI0r1 <= PHI0r0; PHI0r2 <= PHI0r1; end

	/* Reset/brown-out detect synchronized inputs */
	/* Outputs: nRESr, nPBODr, nBODf */
	input nRES, nPBOD, nBOD;
	reg nRESr0, nRESr;
	reg nPBODr0, nPBODr;
	reg nBODr0, nBODr, nBODf0, nBODf;
	always @(posedge C25M) begin
		// Double-synchronize nBOD, nPBOD, nRES
		nPBODr0 <= nPBOD; nBODr0 <= nBOD; nRESr0 <= nRES;
		nPBODr <= nPBODr0; nBODr <= nBODr0; nRESr <= nRESr0;

		// Filter nBODr to get nBODf. Output hi when hi for $5E0F-$10000 cycles
		if (LS[15:0]==16'h5E0F) begin // When LS low-order is $5E0F
			nBODf0 <= nBODr; // "Precharge" nBODf0 
			nBODf <= nBODf0; // "Evaluate" computed nBODf0 into nBODf
		end else if (nBODr2) begin // Else AND nBODf0 with nBODr 
			nBODf0 <= nBODf0 && nBODr; 
		end
	end

	/* Long state counter: counts from 0 to $5F5E0F (6,249,999) *
	 * CSec: 1/2 Hz clock */
	/* Outputs: LS, CSec */
	reg [22:0] LS = 0;
	reg [1:0] CSec = 0;
	reg LSEN = 0;
	always @(posedge C25M) begin
		// Allow LS to fully count once nBODf active
		if (nBODf) LSEN <= 1;

		// LS rolls over at 24'h5F5E0F or at 16'h5E0F when LSEN is 0
		if ((LS[22:16]==7'h5F || ~LSEN) && LS[15:0]==16'h5E0F) LS <= 0;
		else LS <= LS+1;

		// Flip 1/2 Hz clocks when LS==23'h5F5E0F
		if (LS[22:0]==23'h5F5E0F) CSec <= CSec+1;
	end

	/* Init state */
	output reg nRESout = 0;
	reg InitActv = 0;
	reg InitIntr = 0;
	reg SDRAMActv = 0;
	always @(posedge C25M) begin
		if (~nBODf) begin
			nRESout <= 0;
			InitActv <= 0;
			InitIntr <= 1;
		end else if (LS[22:0]==23'h0FFF10) begin
			InitActv <= ~AppleActive;
			InitIntr <= 0;
		end else if (LS[22:0]==23'h504010) begin
			nRESout <= InitActv && ~InitIntr;
			InitActv <= 0;
			SDRAMActv <= InitActv && ~InitIntr;
		end
	end

	/* Apple IO area select signals */
	/* Outputs: DEVSELr */
	input nIOSEL, nDEVSEL, nIOSTRB;
	reg DEVSELr0, DEVSELr;
	always @(negedge C25M) begin DEVSELr0 <= ~nDEVSEL; end
	always @(posedge C25M) begin DEVSELr <= DEVSELr0; end

	/* DMA/IRQ daisy chain */
	input DMAin, INTin;
	output DMAout = DMAin;
	output INTout = INTin;

	/* Apple open-drain outputs */
	output nDMA = 1;
	output nRDY = 1;
	output nNMI = 1;
	output nIRQ = ~(TIRQEN && TIRQMask);
	output nINH = 1;

	/* Apple address bus */
	/* Outputs: RAr1, nWEr1 */
	input [15:0] RA;
	input nWE;
	output RAdir = 1;
	output nWEout = 1;
	reg [15:0] RAr0; reg nWEr0;
	reg [15:0] RAcur; reg nWEcur;
	always @(negedge C25M) begin RAr0 <= RA; nWEr0 <= nWE; end
	always @(posedge C25M) begin
		if (S==0 && PHI0r1 && ~PHI0r2) begin
			RAcur[15:0] <= RAr0[15:0];
			nWEcur <= nWEr0;
		end
	end

	/* Apple select signals */
	/* Outputs: ROMSpecRD, RAMSpecSEL, RAMSpecRD, RAMSpecWR, RAMSEL */
	wire ROMSpecRD = RAcur[15:12]==4'hC && RAcur[11:8]!=4'h0 && nWEcur;
	wire RAMSpecSEL = RAcur[15:12]==4'hC && RAcur[11:8]==4'h0 && RAcur[7] && RAcur[7:4]!=4'h8 && RAcur[3:0]==4'h3;
	wire RAMSpecRD = RAMSpecSEL && nWEcur;
	wire RAMSpecWR = RAMSpecSEL && ~nWEcur;
	reg RAMSEL = 0;
	wire RAMWR = RAMSEL && ~nWEcur;
	always @(posedge C25M) begin
		if (S==5) RAMSEL <= RAMSpecSEL && DEVSELr;
		else if (S==0) RAMSEL <= 0;
	end 

	/* Apple data bus */
	inout [7:0] RD = RDdir ? 8'bZ : RDout[7:0];
	reg [7:0] RDout;
	reg RDOE = 0;
	output RDdir = ~((~nDEVSEL || ~nIOSEL || (~nIOSTRB && IOEN)) &&
					 PHI0 && PHI0r2 && nWE && RDOE && ~BODf);

	/* Slinky address registers */
	reg [24:0] Addr;
	wire AddrHSpecSEL = RAcur[3:0]==4'h2;
	wire AddrMSpecSEL = RAcur[3:0]==4'h1;
	wire AddrLSpecSEL = RAcur[3:0]==4'h0;
	always @(posedge C25M) begin
		if (~nRESr) begin
			Addr[24] <= 1'b0;
			Addr[23:20] <= SetFW[1] ? 4'h0 : 4'hF;
			Addr[19:0] <= 20'h00000;
		end else if (S==7 && DEVSELr) begin
			if (AddrHSpecSEL || AddrMSpecSEL || AddrLSpecSEL) begin
				Addr[24] <= 1'b0;
			end

			if (AddrHSpecSEL) begin
				Addr[23:16] <= { SetFW[1] ? RD[7:4] : 4'hF, RD[3:0] };
			end else if ((RAMSEL && Addr[15:0]==16'hFFFF) || 
				(AddrMSpecSEL && Addr[15] && ~RD[7]) ||
				(AddrLSpecSEL && Addr[7]  && ~RD[7] && Addr[15:8]==8'hFF)) begin
				Addr[23:16] <= Addr[23:16]+1;
			end

			if (AddrMSpecSEL) begin
				Addr[15:8] <= RD[7:0];
			end else if ((RAMSEL && Addr[7:0]==8'hFF) || 
				(AddrLSpecSEL && Addr[7] && ~RD[7])) begin
				Addr[15:8] <= Addr[15:8]+1;
			end

			if (AddrLSpecSEL) begin
				Addr[7:0] <= RD[7:0];
			end else if (RAMSEL) begin
				Addr[7:0] <= Addr[7:0]+1;
			end
		end
	end

	/* SPI flash */
	output reg nFCS = 1;
	output reg FCK = 0;
	output reg MOSI = MOSIOE ? MOSIout : 1'bZ;
	reg MOSIOE = 0;
	reg MOSIout;
	input MISO;

	/* SPI flash control */
	always @(posedge C25M) begin
		if (InitActv) begin
			// Pulse clock from init states $0FFFC0 to $907FFF
			if (LS[22:0]>=23'h0FFFC0 && LS[22:0]<=23'h907FFF) FCK <= LS[0];
			end else FCK <= 0;

			// Flash /CS enabled from init states $0FFFB0 to s$90800F
			if (LS[22:0]>=23'h0FFFB0 && LS[22:0]<=23'h90800F) nFCS <= 0;
			end else nFCS <= 1;

			// Send command $3B (read) (MSB first)
			if 		(LS[22:0]==23'h0FFFB0 || LS[22:0]==23'h0FFFB1) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFB2 || LS[22:0]==23'h0FFFB3) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFB4 || LS[22:0]==23'h0FFFB5) MOSIout <= 1;
			else if	(LS[22:0]==23'h0FFFB6 || LS[22:0]==23'h0FFFB7) MOSIout <= 1;
			else if	(LS[22:0]==23'h0FFFB8 || LS[22:0]==23'h0FFFB9) MOSIout <= 1;
			else if	(LS[22:0]==23'h0FFFBA || LS[22:0]==23'h0FFFBB) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFBC || LS[22:0]==23'h0FFFBD) MOSIout <= 1;
			else if	(LS[22:0]==23'h0FFFBE || LS[22:0]==23'h0FFFBF) MOSIout <= 1;
			// Send 24-bit address (MSB first)
			else if (LS[22:0]==23'h0FFFC0 || LS[22:0]==23'h0FFFC1) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFC2 || LS[22:0]==23'h0FFFC3) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFC4 || LS[22:0]==23'h0FFFC5) MOSIout <= SetFW[1];
			else if	(LS[22:0]==23'h0FFFC6 || LS[22:0]==23'h0FFFC7) MOSIout <= SetFW[0];
			else if	(LS[22:0]==23'h0FFFC8 || LS[22:0]==23'h0FFFC9) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFCA || LS[22:0]==23'h0FFFCB) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFCC || LS[22:0]==23'h0FFFCD) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFCE || LS[22:0]==23'h0FFFCF) MOSIout <= 0;
			else if (LS[22:0]==23'h0FFFD0 || LS[22:0]==23'h0FFFD1) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFD2 || LS[22:0]==23'h0FFFD3) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFD4 || LS[22:0]==23'h0FFFD5) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFD6 || LS[22:0]==23'h0FFFD7) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFD8 || LS[22:0]==23'h0FFFD9) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFDA || LS[22:0]==23'h0FFFDB) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFDC || LS[22:0]==23'h0FFFDD) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFDE || LS[22:0]==23'h0FFFDF) MOSIout <= 0;
			else if (LS[22:0]==23'h0FFFE0 || LS[22:0]==23'h0FFFE1) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFE2 || LS[22:0]==23'h0FFFE3) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFE4 || LS[22:0]==23'h0FFFE5) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFE6 || LS[22:0]==23'h0FFFE7) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFE8 || LS[22:0]==23'h0FFFE9) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFEA || LS[22:0]==23'h0FFFEB) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFEC || LS[22:0]==23'h0FFFED) MOSIout <= 0;
			else if	(LS[22:0]==23'h0FFFEE || LS[22:0]==23'h0FFFEF) MOSIout <= 0;
			else MOSIout <= 0;

			MOSIOE <= LS[22:0]<23'h0FFFF0;
		end else if (AppleActive) begin
			//TODO: control these with Apple II
			nFCS <= 1;
			FCK <= 0;
			MOSIout <= 0;
			MOSIOE <= 0;
			//TODO? sample nMenu when MOSI not outputting?
		end
	end

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

	/* SDRAM data bus */
	inout [7:0] SD = SDOE ? WRD[7:0] : 8'bZ;
	reg [7:0] WRD;
	reg SDOE = 0;
	always @(posedge C25M) begin
		// Shift { MISO, MOSI } in when InitActv. When ready, synchronize RD
		if (InitActv) if (LS[1]) WRD[7:0] <= { MISO, MOSI, WRD[5:0] };
		end else WRD[7:0] <= RD[7:0];
		// Output data on SDRAM data bus only during init and when writing
		SDOE <= InitActv || (RAMSEL && nWEcur && S==6);
	end

	/* State counters */
	reg [2:0] S = 0;
	always @(posedge C25M) begin
		if ( ~InitActv && SDRAMActv && S==0 && PHI0r1 && ~PHI0r2 && nRESr && nBODf) S <= 1;
		else if (S==0) S <= 0;
		else S <= S+1;
	end

	/* Refresh state */
	reg RefReady = 0;
	reg RefDone = 0;
	always @(posedge C25M) begin
		// Ready to refresh when init inactive, SDRAM active, S0 and refresh not already done
		RefReady <= ~InitActv && SDRAMActv && S==0 && ~RefDone;

		if (LS[6:0]==7'h00) RefDone <= 0; // Reset RefDone every 128 C25M cycles (5.12 us)
		else if (~InitActv && SDRAMActv && S==0 && ~RefDone && RefReady && ~(PHI0r1 && ~PHI0r2)) RefDone <= 1;
	end

	/* SDRAM control */
	always @(posedge C25M) begin
		if (S==0 && InitActv) begin
			if (LS[22:0]==23'h000000) begin
				
			end
		end else if (S==0 && ~SDRAMActv) begin
			// NOP CKE
			RCKE <= 1'b1;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
		end else if (S==0 && PHI0r1 && ~PHI0r2) begin
			// NOP CKE
			RCKE <= 1'b1;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
		end else if (S==0 && ~RefDone) begin
			// NOP CKE
			RCKE <= 1'b1;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
		end else if (S==0 && RefReady) begin
			// AREF
			RCKE <= 1'b1;
			nRCS <= 1'b0;
			nRAS <= 1'b0;
			nCAS <= 1'b0;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
		end else if (S==0) begin
			// NOP CKD
			RCKE <= 1'b0;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
		end else if (S==4'h1) begin
			if (ROMSpecRD || RAMSpecRD) begin
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
					RBA[0] <= Addr[23] & ~SetLim8M;
					RA[12:0] <= Addr[22:10];
				end else begin
					RBA[1] <= 1'b1;
					RBA[0] <= 1'b0;
					RA[12:10] <= 3'b000;
					if (RAcur[11]) begin // IOSTRB
						RA[9] <= 1'b0;
						RA[8:1] <= Bank[7:0];
						RA[0] <= RAcur[10];
					end else begin // IOSEL
						RA[9] <= 1'b1;
						RA[8:1] <= 8'h00;
						RA[0] <= RAcur[10];
					end
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
			if (ROMSpecRD || RAMSpecRD) begin
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
			if (ROMSpecRD || RAMSpecRD) begin
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
			if (RAMSpecWR && DEVSELr) begin
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
