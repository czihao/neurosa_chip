`timescale 1ns / 1ps

module tb_fpcmp;

    // Parameters
    parameter DATA_WIDTH = 16;

    // Inputs
    reg [DATA_WIDTH-1:0] num1;
    reg [DATA_WIDTH-1:0] num2;

    // Outputs
    wire result;

    // Instantiate the module
    fp_comparator #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .num1(num1),
        .num2(num2),
        .result(result)
    );

    initial begin
        // Initialize inputs
        num1 = 16'b0;
        num2 = 16'b0;
        
        // num1 > num2 ? 1:0

        num1 = 16'h3C00; // 1.0 
        num2 = 16'h3C00; // 1.0 
        #10;
        $display("Test 1: num1 = %h, num2 = %h, result = %b, expected = 0", num1, num2, result);

        num1 = 16'h4000; // 2.0 
        num2 = 16'h3C00; // 1.0 
        #10;
        $display("Test 2: num1 = %h, num2 = %h, result = %b, expected = 1", num1, num2, result);

        num1 = 16'h3C00; // 1.0 
        num2 = 16'h4000; // 2.0 
        #10;
        $display("Test 3: num1 = %h, num2 = %h, result = %b, exptected = 0", num1, num2, result);

        num1 = 16'hBC00; // -1.0 
        num2 = 16'hC000; // -2.0 
        #10;
        $display("Test 4: num1 = %h, num2 = %h, result = %b, expected = 1", num1, num2, result); 

        num1 = 16'hC000; // -2.0 
        num2 = 16'hBC00; // -1.0 
        #10;
        $display("Test 5: num1 = %h, num2 = %h, result = %b, expected = 0", num1, num2, result); 

        num1 = 16'h3C00; // 1.0 
        num2 = 16'hBC00; // -1.0 
        #10;
        $display("Test 6: num1 = %h, num2 = %h, result = %b, expected = 1", num1, num2, result); 

        // Test case 7: num1 < num2 (different signs)
        num1 = 16'hBC00; // -1.0 
        num2 = 16'h3C00; // 1.0 
        #10;
        $display("Test 7: num1 = %h, num2 = %h, result = %b, expected = 0", num1, num2, result); 

        // Test case 8: num1 is zero
        num1 = 16'h0000; // 0.0 
        num2 = 16'h3C00; // 1.0 
        #10;
        $display("Test 8: num1 = %h, num2 = %h, result = %b, expected = 0", num1, num2, result); 

        // Test case 9: num2 is zero
        num1 = 16'h3C00; // 1.0 
        num2 = 16'h0000; // 0.0 
        #10;
        $display("Test 9: num1 = %h, num2 = %h, result = %b, expected = 1", num1, num2, result); 
        
        num1 = 16'h70ED; // 10086.0
        num2 = 16'h515D; // 42.9
        #10;
        $display("Test 10: num1 = %h, num2 = %h, result = %b, expected = 1", num1, num2, result); 

        num1 = 16'h47A6; // 7.65
        num2 = 16'h6C22; // 9
        #10;
        $display("Test 11: num1 = %h, num2 = %h, result = %b, expected = 0", num1, num2, result); 

        num1 = 16'h3C00; // 1
        num2 = 16'hAC4A; // -0.067
        #10;
        $display("Test 12: num1 = %h, num2 = %h, result = %b, expected = 1", num1, num2, result); 

        num1 = 16'hBC00; // -1.0
        num2 = 16'hBC43; // -1.065
        #10;
        $display("Test 13: num1 = %h, num2 = %h, result = %b, expected = 1", num1, num2, result); 

        
        $stop;
    end

endmodule
