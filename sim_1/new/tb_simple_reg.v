`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 11:17:52 AM
// Design Name: 
// Module Name: tb_simple_reg
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


module tb_simple_reg;

    reg clk;
    reg reset_l;
    reg we;
    reg din;
    
    simple_reg uut (
        .clk(clk),
        .reset_l(reset_l),
        .we(we),
        .din(din)
    );
    
    always begin
        #5 clk = ~clk; // 100MHz clock
    end
    
    initial begin
        clk = 1;
        reset_l = 0;
        we = 0;
        din = 0;
        
        #11;
        reset_l = 1;
        
        #10;
        we = 1;
        din = 1;
        
        #10;
        we = 0;
        
        #50;
        we = 1;
        din = 0;
        
        #10;
        we = 0;
        #10;
        
        
    end
    
endmodule
