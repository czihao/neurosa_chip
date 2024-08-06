`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 12:08:01 PM
// Design Name: 
// Module Name: top_neurons
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top module that instantiates 1024 neurons with a standard bus interface
// 
// Dependencies: neuron
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_neurons#(
    parameter FP_DATA_WIDTH = 16,
    parameter TEN_DATA_WIDTH = 2,
    parameter NUM_NEURON = 512,
    parameter NEURON_ID_WIDTH = 9
) (
    input wire                          clk,
    input wire                          reset_l,
    input wire                          rd,
    input wire                          fire_clk,
    input wire [FP_DATA_WIDTH-1:0]      ins,
    output reg [FP_DATA_WIDTH-1:0]      outs
);    

    reg [NEURON_ID_WIDTH-1:0] active_neuronD, active_neuronQ;           //added
    reg [3:0] bits_in_active_neuron;                                     //added

    reg [NEURON_ID_WIDTH-1:0]   neuronI_in;
    reg [FP_DATA_WIDTH-1:0]     Vmem_in;
    reg [TEN_DATA_WIDTH-1:0]    Q_in;
    reg [FP_DATA_WIDTH-1:0]     mu_in [NUM_NEURON-1:0];
    wire[NEURON_ID_WIDTH+TEN_DATA_WIDTH-1:0]    spike_in;
    reg [NUM_NEURON-1:0]        en_neuron;
    reg                         en_spike;
    reg                         wrQ;
    reg                         wrVmem;
    reg                         wrNeuronI;
    reg                         wrMu;
    wire                        networkDone;
    reg [NUM_NEURON*TEN_DATA_WIDTH-1:0]         network_spike_in;

    // Output arrays from neurons
    wire [NUM_NEURON-1:0]               en_network;
    wire [FP_DATA_WIDTH-1:0]            mu_out [NUM_NEURON-1:0];
//    wire [FP_DATA_WIDTH-1:0]            mu_in_internal [NUM_NEURON-1:0];
    wire [TEN_DATA_WIDTH-1:0]           spike_out [NUM_NEURON-1:0];
    wire [NUM_NEURON-1:0]               neuronWrQDone;
    wire [NUM_NEURON-1:0]               neuronWrVmemDone;
    wire [NUM_NEURON-1:0]               neuronWrMuDone;
    wire [NUM_NEURON-1:0]               neuronWrNeuronIDone;
    wire [NUM_NEURON-1:0]               neuronWrDone;

//    genvar j;
//    generate
//    for (integer j = 0; j < NUM_NEURON; j = j + 1) begin
//        assign 
//    end
//    endgenerate

    genvar i;
    generate
        for (i = 0; i < NUM_NEURON; i = i + 1) begin : neurons
//            if (i == 0) begin
//                neuron #(
//                    .FP_DATA_WIDTH(FP_DATA_WIDTH),
//                    .TEN_DATA_WIDTH(TEN_DATA_WIDTH),
//                    .NUM_NEURON(NUM_NEURON),
//                    .NEURON_ID_WIDTH(NEURON_ID_WIDTH)
//                ) neuron_inst (
//                    .clk(clk),
//                    .reset_l(reset_l),
//                    .en_neuron(en_neuron[i]),
//                    .en_spike(en_spike),
//                    .wrQ(wrQ),
//                    .wrVmem(wrVmem),
//                    .wrNeuronI(wrNeuronI),
//                    .wrMu(wrMu),
//                    .neuronI_in(neuronI_in),
//                    .Vmem_in(Vmem_in),
//                    .Q_in(Q_in),
//                    .mu_in(mu_in),
//                    .spike_in(spike_in),
//                    .networkDone(networkDone),
//                    .mu_out(mu_out[i]),
//                    .spike_out(spike_out[i]),
//                    .neuronWrQDone(neuronWrQDone[i]),
//                    .neuronWrVmemDone(neuronWrVmemDone[i]),
//                    .neuronWrNeuronIDone(neuronWrNeuronIDone[i]),
//                    .neuronWrMuDone(neuronWrMuDone[i]),
//                    .neuronWrDone(neuronWrDone[i]),
//                    .en_network(en_network[i])
//                );
//            end else begin
                neuron #(
                    .FP_DATA_WIDTH(FP_DATA_WIDTH),
                    .TEN_DATA_WIDTH(TEN_DATA_WIDTH),
                    .NUM_NEURON(NUM_NEURON),
                    .NEURON_ID_WIDTH(NEURON_ID_WIDTH)
                ) neuron_inst (
                    .clk(clk),
                    .fire_clk(fire_clk),
                    .reset_l(reset_l),
                    .en_neuron(en_neuron[i]),
                    .en_spike(en_spike),
                    .wrQ(wrQ),
                    .wrVmem(wrVmem),
                    .wrNeuronI(wrNeuronI),
                    .wrMu(wrMu),
                    .neuronI_in(neuronI_in),
                    .Vmem_in(Vmem_in),
                    .Q_in(Q_in),
                    .mu_in(mu_in[i]),
                    .spike_in(spike_in),
                    .networkDone(networkDone),
                    .mu_out(mu_out[i]),
                    .spike_out(spike_out[i]),
                    .neuronWrQDone(neuronWrQDone[i]),
                    .neuronWrVmemDone(neuronWrVmemDone[i]),
                    .neuronWrNeuronIDone(neuronWrNeuronIDone[i]),
                    .neuronWrMuDone(neuronWrMuDone[i]),
                    .neuronWrDone(neuronWrDone[i]),
                    .en_network(en_network[i]),
                    .active_neuron(active_neuronQ)                //added
                );
            end
//        end
    endgenerate
    
    mux_network # (
        .FP_DATA_WIDTH(FP_DATA_WIDTH),
        .TEN_DATA_WIDTH(TEN_DATA_WIDTH),
        .NUM_NEURON(NUM_NEURON),
        .NEURON_ID_WIDTH(NEURON_ID_WIDTH)
    ) network (
        .clk(clk),
        .reset_l(reset_l),
        .en_network(&en_network),
        .spike_in(network_spike_in),
        .networkDone(networkDone),
        .spike_out(spike_in),
        .bits_in_active_neuron(bits_in_active_neuron)
    );


    localparam IDLE = 0, WR = 1, NEURON = 2, RD = 3;         
    localparam BEGIN_WR={FP_DATA_WIDTH{1'b1}};                         //added
    localparam SPIKE_IN_WIDTH = TEN_DATA_WIDTH + NEURON_ID_WIDTH;
    
    reg [1:0]               curr_state, next_state;                   
    reg [NUM_NEURON-1:0]    neuron_statesD, neuron_statesQ;
    reg [NEURON_ID_WIDTH:0] neuron_ind;
    reg                     incr_neuron_id;
    reg [NEURON_ID_WIDTH:0] readout_counter;
    reg                     en_readout_counter;
    
//    wire[FP_DATA_WIDTH:0]   ins;
//    reg [FP_DATA_WIDTH:0]   outs;
    
//    assign ins = io;
//    assign io = rd ? outs:16'bZ;
//    assign mu_in_internal[0] = mu_in;
    
    always @* begin
        // Top control
        mu_in[0] = {FP_DATA_WIDTH{1'b0}};
        for (integer k = 0; k < NUM_NEURON-1; k = k + 1) begin
            mu_in[k+1] = mu_out[k];
        end
        for (integer j = 0; j < NUM_NEURON; j = j + 1) begin
            network_spike_in[2*j+1] = spike_out[j][1];
            network_spike_in[2*j] = spike_out[j][0];
        end
        en_readout_counter = 1'b0;
        incr_neuron_id = 1'b0;
        outs = 0;
        // Neuron, Network control
        en_neuron = 1'b0;
        en_spike = 1'b0;
        wrVmem = 1'b0;
        wrQ = 1'b0;
        wrMu = 1'b0;
        wrNeuronI = 1'b0;
        Vmem_in = {FP_DATA_WIDTH{1'b0}};
        Q_in = {TEN_DATA_WIDTH{1'b0}};
        neuronI_in = {NEURON_ID_WIDTH{1'b0}};
        neuron_statesD = neuron_statesQ;
        active_neuronD = active_neuronQ;                //added
        case(curr_state)
            IDLE: begin
                if (ins == BEGIN_WR) begin                     //changed WR to BEGIN_WR
                    next_state = WR;
                    active_neuronD = active_neuronQ;           //added
                end else begin
                    next_state = IDLE;
                    active_neuronD = ins[NEURON_ID_WIDTH-1:0];  //added
                end
            end
            WR: begin
                if (neuronWrDone[active_neuronQ-1]==1) begin
                    next_state = NEURON;
                end else begin
                    next_state = WR;
                end

                en_neuron[neuron_ind] = 1'b1;

                if (neuronWrDone[neuron_ind]) begin
                    incr_neuron_id = 1'b1;
                end else begin
                    incr_neuron_id = 1'b0;
                end

                if (!neuronWrVmemDone[neuron_ind]) begin
                    wrVmem = 1'b1;
                    Vmem_in = ins[FP_DATA_WIDTH-1:0];
                end else if (!neuronWrMuDone[neuron_ind]) begin
                    wrMu = 1'b1;
                    mu_in[neuron_ind] = ins[FP_DATA_WIDTH-1:0];
                end else if (!neuronWrNeuronIDone[neuron_ind]) begin
                    wrNeuronI = 1'b1;
                    neuronI_in = ins[NEURON_ID_WIDTH-1:0];
                end else if (!neuronWrQDone[neuron_ind]) begin
                    wrQ = 1'b1;
                    Q_in = ins[TEN_DATA_WIDTH-1:0];
                end

            end
            NEURON: begin
                if (!rd) begin
                    en_neuron = {NUM_NEURON{1'b1}};
                    en_spike = 1'b1;
                    next_state = NEURON;
                end else begin
                    en_neuron = {NUM_NEURON{1'b0}};
                    en_spike = 1'b0;
                    next_state = RD;
                end
                mu_in[0] = ins[FP_DATA_WIDTH-1:0];
                if (networkDone == 1) begin
                    // Update Probes
                    if (spike_in[SPIKE_IN_WIDTH-1:SPIKE_IN_WIDTH-2] != 0) begin
                        neuron_statesD[spike_in[NEURON_ID_WIDTH-1:0]] = ~neuron_statesQ[spike_in[NEURON_ID_WIDTH-1:0]];
                    end
                end
            end
            
            RD: begin
                if (readout_counter > active_neuronQ) begin
                    en_readout_counter = 1'b0;
                    next_state = NEURON;
                end else begin
                    en_readout_counter = 1'b1;
                    next_state = RD;
                end
                
                en_neuron = {NUM_NEURON{1'b0}};
                
                outs[15] = neuron_statesQ[readout_counter+15];
                outs[14] = neuron_statesQ[readout_counter+14];
                outs[13] = neuron_statesQ[readout_counter+13];
                outs[12] = neuron_statesQ[readout_counter+12];
                
                outs[11] = neuron_statesQ[readout_counter+11];
                outs[10] = neuron_statesQ[readout_counter+10];
                outs[9] = neuron_statesQ[readout_counter+9];
                outs[8] = neuron_statesQ[readout_counter+8];
                
                outs[7] = neuron_statesQ[readout_counter+7];
                outs[6] = neuron_statesQ[readout_counter+6];
                outs[5] = neuron_statesQ[readout_counter+5];
                outs[4] = neuron_statesQ[readout_counter+4];
                                                        
                outs[3] = neuron_statesQ[readout_counter+3];
                outs[2] = neuron_statesQ[readout_counter+2];
                outs[1] = neuron_statesQ[readout_counter+1];
                outs[0] = neuron_statesQ[readout_counter+0];
                
            end
            default: begin
                next_state = IDLE;
            end
        endcase
        
    end
    
    always @(posedge clk) begin
        if (!reset_l) begin
            curr_state <= IDLE;
            neuron_statesQ <= {NUM_NEURON{1'b1}};
            neuron_ind <= {NEURON_ID_WIDTH+1{1'b0}};
            active_neuronQ <= {NUM_NEURON{1'b1}};         //added
            bits_in_active_neuron <= 4'd9;                //added
            readout_counter <= {NEURON_ID_WIDTH+1{1'b0}};
        end else begin
            curr_state <= next_state;
            neuron_statesQ <= neuron_statesD;
            active_neuronQ <= active_neuronD;         //added
            
                if(active_neuronQ>8'd255)
                   bits_in_active_neuron<=9;
                else if(active_neuronQ>7'd127)
                   bits_in_active_neuron<=8;
                else if(active_neuronQ>6'd63)
                   bits_in_active_neuron<=7;
                else if(active_neuronQ>5'd31)
                   bits_in_active_neuron<=6;
                else if(active_neuronQ>4'd15)
                   bits_in_active_neuron<=5;
                else if(active_neuronQ>3'd7)
                   bits_in_active_neuron<=4;
                else if(active_neuronQ>2'd3)
                   bits_in_active_neuron<=3;
                else
                   bits_in_active_neuron<=2;
            
            if (incr_neuron_id) begin
                if(neuron_ind == active_neuronQ-1)      //added
                    neuron_ind <= 0;
                else
                    neuron_ind <= neuron_ind + 1;
            end 
//            else begin
//                neuron_ind <= 0;
//            end
            if (en_readout_counter) begin
                readout_counter <= readout_counter + 16;
            end else begin
                readout_counter <= {NEURON_ID_WIDTH+1{1'b0}};
            end
        end
    end

endmodule
