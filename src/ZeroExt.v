module ZeroExt(addr_in,addr_out);
input [15:0] addr_in;
output [31:0] addr_out;

assign addr_out = {16'b0,addr_in};

endmodule
