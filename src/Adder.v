module Adder(data1_in,data2_in,data_out);
input [31:0] data1_in;
input [31:0] data2_in;
output [31:0] data_out;

assign data_out = data1_in + data2_in;

endmodule
