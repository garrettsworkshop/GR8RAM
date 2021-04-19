module GR8RAM(C25M, PHI0, nRES, nRESout, SetFW,
			  INTin, INTout, DMAin, DMAout, 
			  nNMIout, nIRQout, nRDYout, nINHout, RWout, nDMAout,
			  RA, nWE, RD, RAdir, RDdir, nIOSEL, nDEVSEL, nIOSTRB,
			  SBA, SA, nRCS, nRAS, nCAS, nSWE, DQML, DQMH, RCKE, SD,
			  nFCS, FCK, MISO, MOSI);

	/* Clock signals */
	input C25M, PHI0;
	reg PHI0r1, PHI0r2;
	always @(posedge C25M) begin PHI0r1 <= PHI0; PHI0r2 <= PHI0r1; end
	
	/* Unused Pins */
	output RAdir = 1;
	input INTin;
	output INTout = INTin;
	input DMAin;
	output DMAout = DMAin;
	output nDMAout = 1;
	output nNMIout = 1;
	output nINHout = 1;
	output nRDYout = 1;
	output nIRQout = 1;
	output RWout = 1;
	
	/* Reset/brown-out detect synchronized inputs */
	input nRES;
	reg nRESr0, nRESr;
	always @(posedge C25M) begin nRESr0 <= nRES; nRESr <= nRESr0; end

	/* Long state counter: counts from 0 to $3FFF */
	reg [13:0] LS = 0;
	always @(posedge C25M) begin if (PS==15) LS <= LS+1; end

	/* Init state */
	output reg nRESout = 0;
	reg [2:0] IS = 0;
	always @(posedge C25M) begin
		if (IS==7) nRESout <= 1;
		else if (PS==15) begin
			if (LS==14'h1FCE) IS <= 1; // PC all + load mode
			else if (LS==14'h1FCF) IS <= 4; // AREF pause, SPI select
			else if (LS==14'h1FFA) IS <= 5; // SPI flash command
			else if (LS==14'h1FFF) IS <= 6; // Flash load driver
			else if (LS==14'h3FFF) IS <= 7; // Operating mode
		end
	end

	/* Apple IO area select signals */
	input nIOSEL, nDEVSEL, nIOSTRB;

	/* Apple address bus */
	input [15:0] RA; input nWE;

	/* Apple select signals */
	wire ROMSpecRD = RA[15:12]==4'hC && RA[11:8]!=4'h0 && nWE && ((RA[11] && IOROMEN) || (~RA[11]));
	wire REGSpecSEL = RA[15:12]==4'hC && RA[11:8]==4'h0 && RA[7] && REGEN;
	wire BankSpecSEL = REGSpecSEL && RA[3:0]==4'hF;
	wire RAMSpecSEL = REGSpecSEL && RA[3:0]==4'h3;
	wire AddrHSpecSEL = REGSpecSEL && RA[3:0]==4'h2;
	wire AddrMSpecSEL = REGSpecSEL && RA[3:0]==4'h1;
	wire AddrLSpecSEL = REGSpecSEL && RA[3:0]==4'h0;
	reg ROMSpecRDr, RAMSpecSELr, nWEr;
	wire BankSEL = REGEN && ~nDEVSEL && BankSpecSEL;
	wire RAMSEL = ~nDEVSEL && RAMSpecSELr;
	wire RAMWR = RAMSEL && ~nWEr;
	wire AddrHSEL = REGEN && ~nDEVSEL && AddrHSpecSEL;
	wire AddrMSEL = REGEN && ~nDEVSEL && AddrMSpecSEL;
	wire AddrLSEL = REGEN && ~nDEVSEL && AddrLSpecSEL;
	always @(posedge PHI0) begin
		ROMSpecRDr <= ROMSpecRD;
		RAMSpecSELr <= RAMSpecSEL;
		nWEr <= nWE;
	end
	
	/* IOROMEN and REGEN control */
	reg IOROMEN = 0;
	reg REGEN = 0;
	always @(posedge C25M, negedge nRESr) begin
		if (~nRESr) begin
			IOROMEN <= 0;
			REGEN <= 0;
		end else if (PS==8 && ~nIOSTRB && RA[10:0]==11'h7FF) begin
			IOROMEN <= 0;
		end else if (PS==8 && ~nIOSEL) begin
			IOROMEN <= 1;
			REGEN <= 1;
		end
	end

	/* Apple data bus */
	inout [7:0] RD = RDdir ? 8'bZ : RDD[7:0];
	reg [7:0] RDD;
	output RDdir = ~(PHI0r2 && nWE && PHI0 &&
		(~nDEVSEL || ~nIOSEL || (~nIOSTRB && IOROMEN)));

	/* Slinky address registers */
	reg [23:0] Addr = 0;
	reg AddrIncL = 0;
	reg AddrIncM = 0;
	reg AddrIncH = 0;
	always @(posedge C25M, negedge nRESr) begin
		if (~nRESr) begin
			Addr[23:0] <= 24'h000000;
			AddrIncL <= 0;
			AddrIncM <= 0;
			AddrIncH <= 0;
		end else begin
			if (PS==8 && RAMSEL) AddrIncL <= 1;
			else AddrIncL <= 0;

			if (PS==8 && AddrLSEL && ~nWEr) begin
				Addr[7:0] <= RD[7:0];
				AddrIncM <= Addr[7] && ~RD[7];
			end else if (AddrIncL) begin
				Addr[7:0] <= Addr[7:0]+1;
				AddrIncM <= Addr[7:0]==8'hFF;
			end else AddrIncM <= 0;

			if (PS==8 && AddrMSEL && ~nWEr) begin
				Addr[15:8] <= RD[7:0];
				AddrIncH <= Addr[15] && ~RD[7];
			end else if (AddrIncM) begin
				Addr[15:8] <= Addr[15:8]+1;
				AddrIncH <= Addr[15:8]==8'hFF;
			end else AddrIncH <= 0;

			if (PS==8 && AddrHSEL && ~nWEr) begin
				Addr[23:16] <= RD[7:0];
			end else if (AddrIncH) begin
				Addr[23:16] <= Addr[23:16]+1;
			end
		end
	end

	/* ROM bank register */
	reg Bank = 0;
	always @(posedge C25M, negedge nRESr) begin
		if (~nRESr) Bank <= 0;
		else if (PS==8 && BankSEL && ~nWEr) begin
			Bank <= RD[0];
		end
	end

	/* SPI flash */
	output nFCS = FCKOE ? ~FCS : 1'bZ;
	reg FCS = 0;
	output FCK = FCKOE ? FCKout : 1'bZ;
	reg FCKOE = 0;
	reg FCKout = 0;
	inout MOSI = MOSIOE ? MOSIout : 1'bZ;
	reg MOSIOE = 0;
	reg MOSIout = 0;
	input MISO;
	always @(posedge C25M) begin
		case (PS[3:0])
			0: begin // NOP CKE
				FCKout <= 1'b1;
			end 1: begin // ACT
				FCKout <= ~(IS==5 || IS==6);
			end 2: begin // RD
				FCKout <= 1'b1;
			end 3: begin // NOP CKE
				FCKout <= ~(IS==5 || IS==6);
			end 4: begin // NOP CKE
				FCKout <= 1'b1;
			end 5: begin // NOP CKE
				FCKout <= ~(IS==5 || IS==6);
			end 6: begin // NOP CKE
				FCKout <= 1'b1;
			end 7: begin // NOP CKE
				FCKout <= ~(IS==5 || IS==6);
			end 8: begin // WR AP
				FCKout <= 1'b1;
			end 9: begin // NOP CKE
				FCKout <= ~(IS==5);
			end 10: begin // PC all
				FCKout <= 1'b1;
			end 11: begin // AREF
				FCKout <= ~(IS==5);
			end 12: begin // NOP CKE
				FCKout <= 1'b1;
			end 13: begin // NOP CKE
				FCKout <= ~(IS==5);
			end 14: begin // NOP CKE
				FCKout <= 1'b1;
			end 15: begin // NOP CKE
				FCKout <= ~(IS==5);
			end
		endcase
		FCS <= IS==4 || IS==5 || IS==6;
		MOSIOE <= IS==5;
		FCKOE <= IS==1 || IS==4 || IS==5 || IS==6 || IS==7;
	end

	always @(posedge C25M) begin
		case (PS[3:0])
			1: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b0; // Command bit 7
					3'h4: MOSIout <= 1'b0; // Address bit 23
					3'h5: MOSIout <= 1'b0; // Address bit 15
					3'h6: MOSIout <= 1'b0; // Address bit 7
					default MOSIout <= 1'b0;
				endcase
			end 3: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b0; // Command bit 6
					3'h4: MOSIout <= 1'b0; // Address bit 22
					3'h5: MOSIout <= SetROM[1]; // Address bit 14
					3'h6: MOSIout <= 1'b0; // Address bit 6
					default MOSIout <= 1'b0;
				endcase
			end 5: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b1; // Command bit 5
					3'h4: MOSIout <= 1'b0; // Address bit 21
					3'h5: MOSIout <= SetROM[0]; // Address bit 13
					3'h6: MOSIout <= 1'b0; // Address bit 5
					default MOSIout <= 1'b0;
				endcase
			end 7: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b1; // Command bit 4
					3'h4: MOSIout <= 1'b0; // Address bit 20
					3'h5: MOSIout <= 1'b0; // Address bit 12
					3'h6: MOSIout <= 1'b0; // Address bit 4
					default MOSIout <= 1'b0;
				endcase
			end 9: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b1; // Command bit 3
					3'h4: MOSIout <= 1'b0; // Address bit 19
					3'h5: MOSIout <= 1'b0; // Address bit 11
					3'h6: MOSIout <= 1'b0; // Address bit 3
					default MOSIout <= 1'b0;
				endcase
			end 11: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b0; // Command bit 2
					3'h4: MOSIout <= 1'b0; // Address bit 18
					3'h5: MOSIout <= 1'b0; // Address bit 10
					3'h6: MOSIout <= 1'b0; // Address bit 2
					default MOSIout <= 1'b0;
				endcase
			end 13: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b1; // Command bit 1
					3'h4: MOSIout <= 1'b0; // Address bit 16
					3'h5: MOSIout <= 1'b0; // Address bit 9
					3'h6: MOSIout <= 1'b0; // Address bit 1
					default MOSIout <= 1'b0;
				endcase
			end 15: begin
				case (LS[2:0])
					3'h3: MOSIout <= 1'b1; // Command bit 0
					3'h4: MOSIout <= 1'b0; // Address bit 15
					3'h5: MOSIout <= 1'b0; // Address bit 7
					3'h6: MOSIout <= 1'b0; // Address bit 0
					default MOSIout <= 1'b0;
				endcase
			end 
		endcase
	end

	input [1:0] SetFW;
	wire [1:0] SetROM = 2'b01;
	wire SetRF = SetFW[1:0] != 2'b11;
	wire SetLim1M = SetFW[1];
	wire SetLim8M = SetFW[1:0] != 2'b00;

	/* SDRAM data bus */
	inout [7:0] SD = SDOE ? WRD[7:0] : 8'bZ;
	reg [7:0] WRD;
	reg SDOE = 0;
	always @(posedge C25M) begin
		case (PS[3:0])
			0: begin // NOP CKE
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 1: begin // ACT
			end 2: begin // RD
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 3: begin // NOP CKE
			end 4: begin // NOP CKE
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 5: begin // NOP CKE
				if (AddrLSpecSEL) RDD[7:0] <= Addr[7:0];
				else if (AddrMSpecSEL) RDD[7:0] <= Addr[15:8];
				else if (AddrHSpecSEL) RDD[7:0] <= Addr[23:16];
				else if (AddrHSpecSEL) RDD[7:0] <= {4'hF, Addr[19:16]};
				else RDD[7:0] <= SD[7:0];
			end 6: begin // NOP CKE
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 7: begin // NOP CKE
			end 8: begin // WR AP
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 9: begin // NOP CKE
			end 10: begin // PC all
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 11: begin // AREF
			end 12: begin // NOP CKE
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 13: begin // NOP CKE
			end 14: begin // NOP CKE
				if (IS==6) WRD[7:0] <= { WRD[5:0], MISO, MOSI };
				else WRD[7:0] <= RD[7:0];
			end 15: begin // NOP CKE
			end
		endcase
	end

	reg [3:0] PS = 0;
	wire PSStart = PS==0 && PHI0r1 && ~PHI0r2;
	always @(posedge C25M) begin
		if (PSStart) PS <= 1;
		else if (PS==0) PS <= 0;
		else PS <= PS+1;
	end

	/* SDRAM address/command */
	output reg RCKE = 1;
	output reg nRCS = 1;
	output reg nRAS = 1;
	output reg nCAS = 1;
	output reg nSWE = 1;
	wire RefReqd = LS[1:0] == 2'b11;
	always @(posedge C25M) begin
		case (PS[3:0])
			0: begin // NOP CKE / NOP CKD
				RCKE <= PSStart;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;	
				nSWE <= 1'b1;
				SDOE <= 0;
			end 1: begin // ACT CKE / NOP CKD (ACT)
				RCKE <= IS==6 || (IS==7 && (ROMSpecRDr || RAMSpecSELr));
				nRCS <= ~(IS==6 || (IS==7 && (ROMSpecRDr || RAMSpecSELr)));
				nRAS <= 1'b0;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 2: begin // RD CKE / NOP CKD (RD)
				RCKE <= IS==7 && nWEr && (ROMSpecRDr || RAMSpecSELr);
				nRCS <= ~(IS==7 && nWEr && (ROMSpecRDr || RAMSpecSELr));
				nRAS <= 1'b1;
				nCAS <= 1'b0;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 3: begin // NOP CKE / CKD
				RCKE <= IS==7 && nWEr && (ROMSpecRDr || RAMSpecSELr);
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 4: begin // NOP CKD
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 5: begin // NOP CKD
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 6: begin // NOP CKD
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 7: begin // NOP CKE / CKD
				RCKE <= IS==6 || (RAMWR && IS==7);
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 8: begin // WR AP CKE / NOP CKD (WR AP)
				RCKE <= IS==6 || (RAMWR && IS==7);
				nRCS <= ~(IS==6 || (RAMWR && IS==7));
				nRAS <= 1'b1;
				nCAS <= 1'b0;
				nSWE <= 1'b0;
				SDOE <= IS==6 || (RAMWR && IS==7);
			end 9: begin // NOP CKE / NOP CKD
				RCKE <= 1'b1;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end 10: begin // PC all CKE / PC all CKD
				RCKE <= IS==1 || IS==4 || IS==5 || IS==6 || (IS==7 && RefReqd);
				nRCS <= 1'b0;
				nRAS <= 1'b0;
				nCAS <= 1'b1;
				nSWE <= 1'b0;
				SDOE <= 0;
			end 11: begin // LDM CKE / AREF CKE / NOP CKD
				RCKE <= IS==1 || IS==4 || IS==5 || IS==6 || (IS==7 && RefReqd);
				nRCS <= ~(IS==1 || IS==4 || IS==5 || IS==6 || (IS==7 && RefReqd));
				nRAS <= 1'b0;
				nCAS <= 1'b0;
				nSWE <= ~(IS==1);
				SDOE <= 0;
			end default: begin // NOP CKD
				RCKE <= 1'b0;
				nRCS <= 1'b1;
				nRAS <= 1'b1;
				nCAS <= 1'b1;
				nSWE <= 1'b1;
				SDOE <= 0;
			end
		endcase
	end
	output reg DQML = 1;
	output reg DQMH = 1;
	output reg [1:0] SBA;
	output reg [12:0] SA;
	always @(posedge C25M) begin
		case (PS[3:0])
			0: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 1: begin // ACT
				DQML <= 1'b1;
				DQMH <= 1'b1;
				if (IS==6) begin
					SBA[1:0] <= { 2'b10 };
					SA[12:0] <= { 10'b0011000100, LS[12:10] };
				end else if (RAMSpecSELr) begin
					SBA[1:0] <= { 1'b0, Addr[23] };
					SA[12:0] <= Addr [22:10];
				end else begin
					SBA[1:0] <= 2'b10;
					SA[12:0] <= { 10'b0011000100, Bank, RA[11:10] };
				end
			end 2: begin // RD
				if (RAMSpecSELr) begin
					SBA[1:0] <= { 1'b0, Addr[23] };
					SA[12:0] <= { 4'b0011, Addr[9:1] };
					DQML <= Addr[0];
					DQMH <= ~Addr[0];
				end else begin
					SBA[1:0] <= 2'b10;
					SA[12:0] <= { 4'b0011, RA[9:1]};
					DQML <= RA[0];
					DQMH <= ~RA[0];
				end
			end 3: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 4: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 5: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 6: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 7: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 8: begin // WR AP
				if (IS==6) begin
					SBA[1:0] <= 2'b10;
					SA[12:0] <= { 4'b0011, LS[9:1] };
					DQML <= LS[0];
					DQMH <= ~LS[0];
				end else begin
					SBA[1:0] <= { 1'b0, Addr[23] };
					SA[12:0] <= { 4'b0011, Addr[9:1] };
					DQML <= Addr[0];
					DQMH <= ~Addr[0];
				end
			end 9: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 10: begin // PC all
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 11: begin // AREF / load mode
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0001000100000;
			end 12: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 13: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 14: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end 15: begin // NOP CKE
				DQML <= 1'b1;
				DQMH <= 1'b1;
				SBA[1:0] <= 2'b00;
				SA[12:0] <= 13'b0011000100000;
			end
		endcase
	end
endmodule
