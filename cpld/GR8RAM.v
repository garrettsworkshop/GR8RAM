module GR8RAM(C7M, C7M_2, Q3, PHI0in, PHI1in, nRES, MODE,
			  A, RA, nWE, D, RD, nINH,
			  nDEVSEL, nIOSEL, nIOSTRB,
			  nRAS, nCAS0, nCAS1, nRCS, nROE, nRWE,
			  C7Mout, PHI1out);

	/* Clock, Reset, Mode */
	input C7M, C7M_2, Q3, PHI0in, PHI1in; // Clock inputs
	input nRES, MODE; // Reset, mode

	/* PHI1 Delay */
	wire [6:0] PHI1b;
	wire PHI1;
	LCELL PHI1b0_MC (.in(PHI1in), .out(PHI1b[0]));
	LCELL PHI1b1_MC (.in(PHI1b[0]), .out(PHI1b[1]));
	LCELL PHI1b2_MC (.in(PHI1b[1]), .out(PHI1b[2]));
	LCELL PHI1b3_MC (.in(PHI1b[2]), .out(PHI1b[3]));
	LCELL PHI1b4_MC (.in(PHI1b[3]), .out(PHI1b[4]));
	LCELL PHI1b5_MC (.in(PHI1b[4]), .out(PHI1b[5]));
	LCELL PHI1b6_MC (.in(PHI1b[5]), .out(PHI1b[6]));
	LCELL PHI1b7_MC (.in(PHI1b[6] & PHI1in), .out(PHI1));
	output C7Mout = C7M_2;
	output PHI1out = PHI1;

	/* Address Bus, etc. */
	input nDEVSEL, nIOSEL, nIOSTRB; // Card select signals
	input [15:0] A; // 6502 address bus
	input nWE; // 6502 R/W
	output [10:0] RA; // DRAM/ROM address
	assign RA[10:8] = ASel ? Addr[10:8] : Addr[21:19];
	assign RA[7:1] = ~nDEVSEL ? (ASel ? Addr[7:1] : Addr[18:12]) : Bank[6:0];
	assign RA[0] = ~nDEVSEL ? (ASel ? Addr[0] : Addr[11]) : A[11];

	/* Data Bus Routing */
	// DRAM/ROM data bus
	wire RDOE = nRES | (CSDBEN & (~nWE | (nDEVSEL & nIOSEL & nIOSTRB)));
	inout [7:0] RD = RDOE ? D[7:0] : 8'bZ;
	// Apple II data bus
	wire DOE = nRES & CSDBEN & nWE & 
		((~nDEVSEL & REGEN) | ~nIOSEL | (~nIOSTRB & IOROMEN));
	wire [7:0] Dout = (nDEVSEL | RAMSELA) ? RD[7:0] :
        AddrHSELA ? {1'b1, Addr[22:16]} : 
        AddrMSELA ? Addr[15:8] : 
        AddrLSELA ? Addr[7:0] : 8'h00;
	inout [7:0] D = DOE ? Dout : 8'bZ;
	
	/* Inhibit output */
	wire AROMSEL;
	LCELL AROMSEL_MC (.in((A[15:12]==4'hD | A[15:12]==4'hE | A[15:12]==4'hF) & nWE & ~MODE), .out(AROMSEL));
	output nINH = AROMSEL ? 1'b0 : 1'bZ;

	/* DRAM and ROM Control Signals */
	output nRCS = ~((~nIOSEL | (~nIOSTRB & IOROMEN)) & CSDBEN); // ROM chip select
	output nROE = ~nWE; // need this for flash ROM
	output nRWE = ~(~nWE & (~nDEVSEL | ~nIOSEL | ~nIOSTRB)); // for ROM & DRAM
	output nRAS = ~(RASr | RASf);
	output nCAS0 = ~(CASr | (CASf & ~nDEVSEL & ~Addr[22])); // DRAM CAS bank 0
	output nCAS1 = ~(CASr | (CASf & ~nDEVSEL & Addr[22])); // DRAM CAS bank 1

  	/* 6502-accessible Registers */
	reg [6:0] Bank = 7'h00; // Bank register for ROM access
	reg [22:0] Addr = 23'h00000; // RAM address register

	/* CAS rising/falling edge components */
	// These are combined to create the CAS outputs.
	reg CASr = 1'b0;
	reg CASf = 1'b0;
	reg RASr = 1'b0;
	reg RASf = 1'b0;

	/* State Counters */
	reg PHI1reg = 1'b0; // Saved PHI1 at last rising clock edge
	reg PHI0seen = 1'b0; // Have we seen PHI0 since reset?
	reg [2:0] S = 3'h0; // State counter
	reg [3:0] Ref = 4'h0; // Refresh skip counter

	/* Select Signals */
	reg RAMSELreg = 1'b0; // RAMSEL registered at end of S4
	wire BankSELA = A[3:0]==4'hF;
	wire RAMSELA = A[3:0]==4'h3;
	wire AddrHSELA = A[3:0]==4'h2;
	wire AddrMSELA = A[3:0]==4'h1;
	wire AddrLSELA = A[3:0]==4'h0;
	LCELL BankWR_MC (.in(BankSELA & ~nWE & ~nDEVSEL & REGEN), .out(BankWR));
	wire BankWR; // Bank reg. at Cn0F
	wire RAMSEL = RAMSELA & ~nDEVSEL & REGEN; // RAM data reg. at Cn03
	wire AddrHWR = AddrHSELA & ~nWE & ~nDEVSEL & REGEN; // Addr. hi reg. at Cn02
	wire AddrMWR = AddrMSELA & ~nWE & ~nDEVSEL & REGEN; // Addr. mid reg. at Cn01
	wire AddrLWR = AddrLSELA & ~nWE & ~nDEVSEL & REGEN; // Addr. lo reg. at Cn00

	/* Misc. */
	reg REGEN = 0; // Register enable
	reg IOROMEN = 0; // IOSTRB ROM enable
	reg CSDBEN = 0; // ROM CS, data bus driver gating
	reg ASel = 0; // DRAM address multiplexer select

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

	always @(posedge C7M, negedge nRES) begin
		if (~nRES) begin // Reset
			PHI1reg <= 1'b0;
			PHI0seen <= 1'b0;
			S <= 3'h0;
			Ref <= 3'b000;
			REGEN <= 1'b0;
			IOROMEN <= 1'b0;
			CSDBEN <= 1'b0;
			Addr <= 23'h000000;
			Bank <= 7'h00;
			RAMSELreg <= 1'b0;
		end else begin
			// Synchronize state counter to S1 when just entering PHI1
			PHI1reg <= PHI1; // Save old PHI1
			if (~PHI1) PHI0seen <= 1; // PHI0seen set in PHI0
			S <= (PHI1 & ~PHI1reg & PHI0seen) ? 4'h1 : 
				S==0 ? 3'h0 :
				S==7 ? 3'h7 : S+1;
			
			// Refresh counter allows DRAM refresh once every 13 cycles
			if (S==3) Ref <= (Ref[3:2] == 2'b11) ? 4'h0 : Ref+1;

			// Disable IOSTRB ROM when accessing 0xCFFF.
			if (S==3 & ~nIOSTRB & A[10:0]==11'h7FF) IOROMEN <= 1'b0;

			// Registers enabled at end of S4 by any IOSEL access (Cn00-CnFF).
			if (S==4 & ~nIOSEL) REGEN <= 1;

			// Enable IOSTRB ROM when accessing 0xCn00 in IOSEL ROM.
			if (S==4 & ~nIOSEL /* & A[7:0]==8'h00 */) IOROMEN <= 1'b1;

			// Register RAM "register" selected at end of S4.
			if (S==4) RAMSELreg <= RAMSEL;

			// Only drive Apple II data bus after state 4 to avoid bus fight.
			// Thus we wait 1.5 7M cycles (210 ns) into PHI0 before driving.
			// Same for driving the ROM/SRAM data bus (RD).
			// Similarly, only select the ROM chip starting at the end of S4.
			// This provides address setup time for write operations and 
			// minimizes power consumption.
			CSDBEN <= S[2]; /*S==4 | S==5 | S==6 | S==7 */

			// Increment address register after RAM access,
			// otherwise set register during S6 if accessed.
			if (S==1 & RAMSELreg) Addr <= Addr+1; // RAMSELreg refers to prev.
			else if (S==6) begin
				if (AddrHWR) Addr[22:16] <= D[6:0]; // Addr hi
				if (AddrMWR) Addr[15:8] <= D[7:0]; // Addr mid
				if (AddrLWR) Addr[7:0] <= D[7:0]; // Addr lo
				if (BankWR) Bank[6:0] <= D[6:0]; // Bank
			end
		end
	end

	/* DRAM RAS/CAS */
	always @(posedge C7M, negedge nRES) begin
		if (~nRES) begin RASr <= 1'b0; CASr <= 1'b0; ASel <= 1'b0;
		end else begin
			// RAS already asserted in middle of S4,
			// so hold RAS through S5
			RASr <= (S==4 & RAMSEL);

			// Multiplex DRAM address in at end of S4 through S5 end.
			ASel = RAMSEL & S[2] & ~S[1]; /*(S==4 | S==5)*/

			// Refresh at end of S1 (i.e. through S2) 
			// CAS whenever RAM seleced
			CASr <= (S==1 & Ref==0) | (S==5 & RAMSEL);
		end
	end
	always @(negedge C7M_2, negedge nRES) begin
		if (~nRES) begin RASf <= 1'b0; CASf <= 1'b0;
		end else begin
			// Refresh in S2
			// Row activate in S4 when accessing RAM
			// Hold RAS in S5 when not doing late CAS for write.
			RASf <= (S==2 & Ref==0) | ((S==4 | (S==5 & ~nWE) & RAMSEL));

			// CASf gated by nDEVSEL; no need to predicate on RAMSEL.
			// Early CAS in S5 for read operations.
			CASf <= (S==5 & nWE) | (S==6) | (S==7);
		end
	end
endmodule
