module GR8RAM(C25M, PHI0, nBOD, nRES,
			  nIOSEL, nDEVSEL, nIOSTRB,
			  RA, nWE, RAdir,
			  RD, RDdir,
			  DMAin, DMAout, INTin, INTout, nRESout,
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
	input nRES, nBOD;
	reg nRESr0, nRESr;
	reg nBODr0, nBODr, nBODf0, nBODf;
	always @(posedge C25M) begin
		// Double-synchronize nBOD, nPBOD, nRES
		nBODr0 <= nBOD; nRESr0 <= nRES;
		nBODr <= nBODr0; nRESr <= nRESr0;

		// Filter nBODr to get nBODf. Output hi when hi for $10000 cycles
		if (LS[15:0]==16'hFFFF) begin // When LS low-order is $FFFF
			nBODf0 <= nBODr; // "Precharge" nBODf0 
			nBODf <= nBODf0; // "Evaluate" computed nBODf0 into nBODf
		end else if (nBODr) begin // Else AND nBODf0 with nBODr 
			nBODf0 <= nBODf0 && nBODr; 
		end
	end

	/* Long state counter: counts from 0 to $3FFFF */
	/* Outputs: LS, CSec */
	reg [17:0] LS = 0;
	always @(posedge C25M) begin
		LS <= LS+1;
	end

	/* Init state */
	output reg nRESout = 0;
	reg InitActv = 0;
	reg InitIntr = 0;
	reg CmdActv = 0;
	reg SDRAMActv = 0;
	always @(posedge C25M) begin
		if (~nBODf) begin
			nRESout <= 0;
			InitIntr <= 1;
			CmdActv <= 0;
		end else if (LS[17:0]==18'h0FF10) begin
			InitActv <= ~CmdActv;
			InitIntr <= 0;
		end else if (LS[17:0]==18'h30010) begin
			nRESout <= InitActv && ~InitIntr;
			InitActv <= 0;
			CmdActv <= InitActv && ~InitIntr;
			if (InitActv && ~InitIntr) SDRAMActv <= 1;
		end
	end

	/* Apple IO area select signals */
	/* Outputs: DEVSELr */
	input nIOSEL, nDEVSEL, nIOSTRB;
	reg DEVSELr0, DEVSELr;
	reg IOSELr0, IOSELr;
	reg IOSTRBr0, IOSTRBr;
	always @(negedge C25M) begin
		DEVSELr0 <= ~nDEVSEL; IOSELr0 <= ~nIOSEL; IOSTRBr0 <= ~nIOSTRB;
	end
	always @(posedge C25M) begin
		DEVSELr <= DEVSELr0; IOSELr <= IOSELr0; IOSTRBr <= IOSTRBr0;
	end

	/* DMA/IRQ daisy chain */
	input DMAin, INTin;
	output DMAout = DMAin;
	output INTout = INTin;

	/* Apple address bus */
	/* Outputs: RACr, RAcur, nWEcur, RAdir */
	input [15:0] RA;
	input nWE;
	reg RACr;
	reg [11:0] RAcur; reg nWEcur;
	output RAdir = 1;
	always @(posedge C25M) begin
		if (S==0 && PHI0r1 && ~PHI0r2) begin
			RACr <= RA[15:12]==4'hC;
			RAcur[11:0] <= RA[11:0];
			nWEcur <= nWE;
		end
	end

	/* Apple select signals */
	/* Outputs: ROMSpecRD, RAMSpecSEL, RAMSpecRD, RAMSpecWR, RAMSEL */
	wire ROMSpecRD = RACr && RAcur[11:8]!=4'h0 && nWEcur;
	wire RAMSpecSEL = RACr && RAcur[11:8]==4'h0 && RAcur[3:0]==4'h3;
	wire RAMSpecRD = RAMSpecSEL && nWEcur;
	wire RAMSpecWR = RAMSpecSEL && ~nWEcur;
	reg RAMSEL = 0;
	wire RAMWR = RAMSEL && ~nWEcur;
	always @(posedge C25M) begin
		if (S==5) RAMSEL <= RAMSpecSEL && DEVSELr;
		else if (S==0) RAMSEL <= 0;
	end 
	
	/* IOROMEN and REGEN control */
	reg IOROMEN = 0;
	reg REGEN = 0;
	always @(posedge C25M) begin
		if (~nRESr) begin
			IOROMEN <= 0;
			REGEN <= 0;
		end else if (S==7 && IOSTRBr && RAcur[10:0]==11'h7FF) begin
			IOROMEN <= 0;
		end else if (S==7 && IOSELr) begin
			IOROMEN <= 1;
			REGEN <= 1;
		end
	end

	/* Apple data bus */
	inout [7:0] RD = RDdir ? 8'bZ : RDout[7:0];
	reg [7:0] RDout;
	reg RDOE = 0;
	output RDdir = ~((~nDEVSEL || ~nIOSEL || (~nIOSTRB && IOROMEN)) &&
					 PHI0 && PHI0r2 && nWE && RDOE && nBODf);

	/* Slinky address registers */
	reg [23:0] Addr = 0;
	wire AddrHSpecSEL = RAcur[3:0]==4'h2;
	wire AddrMSpecSEL = RAcur[3:0]==4'h1;
	wire AddrLSpecSEL = RAcur[3:0]==4'h0;
	always @(posedge C25M) begin
		if (~nRESr) begin
			Addr[23:20] <= SetFW[1] ? 4'h0 : 4'hF;
			Addr[19:0] <= 20'h00000;
		end else if (S==7 && DEVSELr) begin
			if (AddrHSpecSEL && ~nWEcur) begin
				Addr[23:16] <= { SetFW[1] ? RD[7:4] : 4'hF, RD[3:0] };
			end else if ((RAMSEL && Addr[15:0]==16'hFFFF) || 
				(AddrMSpecSEL && Addr[15] && ~RD[7] && ~nWEcur) ||
				(AddrLSpecSEL && Addr[7]  && ~RD[7] && Addr[15:8]==8'hFF && ~nWEcur)) begin
				Addr[23:16] <= Addr[23:16]+1;
			end

			if (AddrMSpecSEL && ~nWEcur) begin
				Addr[15:8] <= RD[7:0];
			end else if ((RAMSEL && Addr[7:0]==8'hFF) || 
				(AddrLSpecSEL && Addr[7] && ~RD[7] && ~nWEcur)) begin
				Addr[15:8] <= Addr[15:8]+1;
			end

			if (AddrLSpecSEL && ~nWEcur) begin
				Addr[7:0] <= RD[7:0];
			end else if (RAMSEL) begin
				Addr[7:0] <= Addr[7:0]+1;
			end
		end
	end

	/* ROM bank register */
	reg [1:0] Bank = 0;
	wire BankSpecSEL = RAcur[3:0]==4'hF;
	always @(posedge C25M) begin
		if (~nRESr) begin
			Bank <= 0;
		end else if (S==7 && DEVSELr && BankSpecSEL && ~nWEcur) begin
			Bank[1:0] <= RD[1:0];
		end
	end

	/* SPI flash */
	output nFCS = ~FCS;
	reg FCS = 0;
	output reg FCK = 0;
	reg FCKEN = 0;
	output MOSI = MOSIOE ? MOSIout : 1'bZ;
	reg MOSIOE = 0;
	reg MOSIout;
	input MISO;

	/* SPI flash control */
	always @(posedge C25M) begin
		FCK <= FCKEN && LS[0];
	end
	always @(posedge C25M) begin
		if (InitActv) begin
			// Pulse clock from init states $0FFC0 to $2FFFF
			if (LS[17:0]==18'h0FFB0) FCKEN <= 1'b0;
			else if (LS[17:0]==18'h0FFC0) FCKEN <= 1'b1;
			else if (LS[17:0]==18'h30000) FCKEN <= 1'b0;

			// Flash /CS enabled from init states $0FFB0 to $2FFFF
			if (LS[17:0]==18'h0FFA0) FCS <= 1'b0;
			else if (LS[17:0]==18'h0FFB0) FCS <= 1'b1;
			else if (LS[17:0]==18'h30000) FCS <= 1'b0;

			// Send command $3B (read) (MSB first)
			/*if 		(LS[17:0]==18'h0FFB0 || LS[17:0]==18'h0FFB1) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFB2 || LS[17:0]==18'h0FFB3) MOSIout <= 0;
			else*/ if	(LS[17:0]==18'h0FFB4 || LS[17:0]==18'h0FFB5) MOSIout <= 1;
			else if	(LS[17:0]==18'h0FFB6 || LS[17:0]==18'h0FFB7) MOSIout <= 1;
			else if	(LS[17:0]==18'h0FFB8 || LS[17:0]==18'h0FFB9) MOSIout <= 1;
			/*else if	(LS[17:0]==18'h0FFBA || LS[17:0]==18'h0FFBB) MOSIout <= 0;*/
			else if	(LS[17:0]==18'h0FFBC || LS[17:0]==18'h0FFBD) MOSIout <= 1;
			else if	(LS[17:0]==18'h0FFBE || LS[17:0]==18'h0FFBF) MOSIout <= 1;
			// Send 24-bit address (MSB first)
			/*else if (LS[17:0]==18'h0FFC0 || LS[17:0]==18'h0FFC1) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFC2 || LS[17:0]==18'h0FFC3) MOSIout <= 0;*/
			else if	(LS[17:0]==18'h0FFC4 || LS[17:0]==18'h0FFC5) MOSIout <= SetFW[1];
			else if	(LS[17:0]==18'h0FFC6 || LS[17:0]==18'h0FFC7) MOSIout <= SetFW[0];
			/*else if	(LS[17:0]==18'h0FFC8 || LS[17:0]==18'h0FFC9) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFCA || LS[17:0]==18'h0FFCB) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFCC || LS[17:0]==18'h0FFCD) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFCE || LS[17:0]==18'h0FFCF) MOSIout <= 0;
			else if (LS[17:0]==18'h0FFD0 || LS[17:0]==18'h0FFD1) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFD2 || LS[17:0]==18'h0FFD3) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFD4 || LS[17:0]==18'h0FFD5) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFD6 || LS[17:0]==18'h0FFD7) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFD8 || LS[17:0]==18'h0FFD9) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFDA || LS[17:0]==18'h0FFDB) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFDC || LS[17:0]==18'h0FFDD) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFDE || LS[17:0]==18'h0FFDF) MOSIout <= 0;
			else if (LS[17:0]==18'h0FFE0 || LS[17:0]==18'h0FFE1) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFE2 || LS[17:0]==18'h0FFE3) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFE4 || LS[17:0]==18'h0FFE5) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFE6 || LS[17:0]==18'h0FFE7) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFE8 || LS[17:0]==18'h0FFE9) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFEA || LS[17:0]==18'h0FFEB) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFEC || LS[17:0]==18'h0FFED) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFEE || LS[17:0]==18'h0FFEF) MOSIout <= 0;*/
			else MOSIout <= 0;

			if (LS[17:0]==18'h0FFA0) MOSIOE <= 1'b0;
			else if (LS[17:0]==18'h0FFB0) MOSIOE <= 1'b1;
			else if (LS[17:0]==18'h0FFF0) MOSIOE <= 1'b0;
		end else if (CmdActv) begin
			//TODO: control these with Apple II
			FCS <= 0;
			FCKEN <= 0;
			MOSIout <= 0;
			MOSIOE <= 0;
			//TODO? sample nMenu when MOSI not outputting?
		end
	end

	/* UFM control */
	reg ARCLK = 0; // UFM address register clock
	// UFM address register data input tied to 0
	reg ARShift = 0; // 1 to Shift UFM address in, 0 to increment
	reg DRCLK = 0; // UFM data register clock
	reg DRDIn = 0; // UFM data register input
	reg DRShift = 0; // 1 to shift UFM out, 0 to load from current address
	reg UFMErase = 0; // Rising edge starts erase. UFM+RTP must not be busy
	reg UFMProgram = 0; // Rising edge starts program. UFM+RTP must not be busy
	wire UFMBusy; // 1 if UFM is doing user operation. Asynchronous
	wire RTPBusy; // 1 if real-time programming in progress. Asynchronous
	wire DRDOut; // UFM data output
	// UFM oscillator always enabled
	wire UFMOsc; // UFM oscillator output (3.3-5.5 MHz)
	UFM UFM_inst ( // UFM IP block (for Altera MAX II and MAX V)
		.arclk (ARCLK),
		.ardin (1'b0),
		.arshft (ARShift),
		.drclk (DRCLK),
		.drdin (DRDIn),
		.drshft (DRShift),
		.erase (UFMErase),
		.oscena (1'b1),
		.program (UFMProgram),
		.busy (UFMB),
		.drdout (DRDOut),
		.osc (UFMOsc),
		.rtpbusy (RTPB));
	reg UFMBr0 = 0; // UFMBusy registered to sync with C25M
	reg UFMBr = 0; // UFMBusy registered to sync with C25M
	reg RTPBr0 = 0; // RTPBusy registered to sync with C25M
	reg RTPBr = 0; // RTPBusy registered to sync with C25M
	always @(posedge C25M) begin
		UFMBr <= UFMBr0; UFMBr0 <= UFMB;
		RTPBr <= RTPBr0; RTPBr0 <= RTPB;
	end
	reg SetLoaded = 0;
	reg [1:0] SetFW;
	reg SetLim8M;
	always @(posedge C25M) begin
		if (~SetLoaded) begin
			if (LS[15:0]<=16'h0FBF) begin
				ARCLK <= 0;
				ARShift <= 1;
				DRCLK <= 0;
				DRShift <= 0;
			end else if (LS[15:0]<=16'h0FFF) begin
				ARCLK <= ~LS[1];
				ARShift <= 1;
				DRCLK <= 0;
				DRShift <= 0;
				SetFW[1:0] <= 2'b11;
				SetLim8M <= 1'b1;
			end else if (LS[15:0]<=16'h2FFF) begin
				if (LS[4:0]==5'h00 || LS[4:0]==5'h01) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 1;
					DRShift <= 0;
				end else if (LS[4:0]==5'h02 || LS[4:0]==5'h03) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h04 || LS[4:0]==5'h05) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 1;
					DRShift <= 1;
					if (LS[4:0]==5'h04 && DRDOut) SetLoaded <= 1;
				end else if (LS[4:0]==5'h06 || LS[4:0]==5'h07) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h08 || LS[4:0]==5'h09) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 1;
					DRShift <= 1;
					if (LS[4:0]==5'h08) SetFW[1] <= DRDOut;
				end else if (LS[4:0]==5'h0A || LS[4:0]==5'h0B) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h0C || LS[4:0]==5'h0D) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 1;
					DRShift <= 1;
					if (LS[4:0]==5'h0C) SetFW[0] <= DRDOut;
				end else if (LS[4:0]==5'h0E || LS[4:0]==5'h0F) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h10 || LS[4:0]==5'h11) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
					if (LS[4:0]==5'h10) SetLim8M <= DRDOut;
				end else if (LS[4:0]==5'h12 || LS[4:0]==5'h13) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h14 || LS[4:0]==5'h15) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h16 || LS[4:0]==5'h17) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h18 || LS[4:0]==5'h19) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h1A || LS[4:0]==5'h1B) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h1C || LS[4:0]==5'h1D) begin
					ARCLK <= 1;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end else if (LS[4:0]==5'h1E || LS[4:0]==5'h1F) begin
					ARCLK <= 0;
					ARShift <= 0;
					DRCLK <= 0;
					DRShift <= 1;
				end
			end else SetLoaded <= 1;
			DRDIn <= 0;
		end else if (CmdActv) begin
			ARCLK <= 0;
			ARShift <= 0;
			DRShift <= 1;


			DRCLK <= 0;
			DRDIn <= 0;
		end else begin
			ARCLK <= 0;
			ARShift <= 0;
			DRShift <= 1;
			DRCLK <= 0;
			DRDIn <= 0;
		end
	end

	/* SDRAM data bus */
	inout [7:0] SD = SDOE ? WRD[7:0] : 8'bZ;
	reg [7:0] WRD;
	reg SDOE = 0;
	always @(posedge C25M) begin
		// Shift { MISO, MOSI } in when InitActv. When ready, synchronize RD
		if (InitActv) if (LS[1]) WRD[7:0] <= { MISO, MOSI, WRD[5:0] };
		else WRD[7:0] <= RD[7:0];
		// Output data on SDRAM data bus only during init and when writing
		SDOE <= InitActv || (RAMSEL && nWEcur && S==6);
	end

	/* State counters */
	reg [3:0] S = 0;
	always @(posedge C25M) begin
		if (~InitActv && SDRAMActv && S==0 && PHI0r1 && ~PHI0r2 && nRESr && nBODf) S <= 1;
		else if (S==0) S <= 0;
		else S <= S+1;
	end

	/* Refresh state */
	reg RefDone = 0;
	always @(posedge C25M) begin
		if (LS[6:0]==7'h00) RefDone <= 0; // Reset RefDone every 128 C25M cycles (5.12 us)
		else if (S==0 && ~RefDone && ~(PHI0r1 && ~PHI0r2)) RefDone <= 1;
	end

	reg [1:0] IS = 0;
	always @(posedge C25M) begin
		if (InitActv) begin
			if (LS[17:0]==18'h0FFAF) IS <= 1;
			else if (LS[17:0]==18'h0FFBF) IS <= 2;
			else if (LS[17:0]==18'h0FFFF) IS <= 3;
		end else IS <= 0;
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
	always @(posedge C25M) begin
		if (S==0 && InitActv) begin
			if (IS[1:0]==2'h0) begin
				// NOP CKE
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:11] <= 2'b00;
				SA[10] <= 1'b1;
				SA[9:0] <= 10'b1000100000;
			end else if (IS[1:0]==2'h1) begin
				if (LS[3:0]==4'h3) begin
					// PC all
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b1;
					nSWE <= 1'b0;
					DQMH <= 1'b1;
					DQML <= 1'b1;
					SA[10] <= 1'b1; // "all"
				end else if (LS[3:0]==4'hB) begin
					// Load mode register
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b0;
					nSWE <= 1'b0;
					DQMH <= 1'b1;
					DQML <= 1'b1;
					SA[10] <= 1'b0; // reserved in mode register
				end
				SBA[1:0] <= 2'b00; // reserved in mode register
				SA[12:11] <= 2'b00; // reserved in mode register
				SA[9] <= 1'b1; // single write mode
				SA[8] <= 1'b0; // reserved in mode register
				SA[7] <= 1'b0; // don't enter test mode
				SA[6:4] <= 2'b010; // CAS latency 2
				SA[3] <= 1'b0; // sequential addressing mode
				SA[2:0] <= 3'b000; // burst length 1
			end else if (IS[1:0]==2'h2) begin
				if (LS[2:0]==3'h3) begin
					// AREF
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b0;
					nSWE <= 1'b1;
					DQMH <= 1'b1;
					DQML <= 1'b1;
				end else begin
					// NOP CKE
					RCKE <= 1'b1;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
					DQMH <= 1'b1;
					DQML <= 1'b1;
				end
				SBA[1:0] <= 2'b10;
				SA[12:11] <= 2'b00;
				SA[10] <= 1'b1;
				SA[9:0] <= 10'b1000100000;
			end else if (IS[1:0]==2'h3) begin
				if (LS[2:0]==3'h3) begin
					// AREF
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b0;
					nSWE <= 1'b1;
					DQMH <= 1'b1;
					DQML <= 1'b1;
					SBA[1:0] <= 2'b10;
					SA[12:11] <= 2'b00;
					SA[10] <= 1'b1;
					SA[9:0] <= 10'b1000100000;
				end else if (LS[2:0]==3'h5) begin
					// ACT
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
					SBA[1:0] <= 1'b10;
					SA[12:10] <= 3'b001;
					SA[9:4] <= 10'b100010;
					SA[3:0] <= { ~LS[17], LS[16:14] };
					DQMH <= 1'b1;
					DQML <= 1'b1;
				end else if (LS[2:0]==3'h7) begin
					// WR auto-PC
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b1;
					nCAS <= 1'b0;
					nSWE <= 1'b0;
					SBA[1:0] <= 1'b10;
					SA[12:11] <= 2'b00; // don't care
					SA[10] <= 1'b1; // auto-precharge
					SA[9:0] <= LS[13:4];
					DQML <= LS[3];
					DQMH <= ~LS[3];
				end else begin
					// NOP CKE
					RCKE <= 1'b1;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
					DQMH <= 1'b1;
					DQML <= 1'b1;
					SBA[1:0] <= 2'b10;
					SA[12:11] <= 2'b00;
					SA[10] <= 1'b1;
					SA[9:0] <= 10'b1000100000;
				end
			end
		end else if (S==0 && ~RefDone) begin
			// AREF
			RCKE <= 1'b1;
			nRCS <= 1'b0;
			nRAS <= 1'b0;
			nCAS <= 1'b0;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
			SBA[1:0] <= 2'b10;
			SA[12:11] <= 2'b00;
			SA[10] <= 1'b1;
			SA[9:0] <= 10'b1000100000;
		end else if (S==0) begin
			// NOP CKE
			RCKE <= 1'b1;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
			SBA[1:0] <= 2'b10;
			SA[12:11] <= 2'b00;
			SA[10] <= 1'b1;
			SA[9:0] <= 10'b1000100000;
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
			end else begin
				// NOP CKE
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end

			if (RAMSpecRD) begin
				SBA[1] <= 1'b0;
				SBA[0] <= Addr[23] & ~SetLim8M;
				SA[12:0] <= Addr[22:10];
			end else begin
				SBA[1] <= 1'b1;
				SBA[0] <= 1'b0;
				SA[12:11] <= 2'b00;
				SA[10] <= 1'b1;
				SA[9:4] <= 10'b100010;
				SA[9:1] <= Bank[1:0];
				SA[1:0] <= RAcur[11:10];
			end
		end else if (S==4'h2) begin
			if (ROMSpecRD || RAMSpecRD) begin
				// RD auto-PC
				RCKE <= 1'b1;
				nRCS <= 1'b0;
				nRAS <= 1'b1;
				nCAS <= 1'b0;
				nSWE <= 1'b1;
				if (RAMSpecRD) begin
					DQMH <= ~Addr[0];
					DQML <= Addr[0];
				end else begin
					DQMH <= ~RAcur[0];
					DQML <= RAcur[0];
				end
			end else begin
				// NOP CKE
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end

			SA[12:11] <= 2'b00; // don't care
			SA[10] <= 1'b1; // auto-precharge
			SA[9] <= 1'b1; // don't care
			if (RAMSpecRD) begin
				SBA[1] <= 1'b0;
				SBA[0] <= Addr[23];
				SA[8:0] <= Addr[9:1];
			end else begin
				SBA[1] <= 1'b1;
				SBA[0] <= 1'b0;
				SA[8:0] <= RAcur[9:1];
			end
		end else if (S==4'h3) begin
			// NOP CKE
			RCKE <= 1'B1;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
			SBA[1:0] <= 2'b10;
			SA[12:11] <= 2'b00;
			SA[10] <= 1'b1;
			SA[9:0] <= 10'b1000100000;
		end else if (S==4'h4) begin
			// NOP CKE
			RCKE <= 1'b1;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
			SBA[1] <= 1'b0;
			SBA[0] <= Addr[23];
			SA[12:0] <= Addr[22:10];
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
			end else begin
				// NOP CKE
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
			SBA[1] <= 1'b0;
			SBA[0] <= Addr[23];
			SA[12:0] <= Addr[22:10];
		end else if (S==4'h6) begin
			if (RAMWR) begin
				// WR auto-PC
				RCKE <= 1'b1;
				nRCS <= 1'b0;
				nRAS <= 1'b1;
				nCAS <= 1'b0;
				nSWE <= 1'b0;
				DQMH <= ~Addr[10];
				DQML <= Addr[10];
			end else begin
				// NOP CKE
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQMH <= 1'b1;
				DQML <= 1'b1;
			end
			SBA[1] <= 1'b0;
			SBA[0] <= Addr[23];
			SA[12:11] <= 2'b00; // don't care
			SA[10] <= 1'b1; // auto-precharge
			SA[9:0] <= Addr[9:0];
		end else if (S==4'h7) begin
			// NOP CKE
			RCKE <= 1'b1;
			nRCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQMH <= 1'b1;
			DQML <= 1'b1;
			SBA[1] <= 1'b0;
			SBA[0] <= Addr[23];
			SA[12:11] <= 2'b00; // don't care
			SA[10] <= 1'b1; // auto-precharge
			SA[9:0] <= Addr[9:0];
		end
	end
endmodule
