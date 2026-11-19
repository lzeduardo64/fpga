module pll(
  input wire in_clk,
  output wire p_clk,
  output wire f_clk,
  output wire locked
);

  rPLL #(
    .FCLKIN("27.0"),
    .IDIV_SEL(2), // -> PFD = 9.0 MHz (range: 3-500 MHz)
    .FBDIV_SEL(13), // -> CLKOUT = 126.0 MHz (range: 3.90625-625 MHz)
    .ODIV_SEL(4) // -> VCO = 504.0 MHz (range: 500-1250 MHz)
    ) multiply (
      .CLKOUTP(),
      .CLKOUTD(),
      .CLKOUTD3(),
      .RESET(1'b0),
      .RESET_P(1'b0),
      .CLKFB(1'b0),
      .FBDSEL(6'b0),
      .IDSEL(6'b0),
      .ODSEL(6'b0),
      .PSDA(4'b0),
      .DUTYDA(4'b0),
      .FDLY(4'b0), 
        .CLKIN(in_clk), // 27.0 MHz
        .CLKOUT(f_clk), // 126.0 MHz
        .LOCK(locked)
    );

  CLKDIV #(
    .DIV_MODE("5"),
  ) divide (
    .HCLKIN(f_clk),
    .RESETN(locked),
    .CALIB(1'b0),
    .CLKOUT(p_clk)
  );

endmodule
