module not_equal(data0_in,data1_in,result);

input [31:0] data0_in, data1_in;
output result;

assign result = (data0_in != data1_in) ? 1 : 0 ;

endmodule
