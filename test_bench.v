`timescale 1ns/1ps

module test_bench;
    reg clk = 0;

    wire hsync;
    wire vsync;
    wire visible;
    wire [9:0] x;
    wire [9:0] y;

    wire [7:0] r;
    wire [7:0] g;
    wire [7:0] b;

    integer file;
    integer pixels = 0;

    timing timing (
        .clk(clk),
        .hsync(hsync),
        .vsync(vsync),
        .visible(visible),
        .x(x),
        .y(y)
    );

    image image (
        .x(x),
        .y(y),
        .r(r),
        .clk(clk),
        .g(g),
        .b(b)
    );

    // Clock de 25,2 MHz
    always #19.84127 clk = ~clk;

localparam integer NUM_FRAMES = 60;
    integer frame;
    reg [8*256-1:0] filename;

    initial begin
        // Aguarda o início do primeiro frame visível
        wait (x == 0 && y == 0);
        #1;

        for (frame = 0; frame < NUM_FRAMES; frame = frame + 1) begin
            pixels = 0;

            // Certifique-se de que a pasta build/frames já exista
            $sformat(filename, "build/frames/frame_%04d.ppm", frame);
            file = $fopen(filename, "w");

            if (file == 0) begin
                $display("Erro ao criar %0s (verifique se a pasta existe)", filename);
                $finish;
            end

            $fwrite(file, "P3\n640 480\n255\n");

            while (pixels < 640 * 480) begin
                if (visible === 1'b1) begin
                    $fwrite(file, "%0d %0d %0d\n", r, g, b);
                    pixels = pixels + 1;
                end

                @(posedge clk);
                #1;
            end

            $fclose(file);
            $display("Frame %0d/%0d salvo em %0s", frame + 1, NUM_FRAMES, filename);
        end

        $finish;
    end
endmodule
