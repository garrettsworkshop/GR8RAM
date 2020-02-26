module GR8RAM(C7M, C7M_2, Q3, PHI0in, PHI1in, nRES, nMode,
			  A, RA, nWE, D, RD,
			  nDEVSEL, nIOSEL, nIOSTRB,
			  nRAS, nCAS0, nCAS1, nRCS, nROE, nRWE);

	/* Clock, Reset, Mode */
	input C7M, C7M_2, Q3, PHI0in, PHI1in; // Clock inputs
	input nRES;

	/* PHI1 Delay */
	wire [8:0] PHI1b;
	wire PHI1;
	LCELL PHI1b0_MC (.in(PHI1in), .out(PHI1b[0]));
	LCELL PHI1b1_MC (.in(PHI1b[0]), .out(PHI1b[1]));
	LCELL PHI1b2_MC (.in(PHI1b[1]), .out(PHI1b[2]));
	LCELL PHI1b3_MC (.in(PHI1b[2]), .out(PHI1b[3]));
	LCELL PHI1b4_MC (.in(PHI1b[3]), .out(PHI1b[4]));
	LCELL PHI1b5_MC (.in(PHI1b[4]), .out(PHI1b[5]));
	LCELL PHI1b6_MC (.in(PHI1b[5]), .out(PHI1b[6]));
	LCELL PHI1b7_MC (.in(PHI1b[6]), .out(PHI1b[7]));
	LCELL PHI1b8_MC (.in(PHI1b[7]), .out(PHI1b[8]));
	LCELL PHI1b9_MC (.in(PHI1b[8] & PHI1in), .out(PHI1));

	/* Address Bus, etc. */
	input nDEVSEL, nIOSEL, nIOSTRB; // Card select signals
	input [15:0] A; // 6502 address bus
	input nWE; // 6502 R/W
	output [10:0] RA; // DRAM/ROM address
	assign RA[10:8] = CASel ? Addr[21:19] : Addr[10:8];
	assign RA[7:0] = ~nIOSTRB ? Bank+1 :
		(~CASel & nIOSEL & nIOSTRB) ? Addr[18:11] :
		(CASel & nIOSEL & nIOSTRB) ? Addr[7:0] : 8'h00;

	/* Select Signals */
	wire BankSELA = A[3:0]==4'hF;
	wire RAMSELA = A[3:0]==4'h3;
	wire AddrHSELA = A[3:0]==4'h2;
	wire AddrMSELA = A[3:0]==4'h1;
	wire AddrLSELA = A[3:0]==4'h0;
	LCELL BankWR_MC (.in(BankSELA & ~nWE & ~nDEVSEL & REGEN), .out(BankWR)); wire BankWR;
	LCELL RAMSEL_MC (.in(RAMSELA & ~nDEVSEL & REGEN), .out(RAMSEL)); wire RAMSEL;
	LCELL AddrHWR_MC (.in(AddrHSELA & ~nWE & ~nDEVSEL & REGEN), .out(AddrHWR)); wire AddrHWR;
	LCELL AddrMWR_MC (.in(AddrMSELA & ~nWE & ~nDEVSEL & REGEN), .out(AddrMWR)); wire AddrMWR;
	LCELL AddrLWR_MC (.in(AddrLSELA & ~nWE & ~nDEVSEL & REGEN), .out(AddrLWR)); wire AddrLWR;

	/* Data Bus Routing */
	// DRAM/ROM data bus
	wire RDOE = DBEN & ~nWE;
	inout [7:0] RD = RDOE ? D[7:0] : 8'bZ;
	// Apple II data bus
	wire DOE = DBEN & nWE & 
		((~nDEVSEL & REGEN) | ~nIOSEL | (~nIOSTRB & IOROMEN));
	wire [7:0] Dout = (nDEVSEL | RAMSELA) ? RD[7:0] :
        AddrHSELA ? Addr[23:16] : 
        AddrMSELA ? Addr[15:8] : 
        AddrLSELA ? Addr[7:0] : 8'h00;
	inout [7:0] D = DOE ? Dout : 8'bZ;

	/* DRAM and ROM Control Signals */
	output nRCS = ~((~nIOSEL | (~nIOSTRB & IOROMEN)) & CSEN); // ROM chip select
	output nROE = ~nWE; // need this for flash ROM
	output nRWE = CASel ? nWE : 1'b1; // for ROM & DRAM
	output nRAS = ~(RASr | RASf);
	output nCAS0 = ~(CAS0f | (CASr & RAMSEL & ~Addr[22])); // DRAM CAS bank 0
	output nCAS1 = ~(CAS1f | (CASr & RAMSEL & Addr[22])); // DRAM CAS bank 1

  	/* 6502-accessible Registers */
	reg REGEN = 0; // Register enable
	reg IOROMEN = 0; // IOSTRB ROM enable
	reg [7:0] Bank = 0; // Bank register for ROM access
	reg [23:0] Addr = 0; // RAM address register
	
	/* Increment Control */
	reg IncAddrL = 0, IncAddrM = 0, IncAddrH = 0;
	
	/* Transfer Counters */
	reg [15:0] TCnt = 0;
	reg [15:0] Dest = 0;

	/* CAS rising/falling edge components */
	// These are combined to create the CAS outputs.
	reg CASr = 0, CAS0f = 0, CAS1f = 0;
	reg RASr = 0, RASf = 0;
	reg CASel = 0; // DRAM address multiplexer select

	/* State Counters */
	reg PHI1reg = 0; // Saved PHI1 at last rising clock edge
	reg PHI0seen = 0; // Have we seen PHI0 since reset?
	reg [2:0] S = 0; // State counter
	reg [3:0] Ref = 0; // Refresh skip counter
	reg DBEN = 0; // Data bus driver gating
	reg CSEN = 0; // ROM CS enable gating

	/* Configuration */
	input Mode;

	// Apple II Bus Compatibiltiy Rules:
	// Synchronize to PHI0 or PHI1. (PHI1 here)
	// PHI1's edge may be -20ns,+10ns relative to C7M.
	// Delay the rising edge of PHI1 to get enough hold time:
	// 		PHI1modified = PHI1 & PHI1delayed;
	// Only sample /DEVSEL, /IOSEL at these times:
	// 		2nd and 3rd rising edge of C7M in PHI0 (S4, S5)
	//		all 3 falling edges of C7M in PHI0 (S4, S5, S6)
	// Can sample /IOSTRB at same times as /IOSEL, plus:
	//		1st rising edge of C7M in PHI0 (S3)

	/* State counters */
	always @(posedge C7M) begin
		// Synchronize state counter to S1 when just entering PHI1
		PHI1reg <= PHI1; // Save old PHI1
		if (~PHI1) PHI0seen <= 1; // PHI0seen set in PHI0
		S <= (PHI1 & ~PHI1reg & PHI0seen) ? 4'h1 : 
			S==0 ? 3'h0 :
			S==7 ? 3'h7 : S+1;
		
		// Refresh counter allows DRAM refresh once every 13 cycles
		if (S==3) Ref <= (Ref[3:2]==2'b11) ? 4'h0 : Ref+1;
	end

	/* State-based data bus and ROM CS gating */
	always @(posedge C7M, negedge nRES) begin
		if (~nRES) begin
			DBEN <= 0;
			CSEN <= 0;
		end else begin
			// Only drive Apple II data bus after S4 to avoid bus fight.
			// Thus we wait 1.5 7M cycles (210 ns) into PHI0 before driving.
			// Same for driving the ROM/SRAM data bus (RD).
			DBEN <= S==4 | S==5 | S==6 | S==7;
			
			// Similarly, only select the ROM chip starting at
			// the end of S4 for reads and the end of S5 for writes.
			// This ensures that write data is valid for
			// the entire time that the ROM is selected,
			// and minimizes power consumption.
			CSEN <= (S==4 & nWE) | S==5 | S==6 | S==7;
		end
	end

	/* DEVSEL register and IOSTRB ROM enable */
	always @(posedge C7M, negedge nRES) begin
		if (~nRES) begin
			REGEN <= 0;
			IOROMEN <= 0;
		end else begin
			// Enable registers at end of S4 when IOSEL accessed (Cn00-CnFF).
			if (S==4 & ~nIOSEL) REGEN <= 1'b1;

			// Enable IOSTRB ROM when accessing CnXX in IOSEL ROM.
			if (S==4 & ~nIOSEL) IOROMEN <= 1'b1;
			// Disable IOSTRB ROM when accessing 0xCFFF.
			if (S==4 & ~nIOSTRB & A[10:0]==11'h7FF) IOROMEN <= 1'b0;
		end
	end
	
	/* Set registers */
	always @(negedge C7M, negedge nRES) begin
		if (~nRES) begin
			Addr <= 0;
			Bank <= 0;
			FullIOEN <= 0;
			IncAddrL <= 0;
			IncAddrM <= 0;
			IncAddrH <= 0;
		end else begin
			// Increment address register
			if (S==1 & IncAddrL) begin
				Addr[7:0] <= Addr[7:0]+1;
				IncAddrL <= 0;
				IncAddrM <= Addr[7:0] == 8'hFF;
			end
			if (S==2 & IncAddrM) begin
				Addr[15:8] <= Addr[15:8]+1;
				IncAddrM <= 0;
				IncAddrH <= Addr[15:8] == 8'hFF;
			end
			if (S==3 & IncAddrH) begin
				IncAddrH <= 0;
				Addr[23:16] <= Addr[23:16]+1;
			end
			
			// Set register in middle of S6 if accessed.
			if (S==6) begin
				if (BankWR) Bank[7:0] <= D[7:0]; // Bank
				
				IncAddrL <= RAMSEL;
				IncAddrM <= AddrLWR & Addr[7] & ~D[7];
				IncAddrH <= AddrMWR & Addr[15] & ~D[7];
				
				if (AddrHWR) Addr[23:16] <= D[7:0]; // Addr hi
				if (AddrMWR) Addr[15:8] <= D[7:0]; // Addr mid
				if (AddrLWR) Addr[7:0] <= D[7:0]; // Addr lo
			end
		end
	end

	/* DRAM RAS/CAS */
	always @(posedge C7M) begin
			RASr <= 	(S==1 & Ref==0) | // Refresh
						(S==4 & RAMSEL & nWE) | // Read: Early RAS
						(S==5 & RAMSEL & ~nWE); // Write: Late RAS
			CASel = 	(RAMSEL & nWE & S==4) | // Read: mux address early
						(RAMSEL & ~nWE & S==5); // Write: mux address late
			// Read: long, early CAS, gated later by RAMSEL
			CASr <= 	(nWE & (S==5 | S==6 | S==7));
	end
	always @(negedge C7M) begin
			RASf <= 	(S==4 & RAMSEL & nWE) | // Read: Early RAS
						(S==5 & RAMSEL & ~nWE); // Write: Late RAS
			CAS0f <= (S==1 & Ref==0) | // Refresh
						(S==5 & RAMSEL & ~Addr[22] & nWE) | // Read: Early CAS
						(S==6 & RAMSEL & ~Addr[22] & ~nWE); // Write: Late CAS
			CAS1f <= (S==1 & Ref==0) | // Refresh
						(S==5 & RAMSEL & Addr[22] & nWE) | // Read: Early CAS
						(S==6 & RAMSEL & Addr[22] & ~nWE); // Write: Late CAS
	end
endmodule