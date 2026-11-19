module timing (
  input wire clk,

  output wire hsync,
  output wire vsync,
  output wire visible,

  output reg [9:0] x,
  output reg [9:0] y
);


localparam H_VISIBLE = 640;
localparam H_FRONT = 16;
localparam H_SYNC = 96;
localparam H_BACK = 48;
localparam H_TOTAL = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

localparam H_SYNC_START = H_VISIBLE + H_FRONT;
localparam H_SYNC_END = H_VISIBLE + H_FRONT + H_SYNC;

localparam V_VISIBLE = 480;
localparam V_FRONT = 10;
localparam V_SYNC = 2;
localparam V_BACK = 33;
localparam V_TOTAL = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

localparam V_SYNC_START = V_VISIBLE + V_FRONT;
localparam V_SYNC_END = V_VISIBLE + V_FRONT + V_SYNC;

always @(posedge clk) begin 
  if (x == H_TOTAL - 1) begin
    x <= 0;
    if (y == V_TOTAL - 1) begin
      y <= 0;
    end else begin
      y <= y + 1;
    end
  end else begin
    x <= x + 1;
  end
end

assign visible = (x < H_VISIBLE) & (y < V_VISIBLE);
assign hsync = ~((x >= H_SYNC_START) & (x < H_SYNC_END));
assign vsync = ~((y >= V_SYNC_START) & (y < V_SYNC_END));

endmodule
