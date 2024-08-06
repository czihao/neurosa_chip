`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 11:14:42 AM
// Design Name: 
// Module Name: simple_reg
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


module simple_reg(
    input wire clk,
    input wire reset_l,
    input wire we,
    input wire din
    );
    
    reg regD = 0, regQ = 0;
    
    always @ (*) begin
        if (we) begin
            regD = din;
        end else begin
            regD = regQ;
        end
    end
    
    always @ (posedge clk or negedge reset_l) begin
        if (!reset_l) begin
            regQ <= 0;
        end else begin
            regQ <= regD;
        end
    end
    
endmodule
