module spi_top(
    input clk, rst, newd,
    input [11:0] din,
    output [11:0] dout,
    output done
    );
    
    wire sclk, cs, mosi;
    
    master_spi MASTER(clk, newd, rst, din, sclk, cs, mosi);
    spi_slave SLAVE(sclk, cs, mosi, dout, done);
endmodule
