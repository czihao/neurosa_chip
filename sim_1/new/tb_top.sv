`timescale 1ns / 1ps

module tb_top_neurons;

    // Parameters
    parameter FP_DATA_WIDTH = 16;
    parameter TEN_DATA_WIDTH = 2;
    parameter NUM_NEURON = 512;          // Set to 4 for testing
    parameter NEURON_ID_WIDTH = 9;
    parameter NUM_ACTIVE_NEURON = 10;
    parameter NUM_OF_MUS = 166;

    // Inputs
    reg clk;
    reg fire_clk;
    reg reset_l;
    reg rd;
    wire [15:0] io;
    reg [15:0] outs;
    reg [15:0] ins;
    reg [15:0] V_mem_stored [0:9];
    reg [15:0] Init_Mu_stored [0:9];
    reg [15:0] Mu_stored [0:NUM_OF_MUS-1];
    reg [15:0] Q_1 [0:9];
    reg [15:0] Q_2 [0:9];
    reg [15:0] Q_3 [0:9];
    reg [15:0] Q_4 [0:9];
    reg [15:0] Q_5 [0:9];
    reg [15:0] Q_6 [0:9];
    reg [15:0] Q_7 [0:9];
    reg [15:0] Q_8 [0:9];
    reg [15:0] Q_9 [0:9];
    reg [15:0] Q_10 [0:9];
    
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
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/vmems.txt", V_mem_stored);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/mus.txt", Mu_stored);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/init_mus.txt", Init_Mu_stored);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_1.txt", Q_1);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_2.txt", Q_2);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_3.txt", Q_3);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_4.txt", Q_4);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_5.txt", Q_5);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_6.txt", Q_6);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_7.txt", Q_7);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_8.txt", Q_8);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_9.txt", Q_9);
        // $readmemh("C:/Users/faiek/Downloads/neurosa_srcs/sim_1/new/Q_10.txt", Q_10);
        /////////////////////////////////////////////////////////////////////////////
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/vmems.txt", V_mem_stored);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/mus.txt", Mu_stored);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/init_mus.txt", Init_Mu_stored);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_1.txt", Q_1);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_2.txt", Q_2);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_3.txt", Q_3);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_4.txt", Q_4);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_5.txt", Q_5);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_6.txt", Q_6);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_7.txt", Q_7);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_8.txt", Q_8);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_9.txt", Q_9);
        $readmemh("D:/zihao/NeuroSA_workspace/neuroSA_fpga/neuroSA_fpga_v1/neuroSA_fpga_v1.srcs/sim_1/new/Q_10.txt", Q_10);
        #10

        // Apply reset
        #11;
        reset_l = 1;

        // Test case 1: Write Vmem to neuron 0
        #10
        // Write 
        ins = 16'h000A;  
        #10;
        ins = 16'hFFFF;  
        #10;
        ins = V_mem_stored[0];  // Set Vmem value 4
        #20;
        ins = Init_Mu_stored[0];  // Set MU value 3.5
        #20;
        ins = 16'h0000;  // Set NeuronI value 0
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_1[i];
            #10;
        end  
        $display("Neuron 0 written");
        $display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[0].neuron_inst.VmemQ, uut.neurons[0].neuron_inst.muQ, uut.neurons[0].neuron_inst.spinQ, uut.neurons[0].neuron_inst.neuronIQ);
        //$display("Expected [4, 4300, 0, 0]");
        $display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[0].neuron_inst.Q_ram.ram[0], uut.neurons[0].neuron_inst.Q_ram.ram[1], uut.neurons[0].neuron_inst.Q_ram.ram[2], uut.neurons[0].neuron_inst.Q_ram.ram[3]);
        //$display("Expected [0 1 2 0]");
        
        #20;
        ins = V_mem_stored[1];  // Set Vmem value 5
        #20;
        ins = Init_Mu_stored[1];  // Set MU value 5.25
        #20;
        ins = 16'h0001;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_2[i];
            #10;
        end
        //$display("Neuron 1 written");
        //$display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[1].neuron_inst.VmemQ, uut.neurons[1].neuron_inst.muQ, uut.neurons[1].neuron_inst.spinQ, uut.neurons[1].neuron_inst.neuronIQ);
        //$display("Expected [5, 4540, 0, 1]");
        //$display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[1].neuron_inst.Q_ram.ram[0], uut.neurons[1].neuron_inst.Q_ram.ram[1], uut.neurons[1].neuron_inst.Q_ram.ram[2], uut.neurons[1].neuron_inst.Q_ram.ram[3]);
        //$display("Expected [2 0 1 2]");       

        #20;
        ins = V_mem_stored[2];  // Set Vmem value -6
        #20;
        ins = Init_Mu_stored[2];  // Set MU value -3.2
        #20;
        ins = 16'h0002;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_3[i];
            #10;
        end
        //$display("Neuron 2 written");
        //$display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[2].neuron_inst.VmemQ, uut.neurons[2].neuron_inst.muQ, uut.neurons[2].neuron_inst.spinQ, uut.neurons[2].neuron_inst.neuronIQ);
        //$display("Expected [-6, C266, 0, 2]");
        //$display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[2].neuron_inst.Q_ram.ram[0], uut.neurons[2].neuron_inst.Q_ram.ram[1], uut.neurons[2].neuron_inst.Q_ram.ram[2], uut.neurons[2].neuron_inst.Q_ram.ram[3]);
        //$display("Expected [1 2 0 1]"); 
        
        #20;
        ins = V_mem_stored[3];  // Set Vmem value 1
        #20;
        ins = Init_Mu_stored[3];  // Set MU value -0.06
        #20;
        ins = 16'h0003;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_4[i];
            #10;
        end
        //$display("Neuron 3 written");
        //$display("Vmem: %d, mu: %h, spin: %b, NeuronID: %d", uut.neurons[3].neuron_inst.VmemQ, uut.neurons[3].neuron_inst.muQ, uut.neurons[0].neuron_inst.spinQ, uut.neurons[3].neuron_inst.neuronIQ);
        //$display("Expected [1, ABAE, 0, 3]");
        //$display("Qram[0]: %d, Qram[1]: %d, Qram[2]: %d, Qram[3]: %d", uut.neurons[3].neuron_inst.Q_ram.ram[0], uut.neurons[3].neuron_inst.Q_ram.ram[1], uut.neurons[3].neuron_inst.Q_ram.ram[2], uut.neurons[3].neuron_inst.Q_ram.ram[3]);
        //$display("Expected [0 1 2 0]"); 
        
        #20;
        ins = V_mem_stored[4];  // Set Vmem value 1
        #20;
        ins = Init_Mu_stored[4];  // Set MU value -0.06
        #20;
        ins = 16'h0004;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_5[i];
            #10;
        end
        
        #20;
        ins = V_mem_stored[5];  // Set Vmem value 1
        #20;
        ins = Init_Mu_stored[5];  // Set MU value -0.06
        #20;
        ins = 16'h0005;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_6[i];
            #10;
        end
        
        #20;
        ins = V_mem_stored[6];  // Set Vmem value 1
        #20;
        ins = Init_Mu_stored[6];  // Set MU value -0.06
        #20;
        ins = 16'h0006;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_7[i];
            #10;
        end
        
        #20;
        ins = V_mem_stored[7];  // Set Vmem value 1
        #20;
        ins = Init_Mu_stored[7];  // Set MU value -0.06
        #20;
        ins = 16'h0007;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_8[i];
            #10;
        end
        
        #20;
        ins = V_mem_stored[8];  // Set Vmem value 1
        #20;
        ins = Init_Mu_stored[8];  // Set MU value -0.06
        #20;
        ins = 16'h0008;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_9[i];
            #10;
        end
        
        #20;
        ins = V_mem_stored[9];  // Set Vmem value 1
        #20;
        ins = Init_Mu_stored[9];  // Set MU value -0.06
        #20;
        ins = 16'h0009;  // Set NeuronI value 1
        #20;
        for (integer i = 0; i < NUM_ACTIVE_NEURON; i = i + 1) begin
            ins = Q_10[i];
            #10;
        end
        
        #70;
        ins = Mu_stored[0];
        #10;
        ins = 0;
        
        for (integer i = 1; i < NUM_OF_MUS; i = i + 1) begin
            #60
            ins = Mu_stored[i];
            #10;
            ins = 0;
        end
        
        #10;
        rd = 1;
        #15;
        $display("Out: %b", outs);
        #5
        rd = 0;
        #10
        $finish;
    end

endmodule
