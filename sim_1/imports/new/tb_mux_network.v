`timescale 1ns / 1ps

module tb_mux_network;

    // Parameters
    parameter Q_DATA_WIDTH = 2;
    parameter Q_SIZE = 1024;
    parameter SPIKE_OUT_ADDR = 10;
    parameter SPIKE_OUT_DATA = 2;

    // Inputs
    reg clk;
    reg reset_l;
    reg en_network;
    reg [Q_DATA_WIDTH*Q_SIZE-1:0] spike_in;

    // Outputs
    wire networkDone;
    wire [SPIKE_OUT_ADDR+SPIKE_OUT_DATA-1:0] spike_out;

    // Instantiate the module
    mux_network #(
        .Q_DATA_WIDTH(Q_DATA_WIDTH),
        .Q_SIZE(Q_SIZE),
        .SPIKE_OUT_ADDR(SPIKE_OUT_ADDR),
        .SPIKE_OUT_DATA(SPIKE_OUT_DATA)
    ) uut (
        .clk(clk),
        .reset_l(reset_l),
        .en_network(en_network),
        .spike_in(spike_in),
        .networkDone(networkDone),
        .spike_out(spike_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        // Initialize inputs
        clk = 1;
        reset_l = 0;
        en_network = 0;
        spike_in = 0;

        // Apply reset
        #11;
        reset_l = 1;
        #10;
        en_network = 1;

        // Generate some input spike data
        // For simplicity, generate a repeating pattern
        spike_in = {1024{2'b01}};  // Filling spike_in with a repeating pattern of "01"

        // Run the network for a few cycles
        #10;
        en_network = 0;
        
        $display("Cycle 1: spike_out = %h, networkDone = %b", spike_out, networkDone);
        
        #10;
        $display("Cycle 2: spike_out = %h, networkDone = %b", spike_out, networkDone);
        
        #10;
        $display("Cycle 3: spike_out = %h, networkDone = %b", spike_out, networkDone);
        en_network = 0;
        
        #50;
        en_network = 1;
        $display("Cycle 4: spike_out = %h, networkDone = %b", spike_out, networkDone);
        
        #10;
        $display("Cycle 5: spike_out = %h, networkDone = %b", spike_out, networkDone);
        
        #10;

        $stop;
    end

endmodule
