`timescale 1ns / 1ps
module tb_spi();
    reg clk = 0;
    reg rst = 0;
    reg newd = 0;
    reg [11:0] din = 0;
    wire [11:0] dout;
    wire done;
 
    always #10 clk = ~clk;
    
    spi_top dut(clk, rst, newd, din, dout, done);
    
    initial
    begin
        rst = 1;
        repeat(5) @(posedge clk);
        rst = 0;
        
        for(int i = 0; i < 10; i++) 
        begin
            newd = 1;
            din = $urandom;
            @(posedge dut.s1.sclk);
            newd = 0;
            @(posedge done);
        end      
    end
endmodule


