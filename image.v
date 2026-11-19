module image (
  input wire [9:0] x,
  output wire [7:0] r,
  output wire [7:0] g,
  output wire [7:0] b
);

  wire active = ~x[9]; 
assign r[7:0] = (active & ~x[8]) ? 8'hFF : 8'h00;
assign g[7:0] = (active & ~x[7]) ? 8'hFF : 8'h00;
assign b[7:0] = (active & ~x[6]) ? 8'hFF : 8'h00;

endmodule
