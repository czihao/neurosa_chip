`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 12:08:01 PM
// Design Name: 
// Module Name: neuron
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module neuron#(
    parameter FP_DATA_WIDTH = 16,
    parameter TEN_DATA_WIDTH = 2,
    parameter NUM_NEURON = 512,
    parameter NEURON_ID_WIDTH = 9
)(
    input wire                          clk,
    input wire                          fire_clk,
    input wire                          mu_clk,
    input wire                          reset_l,
    // Ctrl from TOP
    input wire                          en_neuron,
    input wire                          en_spike,
    input wire                          wrQ,
    input wire                          wrVmem,
    input wire                          wrNeuronI,
    input wire                          wrMu,
    // Data from TOP IO 
    input wire [NEURON_ID_WIDTH-1:0]    neuronI_in,// 9 bits
    input wire [FP_DATA_WIDTH-1:0]      Vmem_in, // 16 bits
    input wire [TEN_DATA_WIDTH-1:0]     Q_in, // 2 bits
    input wire [FP_DATA_WIDTH-1:0]      mu_in, // 16 bits
    input wire [NEURON_ID_WIDTH-1:0]    active_neuron,                    //added
    // Data from network
    input wire [TEN_DATA_WIDTH+NEURON_ID_WIDTH-1:0]   spike_in, // 11 bits
    // Done from network
    input wire                          networkDone,
    // Output
    output reg                          en_network,
    output reg [FP_DATA_WIDTH-1:0]      mu_out, // 16 bits
    output reg [TEN_DATA_WIDTH-1:0]     spike_out, // 2 bits
    output reg                          neuronWrQDone,
    output reg                          neuronWrVmemDone,
    output reg                          neuronWrMuDone,
    output reg                          neuronWrNeuronIDone,
    output reg                          neuronWrDone    
);
    
    // Neuron
    reg signed [FP_DATA_WIDTH-1:0]      VmemQ, VmemD;
    reg [NEURON_ID_WIDTH-1:0]           neuronIQ, neuronID;
    reg [FP_DATA_WIDTH-1:0]             muD, muQ, muSD, muSQ;
    reg [FP_DATA_WIDTH-1:0]             VmemSD, VmemSQ;
    wire[TEN_DATA_WIDTH-1:0]            dVmem;
    reg [TEN_DATA_WIDTH-1:0]            spikeQ, spikeD;

    reg     VmemDoneQ, VmemDoneD;
    reg     neuronIDoneQ, neuronIDoneD;    
    reg     muDoneQ, muDoneD;
    reg     spinQ, spinD;

    reg [3:0]               curr_state;
    reg [3:0]               next_state;
    
    // Q_ram
    reg                         Q_we;
    reg [NEURON_ID_WIDTH-1:0]   Q_addr_in;
    reg [NEURON_ID_WIDTH-1:0]   Q_addr_out;
    reg [TEN_DATA_WIDTH-1:0]    Q_data_in;
    reg [NEURON_ID_WIDTH:0]     Q_counter;

    reg     QDoneD, QDoneQ;
    reg     en_Q_counter;
    
    // Cmp
    wire                    fire;
    reg                     fireD, fireQ;
    
    // int2fp
    wire [FP_DATA_WIDTH-1:0]  fpVmem;
    
//    // fp incrementer
//    reg                         en_incr;
//    reg [VMEM_DATA_WIDTH-1:0]   incVal;
//    wire [VMEM_DATA_WIDTH-1:0]   incRes;

//    // fp decrementer
//    reg                         en_subs;
//    reg [VMEM_DATA_WIDTH-1:0]   subVal;
//    wire [VMEM_DATA_WIDTH-1:0]   subRes;

    
    fp_comparator #(
        .DATA_WIDTH(FP_DATA_WIDTH)
    )cmp(
        .num1(fpVmem),
        .num2(muSQ),
        .result(fire)
    );
    
    int16_to_fp16 int2fp (
        .int_val(VmemSQ),
        .fp16_val(fpVmem)
    );
    
    single_port_ram #(
        .DATA_WIDTH(TEN_DATA_WIDTH),
        .ADDR_WIDTH(NEURON_ID_WIDTH),
        .NUM_NEURON(NUM_NEURON)
    ) Q_ram (
        .clk(clk),
        .reset_l(reset_l),
        .we(Q_we),
        .ain(Q_addr_in),
        .aout(Q_addr_out),
        .din(Q_data_in),
        .dout(dVmem)
    );    
    
    localparam IDLE = 0, RECV1 = 1, EMIT = 2, WRQ = 3, WRVMEM = 4, WRNEURONI = 5, WRMU = 6, RECV2 = 7, NETWORK = 8;
    localparam SPIKE_IN_WIDTH = TEN_DATA_WIDTH + NEURON_ID_WIDTH;

    always @* begin
        neuronWrDone = VmemDoneQ & neuronIDoneQ & QDoneQ & muDoneQ;
        neuronWrMuDone = muDoneQ;
        neuronWrVmemDone = VmemDoneQ;
        neuronWrNeuronIDone = neuronIDoneQ;
        neuronWrQDone = QDoneQ;
        // Default Qram signal
        Q_we = 1'b0;
        en_Q_counter = 1'b0;
        Q_data_in = 1'b0;
        Q_addr_in = 1'b0;
        Q_addr_out = spike_in[NEURON_ID_WIDTH-1:0];
        QDoneD = QDoneQ;
        // Default Vmem reg signal
        VmemD = VmemQ;
        VmemDoneD = VmemDoneQ;
        // Default neuronID reg signal
        neuronID = neuronIQ;
        neuronIDoneD = neuronIDoneQ;
        // Default mu reg signal
        muD = muQ;
        if (en_spike) begin
            muSD = muSQ;
        end else begin
            muSD = muQ;
        end
        VmemSD = VmemSQ;
        muDoneD = muDoneQ;
        mu_out = muSQ;
        
        // Default neuron signal
        spike_out = spikeQ * fireQ;
        spinD = spinQ;
        spikeD = spikeQ;
        
        en_network = 1'b0;
        
        fireD = fireQ;
        
        case (curr_state)
            IDLE: begin
                
                if (wrQ) begin
                    next_state = WRQ;
                    Q_we = 1'b1;
                    en_Q_counter = 1'b1;
                    Q_data_in = Q_in;
                    QDoneD = 1'b0;
                end else if (wrVmem) begin
                    next_state = WRVMEM;
                    VmemD = Vmem_in;
                    VmemSD = spinQ ? Vmem_in : {~Vmem_in[FP_DATA_WIDTH-1], Vmem_in[FP_DATA_WIDTH-2:0]};
                    VmemDoneD = 1'b1;
                end else if (wrNeuronI) begin
                    next_state = WRNEURONI;
                    neuronID = neuronI_in;
                    neuronIDoneD = 1'b1;
                end else if (wrMu) begin
                    next_state = WRMU;
                    // mu = s * mu
//                    muD = spinQ ? mu_in : {~mu_in[FP_DATA_WIDTH-1], mu_in[FP_DATA_WIDTH-2:0]};
                    muD = mu_in;
//                    VmemSD = mu_in;
                    muDoneD = 1'b1;
                end else if (en_spike) begin
                    next_state = EMIT;
                end else begin
                    next_state = IDLE;
                end                
            end
            
            WRQ: begin
//                if (Q_counter < 2**Q_ADDR_WIDTH) begin
                if (Q_counter < active_neuron) begin                              //added
                    Q_we = 1'b1;
                    en_Q_counter = 1'b1;
                    Q_data_in = Q_in;
                    Q_addr_in = Q_counter;  
                    next_state = WRQ;
                    QDoneD = 1'b0;
                end else begin
                    Q_we = 1'b0;
                    en_Q_counter = 1'b0;
                    QDoneD = 1'b1;
                    next_state = IDLE;
                end
            end
            
            WRVMEM: begin
                next_state = IDLE;
            end
            
            WRNEURONI: begin
                next_state = IDLE;
            end
            
            WRMU:begin
                next_state = IDLE;
            end

            RECV1: begin
                next_state = RECV2;
//                muSD = mu_in;
                if (spike_in[NEURON_ID_WIDTH-1:0] == neuronIQ && |spike_in[SPIKE_IN_WIDTH-1:SPIKE_IN_WIDTH-2]) begin
                    spinD = ~spinQ;
                end else begin
                    spinD = spinQ;
                end
                // Negative spike
                if (spike_in[SPIKE_IN_WIDTH-1:SPIKE_IN_WIDTH-2] == 2) begin
                    // positive Q entry
                    if (dVmem == 1) begin
                        VmemD = VmemQ - 2;
                    // negative Q entry
                    end else if (dVmem == 2) begin
                        VmemD = VmemQ + 2;
                    end else begin
                        VmemD = VmemQ;
                    end
                // Positive spike
                end else if (spike_in[SPIKE_IN_WIDTH-1:SPIKE_IN_WIDTH-2] == 1) begin
                    // negative Q entry
                    if (dVmem == 2) begin
                        VmemD = VmemQ - 2;
                    // positive Q entry
                    end else if (dVmem == 1) begin
                        VmemD = VmemQ + 2;
                    end else begin
                        VmemD = VmemQ;
                    end
                end else begin
                    VmemD = VmemQ;
                end
            end
            
 
            RECV2: begin
                next_state = EMIT;
                VmemSD = spinQ ? VmemQ : {{~VmemQ[FP_DATA_WIDTH-1:0]}+1};
            end

            EMIT: begin
                fireD = fire;
                if (fire && spinQ == 1) begin
                    // Negative spike
                    spikeD = 2'd2;
                end else if (fire && spinQ == 0) begin
                    // Positive spike
                    spikeD = 2'd1;
                end else begin
                    // No spike
                    spikeD = 2'd0;
                end
                next_state = NETWORK;
            end

            NETWORK: begin
                if (networkDone == 1) begin
                    next_state = RECV1;
                    muSD = mu_in;
                    en_network = 1'b0;
                end else begin
                    en_network = 1'b1;
                    next_state = NETWORK;
                end
            end

            default: begin
                next_state = IDLE;  // Default state is IDLE
            end
        endcase
    end
    
    always @ (posedge clk) begin
        if (!reset_l)begin
            curr_state <= IDLE;
            // Data reg
            spinQ <= {TEN_DATA_WIDTH{1'b1}};
            VmemQ <= {FP_DATA_WIDTH{1'b0}};
            neuronIQ <= {NEURON_ID_WIDTH{1'b0}};
            muQ <= {FP_DATA_WIDTH{1'b0}};
            VmemSQ <= {FP_DATA_WIDTH{1'b0}};
            spikeQ <= {TEN_DATA_WIDTH{1'b0}};
            // Done signals
            VmemDoneQ <= 1'b0;
            muDoneQ <= 1'b0;
            neuronIDoneQ <= 1'b0;
            QDoneQ <= 1'b0;
            // Q ram counter
            Q_counter <= {NEURON_ID_WIDTH+1{1'b0}};
        end
        else if (en_neuron) begin
            curr_state <= next_state;
            // Data reg
            spinQ <= spinD;
            VmemQ <= VmemD;
            muQ <= muD;
            VmemSQ <= VmemSD;
            neuronIQ <= neuronID;
            spikeQ <= spikeD;
            // Done signals
            QDoneQ <= QDoneD;
            VmemDoneQ <= VmemDoneD;
            muDoneQ <= muDoneD;
            neuronIDoneQ <= neuronIDoneD;
            // Q mem counter
            if (en_Q_counter) begin
                Q_counter <= Q_counter + 1;
            end else begin
                Q_counter <= {NEURON_ID_WIDTH+1{1'b0}};
            end
        end
    end
    
    always @(posedge fire_clk) begin
        if (!reset_l) begin
            fireQ <= 1'b0;
        end else if (en_neuron) begin
            fireQ <= fireD;
        end
    end
    
    always @(posedge mu_clk) begin
        if (!reset_l) begin
            muSQ <= {FP_DATA_WIDTH{1'b0}};
        end else if (en_neuron) begin
            muSQ <= muSD;
        end
    end
endmodule
