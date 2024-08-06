`timescale 1ns / 1ps
module int16_to_fp16 (
    input   wire    [15:0]  int_val,   // Signed 16-bit integer input
    output  reg     [15:0]  fp16_val   // 16-bit half-precision floating-point output
);

    reg             sign;
    reg     [15:0]  abs_val;
    reg     [4:0]   exponent;
    reg     [9:0]   mantissa;

    always @(*) begin
        // Determine the sign bit
        sign = int_val[15] ? 1'b1:1'b0;
        abs_val = sign ? (~int_val + 1) : int_val;
        if (abs_val[15] == 1) begin
            exponent = 5'd15+5'd15;
//            mantissa = abs_val >> 5;
            mantissa = abs_val[14:5];
        end else if (abs_val[14] == 1) begin
            exponent = 5'd15+5'd14;
//            mantissa = abs_val >> 4;
            mantissa = abs_val[13:4];
        end else if (abs_val[13] == 1) begin
            exponent = 5'd15+5'd13;
//            mantissa = abs_val >> 3;
            mantissa = abs_val[12:3];
        end else if (abs_val[12] == 1) begin
            exponent = 5'd15+5'd12;
//            mantissa = abs_val >> 2;
            mantissa = abs_val[11:2];
        end else if (abs_val[11] == 1) begin
            exponent = 5'd15+5'd11;
//            mantissa = abs_val >> 1;
            mantissa = abs_val[10:1];
        end else if (abs_val[10] == 1) begin
            exponent = 5'd15+5'd10;
//            mantissa = abs_val >> 0;
            mantissa = abs_val[9:0];
        end else if (abs_val[9] == 1) begin
            exponent = 5'd15+5'd9;
//            mantissa = abs_val << 1; 
            mantissa = {abs_val[8:0], {1{1'b0}}};
        end else if (abs_val[8] == 1) begin
            exponent = 5'd15+5'd8;
//            mantissa = abs_val << 2;  
            mantissa = {abs_val[7:0], {2{1'b0}}};
        end else if (abs_val[7] == 1) begin
            exponent = 5'd15+5'd7;
//            mantissa = abs_val << 3; 
            mantissa = {abs_val[6:0], {3{1'b0}}};
        end else if (abs_val[6] == 1) begin
            exponent = 5'd15+5'd6;
//            mantissa = abs_val << 4; 
            mantissa = {abs_val[5:0], {4{1'b0}}};
        end else if (abs_val[5] == 1) begin
            exponent = 5'd15+5'd5;
//            mantissa = abs_val << 5; 
            mantissa = {abs_val[4:0], {5{1'b0}}};
        end else if (abs_val[4] == 1) begin
            exponent = 5'd15+5'd4;
//            mantissa = abs_val << 6; 
            mantissa = {abs_val[3:0], {6{1'b0}}};
        end else if (abs_val[3] == 1) begin
            exponent = 5'd15+5'd3;
//            mantissa = abs_val << 7; 
            mantissa = {abs_val[2:0], {7{1'b0}}};
        end else if (abs_val[2] == 1) begin
            exponent = 5'd15+5'd2;
//            mantissa = abs_val << 8; 
            mantissa = {abs_val[1:0], {8{1'b0}}};
        end else if (abs_val[1] == 1) begin
            exponent = 5'd15+5'd1;
//            mantissa = abs_val << 9; 
            mantissa = {abs_val[0], {8{1'b0}}};
        end else if (abs_val[0] == 1) begin // 1
            exponent = 5'b01111;
            mantissa = 10'b0;
        end else begin // 0
            exponent = 5'b0000;
            mantissa = 10'b0;
        end
        fp16_val = {sign, exponent, mantissa};
    end

endmodule
