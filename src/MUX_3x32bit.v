module MUX3_32bit(    
    data0_in,
    data1_in,
    data2_in,
    sel,
    data_out
);

input [31:0] data0_in, data1_in, data2_in;
input [1:0] sel;
output [31:0] data_out;

assign data_out = (sel[1]) ? data2_in : ((sel[0]) ? data1_in : data0_in);

endmodule
