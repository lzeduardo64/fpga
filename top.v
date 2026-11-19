module top (
    input wire b_clk,       
    output wire tmds_clk_p,
    output wire tmds_clk_n,
    output wire [2:0] tmds_d_p,
    output wire [2:0] tmds_d_n,
    output wire led1
);

    wire p_clk; // 25 MHz
    wire f_clk;  // 126 MHz
    wire pll_locked;
    wire hsync;
    wire vsync;
    wire visible;
    wire [9:0] x;

    blinky my_blink (
        .clk(b_clk),
        .led(led1)
    );

    pll my_pll (
        .in_clk(b_clk),
        .p_clk(p_clk),
        .f_clk(f_clk),
        .locked(pll_locked)
    );

    timing vga_gen (
        .clk(p_clk),
        .hsync(hsync),
        .vsync(vsync),
        .visible(visible),
        .x(x)
    );

    wire [7:0] r_data;
    wire [7:0] g_data;
    wire [7:0] b_data;

    image image (
        .x(x),
        .r(r_data),
        .g(g_data),
        .b(b_data)
    );

    wire [9:0] b_code;
    wire [9:0] r_code;
    wire [9:0] g_code;
    tmds b_hdmi_tmds (
        .clk(p_clk),
        .data(b_data),
        .control({vsync, hsync}),
        .visible(visible),
        .code(b_code)
    );
    tmds r_hdmi_tmds (
        .clk(p_clk),
        .data(r_data),
        .control(2'b00),
        .visible(visible),
        .code(r_code)
    );
    tmds g_hdmi_tmds (
        .clk(p_clk),
        .data(g_data),
        .control(2'b00),
        .visible(visible),
        .code(g_code)
    );
   
    wire [2:0] serial;

    OSER10 b_serial (
        .PCLK(p_clk),
        .FCLK(f_clk),
        .RESET(~pll_locked),
        .D0(b_code[0]),
        .D1(b_code[1]),
        .D2(b_code[2]),
        .D3(b_code[3]),
        .D4(b_code[4]),
        .D5(b_code[5]),
        .D6(b_code[6]),
        .D7(b_code[7]),
        .D8(b_code[8]),
        .D9(b_code[9]),
        .Q(serial[0])
    );

    OSER10 r_serial (
        .PCLK(p_clk),
        .FCLK(f_clk),
        .RESET(~pll_locked),
        .D0(r_code[0]),
        .D1(r_code[1]),
        .D2(r_code[2]),
        .D3(r_code[3]),
        .D4(r_code[4]),
        .D5(r_code[5]),
        .D6(r_code[6]),
        .D7(r_code[7]),
        .D8(r_code[8]),
        .D9(r_code[9]),
        .Q(serial[1])
    );

    OSER10 g_serial (
        .PCLK(p_clk),
        .FCLK(f_clk),
        .RESET(~pll_locked),
        .D0(g_code[0]),
        .D1(g_code[1]),
        .D2(g_code[2]),
        .D3(g_code[3]),
        .D4(g_code[4]),
        .D5(g_code[5]),
        .D6(g_code[6]),
        .D7(g_code[7]),
        .D8(g_code[8]),
        .D9(g_code[9]),
        .Q(serial[2])
    );


    TLVDS_OBUF clk_pair (
        .I(p_clk), .O(tmds_clk_p), .OB(tmds_clk_n)
    );
    TLVDS_OBUF b_pair (
        .I(serial[0]), .O(tmds_d_p[0]), .OB(tmds_d_n[0])
    );
    TLVDS_OBUF r_pair (
        .I(serial[1]), .O(tmds_d_p[1]), .OB(tmds_d_n[1])
    );
     TLVDS_OBUF g_pair (
        .I(serial[2]), .O(tmds_d_p[2]), .OB(tmds_d_n[2])
    );

endmodule
