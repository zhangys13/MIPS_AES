module ALU(data0_in,data1_in,data2_in,ALUCtrl,data_out,Zero);

input	[31:0]	data0_in;
input	[31:0]	data1_in;
input [4:0] data2_in;
input	[3:0]	ALUCtrl;
output	[31:0]	data_out;
output	Zero;

reg [31:0] data_out;
wire Zero;
assign Zero = (data_out == 0);

always @(data0_in or data1_in or ALUCtrl or data2_in)
begin
  case (ALUCtrl)
	4'b0010:
		data_out = data0_in + data1_in;
	4'b0110:
		data_out = data0_in - data1_in;
	4'b0000:
		data_out = data0_in & data1_in;
	4'b0001:
		data_out = data0_in | data1_in;
	4'b0111:
		data_out = (data0_in < data1_in) ? 1 : 0;
	4'b0011:
		data_out = data0_in ^ data1_in;
	4'b0100:
		data_out = data1_in << data2_in;
	4'b0101:
		data_out = data1_in >> data2_in;
  endcase
	
end

endmodule
