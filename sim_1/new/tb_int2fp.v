`timescale 1ns / 1ps

module tb_int2fp;

    reg     signed  [15:0]  int_val;           // Signed 16-bit integer input
    wire            [15:0]  fp16_val;         // 16-bit half-precision floating-point output

    // Instantiate the module
    int16_to_fp16 uut (
        .int_val(int_val),
        .fp16_val(fp16_val)
    );

    initial begin
        // Test cases
        # 50;
        // Test 1: Zero
        int_val = 16'b0000_0000_0000_0000;
        #10;
        $display("Input: %d, Output: %h", int_val, fp16_val); 

        // Test 2: Positive number
        // 1
        int_val = 16'b0000_0000_0000_0001;
        #10;
        $display("Input: %d, Output: %h, Expected: %h", int_val, fp16_val, 16'h3C00);
        $display("Input: %d, Output: %b, Expected: %b", int_val, fp16_val, 16'h3C00);  

        // Test 3: Positive number
        // 32767
        int_val = 16'b0111_1111_1111_1111;
        #10;
        $display("Input: %d, Output: %h, Expected: %h", int_val, fp16_val, 16'h7800); 

        // Test 4: Negative number
        // -1
        int_val = 16'b1111_1111_1111_1111;
        #10;
        $display("Input: %d, Output: %h, Expected: %h", int_val, fp16_val, 16'hBC00); 

        // Test 5: Negative number
        // -32768
        int_val = 16'b1000_0000_0000_0000;
        #10;
        $display("Input: %d, Output: %h, Expected: %h", int_val, fp16_val, 16'hF800);
        $display("Input: %d, Output: %b, Expected: %b", int_val, fp16_val, 16'hF800);

        // Test 6: Small positive number
        // 123
        int_val = 16'h007B;
        #10;
        $display("Input: %d, Output: %b, Expected: %b", int_val, fp16_val, 16'h57B0);
        $display("Input: %d, Output: %h, Expected: %h", int_val, fp16_val, 16'h57B0);

        // Test 7: Small negative number
        // -123
        int_val = 16'hFF85;
        #10;
        $display("Input: %d, Output: %b, Expected: %b", int_val, fp16_val, 16'hD7B0); 
        $display("Input: %d, Output: %h, Expected: %h", int_val, fp16_val, 16'hD7B0); 

        $stop;
    end

endmodule