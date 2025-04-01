module Instruction_Memory_DualPE(
    rst, A1, A2, RD1, RD2
);

    input rst;
    input [31:0] A1, A2;
    output [31:0] RD1, RD2;

    reg [31:0] mem [1023:0];

    // Output Assignments
    assign RD1 = (rst == 1'b0) ? 32'h00000000 : mem[A1[31:2]];
    assign RD2 = (rst == 1'b0) ? 32'h00000000 : mem[A2[31:2]];

    // Memory Initialization
    initial begin
        $readmemh("memfile.hex", mem);  // Reading instructions from hex file
    end

endmodule
