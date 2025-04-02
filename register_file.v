module Register_File(
    input clk,
    input rst,
    input WE3_PE1,              // Write Enable for PE1
    input WE3_PE2,              // Write Enable for PE2
    input [4:0] A1_PE1,         // Read address 1 for PE1
    input [4:0] A2_PE1,         // Read address 2 for PE1
    input [4:0] A3_PE1,         // Write address for PE1
    input [4:0] A1_PE2,         // Read address 1 for PE2
    input [4:0] A2_PE2,         // Read address 2 for PE2
    input [4:0] A3_PE2,         // Write address for PE2
    input [31:0] WD3_PE1,       // Write data for PE1
    input [31:0] WD3_PE2,       // Write data for PE2
    output [31:0] RD1_PE1,      // Read data 1 for PE1
    output [31:0] RD2_PE1,      // Read data 2 for PE1
    output [31:0] RD1_PE2,      // Read data 1 for PE2
    output [31:0] RD2_PE2       // Read data 2 for PE2
);

    // Register file declaration (32 registers, 32 bits each)
    reg [31:0] Register [31:0];

    // PE1 Write Operation
    always @ (posedge clk) begin
        if (WE3_PE1 && (A3_PE1 != 5'h00))
            Register[A3_PE1] <= WD3_PE1;
    end

    // PE2 Write Operation
    always @ (posedge clk) begin
        if (WE3_PE2 && (A3_PE2 != 5'h00))
            Register[A3_PE2] <= WD3_PE2;
    end

    // Read Operation for PE1
    assign RD1_PE1 = (rst == 1'b0) ? 32'd0 : Register[A1_PE1];
    assign RD2_PE1 = (rst == 1'b0) ? 32'd0 : Register[A2_PE1];

    // Read Operation for PE2
    assign RD1_PE2 = (rst == 1'b0) ? 32'd0 : Register[A1_PE2];
    assign RD2_PE2 = (rst == 1'b0) ? 32'd0 : Register[A2_PE2];

    // Initializing register 0 to zero
    initial begin
        Register[0] = 32'h00000000;
    end

endmodule
