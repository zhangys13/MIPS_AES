module MUX2_32bit(data0_in,data1_in,sel,data_out);

input [31:0] data0_in, data1_in;
input sel;
output [31:0] data_out;

assign data_out = (sel) ? data1_in : data0_in;

endmodule
