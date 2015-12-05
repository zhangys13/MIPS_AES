
module Data_Memory1(
    clk,
    addr,
    data_in,
    MemRead,
    MemWrite,
    data_out
);

input           clk;
input   [31:0]  addr;
input   [31:0]  data_in;
input           MemRead;
input           MemWrite;
output  [31:0]  data_out;

// Data memory is byte-addressable, data are byte-aligned
// Data memory with 32 Bytes
// Data address range: 0x00 ~ 0x1F
parameter MEM_SIZE=256;
reg	    [7:0]   memory  [0:MEM_SIZE-1];

// Write Data      
always @(posedge clk)
begin
    if (MemWrite)
    begin
        memory[addr+3] <= data_in[31:24];
        memory[addr+2] <= data_in[23:16];
        memory[addr+1] <= data_in[15:8];
        memory[addr]   <= data_in[7:0];
    end
end
   
assign  data_out = (MemRead) ? {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]} : 32'b0;

endmodule
