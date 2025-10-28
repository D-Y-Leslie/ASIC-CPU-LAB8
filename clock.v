`timescale 1 ns / 1 ns

module clock (clk);

output clk;

parameter clk_period = 20;
reg clk;
initial
clk = 0;
always 
#(clk_period/2)clk=~clk;

endmodule