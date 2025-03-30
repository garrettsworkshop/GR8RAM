module SlinkyRegisters(
		/* Clock signal */
		input CLK,
		/* Slinky/RamFactor mode bit */
		input SetRamFactorEN,
		/* Register command inputs */
		input AddrHWR,
		input AddrMWR,
		input AddrLWR,
		input AddrInc,
		input BankWR,
		input RegReset,
		/* Write data input */
		input [7:0] WRD,
		/* Slinky address register output */
		output reg [23:0] Addr,
		/* ROM bank register output */
		output reg Bank);
		
	/* Register increment state */
	reg AddrHInc;
	reg AddrMInc;

	/* Address high byte control */
	always @(posedge CLK) begin
		if (RegReset) Addr[23:16] <= SetRamFactorEN ? 8'h00 : 8'hF0;
		else if (AddrHWR) begin
			if (SetRamFactorEN) Addr[23:16] <= WRD[7:0];
			else Addr[23:16] <= { 4'hF, WRD[3:0] };
		end else if (AddrHInc) begin
			if (SetRamFactorEN) Addr[23:16] <= Addr[23:16]+8'h01;
			else Addr[23:16] <= { 4'hF, Addr[19:16]+4'h1 };
		end
	end

	/* Address middle byte control */
	always @(posedge CLK) begin
		if (RegReset) begin
			Addr[15:8] <= 0;
			AddrHInc <= 0;
		end else if (AddrMWR) begin
			Addr[15:8] <= WRD[7:0];
			AddrHInc <= Addr[15] && !WRD[7];
		end else if (AddrMInc) begin
			Addr[15:8] <= Addr[15:8]+8'h01;
			AddrHInc <= Addr[15:8]==8'hFF;
		end else AddrHInc <= 0;
	end

	/* Address low byte control */
	always @(posedge CLK) begin
		if (RegReset) begin
			Addr[7:0] <= 0;
			AddrMInc <= 0;
		end else if (AddrLWR) begin
			Addr[7:0] <= WRD[7:0];
			AddrMInc <= Addr[7] && !WRD[7];
		end else if (AddrInc) begin
			Addr[7:0] <= Addr[7:0]+8'h01;
			AddrMInc <= Addr[7:0]==8'hFF;
		end else AddrMInc <= 0;
	end

	/* ROM bank register  */
	always @(posedge CLK) begin
		if (RegReset) Bank <= 0;
		else if (BankWR) Bank <= WRD[0];
	end

endmodule