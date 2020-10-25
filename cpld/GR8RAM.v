module GR8RAM(C25M, PHI1, nIOSEL, nDEVSEL, nIOSTRB,
			  RA, RB6, nRWE, nROE, nAOE, Adir, nRCS,
			  RD, nDOE, Ddir,
			  SBA, SA, nSCS, nRAS, nCAS, nSWE, DQML, DQMH, SCKE, SD,
			  nRST, nPreBOD,
			  DMAin, DMAout, INTin, INTout,
			  nIRQout, nINHout, nDMAout, nNMIout);

	/* Clock inputs */
	input C25M, PHI1;
	wire PHI0 = ~PHI1;

	/* Reset inputs */
	input nRST, nPreBOD;
	reg nRSTr0;
	always @(posedge C25M) begin
		nRSTr0 <= nRST;
	end

	/* Select inputs */
	input nIOSEL, nDEVSEL, nIOSTRB;
	/* Synchronized select inputs */
	reg nDEVSELr0, nDEVSELr1;
	reg nIOSELr0;
	reg nIOSTRBr0;
	always @(posedge C25M) begin
		nDEVSELr0 <= nDEVSEL;
		nDEVSELr1 <= nDEVSELr0;
		nIOSELr0 <= nIOSEL;
		nIOSTRBr0 <= nIOSTRB;
	end
	/* DEVSEL-based state counter */
	wire [9:0] DEVSELe = {DEVSELer[9:1], nDEVSELr1 && ~nDEVSELr0 && nRSTr0}
	reg [9:1] DEVSELer;
	always @(posedge C25M) begin
		DEVSELer[9:1] <= DEVSELe[8:0];
	end

	/* Flash Control */
	output nRCS = ~((~nIOSEL || (~nIOSTRB && IOROMEN)) && CSDBEN && nRST);
	output nROE = ~nRWE;

	/* 6502/Flash Data Bus */
	inout RD = RDOE ? Rdout : 8'bZ;
	wire RDOE = ~nDEVSEL && nRST;
	wire RDout = 
		AddrLSelA ? Addr[7:0] :
		AddrMSelA ? Addr[15:8] :
		AddrHSelA ? Addr[23:16] :
		DataSelA ? Addr==0 ? Data0[7:0] : Data[7:0] : 
		8'h57;
	output nDOE = ~((~nDEVSEL || ~nIOSEL || (~nIOSTRB && IOROMEN)) && CSDBEN && nRST);
	output Ddir = ~nRWE;

	/* Data bus / ROM chip select delay */
	reg CSDBEN = 0;
	always @(posedge C25M, negedge nRST) begin
		if (~nRST) CSDBEN <= 1'b0;
		else CSDBEN <= ~nDEVSELr0 || ~nIOSELr0 || ~nIOSTRBr0;
	end

	/* IOROMEN control */
	wire IOROMEN = IOROMEN0 ^ IOROMEN1;
	reg IOROMEN0 = 0;
	reg IOROMEN1 = 0;
	always @(negedge nIOSEL, negedge nRST) begin
		if (~nRST) IOROMEN0 <= 1'b0; // On reset, set both to 0; 0 ^ 0 == 0
		else IOROMEN0 <= ~IOROMEN1; // Enable; X ^ ~X == 1
	end
	always @(negedge nIOSTRB, negedge nRST) begin
		if (~nRST) IOROMEN1 <= 1'b0; // On reset, set both to 0; 0 ^ 0 == 0
		else if (RA[10:0] == 11'h7FF) IOROMEN1 <= IOROMEN0; // Disable; X^X==0
	end

	/* 6502/Flash Address Bus */
	input [15:0] RA;
	input nRWE;
	output nAOE = 0;
	output Adir = 1;
	reg [3:0] RAr;
	reg nRWEr;
	always @(posedge nDEVSEL) begin
		// Latch RA and nRWE at end of DEVSEL access
		RAr[3:0] <= RA[3:0];
		nRWEr <= nRWE;
	end

	/* Register Select Signals */
	wire AddrLSelA =	RA[3:0] == 4'h0;
	wire AddrMSelA =	RA[3:0] == 4'h1;
	wire AddrHSelA =	RA[3:0] == 4'h2;
	wire DataSelA =		RA[3:0] == 4'h3;
	wire DMAAddrLSelA =	RA[3:0] == 4'h4;
	wire DMAAddrHSelA =	RA[3:0] == 4'h5;
	wire DMALenLSelA =	RA[3:0] == 4'h6;
	wire DMALenHSelA =	RA[3:0] == 4'h7;

	wire MagicSelA =	RA[3:0] == 4'h8;
	wire CfgSelA 	=	RA[3:0] == 4'h9;
	wire RAMMaskSelA =	RA[3:0] == 4'hB;
	wire BankHSelA =	RA[3:0] == 4'hE;
	wire BankLSelA =	RA[3:0] == 4'hF;

	/* SDRAM Address / Flash Bank Bus */
	output [1:0] SBA = SAmux ? SBAreg[1:0] :
		~nIOSTRB ? {
			BankC8[4],	// SBA0, Bank4
			BankC8[2]	// SBA1, Bank2
		} : {  // IOSEL
			1'b1,	// SBA0, Bank4
			1'b1	// SBA1, Bank2
		};
	output [12:0] SA = SAmux ? SAreg[12:0] :
		~nIOSTRB ? { 
			SAreg[0],	// SA0
			BankC8[11],	// SA1,  Bank11
			BankC8[8],	// SA2, Bank8
			SAreg[3],	// SA3
			SAreg[4], 	// SA4
			BankC8[7],	// SA5, Bank7
			SAreg[6], 	// SA6
			BankC8[10], // SA7,  Bank10
			BankC8[9],	// SA8, Bank9
			BankC8[1],	// SA9,  Bank1
			BankC8[0],	// SA10, Bank0
			BankC8[3],	// SA11, Bank3
			BankC8[5] ^ BankCX[5] // SA12, Bank5
		} : { // IOSEL
			SAreg[0],	// SA0
			1'b0,	 	// SA1,  Bank11
			1'b0,	// SA2,  Bank8
			SAreg[3],	// SA3
			SAreg[4], 	// SA4
			1'b1, 		// SA5,  Bank7
			SAreg[6], 	// SA6
			1'b0, 		// SA7,  Bank10
			1'b0, 		// SA8,  Bank9
			1'b1,		// SA9,  Bank1
			1'b1,		// SA10, Bank0
			1'b1,		// SA11, Bank3
			BankCX[5]	// SA12, Bank5
		};
	output RB6 = ~nIOSTRB ? BankC8[6] ^ BankCX[6] : BankCX[6];
	reg SAmux = 1'b0;
	reg [1:0] SBAreg;
	reg [12:0] SAreg;

	/* SDRAM Data Bus */
	inout [7:0] SD = SDOE ? WRD : 8'bZ;
	reg SDOE = 0;
	reg [7:0] WRD = 0;
	always @(posedge nDEVSEL) begin
		WRD[7:0] <= RD[7:0];
		if (nRSTr0 && DataSelA && ~nRWE && Addr==0) Data0[7:0] <= RD[7:0];
	end

	/* SDRAM Control Bus */
	output reg nSCS = 1;
	output reg nRAS = 1;
	output reg nCAS = 1;
	output reg nSWE = 1;
	output reg DQML = 1;
	output reg DQMH = 1;
	output reg SCKE = 1;

	/* INT/DMA in/out */
	input DMAin;
	input INTin;
	output DMAout = DMAin;
	output INTout = INTin;

	/* IRQ, NMI, DMA, INH outputs (open-drain is external) */
	output nIRQ = 1;
	output nNMI = 1;
	output nDMA = 1;
	output nINH = 1;

	/* Refresh/Init Counter */
	reg [19:0] Tick;
	always @(posedge C25M) begin
		Tick <= Tick+1;
	end
	reg InitDone = 0;
	always @(posedge C25M) begin
		if (Tick[19:0]==20'hFFFFF) InitDone <= 1'b1;
	end
	reg RefWake = 0;
	reg RefDone = 0;

	/* User-Accessible Registers */
	reg [23:0] Addr = 0;
	reg [7:0] Data = 0;
	reg [7:0] Data0 = 0;
	reg [11:0] BankC8 = 0; // Bits 9:8 are XORed with BankCX
	reg [6:5] BankCX = 0; // Bank CX is init value
	reg ExtBankEN = 0;

	/* Set/Increment Address Register */
	always @(posedge C25M, negedge nRST) begin
		if (~nRST) begin
			Addr <= 0;
		end else begin
			if (DEVSELe[0] && ~nRWEr) begin // Write address register
				if (RAr[3:0]==4'h0) begin // AddrL
					Addr[7:0] <= WRD[7:0];
					if (Addr[7] & ~WRD[7]) Addr[23:8] <= Addr[23:8]+1;
				end else if (RAr[3:0]==4'h1) begin // AddrM
					Addr[15:8] <= WRD[7:0];
					if (Addr[15] & ~WRD[7]) Addr[23:16] <= Addr[23:16]+1;
				end else if (RAr[3:0]==4'h2) begin // AddrH
					Addr[23:16] <= WRD[7:0];
				end
			end else if (DEVSELe[2] && RAr[3:0]==4'h3) begin // R/W data
				Addr[23:0] <= Addr[23:0]+1;
			end
		end
	end

	/* Set bank */
	always @(posedge nDEVSEL, negedge nRST) begin
		if (~nRST) begin
			BankC8 <= 0;
		end else begin
			if (~nRWE) begin
				if (RAr[3:0]==4'hE && ExtBankEN) begin
					BankC8[11:10] <= WRD[3:2];
					BankC8[9:8] <= WRD[1:0] ^ BankCX[9:8];
				end else if (RAr[3:0]==4'hF) begin
					BankC8[7] <= WRD[7] & ExtBankEN;
					BankC8[6:0] <= WRD[6:0];
				end
			end
		end
	end

	/* Latch read data */
	always @(posedge C25M) begin
		if (DEVSELe[9]) Data[7:0] <= SDD[7:0];
	end

	/* SDRAM Control */
	always @(posedge C25M) begin
		if (~InitDone) begin
			if (Tick[19:8]==12'hFFF) begin
				if (Tick[3:0]==4'h8) begin
					if (Tick[7:4]==4'h0) begin
						// PC all
						SCKE <= 1'b1;
						nSCS <= 1'b0;
						nRAS <= 1'b0;
						nCAS <= 1'b1;
						nSWE <= 1'b0;
						DQML <= 1'b1;
						DQMH <= 1'b1;

						SAreg[10] <= 1'b1; // "all"
					end else if (Tick[7:4]==4'h7) begin
						// Load mode register
						SCKE <= 1'b1;
						nSCS <= 1'b0;
						nRAS <= 1'b0;
						nCAS <= 1'b0;
						nSWE <= 1'b0;
						DQML <= 1'b1;
						DQMH <= 1'b1;

						SAreg[11] <= 1'b0; // Reserved in mode register
					end else begin
						// AREF
						SCKE <= 1'b1;
						nSCS <= 1'b0;
						nRAS <= 1'b0;
						nCAS <= 1'b0;
						nSWE <= 1'b1;
						DQML <= 1'b1;
						DQMH <= 1'b1;
					end
				end else begin
					// NOP
					SCKE <= 1'b1;
					nSCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
					DQML <= 1'b1;
					DQMH <= 1'b1;
				end
			end else begin
				// NOP ckdis
				SCKE <= 1'b0;
				nSCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQML <= 1'b1;
				DQMH <= 1'b1;
			end

			// Mode register contents
			SBAreg[1:0] <= 2'b00;	// Reserved
			SAreg[11] <= 1'b0;		// Reserved
			SAreg[9] <= 1'b1;		// "1" for single write mode
			SAreg[8] <= 1'b0;		// Reserved
			SAreg[7] <= 1'b0;		// "0" for not test mode
			SAreg[6:4] <= 3'b010;	// "2" for CAS latency 2
			SAreg[3] <= 1'b0;		// "0" for sequential burst (not used)
			SAreg[2:0] <= 3'b000;	// "0" for burst length 1 (no burst)

			SAmux <= 1'b1;
			RefDone <= 1'b0;
			RefWake <= 1'b0;
		end else if (DEVSELe[0] && RAr[3:0]==4'h3) begin
			// NOP
			SCKE <= ~nRWEr;
			nSCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQML <= 1'b1;
			DQMH <= 1'b1;

			SAmux <= 1'b1;
			RefWake <= 1'b0;
		end else if (DEVSELe[1] && RAr[3:0]==4'h3) begin
			// ACT
			SCKE <= ~nRWEr;
			nSCS <= nRWEr;
			nRAS <= 1'b0;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQML <= 1'b1;
			DQMH <= 1'b1;

			// Row address
			SBAreg[1:0] <= Addr[23:22];
			SAreg[12] <= 1'b0;
			SAreg[11:0] <= Addr[21:10];
			
			SAmux <= 1'b1;
			RefWake <= 1'b0;
		end else if (DEVSELe[2] && RAr[3:0]==4'h3) begin
			// WR/NOP
			SCKE <= ~nRWEr;
			nSCS <= nRWEr;
			nRAS <= 1'b1;
			nCAS <= 1'b0;
			nSWE <= 1'b0;
			DQML <= Addr[0];
			DQMH <= ~Addr[0];

			// Column address
			SBAreg[1:0] <= Addr[23:22];
			SAreg[12:11] <= 2'b00;
			SAreg[9] <= 1'b0;
			SAreg[8:0] <= Addr[9:1];

			// Auto-precharge only if row will increment
			SAreg[10] <= Addr[9:0]==10'h3FF;

			SAmux <= 1'b1;
			RefWake <= 1'b0;
		end else if (DEVSELe[3] && RAr[3:0]==4'h3) begin
			// NOP
			SCKE <= ~nRWEr;
			nSCS <= nRWEr;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQML <= 1'b1;
			DQMH <= 1'b1;

			SAmux <= 1'b0;
			RefWake <= 1'b0;
		end else if (DEVSELe[4] && RAr[3:0]==4'h3) begin
			// NOP (auto-precharge from previous write)
			SCKE <= 1'b1;
			nSCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQML <= 1'b1;
			DQMH <= 1'b1;

			SAmux <= 1'b0;
			RefWake <= 1'b0;
		end else if (DEVSELe[5] && RAr[3:0]==4'h3) begin
			// ACT only if WR AP just occurred / NOP
			SCKE <= 1'b1;
			nSCS <= ~nRWEr && ~SAreg[10];
			nRAS <= 1'b0;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQML <= 1'b1;
			DQMH <= 1'b1;

			// Row address
			SBAreg[1:0] <= Addr[23:22];
			SAreg[12] <= 1'b0;
			SAreg[11:0] <= Addr[21:10];
			
			SAmux <= 1'b1;
			RefWake <= 1'b0;
		end else if (DEVSELe[6] && RAr[3:0]==4'h3) begin
			// RD
			SCKE <= 1'b1;
			nSCS <= 1'b0;
			nRAS <= 1'b1;
			nCAS <= 1'b0;
			nSWE <= 1'b1;
			DQML <= Addr[0];
			DQMH <= ~Addr[0];

			// Column address
			SBAreg[1:0] <= Addr[23:22];
			SAreg[12:11] <= 2'b00;
			SAreg[10] <= 1'b1; // auto-precharge
			SAreg[9] <= 1'b0;
			SAreg[8:0] <= Addr[9:1];

			SAmux <= 1'b1;
			RefWake <= 1'b0;
		end else if (DEVSELe[7] && RAr[3:0]==4'h3) begin
			// NOP
			SCKE <= 1'b1;
			nSCS <= 1'b1;
			nRAS <= 1'b1;
			nCAS <= 1'b1;
			nSWE <= 1'b1;
			DQML <= 1'b1;
			DQMH <= 1'b1;

			SAmux <= 1'b0;
			RefWake <= 1'b0;
		end else begin
			if (Tick[5] && ~RefDone) begin
				if (~RefWake) begin
					// NOP
					SCKE <= 1'b1;
					nSCS <= 1'b1;
					nRAS <= 1'b1;
					nCAS <= 1'b1;
					nSWE <= 1'b1;
					DQML <= 1'b1;
					DQMH <= 1'b1;

					RefWake <= 1'b1;
				end else begin
					// AREF
					SCKE <= 1'b1;
					nSCS <= 1'b0;
					nRAS <= 1'b0;
					nCAS <= 1'b0;
					nSWE <= 1'b1;
					DQML <= 1'b1;
					DQMH <= 1'b1;

					RefWake <= 1'b0;
					RefDone <= 1'b1;
				end
			end else begin
				// NOP ckdis
				SCKE <= 1'b0;
				nSCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				DQML <= 1'b1;
				DQMH <= 1'b1;

				RefWake <= 1'b0;
				if (Tick[5]) RefDone <= 1'b0;
			end

			SAmux <= 1'b0;
		end
	end

	/* UFM Interface */
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
		.busy (UFMBusy),
		.drdout (DRDOut),
		.osc (UFMOsc),
		.rtpbusy (RTPBusy));
	reg UFMBr = 0; // UFMBusy registered to sync with C14M
	reg RTPBr = 0; // RTPBusy registered to sync with C14M

	reg [15:0] Cfg;
	reg CfgLoaded = 0;
	// Do nothing when Tick15:14==2'h0
	// Get ready when Tick15:14==2'h1
	// 	Zero AR
	// Load Cfg when Tick15:14==2'h2
	// 	Tick13:6 (256) - first half of UFM looked at
	// 	Tick5:2 (16) - 16 bits loaded from UFM
	//		0: set CfgLoaded if DRDout==1, otherwise shift DRDout into Cfg
	//		1-14: continue shifting DRDout into Cfg[15:0]
	//		15: shift last DRDout bit into Cfg[15:0] and increment AR
	// 	Tick1:0 (4) - 1 bit shifted
	// Do nothing when Tick15:14==2'h3
	//	Set CfgLoaded too
	always @(posedge C25M) begin
		if (~CfgLoaded) begin
			if (Tick[15:14]==2'h0) begin
				// Do nothing
				ARShift <= 1;
				ARCLK <= 0;
				DRCLK <= 0;
			end else if (Tick[15:14]==2'h1) begin
				// Shift zeros into AR during first half
				if (~Tick[13]) begin
					ARShift <= 1;
					ARCLK <= Tick[1];
				end else begin
					ARShift <= 0;
					ARCLK <= 0;
				end

				// Load default config
				Cfg[15:0] <= 16'hFFFF;

				// Load indirect into DR at end
				if (Tick[13:0]==14'h3FFC || 
					Tick[13:0]==14'h3FFD || 
					Tick[13:0]==14'h3FFE || 
					Tick[13:0]==14'h3FFF || ) begin
					DRCLK <= 1;
				end else DRCLK <= 0;
			end else if (Tick[15:14]==2'h2) begin
				// Load 16 bits into Cfg register
				if (Tick[5:2]==4'h0 && Tick[1:0]==0 && DRDout) begin
					CfgLoaded <= 1;
				end else if (Tick[1:0]==0) begin
					Cfg[15:0] <= {Cfg[14:1], DRDout};
				end

				// Increment AR
				if (Tick[5:2]==4'hE) begin
					ARCLK <= 1;
				end else begin
					ARCLK <= 0;
				end

				// Load indirect into DR
				if (Tick[5:2]==4'hF) begin
					DRCLK <= 1;
				end else begin
					DRCLK <= 0;
				end

				ARShift <= 1'b0; // Only incrementing AR now
			end else if (Tick[15:14]==2'h3) begin
				// Do nothing
				ARShift <= 1;
				ARCLK <= 0;
				DRCLK <= 0;
				CfgLoaded <= 1; // in case setting at address 0xFF
			end

			DRShift <= 0; // Only reading DR during init, not writing UFM
			DRDIn <= 0;
		end else if (DEVSELe[0] && RAr[3:0]==4'h8) begin
			
		end else begin
			// Do nothing
			ARShift <= 1;
			ARCLK <= 0;
			DRCLK <= 0;
			DRShift <= 0;
			DRDIn <= 0;
		end
	end

	
	always @(posedge nDEVSEL, negedge nRST) begin
		if (~nRST) 
	end
endmodule
