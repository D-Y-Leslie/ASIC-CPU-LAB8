/***************
* 32X8 MEMORY *
***************/
`timescale 1 ns / 1 ns

module mem ( data, addr, read, write );
inout [7:0] data ;
input [4:0] addr ;
input read ;
input write;

reg [7:0] memory [0:31];
reg [7:0] data_out;

// 当 read 为高电平时，读出 memory 的数据到 data 总线上
assign data = (read) ? data_out : 8'bz;

// 在 write 的上升沿，将 data 总线上的数据写入 memory
always @(posedge write) begin
    memory[addr] <= data;
end

// 当 read 或者 addr 变化时，更新 data_out
always @(read or addr) begin
    if (read) begin
        data_out = memory[addr];
    end
end

endmodule
