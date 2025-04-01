module Main_Decoder(
    Op1, RegWrite1, ImmSrc1, ALUSrc1, MemWrite1, ResultSrc1, Branch1, ALUOp1,
    Op2, RegWrite2, ImmSrc2, ALUSrc2, MemWrite2, ResultSrc2, Branch2, ALUOp2
);
    // Inputs for PE1
    input [6:0] Op1;
    output RegWrite1, ALUSrc1, MemWrite1, ResultSrc1, Branch1;
    output [1:0] ImmSrc1, ALUOp1;

    // Inputs for PE2
    input [6:0] Op2;
    output RegWrite2, ALUSrc2, MemWrite2, ResultSrc2, Branch2;
    output [1:0] ImmSrc2, ALUOp2;

    // Main Decoder for PE1
    assign RegWrite1 = (Op1 == 7'b0000011 | Op1 == 7'b0110011 | Op1 == 7'b0010011 ) ? 1'b1 :
                       1'b0;
    assign ImmSrc1 = (Op1 == 7'b0100011) ? 2'b01 : 
                     (Op1 == 7'b1100011) ? 2'b10 :    
                     2'b00;
    assign ALUSrc1 = (Op1 == 7'b0000011 | Op1 == 7'b0100011 | Op1 == 7'b0010011) ? 1'b1 :
                     1'b0;
    assign MemWrite1 = (Op1 == 7'b0100011) ? 1'b1 :
                       1'b0;
    assign ResultSrc1 = (Op1 == 7'b0000011) ? 1'b1 :
                        1'b0;
    assign Branch1 = (Op1 == 7'b1100011) ? 1'b1 :
                     1'b0;
    assign ALUOp1 = (Op1 == 7'b0110011) ? 2'b10 :
                    (Op1 == 7'b1100011) ? 2'b01 :
                    2'b00;

    // Main Decoder for PE2
    assign RegWrite2 = (Op2 == 7'b0000011 | Op2 == 7'b0110011 | Op2 == 7'b0010011 ) ? 1'b1 :
                       1'b0;
    assign ImmSrc2 = (Op2 == 7'b0100011) ? 2'b01 : 
                     (Op2 == 7'b1100011) ? 2'b10 :    
                     2'b00;
    assign ALUSrc2 = (Op2 == 7'b0000011 | Op2 == 7'b0100011 | Op2 == 7'b0010011) ? 1'b1 :
                     1'b0;
    assign MemWrite2 = (Op2 == 7'b0100011) ? 1'b1 :
                       1'b0;
    assign ResultSrc2 = (Op2 == 7'b0000011) ? 1'b1 :
                        1'b0;
    assign Branch2 = (Op2 == 7'b1100011) ? 1'b1 :
                     1'b0;
    assign ALUOp2 = (Op2 == 7'b0110011) ? 2'b10 :
                    (Op2 == 7'b1100011) ? 2'b01 :
                    2'b00;

endmodule
