module top (
  input wire clk,
  output wire led1,
  output wire led2,
  output wire led3
);

parameter CLOCK = 27000000;
reg [24:0] ticks = 0;
reg [1:0] on = 0;

always @(posedge clk) begin
  if (ticks == CLOCK - 1) begin
    ticks <= ticks + 1;
    on <= on + 1;
  end else begin
    ticks <= ticks + 1;
  end
end

  assign led1 = ~(on[0] & on[1]);
  assign led2 = ~(on[0] | on[1]);
  assign led3 = ~(on[0] ^ on[1]);

endmodule
