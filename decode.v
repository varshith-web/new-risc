// Decode_Cycle.v - Decode Stage for Dual PE RISC Architecture

module decode_cycle(
    input clk, rst,

    // Inputs from IF stage
    input [31:0] InstrD1, InstrD2, PCD1, PCD2, PCPlus4D1, PCPlus4D2,
    input RegWriteW1, RegWriteW2,
    input [4:0] RDW1, RDW2,
    input [31:0] ResultW1, ResultW2,

    // Outputs to EX stage (PE1 and PE2)
    output RegWriteE1, ALUSrcE1, MemWriteE1, ResultSrcE1, BranchE1,
    output [2:0] ALUControlE1,
    output [31:0] RD1_E1, RD2_E1, Imm_Ext_E1,
    output [4:0] RS1_E1, RS2_E1, RD_E1,
    output [31:0] PCE1, PCPlus4E1,

    output RegWriteE2, ALUSrcE2, MemWriteE2, ResultSrcE2, BranchE2,
    output [2:0] ALUControlE2,
    output [31:0] RD1_E2, RD2_E2, Imm_Ext_E2,
    output [4:0] RS1_E2, RS2_E2, RD_E2,
    output [31:0] PCE2, PCPlus4E2
);

    // Interim Wires (PE1)
    wire RegWriteD1, ALUSrcD1, MemWriteD1, ResultSrcD1, BranchD1;
    wire [1:0] ImmSrcD1;
    wire [2:0] ALUControlD1;
    wire [31:0] RD1_D1, RD2_D1, Imm_Ext_D1;

    // Interim Wires (PE2)
    wire RegWriteD2, ALUSrcD2, MemWriteD2, ResultSrcD2, BranchD2;
    wire [1:0] ImmSrcD2;
    wire [2:0] ALUControlD2;
    wire [31:0] RD1_D2, RD2_D2, Imm_Ext_D2;

    // Registers (PE1)
    reg RegWriteD_r1, ALUSrcD_r1, MemWriteD_r1, ResultSrcD_r1, BranchD_r1;
    reg [2:0] ALUControlD_r1;
    reg [31:0] RD1_D_r1, RD2_D_r1, Imm_Ext_D_r1;
    reg [4:0] RD_D_r1, RS1_D_r1, RS2_D_r1;
    reg [31:0] PCD_r1, PCPlus4D_r1;

    // Registers (PE2)
    reg RegWriteD_r2, ALUSrcD_r2, MemWriteD_r2, ResultSrcD_r2, BranchD_r2;
    reg [2:0] ALUControlD_r2;
    reg [31:0] RD1_D_r2, RD2_D_r2, Imm_Ext_D_r2;
    reg [4:0] RD_D_r2, RS1_D_r2, RS2_D_r2;
    reg [31:0] PCD_r2, PCPlus4D_r2;

    // Control Unit for PE1
    Control_Unit_Top control1 (
        .Op(InstrD1[6:0]),
        .RegWrite(RegWriteD1),
        .ImmSrc(ImmSrcD1),
        .ALUSrc(ALUSrcD1),
        .MemWrite(MemWriteD1),
        .ResultSrc(ResultSrcD1),
        .Branch(BranchD1),
        .funct3(InstrD1[14:12]),
        .funct7(InstrD1[31:25]),
        .ALUControl(ALUControlD1)
    );

    // Control Unit for PE2
    Control_Unit_Top control2 (
        .Op(InstrD2[6:0]),
        .RegWrite(RegWriteD2),
        .ImmSrc(ImmSrcD2),
        .ALUSrc(ALUSrcD2),
        .MemWrite(MemWriteD2),
        .ResultSrc(ResultSrcD2),
        .Branch(BranchD2),
        .funct3(InstrD2[14:12]),
        .funct7(InstrD2[31:25]),
        .ALUControl(ALUControlD2)
    );

    // Register File for Dual PE
    Register_File rf (
        .clk(clk),
        .rst(rst),
        .WE1(RegWriteW1),
        .WD1(ResultW1),
        .A1(InstrD1[19:15]),
        .A2(InstrD1[24:20]),
        .A3(RDW1),
        .RD1(RD1_D1),
        .RD2(RD2_D1),
        
        .WE2(RegWriteW2),
        .WD2(ResultW2),
        .A4(InstrD2[19:15]),
        .A5(InstrD2[24:20]),
        .A6(RDW2),
        .RD3(RD1_D2),
        .RD4(RD2_D2)
    );

    // Immediate Extension for Dual PE
    Sign_Extend extension1 (
        .In(InstrD1),
        .ImmSrc(ImmSrcD1),
        .Imm_Ext(Imm_Ext_D1)
    );

    Sign_Extend extension2 (
        .In(InstrD2),
        .ImmSrc(ImmSrcD2),
        .Imm_Ext(Imm_Ext_D2)
    );

    // Register Logic for PE1 and PE2
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {RegWriteD_r1, ALUSrcD_r1, MemWriteD_r1, ResultSrcD_r1, BranchD_r1} <= 0;
            {RegWriteD_r2, ALUSrcD_r2, MemWriteD_r2, ResultSrcD_r2, BranchD_r2} <= 0;
        end else begin
            // PE1
            RegWriteD_r1 <= RegWriteD1;
            ALUSrcD_r1 <= ALUSrcD1;
            MemWriteD_r1 <= MemWriteD1;
            ResultSrcD_r1 <= ResultSrcD1;
            BranchD_r1 <= BranchD1;
            ALUControlD_r1 <= ALUControlD1;
            RD1_D_r1 <= RD1_D1;
            RD2_D_r1 <= RD2_D1;
            Imm_Ext_D_r1 <= Imm_Ext_D1;
            RD_D_r1 <= InstrD1[11:7];
            PCD_r1 <= PCD1;
            PCPlus4D_r1 <= PCPlus4D1;
            RS1_D_r1 <= InstrD1[19:15];
            RS2_D_r1 <= InstrD1[24:20];

            // PE2
            RegWriteD_r2 <= RegWriteD2;
            ALUSrcD_r2 <= ALUSrcD2;
            MemWriteD_r2 <= MemWriteD2;
            ResultSrcD_r2 <= ResultSrcD2;
            BranchD_r2 <= BranchD2;
            ALUControlD_r2 <= ALUControlD2;
            RD1_D_r2 <= RD1_D2;
            RD2_D_r2 <= RD2_D2;
            Imm_Ext_D_r2 <= Imm_Ext_D2;
            RD_D_r2 <= InstrD2[11:7];
            PCD_r2 <= PCD2;
            PCPlus4D_r2 <= PCPlus4D2;
            RS1_D_r2 <= InstrD2[19:15];
            RS2_D_r2 <= InstrD2[24:20];
        end
    end

    // Output Assignments
    assign {RegWriteE1, ALUSrcE1, MemWriteE1, ResultSrcE1, BranchE1, ALUControlE1} = {RegWriteD_r1, ALUSrcD_r1, MemWriteD_r1, ResultSrcD_r1, BranchD_r1, ALUControlD_r1};
    assign {RD1_E1, RD2_E1, Imm_Ext_E1, RD_E1, PCE1, PCPlus4E1} = {RD1_D_r1, RD2_D_r1, Imm_Ext_D_r1, RD_D_r1, PCD_r1, PCPlus4D_r1};
    assign {RS1_E1, RS2_E1} = {RS1_D_r1, RS2_D_r1};

    assign {RegWriteE2, ALUSrcE2, MemWriteE2, ResultSrcE2, BranchE2, ALUControlE2} = {RegWriteD_r2, ALUSrcD_r2, MemWriteD_r2, ResultSrcD_r2, BranchD_r2, ALUControlD_r2};
    assign {RD1_E2, RD2_E2, Imm_Ext_E2, RD_E2, PCE2, PCPlus4E2} = {RD1_D_r2, RD2_D_r2, Imm_Ext_D_r2, RD_D_r2, PCD_r2, PCPlus4D_r2};
    assign {RS1_E2, RS2_E2} = {RS1_D_r2, RS2_D_r2};

endmodule
