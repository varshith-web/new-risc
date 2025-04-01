module memory_cycle(
    clk, rst,
    // PE1 Signals
    RegWriteM1, MemWriteM1, ResultSrcM1, RD_M1, PCPlus4M1, WriteDataM1, ALU_ResultM1,
    RegWriteW1, ResultSrcW1, RD_W1, PCPlus4W1, ALU_ResultW1, ReadDataW1,
    // PE2 Signals
    RegWriteM2, MemWriteM2, ResultSrcM2, RD_M2, PCPlus4M2, WriteDataM2, ALU_ResultM2,
    RegWriteW2, ResultSrcW2, RD_W2, PCPlus4W2, ALU_ResultW2, ReadDataW2
);

    // Common Inputs
    input clk, rst;

    // PE1 Inputs
    input RegWriteM1, MemWriteM1, ResultSrcM1;
    input [4:0] RD_M1;
    input [31:0] PCPlus4M1, WriteDataM1, ALU_ResultM1;

    // PE2 Inputs
    input RegWriteM2, MemWriteM2, ResultSrcM2;
    input [4:0] RD_M2;
    input [31:0] PCPlus4M2, WriteDataM2, ALU_ResultM2;

    // PE1 Outputs
    output RegWriteW1, ResultSrcW1;
    output [4:0] RD_W1;
    output [31:0] PCPlus4W1, ALU_ResultW1, ReadDataW1;

    // PE2 Outputs
    output RegWriteW2, ResultSrcW2;
    output [4:0] RD_W2;
    output [31:0] PCPlus4W2, ALU_ResultW2, ReadDataW2;

    // Interim Wires for PE1
    wire [31:0] ReadDataM1;

    // Interim Wires for PE2
    wire [31:0] ReadDataM2;

    // Register Declarations for PE1
    reg RegWriteM_r1, ResultSrcM_r1;
    reg [4:0] RD_M_r1;
    reg [31:0] PCPlus4M_r1, ALU_ResultM_r1, ReadDataM_r1;

    // Register Declarations for PE2
    reg RegWriteM_r2, ResultSrcM_r2;
    reg [4:0] RD_M_r2;
    reg [31:0] PCPlus4M_r2, ALU_ResultM_r2, ReadDataM_r2;

    // Data Memory Module for PE1
    Data_Memory dmem1 (
        .clk(clk),
        .rst(rst),
        .WE(MemWriteM1),
        .WD(WriteDataM1),
        .A(ALU_ResultM1),
        .RD(ReadDataM1)
    );

    // Data Memory Module for PE2
    Data_Memory dmem2 (
        .clk(clk),
        .rst(rst),
        .WE(MemWriteM2),
        .WD(WriteDataM2),
        .A(ALU_ResultM2),
        .RD(ReadDataM2)
    );

    // Memory Stage Register Logic for PE1
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            RegWriteM_r1 <= 1'b0; 
            ResultSrcM_r1 <= 1'b0;
            RD_M_r1 <= 5'h00;
            PCPlus4M_r1 <= 32'h00000000;
            ALU_ResultM_r1 <= 32'h00000000;
            ReadDataM_r1 <= 32'h00000000;
        end else begin
            RegWriteM_r1 <= RegWriteM1; 
            ResultSrcM_r1 <= ResultSrcM1;
            RD_M_r1 <= RD_M1;
            PCPlus4M_r1 <= PCPlus4M1;
            ALU_ResultM_r1 <= ALU_ResultM1;
            ReadDataM_r1 <= ReadDataM1;
        end
    end

    // Memory Stage Register Logic for PE2
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            RegWriteM_r2 <= 1'b0;
            ResultSrcM_r2 <= 1'b0;
            RD_M_r2 <= 5'h00;
            PCPlus4M_r2 <= 32'h00000000;
            ALU_ResultM_r2 <= 32'h00000000;
            ReadDataM_r2 <= 32'h00000000;
        end else begin
            RegWriteM_r2 <= RegWriteM2;
            ResultSrcM_r2 <= ResultSrcM2;
            RD_M_r2 <= RD_M2;
            PCPlus4M_r2 <= PCPlus4M2;
            ALU_ResultM_r2 <= ALU_ResultM2;
            ReadDataM_r2 <= ReadDataM2;
        end
    end

    // Output Assignments for PE1
    assign RegWriteW1 = RegWriteM_r1;
    assign ResultSrcW1 = ResultSrcM_r1;
    assign RD_W1 = RD_M_r1;
    assign PCPlus4W1 = PCPlus4M_r1;
    assign ALU_ResultW1 = ALU_ResultM_r1;
    assign ReadDataW1 = ReadDataM_r1;

    // Output Assignments for PE2
    assign RegWriteW2 = RegWriteM_r2;
    assign ResultSrcW2 = ResultSrcM_r2;
    assign RD_W2 = RD_M_r2;
    assign PCPlus4W2 = PCPlus4M_r2;
    assign ALU_ResultW2 = ALU_ResultM_r2;
    assign ReadDataW2 = ReadDataM_r2;

endmodule
