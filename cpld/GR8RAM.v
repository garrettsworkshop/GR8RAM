module GR8RAM(C25M, PHI0, nBOD, nRES, nRESout,
			  nIOSEL, nDEVSEL, nIOSTRB,
			  RA, nWE, RAdir, RD, RDdir,
			  SBA, SA, nRCS, nRAS, nCAS, nSWE, DQML, DQMH, RCKE, SD,
			  nFCS, FCK, MISO, MOSI);

	/* Clock signals */
	/* Outputs: C25M, PHI0r1, PHI0r2, */
	input C25M, PHI0;
	reg PHI0r0, PHI0r1, PHI0r2;
	always @(negedge C25M) begin PHI0r0 <= PHI0; end
	always @(posedge C25M) begin PHI0r1 <= PHI0r0; PHI0r2 <= PHI0r1; end

	/* Reset/brown-out detect synchronized inputs */
	/* Outputs: nRESr, nBODf */
	input nRES, nBOD;
	reg nRESr0, nRESr;
	reg nBODr0, nBODr, nBODf0, nBODf;
	always @(negedge C25M) begin nBODr0 <= nBOD; nRESr0 <= nRES; end
	always @(posedge C25M) begin nBODr <= nBODr0; nRESr <= nRESr0; end
	always @(posedge C25M) begin
		// Filter nBODr to get nBODf. Output hi when hi for $10000 cycles
		if (LS[15:0]==16'hFF00) begin // When LS low-order is $FFF0
			nBODf0 <= nBODr; // "Precharge" nBODf0 
			nBODf <= nBODf0; // Move computed nBODf0 into nBODf
		end else if (nBODr) begin // Else AND nBODf0 with nBODr 
			nBODf0 <= nBODf0 && nBODr; // "Evaluate" by ANDing
		end
	end

	/* Long state counter: counts from 0 to $3FFFF */
	/* Outputs: LS */
	reg [17:0] LS = 0;
	always @(posedge C25M) begin LS <= LS+1; end

	/* Init state */
	output reg nRESout = 0;
	reg InitActv = 0;
	reg InitIntr = 0;
	reg SDRAMActv = 0;
	always @(posedge C25M) begin
		if (~nBODf) begin
			nRESout <= 0;
			InitIntr <= 1;
		end else if (~nRESr && LS[17:0]==18'h0FF00) begin
			nRESout <= 0;
			InitActv <= 1;
			InitIntr <= 0;
		end else if (LS[17:0]==18'h30002) begin
			InitActv <= 0;
			if (InitActv && ~InitIntr) begin
				SDRAMActv <= 1;
				nRESout <= 1;
			end
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

	/* Apple address bus */
	/* Outputs: RACr, RAcur, nWEcur, RAdir */
	input [15:0] RA;
	input nWE;
	reg RACr;
	reg [11:0] RAcur; reg nWEcur;
	output RAdir = 1;
	always @(posedge C25M) begin
		if (PSStart) begin
			RACr <= RA[15:12]==4'hC;
			RAcur[11:0] <= RA[11:0];
			nWEcur <= nWE;
		end
	end

	/* Apple select signals */
	/* Outputs: ROMSpecRD, RAMSpecSEL, RAMSpecRD, RAMSpecWR */
	wire ROMSpecRD = RACr && RAcur[11:8]!=4'h0 && nWEcur;
	wire RAMSpecSEL = RACr && RAcur[11:8]==4'h0 && RAcur[7] && RAcur[3:0]==4'h3;
	wire RAMSpecRD = RAMSpecSEL && nWEcur;
	wire RAMSpecWR = RAMSpecSEL && ~nWEcur;
	
	/* IOROMEN and REGEN control */
	reg IOROMEN = 0;
	reg REGEN = 0;
	always @(posedge C25M) begin
		if (~nRESr) begin
			IOROMEN <= 0;
			REGEN <= 0;
		end else if (PS==7 && IOSTRBr && RAcur[10:0]==11'h7FF) begin
			IOROMEN <= 0;
		end else if (PS==7 && IOSELr) begin
			IOROMEN <= 1;
			REGEN <= 1;
		end
	end

	/* Apple data bus */
	inout [7:0] RD = RDdir ? 8'bZ : RDout[7:0];
	reg [7:0] RDout;
	output RDdir = ~(PHI0 && PHI0r2 && nWE && nRESr &&
		((~nDEVSEL && REGEN) || ~nIOSEL || (~nIOSTRB && IOROMEN)));

	/* Slinky address registers */
	reg [23:0] Addr = 0;
	wire AddrHSpecSEL = RAcur[3:0]==4'h2;
	wire AddrMSpecSEL = RAcur[3:0]==4'h1;
	wire AddrLSpecSEL = RAcur[3:0]==4'h0;
	always @(posedge C25M) begin
		if (~nRESr) begin
			Addr[23:0] <= 24'h000000;
		end else if (PS==7 && REGEN && DEVSELr) begin
			if (RAMSpecSEL) begin
				Addr[23:0] <= Addr[23:0]+1;
			end else if (AddrLSpecSEL && ~nWEcur) begin
				Addr[7:0] <= RD[7:0];
				if (~RD[7] && Addr[7]) begin
					Addr[23:8] <= Addr[23:8]+1;
				end
			end else if (AddrMSpecSEL && ~nWEcur) begin
				Addr[15:8] <= RD[7:0];
				if (~RD[7] && Addr[15]) begin
					Addr[23:16] <= Addr[23:16]+1;
				end
			end else if (AddrHSpecSEL && ~nWEcur) begin
				Addr[23:16] <= RD[7:0];
			end
		end
	end

	/* ROM bank register */
	reg [1:0] Bank = 0;
	wire BankSpecSEL = RAcur[3:0]==4'hF;
	always @(posedge C25M) begin
		if (~nRESr) Bank <= 0;
		else if (PS==7 && DEVSELr && BankSpecSEL && ~nWEcur) begin
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
		FCK <= (FCKEN && LS[0]) || (nRESr && FCKEN);
	end
	always @(posedge C25M) begin
		if (InitActv) begin
			// Flash /CS enabled from init states $0FFB0 to $2FFFF
			if (LS[17:0]==18'h0FF90) FCS <= 1'b0;
			else if (LS[17:0]==18'h0FFA0) FCS <= 1'b1;
			else if (LS[17:0]==18'h30000) FCS <= 1'b0;

			// Pulse clock from init states $0FFC0 to $2FFFF
			if (LS[17:0]==18'h0FF90) FCKEN <= 1'b0;
			else if (LS[17:0]==18'h0FFB0) FCKEN <= 1'b1;
			else if (LS[17:0]==18'h30000) FCKEN <= 1'b0;

			// Send command $3B (read) (MSB first)
			if 		(LS[17:0]==18'h0FFB0 || LS[17:0]==18'h0FFB1) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFB2 || LS[17:0]==18'h0FFB3) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFB4 || LS[17:0]==18'h0FFB5) MOSIout <= 1;
			else if	(LS[17:0]==18'h0FFB6 || LS[17:0]==18'h0FFB7) MOSIout <= 1;
			else if	(LS[17:0]==18'h0FFB8 || LS[17:0]==18'h0FFB9) MOSIout <= 1;
			else if	(LS[17:0]==18'h0FFBA || LS[17:0]==18'h0FFBB) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFBC || LS[17:0]==18'h0FFBD) MOSIout <= 1;
			else if	(LS[17:0]==18'h0FFBE || LS[17:0]==18'h0FFBF) MOSIout <= 1;
			// Send 24-bit address (MSB first)
			else if (LS[17:0]==18'h0FFC0 || LS[17:0]==18'h0FFC1) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFC2 || LS[17:0]==18'h0FFC3) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFC4 || LS[17:0]==18'h0FFC5) MOSIout <= 0;
			else if	(LS[17:0]==18'h0FFC6 || LS[17:0]==18'h0FFC7) MOSIout <= SetFW;
			else if	(LS[17:0]==18'h0FFC8 || LS[17:0]==18'h0FFC9) MOSIout <= 0;
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
			else if	(LS[17:0]==18'h0FFEE || LS[17:0]==18'h0FFEF) MOSIout <= 0;
			else MOSIout <= 0;

			if (LS[17:0]==18'h0FF90) MOSIOE <= 1'b1;
			else if (LS[17:0]==18'h0FFF0) MOSIOE <= 1'b0;
		end else if (nRESr) begin
			//TODO: control these with Apple II
			FCS <= 0;
			FCKEN <= 0;
			MOSIout <= 0;
			MOSIOE <= 0;
		end
	end

	/* UFM control */
	reg ARCLK = 0; // UFM address register clock
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
	always @(negedge C25M) begin UFMBr0 <= UFMB; RTPBr0 <= RTPB; end
	always @(posedge C25M) begin UFMBr <= UFMBr0; RTPBr <= RTPBr0; end
	reg SetLoaded = 0;
	reg SetFW;
	reg SetLim8M;
	always @(posedge C25M) begin
		if (~SetLoaded) begin
			if (LS[15:0]<=16'h0FB0) begin
				ARCLK <= 0;
				ARShift <= 1;
				DRCLK <= 0;
				DRShift <= 0;
			end else if (LS[15:0]<=16'h0FFF) begin
				ARCLK <= ~LS[1];
				ARShift <= 1;
				DRCLK <= 0;
				DRShift <= 0;
				SetFW <= 1'b1;
				SetLim8M <= 1'b1;
			end else if (LS[15:0]<=16'h1FFF) begin
				case (LS[3:1])
					3'h0: begin
						ARCLK <= 0;
						ARShift <= 0;
						DRCLK <= 1;
						DRShift <= 0;
					end 3'h1: begin
						ARCLK <= 0;
						ARShift <= 0;
						DRCLK <= 0;
						DRShift <= 1;
					end 3'h2: begin
						ARCLK <= 0;
						ARShift <= 0;
						DRCLK <= 1;
						DRShift <= 1;
						if (LS[3:0]==4'h2 && DRDOut) SetLoaded <= 1;
					end 3'h3: begin
						ARCLK <= 0;
						ARShift <= 0;
						DRCLK <= 0;
						DRShift <= 1;
					end 3'h4: begin
						ARCLK <= 0;
						ARShift <= 0;
						DRCLK <= 1;
						DRShift <= 1;
						if (LS[3:0]==4'h4) SetFW <= DRDOut;
					end 3'h5: begin
						ARCLK <= 0;
						ARShift <= 0;
						DRCLK <= 0;
						DRShift <= 1;
					end 3'h6: begin
						ARCLK <= 1;
						ARShift <= 0;
						DRCLK <= 0;
						DRShift <= 1;
						if (LS[3:0]==4'h6) SetLim8M <= DRDOut;
					end 3'h7: begin
						ARCLK <= 0;
						ARShift <= 0;
						DRCLK <= 0;
						DRShift <= 0;
					end
				endcase
			end else SetLoaded <= 1;
			DRDIn <= 0;
		end else if (PS==7 /* && ... FIXME */) begin
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
		if (InitActv && LS[1]) WRD[7:0] <= { MISO, MOSI, WRD[5:0] };
		else if (PS==8) WRD[7:0] <= RD[7:0];
		// Output data on SDRAM data bus only during init and when writing
		SDOE <= InitActv || (RAMSpecWR && PS==8);
	end

	reg [2:0] PS = 0;
	wire PSStart = ~InitActv && nRESr && PS==0 && PHI0r1 && ~PHI0r2;
	always @(posedge C25M) begin
		if (PSStart) PS <= 1;
		else if (PS==0) PS <= 0;
		else PS <= PS+1;
	end

	reg [1:0] IS = 0;
	always @(posedge C25M) begin
		if (InitActv) begin
			if (LS[17:0]==18'h0FFAF) IS <= 1;
			else if (LS[17:0]==18'h0FFBF) IS <= 2;
			else if (LS[17:0]==18'h0FFFF) IS <= 3;
		end else IS <= 0;
	end

	/* Refresh state */
	reg RefReqd = 0;
	reg RefReady = 0;
	always @(posedge C25M) begin
		if (LS[6:0]==7'h00) RefReqd <= SDRAMActv; // Reset RefDone every 128 C25M cycles (5.12 us)
		else if (PS==0 && ~RefReqd) RefReqd <= 0;
	end

	/* SDRAM address/command */
	output [1:0] SBA; assign SBA[1:0] = 
		Amux[2:0]==2'h0 ? 2'b00 : // mode register / "all"
		Amux[2:0]==2'h1 ? 2'b00 : // FIXME: init row / col
		Amux[2:0]==2'h2 ? 2'b10 : // ROM row / col
		/* 2'h3 */ { 1'b0, Addr[23] & SetFW & ~SetLim8M }; // RAM col
	output [12:0] SA; assign SA[12:0] = 
		Amux[2:0]==3'h0 ? 13'b0001000100000 : // mode register
		Amux[2:0]==3'h1 ? 13'b0011000100000 : // "all"
		Amux[2:0]==3'h2 ? 13'b0011000100000 : // FIXME: init row
		Amux[2:0]==3'h3 ? 13'b0011000100000 : // FIXME: init col
		Amux[2:0]==3'h4 ? { 9'b000000000, Bank[1:0], RAcur[11:10] } : // ROM row
		Amux[2:0]==3'h5 ? { 4'b0000, RAcur[9:1]} : // ROM col
		Amux[2:0]==3'h6 ? { Addr[22] & SetFW, 
							Addr[21] & SetFW, 
							Addr[20] & SetFW,
							Addr[19:10] } : // RAM row
		/* 3'h7 */        { 4'b0000, Addr[9:1] }; // RAM col
	output DQML; assign DQML = 
		Amux[2:0]==3'h0 ? 1'b1 : // mode register
		Amux[2:0]==3'h1 ? 1'b1 : // "all"
		Amux[2:0]==3'h2 ? 1'b1 : // FIXME: init row
		Amux[2:0]==3'h3 ? LS[3] : // FIXME: init col
		Amux[2:0]==3'h4 ? 1'b1 : // ROM row
		Amux[2:0]==3'h5 ? RAcur[0]: // ROM col
		Amux[2:0]==3'h6 ? 1'b1 : // RAM row
		/* 3'h7 */        Addr[0]; // RAM col
	output DQMH; assign DQMH =
		Amux[2:0]==3'h0 ? 1'b1 : // mode register
		Amux[2:0]==3'h1 ? 1'b1 : // "all"
		Amux[2:0]==3'h2 ? 1'b1 : // FIXME: init row
		Amux[2:0]==3'h3 ? ~LS[3] : // FIXME: init col
		Amux[2:0]==3'h4 ? 1'b1 : // ROM row
		Amux[2:0]==3'h5 ? ~RAcur[0]: // ROM col
		Amux[2:0]==3'h6 ? 1'b1 : // RAM row
		/* 3'h7 */        ~Addr[0]; // RAM col
	reg [2:0] Amux = 0;
	output reg RCKE = 1;
	output reg nRCS = 1;
	output reg nRAS = 1;
	output reg nCAS = 1;
	output reg nSWE = 1;
	always @(posedge C25M) begin
		case (PS[2:0])
			0: begin
				if (PSStart) begin
					// NOP CKE
					RCKE <= 1'b1;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
					Amux <= 3'b001;
				end else if (RefReqd) begin
					if (RCKE) begin
						// AREF
						RCKE <= 1'b1;
						nRCS <= 1'b0;
						nRAS <= 1'b0;
						nCAS <= 1'b0;
						nSWE <= 1'b1;
						Amux <= 3'b001;
					end else begin
						// NOP CKE
						RCKE <= 1'b1;
						nRCS <= 1'b1;
						nRAS <= 1'b1;
						nCAS <= 1'b1;
						nSWE <= 1'b1;
						Amux <= 3'b001;
					end
				end else begin
					// NOP CKD
					RCKE <= 1'b0;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
					Amux <= 3'b001;
				end
			end 1: begin
				if (ROMSpecRD || RAMSpecSEL) begin
					// ACT
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end else begin
					// NOP CKD
					RCKE <= 1'b0;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end
				if (ROMSpecRD) Amux <= 3'b100;
				else Amux <= 3'b110;
			end 2: begin
				if (ROMSpecRD || RAMSpecRD) begin
					// RD
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end else begin
					// NOP CKD
					RCKE <= 1'b0;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end

				if (ROMSpecRD) Amux <= 3'b101;
				else Amux <= 3'b111;
			end 3: begin
				if (ROMSpecRD || RAMSpecRD) begin
					// NOP CKE
					RCKE <= 1'b1;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end else begin
					// NOP CKD
					RCKE <= 1'b0;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end
				Amux <= 3'b001;
			end 4: begin
				if (RAMSpecWR && DEVSELr) begin
					// NOP CKE
					RCKE <= 1'b1;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end else begin
					// NOP CKD
					RCKE <= 1'b0;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end
				Amux <= 3'b001;
			end 5: begin
				if (RAMSpecWR && DEVSELr) begin
					// WR AP
					RCKE <= 1'b1;
					nRCS <= 1'b0;
					nRAS <= 1'b1;
					nCAS <= 1'b0;
					nSWE <= 1'b0;
				end else begin
					// NOP CKD
					RCKE <= 1'b0;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end
				Amux <= 3'b111;
			end 6: begin
				// NOP CKE if ACT'd, else CKD
				RCKE <= ROMSpecRD || RAMSpecSEL;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				Amux <= 3'b001;
			end 7: begin
				if (ROMSpecRD || RAMSpecSEL) begin
					// PC all CKD
					RCKE <= 1'b0;
					nRCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b1;
					nSWE <= 1'b0;
				end else begin
					// NOP CKD
					RCKE <= 1'b0;
					nRCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
				end
				Amux <= 3'b001;
			end
		endcase
	end
endmodule
