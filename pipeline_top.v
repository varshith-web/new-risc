`include "Fetch_Cycle.v"
`include "Decode_Cycle.v"
`include "Execute_Cycle.v"
`include "Memory_Cycle.v"
`include "Writeback_Cycle.v"    
`include "PC.v"
`include "PC_Adder.v"
`include "Mux.v"
`include "Instruction_Memory.v"
`include "Control_Unit_Top.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Data_Memory.v"
`include "Hazard_unit.v"

module Pipeline_top(clk, rst);

    // Declaration of I/O
    input clk, rst;

    // Declaration of Interim Wires for PE1 and PE2
    wire PCSrcE1, RegWriteW1, RegWriteE1, ALUSrcE1, MemWriteE1, ResultSrcE1, BranchE1, RegWriteM1, MemWriteM1, ResultSrcM1, ResultSrcW1;
    wire [2:0] ALUControlE1;
    wire [4:0] RD_E1, RD_M1, RDW1;
    wire [31:0] PCTargetE1, InstrD1, PCD1, PCPlus4D1, ResultW1, RD1_E1, RD2_E1, Imm_Ext_E1, PCE1, PCPlus4E1, PCPlus4M1, WriteDataM1, ALU_ResultM1;
    wire [31:0] PCPlus4W1, ALU_ResultW1, ReadDataW1;
    wire [4:0] RS1_E1, RS2_E1;
    wire [1:0] ForwardBE1, ForwardAE1;

    wire PCSrcE2, RegWriteW2, RegWriteE2, ALUSrcE2, MemWriteE2, ResultSrcE2, BranchE2, RegWriteM2, MemWriteM2, ResultSrcM2, ResultSrcW2;
    wire [2:0] ALUControlE2;
    wire [4:0] RD_E2, RD_M2, RDW2;
    wire [31:0] PCTargetE2, InstrD2, PCD2, PCPlus4D2, ResultW2, RD1_E2, RD2_E2, Imm_Ext_E2, PCE2, PCPlus4E2, PCPlus4M2, WriteDataM2, ALU_ResultM2;
    wire [31:0] PCPlus4W2, ALU_ResultW2, ReadDataW2;
    wire [4:0] RS1_E2, RS2_E2;
    wire [1:0] ForwardBE2, ForwardAE2;

    // Module Initiation for PE1
    // Fetch Stage
    fetch_cycle Fetch1 (
        .clk(clk), 
        .rst(rst), 
        .PCSrcE(PCSrcE1), 
        .PCTargetE(PCTargetE1), 
        .InstrD(InstrD1), 
        .PCD(PCD1), 
        .PCPlus4D(PCPlus4D1)
    );

    // Decode Stage
    decode_cycle Decode1 (
        .clk(clk), 
        .rst(rst), 
        .InstrD(InstrD1), 
        .PCD(PCD1), 
        .PCPlus4D(PCPlus4D1), 
        .RegWriteW(RegWriteW1), 
        .RDW(RDW1), 
        .ResultW(ResultW1), 
        .RegWriteE(RegWriteE1), 
        .ALUSrcE(ALUSrcE1), 
        .MemWriteE(MemWriteE1), 
        .ResultSrcE(ResultSrcE1),
        .BranchE(BranchE1),  
        .ALUControlE(ALUControlE1), 
        .RD1_E(RD1_E1), 
        .RD2_E(RD2_E1), 
        .Imm_Ext_E(Imm_Ext_E1), 
        .RD_E(RD_E1), 
        .PCE(PCE1), 
        .PCPlus4E(PCPlus4E1),
        .RS1_E(RS1_E1),
        .RS2_E(RS2_E1)
    );

    // Execute Stage
    execute_cycle Execute1 (
        .clk(clk), 
        .rst(rst), 
        .RegWriteE(RegWriteE1), 
        .ALUSrcE(ALUSrcE1), 
        .MemWriteE(MemWriteE1), 
        .ResultSrcE(ResultSrcE1), 
        .BranchE(BranchE1), 
        .ALUControlE(ALUControlE1), 
        .RD1_E(RD1_E1), 
        .RD2_E(RD2_E1), 
        .Imm_Ext_E(Imm_Ext_E1), 
        .RD_E(RD_E1), 
        .PCE(PCE1), 
        .PCPlus4E(PCPlus4E1), 
        .PCSrcE(PCSrcE1), 
        .PCTargetE(PCTargetE1), 
        .RegWriteM(RegWriteM1), 
        .MemWriteM(MemWriteM1), 
        .ResultSrcM(ResultSrcM1), 
        .RD_M(RD_M1), 
        .PCPlus4M(PCPlus4M1), 
        .WriteDataM(WriteDataM1), 
        .ALU_ResultM(ALU_ResultM1),
        .ResultW(ResultW1),
        .ForwardA_E(ForwardAE1),
        .ForwardB_E(ForwardBE1)
    );

    // Memory Stage
    memory_cycle Memory1 (
        .clk(clk), 
        .rst(rst), 
        .RegWriteM(RegWriteM1), 
        .MemWriteM(MemWriteM1), 
        .ResultSrcM(ResultSrcM1), 
        .RD_M(RD_M1), 
        .PCPlus4M(PCPlus4M1), 
        .WriteDataM(WriteDataM1), 
        .ALU_ResultM(ALU_ResultM1), 
        .RegWriteW(RegWriteW1), 
        .ResultSrcW(ResultSrcW1), 
        .RD_W(RDW1), 
        .PCPlus4W(PCPlus4W1), 
        .ALU_ResultW(ALU_ResultW1), 
        .ReadDataW(ReadDataW1)
    );

    // Write Back Stage
    writeback_cycle WriteBack1 (
        .clk(clk), 
        .rst(rst), 
        .ResultSrcW(ResultSrcW1), 
        .PCPlus4W(PCPlus4W1), 
        .ALU_ResultW(ALU_ResultW1), 
        .ReadDataW(ReadDataW1), 
        .ResultW(ResultW1)
    );

    // Hazard Unit for PE1
    hazard_unit Hazard1 (
        .rst(rst), 
        .RegWriteM(RegWriteM1), 
        .RegWriteW(RegWriteW1), 
        .RD_M(RD_M1), 
        .RD_W(RDW1), 
        .Rs1_E(RS1_E1), 
        .Rs2_E(RS2_E1), 
        .ForwardAE(ForwardAE1), 
        .ForwardBE(ForwardBE1)
    );

    // Similar setup for PE2 can be done here

endmodule
