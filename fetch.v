module fetch_cycle(
    input clk, 
    input rst,
    input PCSrcE,              // When true, select branch/jump target
    input [31:0] PCTargetE,    // Branch/jump target PC

    // Outputs to Decode Stage
    output [31:0] InstrD1,     // Instruction for PE1
    output [31:0] InstrD2,     // Instruction for PE2
    output [31:0] PCD1,        // Program Counter for PE1
    output [31:0] PCD2,        // Program Counter for PE2
    output [31:0] PCPlus4D1,   // PC + 4 for PE1
    output [31:0] PCPlus4D2    // PC + 4 for PE2
);

    // Internal wires for PC and instruction fetch
    wire [31:0] PC_F, PCF, PCPlus8F;
    wire [31:0] InstrF1, InstrF2;
    wire [31:0] PCPlus4F1, PCPlus4F2;

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

    // Dual Port Instruction Memory: Fetch instructions for both PEs
    Instruction_Memory_Dual IMEM (
        .rst(rst),
        .A(PCF),        // Address for PE1 instruction
        .RD1(InstrF1),  // Instruction for PE1
        .RD2(InstrF2)   // Instruction for PE2 (PC+4)
    );

    // PC Adders: Calculate PC + 4 and PC + 8
    PC_Adder PC_adder1 (
        .a(PCF),
        .b(32'h00000004),  // Increment by 4 bytes
        .c(PCPlus4F1)
    );
    PC_Adder PC_adder2 (
        .a(PCF + 32'h4),   // Increment base address by 4 bytes
        .b(32'h00000004),  // Increment by 4 bytes
        .c(PCPlus4F2)
    );
    PC_Adder PC_adder8 (
        .a(PCF),
        .b(32'h00000008),  // Increment by 8 bytes (two instructions)
        .c(PCPlus8F)
    );

    // Pipeline Registers to latch fetch stage outputs
    reg [31:0] InstrF1_reg, InstrF2_reg, PCF1_reg, PCF2_reg, PCPlus4F1_reg, PCPlus4F2_reg;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            InstrF1_reg <= 32'h0;
            InstrF2_reg <= 32'h0;
            PCF1_reg <= 32'h0;
            PCF2_reg <= 32'h0;
            PCPlus4F1_reg <= 32'h0;
            PCPlus4F2_reg <= 32'h0;
        end else begin
            InstrF1_reg <= InstrF1;
            InstrF2_reg <= InstrF2;
            PCF1_reg <= PCF;
            PCF2_reg <= PCF + 32'h4; // Second PE PC
            PCPlus4F1_reg <= PCPlus4F1;
            PCPlus4F2_reg <= PCPlus4F2;
        end
    end

    // Assign the pipeline register values to output ports
    assign InstrD1 = InstrF1_reg;
    assign InstrD2 = InstrF2_reg;
    assign PCD1 = PCF1_reg;
    assign PCD2 = PCF2_reg;
    assign PCPlus4D1 = PCPlus4F1_reg;
    assign PCPlus4D2 = PCPlus4F2_reg;

endmodule
