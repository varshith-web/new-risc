module Data_Memory_Dual_PE(
    input clk, rst,
    input WE1, WE2,                  // Write Enable for PE1 and PE2
    input [31:0] A1, WD1, A2, WD2,   // Address and Write Data for PE1 and PE2
    output [31:0] RD1, RD2           // Read Data for PE1 and PE2
);

    // Memory declaration (1024 x 32-bit)
    reg [31:0] mem [1023:0];

    // Memory write operations
    always @(posedge clk) begin
        if (WE1) 
            mem[A1] <= WD1;       // Write data to address A1 for PE1
        if (WE2)
            mem[A2] <= WD2;       // Write data to address A2 for PE2
    end

    // Memory read operations
    assign RD1 = (~rst) ? 32'd0 : mem[A1];
    assign RD2 = (~rst) ? 32'd0 : mem[A2];

    // Initializing memory
    initial begin
        integer i;
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
        // Example initial data (if needed)
        // mem[0] = 32'h00000000;
        // mem[40] = 32'h00000002;
    end

endmodule
