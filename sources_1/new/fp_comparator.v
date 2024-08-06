module fp_comparator #(
    parameter DATA_WIDTH=16
)(
    input wire [DATA_WIDTH-1:0] num1,
    input wire [DATA_WIDTH-1:0] num2,
    output reg result
);

    // Extract sign, exponent, and mantissa
    wire sign1 = num1[15];
    wire sign2 = num2[15];
    wire signed [4:0] exp1 = num1[14] ? num1[13:10]+1 : ~(15-num1[13:10]) + 1;
    wire signed [4:0] exp2 = num2[14] ? num2[13:10]+1 : ~(15-num2[13:10]) + 1;
    wire [10:0] mantissa1 = num1[14:10] == 0 ? {1'b0, num1[9:0]} : {1'b1, num1[9:0]};
    wire [10:0] mantissa2 = num2[14:10] == 0 ? {1'b0, num2[9:0]} : {1'b1, num2[9:0]};

    always @* begin
        if (num1 == num2) begin
            result = 0; // num1 == num2
        end else if (sign1 != sign2) begin
            result = sign1 ? 1'b0 : 1'b1; // If signs are different, positive number is larger
        end else if (exp1 != exp2) begin
            if (sign1 == 0) begin
                result = (exp1 > exp2) ? 1'b1 : 1'b0; // Compare exponents for positive numbers
            end else begin
                result = (exp1 > exp2) ? 1'b0 : 1'b1; // Compare exponents for negative numbers
            end
        end else begin
            if (sign1 == 0) begin
                result = (mantissa1 >= mantissa2) ? 1'b1 : 1'b0; // Compare mantissas for positive numbers
            end else begin
                result = (mantissa1 >= mantissa2) ? 1'b0 : 1'b1; // Compare mantissas for negative numbers
            end
        end
    end

endmodule
