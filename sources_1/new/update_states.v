`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 09:50:49 AM
// Design Name: 
// Module Name: update_states
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


module update_states
#(
    parameter N = 4  // Size of the matrix and state vector
) (
    input wire clk,             // Clock signal
    input wire rst,             // Reset signal
    input wire[N-1:0][N-1:0] Q, // N-by-N binary weight matrix
    output reg[N-1:0] s         // 1-by-N binary state vector
);

    reg [$clog2(N)-1:0] counter; // Counter to iterate through the rows

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            s <= 0;
        end else begin
            // Update the state vector with the jth row of the matrix Q
            s <= Q[counter];
            // Increment the counter and roll over
            if (counter == N-1) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
