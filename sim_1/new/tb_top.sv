`timescale 1ns / 1ps

module tb_top_neurons;

    // Parameters
    parameter FP_DATA_WIDTH = 16;
    parameter TEN_DATA_WIDTH = 2;
    parameter NUM_NEURON = 4;          // Set to 4 for testing
    parameter NEURON_ID_WIDTH = 2;

    // Inputs
    reg clk;
    reg fire_clk;
    reg reset_l;
    reg rd;
    wire [15:0] io;
    reg [15:0] outs;
    reg [15:0] ins;
    
//    assign outs = rd? io:16'bZ;
//    assign io = ins;

    // Instantiate the module
    top_neurons #(
        .FP_DATA_WIDTH(FP_DATA_WIDTH),
        .TEN_DATA_WIDTH(TEN_DATA_WIDTH),
        .NUM_NEURON(NUM_NEURON),
        .NEURON_ID_WIDTH(NEURON_ID_WIDTH)
    ) uut (
        .clk(clk),
        .fire_clk(fire_clk),
        .reset_l(reset_l),
        .rd(rd),
        .ins(ins),
        .outs(outs)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100MHz clock
        
    end
    
    always begin
        #5 fire_clk = ~fire_clk; // 100MHz clock
        
    end

    initial begin
        // Initialize inputs
        clk = 1;
        fire_clk = 1;
        reset_l = 0;
        rd = 0;
        ins = 0;
        #10

        // Apply reset
        #11;
        reset_l = 1;

        // Test case 1: Write Vmem to neuron 0
        #10
        // Write 
        ins = 16'h0001;  
        #10;
        ins = 16'h0004;  // Set Vmem value 4
        #20;
        ins = 16'h4300;  // Set MU value 3.5
        #20;
        ins = 16'h0000;  // Set NeuronI value 0
        #20;
        for (integer i = 0; i < NUM_NEURON; i = i + 1) begin
            ins = i%3;
            #10;
        end  
        $display("Neuron 0 written");
        $display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[0].neuron_inst.VmemQ, uut.neurons[0].neuron_inst.mu_inQ, uut.neurons[0].neuron_inst.spinQ, uut.neurons[0].neuron_inst.neuronIQ);
        $display("Expected [4, 4300, 0, 0]");
        $display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[0].neuron_inst.Q_ram.ram[0], uut.neurons[0].neuron_inst.Q_ram.ram[1], uut.neurons[0].neuron_inst.Q_ram.ram[2], uut.neurons[0].neuron_inst.Q_ram.ram[3]);
        $display("Expected [0 1 2 0]");
        
        #20;
        ins = 16'h0005;  // Set Vmem value 5
        #20;
        ins = 16'h4540;  // Set MU value 5.25
        #20;
        ins = 16'h0001;  // Set NeuronI value 1
        #20;
        for (integer i = 2; i < NUM_NEURON+2; i = i + 1) begin
            ins = i%3;
            #10;
        end
        $display("Neuron 1 written");
        $display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[1].neuron_inst.VmemQ, uut.neurons[1].neuron_inst.mu_inQ, uut.neurons[1].neuron_inst.spinQ, uut.neurons[1].neuron_inst.neuronIQ);
        $display("Expected [5, 4540, 0, 1]");
        $display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[1].neuron_inst.Q_ram.ram[0], uut.neurons[1].neuron_inst.Q_ram.ram[1], uut.neurons[1].neuron_inst.Q_ram.ram[2], uut.neurons[1].neuron_inst.Q_ram.ram[3]);
        $display("Expected [2 0 1 2]");       

        #20;
        ins = 16'hFFFa;  // Set Vmem value -6
        #20;
        ins = 16'hC266;  // Set MU value -3.2
        #20;
        ins = 16'h0002;  // Set NeuronI value 1
        #20;
        for (integer i = 1; i < NUM_NEURON+1; i = i + 1) begin
            ins = i%3;
            #10;
        end
        $display("Neuron 2 written");
        $display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[2].neuron_inst.VmemQ, uut.neurons[2].neuron_inst.mu_inQ, uut.neurons[2].neuron_inst.spinQ, uut.neurons[2].neuron_inst.neuronIQ);
        $display("Expected [-6, C266, 0, 2]");
        $display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[2].neuron_inst.Q_ram.ram[0], uut.neurons[2].neuron_inst.Q_ram.ram[1], uut.neurons[2].neuron_inst.Q_ram.ram[2], uut.neurons[2].neuron_inst.Q_ram.ram[3]);
        $display("Expected [1 2 0 1]"); 
        
        #20;
        ins = 16'h0001;  // Set Vmem value 1
        #20;
        ins = 16'hABAE;  // Set MU value -0.06
        #20;
        ins = 16'h0003;  // Set NeuronI value 1
        #20;
        for (integer i = 3; i < NUM_NEURON+3; i = i + 1) begin
            ins = i%3;
            #10;
        end
        $display("Neuron 3 written");
        $display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[3].neuron_inst.VmemQ, uut.neurons[3].neuron_inst.mu_inQ, uut.neurons[0].neuron_inst.spinQ, uut.neurons[3].neuron_inst.neuronIQ);
        $display("Expected [1, ABAE, 0, 3]");
        $display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[3].neuron_inst.Q_ram.ram[0], uut.neurons[3].neuron_inst.Q_ram.ram[1], uut.neurons[3].neuron_inst.Q_ram.ram[2], uut.neurons[3].neuron_inst.Q_ram.ram[3]);
        $display("Expected [0 1 2 0]"); 
        
        #70;
        ins = 16'h6060;
        #10;
        ins = 0;
        
        #60;
        ins = 16'haaaa;
        #10;
        ins = 0;
        
        #60;
        ins = 16'hbbbb;
        #10;
        ins = 0;
        
        #60;
        ins = 16'hcccc;
        #10;
        ins = 0;
        
        #10;
        rd = 1;
        #20;
        rd = 0;
        
    end

endmodule
