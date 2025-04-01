module ALU_Decoder(
    ALUOp1, funct3_1, funct7_1, op1, ALUControl1,
    ALUOp2, funct3_2, funct7_2, op2, ALUControl2
);

    // Inputs for PE1
    input [1:0] ALUOp1;
    input [2:0] funct3_1;
    input [6:0] funct7_1, op1;
    output [2:0] ALUControl1;

    // Inputs for PE2
    input [1:0] ALUOp2;
    input [2:0] funct3_2;
    input [6:0] funct7_2, op2;
    output [2:0] ALUControl2;

    // ALU Control for PE1
    assign ALUControl1 = (ALUOp1 == 2'b00) ? 3'b000 :    // Load/Store: Add
                         (ALUOp1 == 2'b01) ? 3'b001 :    // Branch: Subtract
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b000) & ({op1[5], funct7_1[5]} == 2'b11)) ? 3'b001 :  // SUB
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b000) & ({op1[5], funct7_1[5]} != 2'b11)) ? 3'b000 :  // ADD
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b010)) ? 3'b101 :  // SLT
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b110)) ? 3'b011 :  // OR
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b111)) ? 3'b010 :  // AND
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b100)) ? 3'b100 :  // XOR
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b001)) ? 3'b110 :  // SLL
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b101) & (funct7_1[5] == 1'b0)) ? 3'b111 :  // SRL
                         ((ALUOp1 == 2'b10) & (funct3_1 == 3'b101) & (funct7_1[5] == 1'b1)) ? 3'b100 :  // SRA
                         3'b000;

    // ALU Control for PE2
    assign ALUControl2 = (ALUOp2 == 2'b00) ? 3'b000 :    // Load/Store: Add
                         (ALUOp2 == 2'b01) ? 3'b001 :    // Branch: Subtract
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b000) & ({op2[5], funct7_2[5]} == 2'b11)) ? 3'b001 :  // SUB
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b000) & ({op2[5], funct7_2[5]} != 2'b11)) ? 3'b000 :  // ADD
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b010)) ? 3'b101 :  // SLT
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b110)) ? 3'b011 :  // OR
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b111)) ? 3'b010 :  // AND
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b100)) ? 3'b100 :  // XOR
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b001)) ? 3'b110 :  // SLL
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b101) & (funct7_2[5] == 1'b0)) ? 3'b111 :  // SRL
                         ((ALUOp2 == 2'b10) & (funct3_2 == 3'b101) & (funct7_2[5] == 1'b1)) ? 3'b100 :  // SRA
                         3'b000;

endmodule
