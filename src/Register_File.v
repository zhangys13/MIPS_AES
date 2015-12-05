module Register_File(clk,rst,RegWrite,Rs_addr,Rt_addr,
Rd_addr,Rd_data,Rs_data,Rt_data);
input clk;
input rst;
input RegWrite;
input [4:0] Rs_addr;
input [4:0] Rt_addr;
input [4:0] Rd_addr;
input [31:0] Rd_data;
output [31:0] Rs_data;
output [31:0] Rt_data;

reg [31:0] Register [0:31];

assign Rs_data = Register[Rs_addr];
assign Rt_data = Register[Rt_addr];

always @(posedge clk or negedge rst)
begin
  if(~rst)
    begin
      Register[0] <= 32'd0;
      Register[1] <= 32'd0;
      Register[2] <= 32'd0;
      Register[3] <= 32'd0;
      Register[4] <= 32'd0;
      Register[5] <= 32'd0;
      Register[6] <= 32'd0;
      Register[7] <= 32'd0;
      Register[8] <= 32'd0;
      Register[9] <= 32'd0;
      Register[10] <= 32'd0;
      Register[11] <= 32'd0;
      Register[12] <= 32'd0;
      Register[13] <= 32'd0;
      Register[14] <= 32'd0;
      Register[15] <= 32'd0;
      Register[16] <= 32'd0;
      Register[17] <= 32'd0;
      Register[18] <= 32'd0;
      Register[19] <= 32'd0;
      Register[20] <= 32'd0;
      Register[21] <= 32'd0;
      Register[22] <= 32'd0;
      Register[23] <= 32'd0;
      Register[24] <= 32'b0;
      Register[25] <= 32'b0;  
      Register[26] <= 32'b0;
      Register[27] <= 32'b0;
      Register[28] <= 32'b0;
      Register[29] <= 32'b0;  
      Register[30] <= 32'b0;
      Register[31] <= 32'b0;
    end
  else
    begin
	if(RegWrite)
      Register[Rd_addr] <= Rd_data;
    end
end
endmodule

      
  
