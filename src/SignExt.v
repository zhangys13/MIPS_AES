module SignExt(addr_in,addr_out);
input [15:0] addr_in;
output [31:0] addr_out;

assign addr_out = {{16{addr_in[15]}},addr_in};

endmodule
