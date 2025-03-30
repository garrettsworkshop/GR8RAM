module GR8RAM(
	/* Apple II PHI0 clock */
	input PHI0,
	/* 25 MHz crystal oscillator input (not usually mounted) */
	input CLKin /* synthesis syn_force_pads=1 syn_noprune=1 */,
	/* LED output */
	output LED,
	/* Reset and IRQ */
	input nRESin,
	output nRESout,
	output nIRQout,
	/* DIP switch inputs */
	input [2:1] SW,
	/* Buffered address, write enable, data buses */
	input [15:0] BA /* synthesis syn_force_pads=1 syn_noprune=1 */,
	input nWE,
	inout [7:0] BD,
	output nDoutOE,
	output nDinOE,
	/* Card select signals */
	input nIOSEL, 
	input nDEVSEL, 
	input nIOSTRB,
	/* SDRAM bus */
	output RCLK,
	output [1:0] RBA,
	output [12:0] RA,
	output nRCS,
	output RCKE,
	output nRAS,
	output nCAS,
	output nRWE,
	output DQML,
	output DQMH,
	inout [7:0] RD,
	/* SPI NOR flash */
	inout nFCS,
	output FCK,
	inout MOSI,
	input MISO);
	
	assign LED = 1;
	
	/* Internal clock */
	wire CLK;
	defparam OSCH_inst.NOM_FREQ = "44.33";
	OSCH OSCH_inst(.STDBY(1'b0), .OSC(CLK), .SEDSTDBY());

	/* Apple II bus interface */
	wire [7:0] BI_WRD;
	wire BI_RAMRD, BI_ROMRD, BI_RAMWR, BI_RAMRef;
	wire AddrHWR, AddrMWR, AddrLWR, AddrInc, BankWR, RegReset;

    /* Slinky address and ROM bank registers */
	wire [23:0] Addr;
	wire Bank;

    /* Init controller */
	wire InitDone;
	wire [2:0] IC_RAMCmd;
	wire [24:0] IC_Addr;
	wire [7:0] IC_WRD;
	wire [1:0] SetSize;
	wire SetRamFactorEN;
	wire SetRestoreEN;
	
    /* SDRAM controller */
    wire [7:0] RDD;

	/* Apple II bus interface */
	BusInterface bi(
		/* Clock signal inputs */
		.CLK(CLK),
		.PHI0(PHI0),
		/* Apple II reset input */
		.nRES (nRESin),
		/* Card select signal inputs */
		.nDEVSEL(nDEVSEL),
		.nIOSEL(nIOSEL),
		.nIOSTRB(nIOSTRB),
		/* Buffered address, write enable inputs */
		.BA(BA[10:0]),
		.nWE(nWE),
		/* Data bus mux inputs */
		.RDD(RDD),
		.Addr(Addr),
		/* Data bus output and BD buffer control */
		.BD(BD),
		.nDoutOE(nDoutOE),
		.nDinOE(nDinOE),
		/* Write data output to slinky registers and RAM controller */
		.WRD(BI_WRD),
		/* Initialization done input from initialization controller */
		.BusEnable(InitDone),
		/* SDRAM command outputs */
		.RAMRD(BI_RAMRD),
		.ROMRD(BI_ROMRD),
		.RAMWR(BI_RAMWR),
		.RAMRef(BI_RAMRef),
		/* Register command outputs */
		.AddrHWR(AddrHWR),
		.AddrMWR(AddrMWR),
		.AddrLWR(AddrLWR),
		.AddrInc(AddrInc),
		.BankWR(BankWR),
		.RegReset(RegReset));


    /* Slinky address and ROM bank registers */
	SlinkyRegisters registers(
		/* Clock signal */
		.CLK(CLK),
		/* Slinky/RamFactor mode bit */
		.SetRamFactorEN(SetRamFactorEN),
		/* Register command inputs */
		.AddrHWR(AddrHWR),
		.AddrMWR(AddrMWR),
		.AddrLWR(AddrLWR),
		.AddrInc(AddrInc),
		.BankWR(BankWR),
		.RegReset(RegReset),
		/* Write data input */
		.WRD(BI_WRD),
		/* Slinky address register output */
		.Addr(Addr),
		/* ROM bank register output */
		.Bank(Bank));


    /* Init controller */
	InitController ic(
		/* Clock signal */
		.CLK(CLK),
		/* Settings input and outputs */
		.SW({ RD[0], SW[2:1] }),
		.SetSize(SetSize),
		.SetRamFactorEN(SetRamFactorEN),
		.SetRestoreEN(SetRestoreEN),
		/* Initialization done and POR outputs */
		.InitDone(InitDone),
		/* SDRAM command outputs */
		.RAMCmd(IC_RAMCmd),
		.RAMAddr(IC_Addr),
		/* SDRAM write data output */
		.WRD(IC_WRD),
		/* SPI flash bus */
		.nFCS(nFCS),
		.FCK(FCK),
		.MOSI(MOSI),
		.MISO(MISO));


    /* SDRAM controller */
	SDRAMController ram(
		/* Clock signal */
		.CLK(CLK),
		/* POR input from init controller */
		.InitDone(InitDone),
		/* Command inputs from bus interface */
		.BI_RAMRD(BI_RAMRD),
		.BI_RAMWR(BI_RAMWR),
		.BI_RAMRef(BI_RAMRef),
		.Addr(Addr),
		.BD(BD),
		/* Command inputs from init controller */
		.IC_RAMCmd(IC_RAMCmd),
		.IC_Addr(IC_Addr),
		.IC_WRD(IC_WRD),
		/* SDRAM bus */
		.RCLK(RCLK),
		.RBA(RBA),
		.RA(RA),
		.nRCS(nRCS),
		.RCKE(RCKE),
		.nRAS(nRAS),
		.nCAS(nCAS),
		.nRWE(nRWE),
		.DQML(DQML),
		.DQMH(DQMH),
		.RD(RD),
		/* SDRAM read data */
		.RDD(RDD));

    /* Reset output is InitDone */
    assign nRESout = InitDone;

	/* IRQ always disabled */
	assign nIRQout = 1;

endmodule
