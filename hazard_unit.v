module hazard_unit_dual_pe(
    rst, RegWriteM1, RegWriteM2, RegWriteW1, RegWriteW2, 
    RD_M1, RD_M2, RD_W1, RD_W2, 
    Rs1_E1, Rs1_E2, Rs2_E1, Rs2_E2, 
    ForwardAE1, ForwardAE2, ForwardBE1, ForwardBE2
);

    // Declaration of I/Os
    input rst;
    input RegWriteM1, RegWriteM2, RegWriteW1, RegWriteW2;
    input [4:0] RD_M1, RD_M2, RD_W1, RD_W2;
    input [4:0] Rs1_E1, Rs1_E2, Rs2_E1, Rs2_E2;
    output [1:0] ForwardAE1, ForwardAE2, ForwardBE1, ForwardBE2;

    // Forwarding for PE1 - ForwardAE1
    assign ForwardAE1 = (rst == 1'b0) ? 2'b00 : 
                        ((RegWriteM1 == 1'b1) & (RD_M1 != 5'h00) & (RD_M1 == Rs1_E1)) ? 2'b10 :
                        ((RegWriteW1 == 1'b1) & (RD_W1 != 5'h00) & (RD_W1 == Rs1_E1)) ? 2'b01 :
                        ((RegWriteM2 == 1'b1) & (RD_M2 != 5'h00) & (RD_M2 == Rs1_E1)) ? 2'b10 :
                        ((RegWriteW2 == 1'b1) & (RD_W2 != 5'h00) & (RD_W2 == Rs1_E1)) ? 2'b01 : 2'b00;

    // Forwarding for PE1 - ForwardBE1
    assign ForwardBE1 = (rst == 1'b0) ? 2'b00 : 
                        ((RegWriteM1 == 1'b1) & (RD_M1 != 5'h00) & (RD_M1 == Rs2_E1)) ? 2'b10 :
                        ((RegWriteW1 == 1'b1) & (RD_W1 != 5'h00) & (RD_W1 == Rs2_E1)) ? 2'b01 :
                        ((RegWriteM2 == 1'b1) & (RD_M2 != 5'h00) & (RD_M2 == Rs2_E1)) ? 2'b10 :
                        ((RegWriteW2 == 1'b1) & (RD_W2 != 5'h00) & (RD_W2 == Rs2_E1)) ? 2'b01 : 2'b00;

    // Forwarding for PE2 - ForwardAE2
    assign ForwardAE2 = (rst == 1'b0) ? 2'b00 : 
                        ((RegWriteM2 == 1'b1) & (RD_M2 != 5'h00) & (RD_M2 == Rs1_E2)) ? 2'b10 :
                        ((RegWriteW2 == 1'b1) & (RD_W2 != 5'h00) & (RD_W2 == Rs1_E2)) ? 2'b01 :
                        ((RegWriteM1 == 1'b1) & (RD_M1 != 5'h00) & (RD_M1 == Rs1_E2)) ? 2'b10 :
                        ((RegWriteW1 == 1'b1) & (RD_W1 != 5'h00) & (RD_W1 == Rs1_E2)) ? 2'b01 : 2'b00;

    // Forwarding for PE2 - ForwardBE2
    assign ForwardBE2 = (rst == 1'b0) ? 2'b00 : 
                        ((RegWriteM2 == 1'b1) & (RD_M2 != 5'h00) & (RD_M2 == Rs2_E2)) ? 2'b10 :
                        ((RegWriteW2 == 1'b1) & (RD_W2 != 5'h00) & (RD_W2 == Rs2_E2)) ? 2'b01 :
                        ((RegWriteM1 == 1'b1) & (RD_M1 != 5'h00) & (RD_M1 == Rs2_E2)) ? 2'b10 :
                        ((RegWriteW1 == 1'b1) & (RD_W1 != 5'h00) & (RD_W1 == Rs2_E2)) ? 2'b01 : 2'b00;

endmodule
