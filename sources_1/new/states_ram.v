`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 10:13:57 AM
// Design Name: 
// Module Name: states_ram
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


module states_ram#
(   
    parameter RAM_BITS = 16,
    parameter RAM_SIZE = 10
)(
    input wire clk,
    input wire rst_l,
//    input wire [N*16-1:0] new_values, // New values for the vector (flattened)
    input wire update_enable, // Signal to enable the update
//    input wire [15:0] update_addr,
    input wire [RAM_SIZE-1:0] Q_row,
    input wire [15:0] addro,
    output reg [15:0] out // 16-bit integer vector
);

    integer i;
    reg [RAM_BITS-1:0] states_ram [RAM_SIZE-1:0];

    always @(posedge clk) begin
        if (!rst_l) begin
            // Initialize the array elements on reset
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                states_ram[i] <= 16'h0000;
            end
        end else if (update_enable) begin
            // Update the array elements in parallel
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                states_ram[i] <= states_ram[i] + Q_row[i];
            end
        end
        else begin
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                states_ram[i] <= states_ram[i];
            end
        end
    end

endmodule
