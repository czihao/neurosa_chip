`timescale 1ns / 1ps

module tb;
    // Inputs
    reg clk;
    reg en_neuron;
    reg reset_l;
    reg [11:0] spikei;
    reg [9:0] neuron_index;

    // Outputs
    wire [11:0] spikeo;
    reg [15:0] log_lut [1023:0];

    // Instantiate the neuron module
    neuron #(.N(16)) uut (
        .clk(clk),
        .en_neuron(en_neuron),
        .reset_l(reset_l),
        .spikei(spikei),
        .neuron_index(neuron_index),
        .spikeo(spikeo)
    );
    integer i;
    // Clock generation
    initial begin
        clk = 1;
//        forever #5 clk = ~clk;  // 10ns period clock
//        $readmemh("log_lut.txt", log_lut);
        for (i=0; i<1024; i=i+1)
            log_lut[i] = 16'h0000;
        $readmemh("D:/zihao/NeuroSA/log_lut.txt", log_lut);
    end
    
    

    // Test sequence
    initial begin
        // Initialize inputs
        en_neuron = 0;
        reset_l = 0;
        spikei = 0;
        neuron_index = 10'b0000000110;

        // Reset the neuron
        #10;
        reset_l = 1;
        en_neuron = 1;

        // Enable the neuron
//        #10;
//        en_neuron = 1;

        // Provide a positive spike input
//        #10;
////        spikei = 12'b01_0000000010;  // Positive spike with address 2
////        neuron_index = 10'b0000000110;
//        // Let neurons spike

//        // Provide a negative spike input
        #10;
        spikei = 12'b01_0000000100;  // Positive spike with address 3
        neuron_index = 10'b0000000110;

        // Provide another positive spike input
        #10;
//        spikei = 12'b01_0000000100;  // Positive spike with address 4
//        neuron_index = 10'b0000000110;
        // Let neurons spikes

        #10;
        spikei = 12'b00_0000000100;  // Positive spike with address 4
        neuron_index = 10'b0000000110;
        
        #10;
        // Let neurons spikes
        #10;
        spikei = 12'b01_0000000100;  // Positive spike with address 4
        neuron_index = 10'b0000000110;
        
        #10;
        // Let neurons spikes

        // Disable the neuron
//        #10;
        en_neuron = 0;

        // Finish the simulation
        #10;
        $finish;
    end

endmodule
