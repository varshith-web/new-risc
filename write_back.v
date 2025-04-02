module writeback_cycle(
    input clk,
    input rst,
    input ResultSrcW_PE1,      // Control signal for PE1
    input ResultSrcW_PE2,      // Control signal for PE2
    input [31:0] PCPlus4W_PE1, // PC+4 value for PE1
    input [31:0] PCPlus4W_PE2, // PC+4 value for PE2
    input [31:0] ALU_ResultW_PE1, // ALU result from PE1
    input [31:0] ALU_ResultW_PE2, // ALU result from PE2
    input [31:0] ReadDataW_PE1,   // Data read from memory for PE1
    input [31:0] ReadDataW_PE2,   // Data read from memory for PE2
    output [31:0] ResultW_PE1,    // Writeback result for PE1
    output [31:0] ResultW_PE2     // Writeback result for PE2
);

    // Multiplexer to select between ALU result and memory read data for PE1
    Mux result_mux_PE1 (
        .a(ALU_ResultW_PE1),  // Input A for PE1: ALU result
        .b(ReadDataW_PE1),    // Input B for PE1: Data from memory
        .s(ResultSrcW_PE1),   // Select signal for PE1
        .c(ResultW_PE1)       // Output for PE1: Writeback result
    );

    // Multiplexer to select between ALU result and memory read data for PE2
    Mux result_mux_PE2 (
        .a(ALU_ResultW_PE2),  // Input A for PE2: ALU result
        .b(ReadDataW_PE2),    // Input B for PE2: Data from memory
        .s(ResultSrcW_PE2),   // Select signal for PE2
        .c(ResultW_PE2)       // Output for PE2: Writeback result
    );

endmodule
