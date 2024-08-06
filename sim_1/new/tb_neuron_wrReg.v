`timescale 1ns / 1ps

module tb_neuron_wrReg;

    // Parameters
    parameter MU_DATA_WIDTH = 16;
    parameter VMEM_DATA_WIDTH = 16;
    parameter Q_ADDR_WIDTH = 10;
    parameter Q_DATA_WIDTH = 2;
    parameter SPIKE_DATA_WIDTH = 12;
    parameter SPIKE_ADDR_WIDTH = 10;

    // Inputs
    reg clk;
    reg reset_l;
    reg en_neuron;
    reg en_spike;
    reg wrQ;
    reg wrVmem;
    reg wrNeuronI;
    reg wrMu;
    reg [SPIKE_ADDR_WIDTH-1:0] neuronI_in;
    reg [VMEM_DATA_WIDTH-1:0] Vmem_in;
    reg [Q_DATA_WIDTH-1:0] Q_in;
    reg [MU_DATA_WIDTH-1:0] mu_in;
    reg [SPIKE_DATA_WIDTH-1:0] spike_in;
    reg networkDone;

    // Outputs
    wire [MU_DATA_WIDTH-1:0] mu_out;
    wire [SPIKE_DATA_WIDTH-1:0] spike_out;
    wire neuronWrDone;

    // Instantiate the module
    neuron #(
        .MU_DATA_WIDTH(MU_DATA_WIDTH),
        .VMEM_DATA_WIDTH(VMEM_DATA_WIDTH),
        .Q_ADDR_WIDTH(Q_ADDR_WIDTH),
        .Q_DATA_WIDTH(Q_DATA_WIDTH),
        .SPIKE_DATA_WIDTH(SPIKE_DATA_WIDTH),
        .SPIKE_ADDR_WIDTH(SPIKE_ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .reset_l(reset_l),
        .en_neuron(en_neuron),
        .en_spike(en_spike),
        .wrQ(wrQ),
        .wrVmem(wrVmem),
        .wrNeuronI(wrNeuronI),
        .wrMu(wrMu),
        .neuronI_in(neuronI_in),
        .Vmem_in(Vmem_in),
        .Q_in(Q_in),
        .mu_in(mu_in),
        .spike_in(spike_in),
        .networkDone(networkDone),
        .mu_out(mu_out),
        .spike_out(spike_out),
        .neuronWrDone(neuronWrDone)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        // Initialize inputs
        clk = 1;
        reset_l = 0;
        en_neuron = 0;
        en_spike = 0;
        wrQ = 0;
        wrVmem = 0;
        wrNeuronI = 0;
        wrMu = 0;
        neuronI_in = 0;
        Vmem_in = 0;
        Q_in = 0;
        mu_in = 0;
        spike_in = 0;
        networkDone = 0;

        // Apply reset
        #10;
        reset_l = 1;
        en_neuron = 1;

        // Test WRVMEM state
        #10;
        wrVmem = 1;
        Vmem_in = 16'h1234;
        #10;
        wrVmem = 0;
        $display("Test WRVMEM: Vmem_in = %h, VmemQ = %h", Vmem_in, uut.VmemQ);

        // Test WRNEURONI state
        #10;
        wrNeuronI = 1;
        neuronI_in = 10'h3A;
        #10;
        wrNeuronI = 0;
        $display("Test WRNEURONI: neuronI_in = %h, neuronIQ = %h", neuronI_in, uut.neuronIQ);

        // Test WRMU state
        #10;
        wrMu = 1;
        mu_in = 16'h5678;
        #10;
        wrMu = 0;
        $display("Test WRMU: mu_in = %h, muQ = %h", mu_in, uut.muQ);

        $stop;
    end

endmodule
