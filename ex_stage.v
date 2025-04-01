module execute_cycle_dualPE(
    clk, rst, 
    RegWriteE1, ALUSrcE1, MemWriteE1, ResultSrcE1, BranchE1, ALUControlE1, 
    RD1_E1, RD2_E1, Imm_Ext_E1, RD_E1, PCE1, PCPlus4E1, 
    PCSrcE1, PCTargetE1, RegWriteM1, MemWriteM1, ResultSrcM1, RD_M1, PCPlus4M1, WriteDataM1, ALU_ResultM1, 
    RegWriteE2, ALUSrcE2, MemWriteE2, ResultSrcE2, BranchE2, ALUControlE2, 
    RD1_E2, RD2_E2, Imm_Ext_E2, RD_E2, PCE2, PCPlus4E2, 
    PCSrcE2, PCTargetE2, RegWriteM2, MemWriteM2, ResultSrcM2, RD_M2, PCPlus4M2, WriteDataM2, ALU_ResultM2, 
    ResultW1, ForwardA_E1, ForwardB_E1, 
    ResultW2, ForwardA_E2, ForwardB_E2
);

    // Input Declarations
    input clk, rst;
    
    // PE1 Inputs
    input RegWriteE1, ALUSrcE1, MemWriteE1, ResultSrcE1, BranchE1;
    input [2:0] ALUControlE1;
    input [31:0] RD1_E1, RD2_E1, Imm_Ext_E1;
    input [4:0] RD_E1;
    input [31:0] PCE1, PCPlus4E1, ResultW1;
    input [1:0] ForwardA_E1, ForwardB_E1;
    
    // PE2 Inputs
    input RegWriteE2, ALUSrcE2, MemWriteE2, ResultSrcE2, BranchE2;
    input [2:0] ALUControlE2;
    input [31:0] RD1_E2, RD2_E2, Imm_Ext_E2;
    input [4:0] RD_E2;
    input [31:0] PCE2, PCPlus4E2, ResultW2;
    input [1:0] ForwardA_E2, ForwardB_E2;

    // Output Declarations for PE1
    output PCSrcE1, RegWriteM1, MemWriteM1, ResultSrcM1;
    output [4:0] RD_M1; 
    output [31:0] PCPlus4M1, WriteDataM1, ALU_ResultM1;
    output [31:0] PCTargetE1;

    // Output Declarations for PE2
    output PCSrcE2, RegWriteM2, MemWriteM2, ResultSrcM2;
    output [4:0] RD_M2; 
    output [31:0] PCPlus4M2, WriteDataM2, ALU_ResultM2;
    output [31:0] PCTargetE2;

    // Intermediate Wire Declarations
    wire [31:0] Src_A1, Src_B_interim1, Src_B1;
    wire [31:0] ResultE1;
    wire ZeroE1;
    
    wire [31:0] Src_A2, Src_B_interim2, Src_B2;
    wire [31:0] ResultE2;
    wire ZeroE2;

    // PE1: Mux for Source A
    Mux_3_by_1 srca_mux1 (
        .a(RD1_E1),
        .b(ResultW1),
        .c(ALU_ResultM1),
        .s(ForwardA_E1),
        .d(Src_A1)
    );

    // PE1: Mux for Source B
    Mux_3_by_1 srcb_mux1 (
        .a(RD2_E1),
        .b(ResultW1),
        .c(ALU_ResultM1),
        .s(ForwardB_E1),
        .d(Src_B_interim1)
    );

    // PE1: ALU Src Mux
    Mux alu_src_mux1 (
        .a(Src_B_interim1),
        .b(Imm_Ext_E1),
        .s(ALUSrcE1),
        .c(Src_B1)
    );

    // PE1: ALU Unit
    ALU alu1 (
        .A(Src_A1),
        .B(Src_B1),
        .Result(ResultE1),
        .ALUControl(ALUControlE1),
        .Zero(ZeroE1)
    );

    // PE1: Branch Adder
    PC_Adder branch_adder1 (
        .a(PCE1),
        .b(Imm_Ext_E1),
        .c(PCTargetE1)
    );

    // PE2: Mux for Source A
    Mux_3_by_1 srca_mux2 (
        .a(RD1_E2),
        .b(ResultW2),
        .c(ALU_ResultM2),
        .s(ForwardA_E2),
        .d(Src_A2)
    );

    // PE2: Mux for Source B
    Mux_3_by_1 srcb_mux2 (
        .a(RD2_E2),
        .b(ResultW2),
        .c(ALU_ResultM2),
        .s(ForwardB_E2),
        .d(Src_B_interim2)
    );

    // PE2: ALU Src Mux
    Mux alu_src_mux2 (
        .a(Src_B_interim2),
        .b(Imm_Ext_E2),
        .s(ALUSrcE2),
        .c(Src_B2)
    );

    // PE2: ALU Unit
    ALU alu2 (
        .A(Src_A2),
        .B(Src_B2),
        .Result(ResultE2),
        .ALUControl(ALUControlE2),
        .Zero(ZeroE2)
    );

    // PE2: Branch Adder
    PC_Adder branch_adder2 (
        .a(PCE2),
        .b(Imm_Ext_E2),
        .c(PCTargetE2)
    );

    // Output Assignments for PE1
    assign PCSrcE1 = ZeroE1 & BranchE1;
    assign RegWriteM1 = RegWriteE1;
    assign MemWriteM1 = MemWriteE1;
    assign ResultSrcM1 = ResultSrcE1;
    assign RD_M1 = RD_E1;
    assign PCPlus4M1 = PCPlus4E1;
    assign WriteDataM1 = Src_B_interim1;
    assign ALU_ResultM1 = ResultE1;

    // Output Assignments for PE2
    assign PCSrcE2 = ZeroE2 & BranchE2;
    assign RegWriteM2 = RegWriteE2;
    assign MemWriteM2 = MemWriteE2;
    assign ResultSrcM2 = ResultSrcE2;
    assign RD_M2 = RD_E2;
    assign PCPlus4M2 = PCPlus4E2;
    assign WriteDataM2 = Src_B_interim2;
    assign ALU_ResultM2 = ResultE2;

endmodule
