`include "ALU_Decoder.v"
`include "Main_Decoder.v"

module Control_Unit_Top(
    input [6:0] Op1, Op2,         // Opcode for PE1 and PE2
    input [6:0] funct7_1, funct7_2, // funct7 for PE1 and PE2
    input [2:0] funct3_1, funct3_2, // funct3 for PE1 and PE2
    output RegWrite1, RegWrite2,   // RegWrite signals for PE1 and PE2
    output ALUSrc1, ALUSrc2,       // ALUSrc signals for PE1 and PE2
    output MemWrite1, MemWrite2,   // MemWrite signals for PE1 and PE2
    output ResultSrc1, ResultSrc2, // ResultSrc signals for PE1 and PE2
    output Branch1, Branch2,       // Branch signals for PE1 and PE2
    output [1:0] ImmSrc1, ImmSrc2, // Immediate Source signals for PE1 and PE2
    output [2:0] ALUControl1, ALUControl2 // ALU Control signals for PE1 and PE2
);

    // ALUOp signals for both processing elements
    wire [1:0] ALUOp1, ALUOp2;

    // Main Decoder for PE1
    Main_Decoder Main_Decoder1 (
        .Op(Op1),
        .RegWrite(RegWrite1),
        .ImmSrc(ImmSrc1),
        .MemWrite(MemWrite1),
        .ResultSrc(ResultSrc1),
        .Branch(Branch1),
        .ALUSrc(ALUSrc1),
        .ALUOp(ALUOp1)
    );

    // Main Decoder for PE2
    Main_Decoder Main_Decoder2 (
        .Op(Op2),
        .RegWrite(RegWrite2),
        .ImmSrc(ImmSrc2),
        .MemWrite(MemWrite2),
        .ResultSrc(ResultSrc2),
        .Branch(Branch2),
        .ALUSrc(ALUSrc2),
        .ALUOp(ALUOp2)
    );

    // ALU Decoder for PE1
    ALU_Decoder ALU_Decoder1 (
        .ALUOp(ALUOp1),
        .funct3(funct3_1),
        .funct7(funct7_1),
        .op(Op1),
        .ALUControl(ALUControl1)
    );

    // ALU Decoder for PE2
    ALU_Decoder ALU_Decoder2 (
        .ALUOp(ALUOp2),
        .funct3(funct3_2),
        .funct7(funct7_2),
        .op(Op2),
        .ALUControl(ALUControl2)
    );

endmodule
