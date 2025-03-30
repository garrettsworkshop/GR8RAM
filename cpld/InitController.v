module InitController(
		/* Clock signal */
		input CLK,
		/* Settings input and outputs */
		input [3:1] SW,
		output reg [1:0] SetSize,
		output reg SetRamFactorEN,
		output reg SetRestoreEN,
		/* Initialization done and POR outputs */
		output reg InitDone,
		/* SDRAM command outputs */
		output reg [2:0] RAMCmd,
		output reg [24:0] RAMAddr,
		/* SDRAM write data output */
		output reg [7:0] WRD,
		/* SPI flash bus */
		inout nFCS,
		output FCK,
		inout MOSI,
		input MISO);

	/* RAM command definitions */
	`define RC_NOP (3'h0)
	`define RC_LDM (3'h1)
	`define RC_ACT (3'h2)
	`define RC_WR  (3'h3)
	`define RC_PC  (3'h4)
	`define RC_Ref (3'h5)
		
	/* Init state */
	reg [12:0] CS = 0;
	reg [12:0] LS = 0;
	reg [3:0] IS = 0;

	/* /FCS output */
	reg FOE = 0;
	reg nFCSout;
	wire nFCSin;
	BB fcs_bb(.I(nFCSout), .T(FOE), .O(nFCSin), .B(nFCS));

	/* FCK output */
	reg FCKEN;
	wire FCKout;
    ODDRX1F fck_oddr(.D0(1'b0), .D1(FCKEN), 
        .SCLK(CLK), .RST(1'b0), .Q(FCKout));
	OBZ fck_iobz(.I(FCKout), .T(FOE), .O(FCK));

	/* MOSI output */
	reg MOSIOE = 0;
	reg MOSIout;
	wire MOSIin;
	BB mosi_bb(.I(MOSIout), .T(MOSIOE), .O(MOSIin), .B(MOSI));

	/* Flash alternate master detect */
	reg FlashProgDetected;
	always @(posedge CLK) begin
		if (IS==0) FlashProgDetected <= 0;
		else if (!nFCSin) FlashProgDetected <= 1;
	end

	/* CS (command state) control -- lowest order */
	wire CSTC = CS[12:0]==13'h103F;
	always @(posedge CLK) begin
		if (CSTC) CS[12:0] <= 0;
		else CS[12:0] <= CS+13'h0001;
	end

	/* LS (long state) control -- medium order */
	wire LSTC =
		IS==0 ? LS[12:0]==13'h003F : // POR pause
		IS==1 ? LS[12:0]==13'h01FF : // Check to see if flash programmer attached
		IS==2 ? LS[12:0]==13'h0000 : // Issue flash command
		IS==3 ? LS[12:0]==13'h0007 : // Load flash to RAM
		IS==4 ? LS[12:0]==13'h0000 : // End flash command
		IS==5 ? LS[12:0]==13'h0000 : // Issue flash command
		IS==6 ? LS[12:0]==13'h1FFF : // Load flash to RAM
		IS==7 ? LS[12:0]==13'h0000 : // End flash command
		IS==8 ? LS[12:0]==13'h0000 : // Operation mode
		IS==9 ? LS[12:0]==13'h0000 : // Inhibit mode
		1; // Other
	always @(posedge CLK) begin
		if (CSTC) begin
			if (LSTC) LS <= 0;
			else LS <= LS+13'h0001;
		end
	end

	/* IS (init state) control -- high order */
	always @(posedge CLK) begin
		if (LSTC && CSTC) case (IS)
			4'h0: IS <= 4'h1;
			4'h1: IS <= FlashProgDetected ? 4'h9 : 4'h2;
			4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7: IS <= IS+4'h1;
			4'h8: IS <= 4'h8;
			4'h9: IS <= 4'h9;
			default: IS <= 4'h9;
		endcase
	end

	/* Apple II reset output control */
	always @(posedge CLK) InitDone <= IS==8;
	
	/* RAM write address generation */
	wire [24:0] RAMDriverAddr = 25'h1000000;
	wire [24:0] RAMImageAddr = 25'h0000000;
	always @(posedge CLK) RAMAddr[24:0] <=
		IS==3 ? { RAMDriverAddr[24:13],  LS[2:0], CS[11:2] } :
		IS==6 ? {  RAMImageAddr[24:23], LS[12:0], CS[11:2] } :
		25'h1FFFFFF;

	/* Flash driver address */
	wire [23:0] FlashDriverRFAddr = 24'hFF8000;
	wire [23:0] FlashDriverSlinkyAddr = 24'hFF0000;
	wire [23:0] FlashDriverAddr =
		SetRamFactorEN ? FlashDriverRFAddr : FlashDriverSlinkyAddr;

	/* Flash image address */
	wire [23:0] FlashImageRF1MBAddr = 24'h900000;
	wire [23:0] FlashImageSlinky1MBAddr = 24'h800000;
	wire [23:0] FlashImageRF8MBAddr = 24'h000000;
	wire [23:0] FlashImageAddr =
		(SetRamFactorEN && SetSize==2'b00) ? FlashImageRF1MBAddr :
		(SetRamFactorEN && SetSize!=2'b00) ? FlashImageRF8MBAddr :
		FlashImageSlinky1MBAddr;

	/* Flash address */
	wire [23:0] FlashAddr = 
		(IS==1) ? FlashDriverAddr[23:0] : FlashImageAddr[23:0];

	/* Flash command */
	wire [7:0] FlashCommand = 8'h3B;

	/* Settings decode */
	always @(posedge CLK) begin
		if (IS==0 && LSTC && CSTC) case (SW[2:1])
			2'b00: begin // 16 MB RamFactor
				SetSize <= 2'b11;
				SetRamFactorEN <= 1;
				SetRestoreEN <= 0;
			end 2'b01: begin // 8 MB RamFactor
				SetSize <= 2'b01;
				SetRamFactorEN <= 1;
				SetRestoreEN <= /*!*/SW[3];
			end 2'b10: begin // 1 MB RamFactor
				SetSize <= 2'b00;
				SetRamFactorEN <= 1;
				SetRestoreEN <= /*!*/SW[3];
			end 2'b11: begin // 1 MB Slinky
				SetSize <= 2'b00;
				SetRamFactorEN <= 0;
				SetRestoreEN <= /*!*/SW[3];
			end
		endcase
	end

	/* SPI flash control */
	always @(posedge CLK) begin
		case (IS)
			0, 1: begin // POR pause and flash check
				FOE <= 0;
				nFCSout <= 1;
				FCKEN <= 0;
				MOSIOE <= 0;
				MOSIout <= 0;
				RAMCmd <= `RC_NOP;
			end 2, 5: begin
				FOE <= 1;
				case (CS[12:0]) // Send command
					13'h0000: begin
						nFCSout <= 1;
						FCKEN <= 0;
						MOSIout <= 0;
						MOSIOE <= 1;
						RAMCmd <= `RC_PC;
					end 13'h0004: begin
						nFCSout <= 1;
						FCKEN <= 0;
						MOSIout <= 0;
						MOSIOE <= 1;
						RAMCmd <= `RC_LDM;
					end 13'h0008, 13'h000C,
						13'h0010, 13'h0014, 13'h0018, 13'h001C,
						13'h0020, 13'h0024, 13'h0028, 13'h002C,
						13'h0030, 13'h0034, 13'h0038, 13'h003C,
						13'h0040, 13'h0044, 13'h0048, 13'h004C,
						13'h0050, 13'h0054, 13'h0058, 13'h005C,
						13'h0060, 13'h0064, 13'h0068, 13'h006C,
						13'h0070, 13'h0074, 13'h0078, 13'h007C: begin
						nFCSout <= 1;
						FCKEN <= 0;
						MOSIout <= 0;
						MOSIOE <= 1;
						RAMCmd <= `RC_Ref;
					end 13'h1010, 13'h1011, 13'h1012, 13'h1013,
						13'h1014, 13'h1015, 13'h1016: begin // /CS low
						nFCSout <= 0;
						FCKEN <= 0;
						MOSIout <= 0;
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1017: begin // Command bit 7 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[7];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1018: begin // Command bit 6 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[6];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1019: begin // Command bit 5 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[5];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h101A: begin // Command bit 4 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[4];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h101B: begin // Command bit 3 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[3];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h101C: begin // Command bit 2 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[2];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h101D: begin // Command bit 1 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[1];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h101E: begin // Command bit 0 (0x3B)
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashCommand[0];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h101F: begin // Address bit 23
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[23];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1020: begin // Address bit 22
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[22];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1021: begin // Address bit 21
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[23];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1022: begin // Address bit 20
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[20];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1023: begin // Address bit 19
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[19];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1024: begin // Address bit 18
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[18];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1025: begin // Address bit 17
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[17];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1026: begin // Address bit 16
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[16];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1027: begin // Address bit 15
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[15];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1028: begin // Address bit 14
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[14];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1029: begin // Address bit 13
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[13];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h102A: begin // Address bit 12
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[12];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h102B: begin // Address bit 11
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[11];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h102C: begin // Address bit 10
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[10];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h102D: begin // Address bit 9
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[9];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h102E: begin // Address bit 8
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[8];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h102F: begin // Address bit 7
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[7];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1030: begin // Address bit 6
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[6];
						MOSIOE <= 1;
						RAMCmd <= `RC_Ref;
					end 13'h1031: begin // Address bit 5
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[5];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1032: begin // Address bit 4
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[4];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1033: begin // Address bit 3
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[3];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1034: begin // Address bit 2
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[2];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1035: begin // Address bit 1
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[1];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1036: begin // Address bit 0
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= FlashAddr[0];
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end 13'h1037: begin // First dummy bit
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= 0;
						MOSIOE <= 0;
						RAMCmd <= `RC_NOP;
					end 13'h1038, 13'h1039, 13'h103A, // Dummy bits 2-8
					    13'h103B, 13'h103C, 13'h103D, 13'h103E: begin
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= 0;
						MOSIOE <= 0;
						RAMCmd <= `RC_NOP;
					end 13'h103F: begin // First data bit output
						nFCSout <= 0;
						FCKEN <= 1;
						MOSIout <= 0;
						MOSIOE <= 0;
						RAMCmd <= `RC_NOP;
					end default: begin
						nFCSout <= 1;
						FCKEN <= 0;
						MOSIout <= 0;
						MOSIOE <= 1;
						RAMCmd <= `RC_NOP;
					end
				endcase
			end 3, 6: begin // Load flash to RAM
				FOE <= 1;
				nFCSout <= 0;
				MOSIout <= 0;
				MOSIOE <= 0;
				if (!CS[12]) begin
					FCKEN <= 1;
					if (CS[11:0]==0) RAMCmd <= `RC_ACT;
					else if (CS[1:0]==2'b11) RAMCmd <= `RC_WR;
					else RAMCmd <= `RC_NOP;
				end else begin
					FCKEN <= 0;
					case (CS)
						13'h1002: RAMCmd <= `RC_PC;
						13'h1004, 13'h1008, 13'h100C,
						13'h1010, 13'h1014, 13'h1018, 13'h101C,
						13'h1020, 13'h1024, 13'h1028, 13'h102C,
						13'h1030, 13'h1034, 13'h1038, 13'h103C: RAMCmd <= `RC_Ref;
						default: RAMCmd <= `RC_NOP;
					endcase
				end
			end 4, 7: begin // End flash command
				FOE <= 1;
				nFCSout <= 1;
				FCKEN <= 0;
				MOSIout <= 0;
				MOSIOE <= 0;
				case (CS)
					13'h1002: RAMCmd <= `RC_PC;
					13'h1004, 13'h1008, 13'h100C,
					13'h1010, 13'h1014, 13'h1018, 13'h101C,
					13'h1020, 13'h1024, 13'h1028, 13'h102C,
					13'h1030, 13'h1034, 13'h1038, 13'h103C: RAMCmd <= `RC_Ref;
					default: RAMCmd <= `RC_NOP;
				endcase
			end 8: begin // Operating mode
				FOE <= 1;
				nFCSout <= 1;
				FCKEN <= 0;
				MOSIout <= 0;
				MOSIOE <= 0;
				RAMCmd <= `RC_NOP;
			end 9: begin // Flash sleep
				FOE <= 0;
				nFCSout <= 1;
				FCKEN <= 0;
				MOSIout <= 0;
				MOSIOE <= 0;
				RAMCmd <= `RC_NOP;
			end default: begin // Else
				FOE <= 1;
				nFCSout <= 1;
				FCKEN <= 0;
				MOSIout <= 0;
				MOSIOE <= 0;
				RAMCmd <= `RC_NOP;
			end
		endcase
	end

	/* MISO and MOSI capture on falling edge */
	reg MISOr, MOSIr;
	always @(negedge CLK) MISOr <= MISO;
	always @(negedge CLK) MOSIr <= MOSIin;

	/* Input data shift register */
	always @(posedge CLK) begin
		WRD[7:0] <= SetRestoreEN ? { WRD[5:0], MISOr, MOSIr } : 8'h00;
	end
endmodule