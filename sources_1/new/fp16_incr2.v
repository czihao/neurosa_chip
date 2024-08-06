`timescale 1ns / 1ps

module fp16_incr2 #(
    parameter   DATA_WIDTH = 16
)(  
    input wire                    clk,
    input wire                    reset_l,
    input wire                    en_incr,
    input wire [DATA_WIDTH-1:0]   val,
    output reg [DATA_WIDTH-1:0]   res
    );
    // on posedge clk
    // if en_incr == 1
    // res <= val - 2
    
    localparam [DATA_WIDTH-1:0] MAX_VAL = 16'h7BFF; // 01111_1111111111

    always @ (posedge clk) begin
        if (!reset_l) begin
            res <= 0;
        end else begin
            if (en_incr) begin
                // Increment the value
                res <= val + 16'h4000; 

                // Handle overflow and clip to the maximum value
                if (res > MAX_VAL) begin
                    res <= MAX_VAL;
                end
            end
        end
    end
endmodule
