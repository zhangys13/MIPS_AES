module icache(addr,instr);
input [8:0] addr;
output [31:0] instr;

parameter MEM_SIZE = 512;
reg [31:0] memory [0:MEM_SIZE-1];

assign instr = memory[addr];

endmodule
