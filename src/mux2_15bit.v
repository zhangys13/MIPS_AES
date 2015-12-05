module mux2_15bit(data0_in,data1_in,stall,data_out);
input [14:0] data0_in;
input [14:0] data1_in;
input stall;
output [14:0] data_out;

assign data_out = stall ? data0_in : data1_in;

endmodule
