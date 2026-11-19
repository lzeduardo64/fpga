module blinky(
  input wire clk,
  output wire led
);

  localparam COUNTER = 27000000;
  reg [25:0] count = 0;
  reg on = 0;

  always @(posedge clk) begin
    if (count == COUNTER - 1) begin
      count <= 0;
      on <= ~on;
    end else begin
      count <= count + 1;
    end
  end

  assign led = on;

endmodule
