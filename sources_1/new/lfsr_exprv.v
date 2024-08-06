`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 02:04:40 PM
// Design Name: 
// Module Name: lfsr_exprv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lfsr_exprv#(
    parameter RV_DATA_WIDTH = 16, 
    parameter LFSR_DATA_WIDTH = 10,
    parameter LUTSIZE = 1024
//    parameter [LFSR_DATA_WIDTH-1:0] TAPS = 10'h0042
)(
    input wire clk,
    input wire reset_l,
    input wire enable,
    input wire [RV_DATA_WIDTH-1:0] temp,
    output reg [RV_DATA_WIDTH-1:0] exprv
);
    integer i;
    reg [LFSR_DATA_WIDTH-1:0] lfsr_state;
    wire feedback;
    reg [RV_DATA_WIDTH-1:0] lut [LUTSIZE-1:0];    
    
    assign feedback = lfsr_state[9] ^ lfsr_state[0] ^ lfsr_state[8] ^ lfsr_state[6];
    
    initial begin
        for (i=0; i<LUTSIZE; i=i+1)
            lut[i] = 16'h0000;
        $readmemh("D:/zihao/NeuroSA/log_lut.txt", lut);
    end
    
    always @* begin
//        lut_index = lfsr_state[PRECISION-1 -: $clog2(LUTSIZE)];
        exprv = lut[lfsr_state];
    end
    

    always @(posedge clk) begin
        if (!reset_l) begin
            lfsr_state <= {LFSR_DATA_WIDTH{10'h086}}; // Reset state
        end else if (enable) begin
            lfsr_state <= {lfsr_state[LFSR_DATA_WIDTH-2:0], feedback};
        end
    end
endmodule
