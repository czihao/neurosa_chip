`timescale 1ns / 1ps

module tb_neuron;

    // Parameters
    parameter FP_DATA_WIDTH = 16;
    parameter TEN_DATA_WIDTH = 2;
    parameter NUM_NEURON = 64;
    parameter NEURON_ID_WIDTH = 10;

    localparam SPIKE_IN_WIDTH = TEN_DATA_WIDTH + NEURON_ID_WIDTH;

    // Inputs
    reg clk;
    reg reset_l;
    reg en_neuron;
    reg en_spike;
    reg wrQ;
    reg wrVmem;
    reg wrNeuronI;
    reg wrMu;
    reg [NEURON_ID_WIDTH-1:0] neuronI_in;
    reg [FP_DATA_WIDTH-1:0] Vmem_in;
    reg [TEN_DATA_WIDTH-1:0] Q_in;
    reg [FP_DATA_WIDTH-1:0] mu_in;
    reg [SPIKE_IN_WIDTH-1:0] spike_in;
    reg networkDone;

    // Outputs
    wire [FP_DATA_WIDTH-1:0] mu_out;
    wire [TEN_DATA_WIDTH-1:0] spike_out;
    wire neuronWrDone;

    // Instantiate the module
    neuron #(
        .FP_DATA_WIDTH(FP_DATA_WIDTH),
        .TEN_DATA_WIDTH(TEN_DATA_WIDTH),
        .NUM_NEURON(NUM_NEURON),
        .NEURON_ID_WIDTH(NEURON_ID_WIDTH)
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
        #11;
        reset_l = 1;
        #10;
        en_neuron = 1;
        
        // Test WRVMEM state
        #10;
        wrVmem = 1;
        Vmem_in = 16'h0068; // 104
        #10;
        wrVmem = 0;
        $display("Test WRVMEM: Vmem_in = %h, VmemQ = %h", Vmem_in, uut.VmemQ);

        // Test WRNEURONI state
        #10;
        wrNeuronI = 1; // 
        neuronI_in = 10'h3A; //58
        #10;
        wrNeuronI = 0;
        $display("Test WRNEURONI: neuronI_in = %h, neuronIQ = %h", neuronI_in, uut.neuronIQ);

        // Test WRMU state
        #10;
        wrMu = 1;
        mu_in = 16'h5678; //103.5
        #10;
        wrMu = 0;
        $display("Test WRMU: mu_in = %h, muQ = %h", mu_in, uut.muQ);
        

        // Test WRQ state
        #10;
        wrQ = 1;
        for (int i = 0; i < NUM_NEURON; i = i + 1) begin
            if (i == neuronI_in) begin
                Q_in = 0;
            end else begin
                Q_in = i%3; // Generate some data pattern for Q_in
            end
            #10;
        end
        wrQ = 0;
        
        #10;
        en_spike = 1;
        // 104 > 103.5
        #10
        $display("Test EMIT, spin: %b, Vmem: %d, mu: %h, fire: %b, expected = 0, 104, d678, 1", uut.spinQ, uut.VmemQ, uut.muQ, uut.fire);

        #20 // Network
        networkDone = 1;
        spike_in = 12'b10_00000_01101;
        mu_in = 16'h5668; //102.5

        #10 // RECV1
        networkDone = 0;
        // spin unchanged
        // VmemQ - 2
        $display("Test RECV1 dVmem: %d", uut.dVmem);
        #10 // RECV2
        $display("Test RECV2 Vmem: %h", uut.VmemQ);
        #10 // EMIT
        $display("Test EMIT, spin: %b, Vmem: %d, mu: %h, fire: %b, expected = 0, 102, d668, 1", uut.spinQ, uut.VmemQ, uut.muQ, uut.fire);

        #20 // Network
        spike_in = 12'b01_00001_11010;
        networkDone = 1;
        // -1 spike from neuron 58 (self), Q[58] = 0
        mu_in = 16'h5664; //102.3

        #10 // RECV1
        networkDone = 0;
        // spin changes
        // VmemQ - 2
        $display("Test RECV1 dVmem: %d", uut.dVmem);
        #10 // RECV2
        $display("Test RECV2 Vmem: %h", uut.VmemQ);
        #10 // EMIT
        $display("Test EMIT, spin: %b, Vmem: %d, mu: %h, fire: %b, expected = 1, 102, 5664, 0", uut.spinQ, uut.VmemQ, uut.muQ, uut.fire);


        #10
        reset_l = 0;

        $stop;
    end

endmodule
