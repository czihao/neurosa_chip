`timescale 1ns / 1ps

module tb_lfsr_exprv;

    // Parameters
    parameter RV_PRECISION = 16;
    parameter LFSR_PRECISION = 10;
    parameter LUTSIZE = 1024;
//    parameter [RV_PRECISION-1:0] TAPS = 16'h0042;

    // Inputs
    reg clk;
    reg reset_l;
    reg enable;

    // Outputs
    wire [RV_PRECISION-1:0] exprv;

    // Instantiate the Unit Under Test (UUT)
    lfsr_exprv #(
        .RV_PRECISION(RV_PRECISION),
        .LFSR_PRECISION(LFSR_PRECISION),
        .LUTSIZE(LUTSIZE)
//        .TAPS(TAPS)
    ) rng_mu (
        .clk(clk),
        .reset_l(reset_l),
        .enable(enable),
        .exprv(exprv)
    );
    
    

    // Clock generation
    initial begin
        clk = 1;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Stimulus process
    initial begin
        // Initialize Inputs
        reset_l = 0;
        enable = 0;

        // Wait for global reset
        #10;
        
        // Apply reset
        reset_l = 1;
        enable = 1;

        // Wait for some time to observe the outputs
        #500;
        
        // Disable the LFSR
        enable = 0;
        #100;
        
        // Re-enable the LFSR
        enable = 1;
        #500;

        // Finish the simulation
        $finish;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time = %0dns, clk = %b, reset_l = %b, enable = %b, exprv = %h", 
                 $time, clk, reset_l, enable, exprv);
    end

endmodule
