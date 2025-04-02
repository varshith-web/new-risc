`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"

module Dual_PE_Top(clk, rst);

    input clk, rst;

    // PE1 Wires
    wire [31:0] PC1, RD_Instr1, RD1_Top1, Imm_Ext_Top1, ALUResult1, ReadData1, PCPlus4_1, RD2_Top1, SrcB1, Result1;
    wire RegWrite1, MemWrite1, ALUSrc1, ResultSrc1;
    wire [1:0] ImmSrc1;
    wire [2:0] ALUControl1;

    // PE2 Wires
    wire [31:0] PC2, RD_Instr2, RD1_Top2, Imm_Ext_Top2, ALUResult2, ReadData2, PCPlus4_2, RD2_Top2, SrcB2, Result2;
    wire RegWrite2, MemWrite2, ALUSrc2, ResultSrc2;
    wire [1:0] ImmSrc2;
    wire [2:0] ALUControl2;

    // =======================
    // PE1 Architecture
    // =======================
    PC_Module PC1_Module(
        .clk(clk),
        .rst(rst),
        .PC(PC1),
        .PC_Next(PCPlus4_1)
    );

    PC_Adder PC_Adder1(
        .a(PC1),
        .b(32'd4),
        .c(PCPlus4_1)
    );

    Instruction_Memory Instruction_Memory1(
        .rst(rst),
        .A(PC1),
        .RD(RD_Instr1)
    );

    Register_File Register_File1(
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite1),
        .WD3(Result1),
        .A1(RD_Instr1[19:15]),
        .A2(RD_Instr1[24:20]),
        .A3(RD_Instr1[11:7]),
        .RD1(RD1_Top1),
        .RD2(RD2_Top1)
    );

    Sign_Extend Sign_Extend1(
        .In(RD_Instr1),
        .ImmSrc(ImmSrc1[0]),
        .Imm_Ext(Imm_Ext_Top1)
    );

    Mux Mux_Register_to_ALU1(
        .a(RD2_Top1),
        .b(Imm_Ext_Top1),
        .s(ALUSrc1),
        .c(SrcB1)
    );

    ALU ALU1(
        .A(RD1_Top1),
        .B(SrcB1),
        .Result(ALUResult1),
        .ALUControl(ALUControl1),
        .OverFlow(),
        .Carry(),
        .Zero(),
        .Negative()
    );

    Control_Unit_Top Control_Unit_Top1(
        .Op(RD_Instr1[6:0]),
        .RegWrite(RegWrite1),
        .ImmSrc(ImmSrc1),
        .ALUSrc(ALUSrc1),
        .MemWrite(MemWrite1),
        .ResultSrc(ResultSrc1),
        .Branch(),
        .funct3(RD_Instr1[14:12]),
        .funct7(RD_Instr1[31:25]),
        .ALUControl(ALUControl1)
    );

    Data_Memory Data_Memory1(
        .clk(clk),
        .rst(rst),
        .WE(MemWrite1),
        .WD(RD2_Top1),
        .A(ALUResult1),
        .RD(ReadData1)
    );

    Mux Mux_DataMemory_to_Register1(
        .a(ALUResult1),
        .b(ReadData1),
        .s(ResultSrc1),
        .c(Result1)
    );

    // =======================
    // PE2 Architecture
    // =======================
    PC_Module PC2_Module(
        .clk(clk),
        .rst(rst),
        .PC(PC2),
        .PC_Next(PCPlus4_2)
    );

    PC_Adder PC_Adder2(
        .a(PC2),
        .b(32'd4),
        .c(PCPlus4_2)
    );

    Instruction_Memory Instruction_Memory2(
        .rst(rst),
        .A(PC2),
        .RD(RD_Instr2)
    );

    Register_File Register_File2(
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite2),
        .WD3(Result2),
        .A1(RD_Instr2[19:15]),
        .A2(RD_Instr2[24:20]),
        .A3(RD_Instr2[11:7]),
        .RD1(RD1_Top2),
        .RD2(RD2_Top2)
    );

    Sign_Extend Sign_Extend2(
        .In(RD_Instr2),
        .ImmSrc(ImmSrc2[0]),
        .Imm_Ext(Imm_Ext_Top2)
    );

    Mux Mux_Register_to_ALU2(
        .a(RD2_Top2),
        .b(Imm_Ext_Top2),
        .s(ALUSrc2),
        .c(SrcB2)
    );

    ALU ALU2(
        .A(RD1_Top2),
        .B(SrcB2),
        .Result(ALUResult2),
        .ALUControl(ALUControl2),
        .OverFlow(),
        .Carry(),
        .Zero(),
        .Negative()
    );

    Control_Unit_Top Control_Unit_Top2(
        .Op(RD_Instr2[6:0]),
        .RegWrite(RegWrite2),
        .ImmSrc(ImmSrc2),
        .ALUSrc(ALUSrc2),
        .MemWrite(MemWrite2),
        .ResultSrc(ResultSrc2),
        .Branch(),
        .funct3(RD_Instr2[14:12]),
        .funct7(RD_Instr2[31:25]),
        .ALUControl(ALUControl2)
    );

    Data_Memory Data_Memory2(
        .clk(clk),
        .rst(rst),
        .WE(MemWrite2),
        .WD(RD2_Top2),
        .A(ALUResult2),
        .RD(ReadData2)
    );

    Mux Mux_DataMemory_to_Register2(
        .a(ALUResult2),
        .b(ReadData2),
        .s(ResultSrc2),
        .c(Result2)
    );

endmodule
