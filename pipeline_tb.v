module tb_dual_pe();

    reg clk = 0, rst;
    
    // Clock Generation
    always begin
        clk = ~clk;
        #50;
    end

    // Reset Generation
    initial begin
        rst <= 1'b0;
        #200;
        rst <= 1'b1;
        #2000;
        $finish;    
    end

    // VCD Dump for Waveform Analysis
    initial begin
        $dumpfile("dump_dual_pe.vcd");
        $dumpvars(0, tb_dual_pe);
    end

    // Instantiate the Top Module (Pipeline Top with 2 PEs)
    Pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );

endmodule
