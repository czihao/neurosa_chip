module single_port_ram
#(
    parameter DATA_WIDTH = 2,         // Tenary weights
    parameter ADDR_WIDTH = 10,          // Max graph size 1024 (for now)
    parameter NUM_NEURON = 1024
)
(
    input wire                  clk,    // Clock
    input wire                  reset_l,// Reset
    input wire                  we,     // Write Enable
    input wire [ADDR_WIDTH-1:0] ain,   // Address bus
    input wire [ADDR_WIDTH-1:0] aout,   // Address bus
    input wire [DATA_WIDTH-1:0] din,    // Data input bus
    output reg [DATA_WIDTH-1:0] dout    // Data output bus
);

    // Declare the RAM variable
    reg [DATA_WIDTH-1:0] ram [NUM_NEURON-1:0];
    integer i;
    
    always @* begin
        dout = ram[aout];
    end

    always @(posedge clk) begin
        if (!reset_l) begin
            for (i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
                ram[i] <= {DATA_WIDTH{1'b0}};
            end
        end else begin
            if (we) begin
                // Write operation
                ram[ain] <= din;
            end
        end
    end

endmodule