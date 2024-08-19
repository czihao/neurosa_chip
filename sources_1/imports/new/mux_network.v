`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 05:44:59 PM
// Design Name: 
// Module Name: Network_2bit_1024_flattened
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


module mux_network #(
    parameter FP_DATA_WIDTH = 16,
    parameter TEN_DATA_WIDTH = 2,
    parameter NUM_NEURON = 512,
    parameter NEURON_ID_WIDTH = 9
)(
    input   wire                                        clk,
    input   wire                                        reset_l,
    input   wire                                        en_network,
    input   wire                                        top_en_network,
    input   wire[TEN_DATA_WIDTH*NUM_NEURON-1:0]         spike_in,
    input   wire[3:0]                                   bits_in_active_neuron,            //added
    output  reg                                         networkDone,
    output  reg [TEN_DATA_WIDTH+NEURON_ID_WIDTH-1:0]    spike_out
    );

    wire                                    feedback;
    reg [NEURON_ID_WIDTH-1:0]               lfsr_state;
    reg [NEURON_ID_WIDTH:0]                 spike_id;
    
    reg [TEN_DATA_WIDTH*NUM_NEURON-1:0]     spike_inD, spike_inQ;
    
    reg [1:0]                               curr_state, next_state;
    
    reg                                     en_lfsr;
        
    localparam NETWORK0 = 0, NETWORK1 = 1, NETWORK2 = 2, NETWORK3 = 3;
    
 //    assign feedback = lfsr_state[1] ^ lfsr_state[0];
 //  assign feedback = lfsr_state[9] ^ lfsr_state[6];
     assign feedback = lfsr_state[8] ^ lfsr_state[4];
    
    always@* begin
        en_lfsr = 1'b0;
        spike_out = {spike_inQ[spike_id+1], spike_inQ[spike_id], spike_id[NEURON_ID_WIDTH:1]};           //changed lfsr to spike_id
        networkDone = 1'b0;
        spike_inD = spike_inQ;
        case (curr_state) 
            NETWORK0: begin
                if (en_network) begin
                    en_lfsr = 1'b1;
                    next_state = NETWORK3;
                    spike_inD = spike_in;
                end else begin
                    next_state = NETWORK0;
                end
            end
//            NETWORK1: begin
//                next_state = NETWORK2;
//            end
//            NETWORK2: begin
//                next_state = NETWORK3;
//            end
            NETWORK3: begin
                next_state = NETWORK0;
                networkDone = 1'b1;  
            end
            default: begin
                next_state = NETWORK0;
            end
        endcase
    end  
    
    // LFSR logic
    always @(posedge clk) begin
        if (!reset_l) begin
            curr_state <= NETWORK0;
            lfsr_state <= 9'b110010011;
            spike_inQ <= {1024{1'b0}};
            spike_id <= 10'b00_0000_0000;
        end else if (top_en_network) begin
            curr_state <= next_state;
            spike_inQ <= spike_inD;
            if (en_lfsr) begin
                lfsr_state <= {lfsr_state[NEURON_ID_WIDTH-2:0], feedback};
                if(bits_in_active_neuron==9)
                spike_id <= {lfsr_state[NEURON_ID_WIDTH-2:0], feedback, 1'b0};
                else if(bits_in_active_neuron==8)
                spike_id <= {{{1'b0}},lfsr_state[NEURON_ID_WIDTH-3:0], feedback, 1'b0};
                else if(bits_in_active_neuron==7)
                spike_id <= {{2{1'b0}},lfsr_state[NEURON_ID_WIDTH-4:0], feedback, 1'b0};
                else if(bits_in_active_neuron==6)
                spike_id <= {{3{1'b0}},lfsr_state[NEURON_ID_WIDTH-5:0], feedback, 1'b0};
                else if(bits_in_active_neuron==5)
                spike_id <= {{4{1'b0}},lfsr_state[NEURON_ID_WIDTH-6:0], feedback, 1'b0};
                else if(bits_in_active_neuron==4)
                spike_id <= {{5{1'b0}},lfsr_state[NEURON_ID_WIDTH-7:0], feedback, 1'b0};
                else if(bits_in_active_neuron==3)
                spike_id <= {{6{1'b0}},lfsr_state[NEURON_ID_WIDTH-8:0], feedback, 1'b0};
                else
                spike_id <= {{7{1'b0}},lfsr_state[NEURON_ID_WIDTH-9:0], feedback, 1'b0};
            end
        end
    end
endmodule