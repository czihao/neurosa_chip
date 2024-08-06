`timescale 1ns / 1ps

module fp16_subs2 #(
    parameter   DATA_WIDTH = 16
)(
    input wire                    clk,
    input wire                    reset_l,
    input wire                    en_subs,
    input wire [DATA_WIDTH-1:0]   val,
    output reg [DATA_WIDTH-1:0]   res
    );
    // on posedge clk
    // if en_subs == 1
    // res <= val - 2
    always @ (posedge clk) begin
        if (!reset_l) begin
            res <= 0;
        end else begin
            if (en_subs) begin
                res <= val;
            end
        end
    end
endmodule