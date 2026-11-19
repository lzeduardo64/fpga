module image (
  input wire [9:0] x,
  input wire [9:0] y,
  input wire clk,

  output wire [7:0] r,
  output wire [7:0] g,
  output wire [7:0] b
);

  reg [25:0] frame_cnt = 26'd0;

  always @(posedge clk) begin
    frame_cnt <= frame_cnt + 26'd1;
  end

  wire [7:0] t = frame_cnt[24:17];
  assign r = (x[9:2] ^ y[8:1]) + t;
  assign g = ((x[9:2] + t) ^ y[8:1]);
  assign b = (x[9:2] ^ (y[8:1] + t));

endmodule
