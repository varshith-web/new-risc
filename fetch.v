module fetch_cycle(
    input clk, 
    input rst,
    input PCSrcE,              // When true, select branch/jump target
    input [31:0] PCTargetE,    // Branch/jump target PC
    output [31:0] InstrD1,     // Instruction for PE1 (from IF stage)
    output [31:0] InstrD2,     // Instruction for PE2 (from IF stage)
    output [31:0] PCD,         // Current PC (for debug or later stages)
    output [31:0] PCPlus8D     // PC + 8 (next sequential PC value)
);

    // Internal wires for PC and instruction fetch
    wire [31:0] PC_F, PCF, PCPlus8F;
    wire [31:0] InstrF1, InstrF2;

    // PC MUX: Select the next PC between PC+8 and branch/jump target
    Mux PC_MUX (
        .a(PCPlus8F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );

    // PC Counter: Update PC on each clock cycle
    PC_Module Program_Counter (
        .clk(clk),
        .rst(rst),
        .PC(PCF),
        .PC_Next(PC_F)
    );

    // Instruction Memory (Dual Port): Reads two instructions simultaneously.
    // Note: This module should support two independent reads.
    Instruction_Memory_Dual IMEM (
        .rst(rst),
        .A(PCF),           // Address for the first instruction
        .RD1(InstrF1),     // First instruction output
        .RD2(InstrF2)      // Second instruction output (located at PC + 4)
    );

    // PC Adder: Calculate PC + 8 for dual instruction fetch.
    PC_Adder PC_adder (
        .a(PCF),
        .b(32'h00000008),  // 8 bytes (2 instructions x 4 bytes)
        .c(PCPlus8F)
    );

    // Pipeline Registers to latch fetch stage outputs
    reg [31:0] InstrF1_reg, InstrF2_reg, PCF_reg, PCPlus8F_reg;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            InstrF1_reg <= 32'h0;
            InstrF2_reg <= 32'h0;
            PCF_reg <= 32'h0;
            PCPlus8F_reg <= 32'h0;
        end else begin
            InstrF1_reg <= InstrF1;
            InstrF2_reg <= InstrF2;
            PCF_reg <= PCF;
            PCPlus8F_reg <= PCPlus8F;
        end
    end

    // Assign the pipeline register values to output ports.
    assign InstrD1 = InstrF1_reg;
    assign InstrD2 = InstrF2_reg;
    assign PCD = PCF_reg;
    assign PCPlus8D = PCPlus8F_reg;

endmodule
