module MEM_WB(
	clk,
	rst,
	RegWrite_MEM,	
	MemtoReg_MEM,	
	MemData_MEM,
	ALUData_MEM,
	UpperImm_MEM,
	WBregister_MEM,
	jal_MEM,
	PC_8_MEM,
	RegWrite_WB,	
	MemtoReg_WB,	
	MemData_WB,
	ALUData_WB,
	UpperImm_WB,
	WBregister_WB,
	jal_WB,
	PC_8_WB
);

input clk;
input rst;
input RegWrite_MEM;
input [1:0] MemtoReg_MEM;
input [31:0] MemData_MEM;
input [31:0] ALUData_MEM;
input [31:0] UpperImm_MEM;
input [4:0] WBregister_MEM;
input jal_MEM;
input [31:0] PC_8_MEM;

output RegWrite_WB;
output [1:0] MemtoReg_WB;
output [31:0] MemData_WB;
output [31:0] ALUData_WB;
output [31:0] UpperImm_WB;
output [4:0] WBregister_WB;
output jal_WB;
output [31:0] PC_8_WB;

reg RegWrite_WB;
reg [1:0] MemtoReg_WB;
reg [31:0] MemData_WB;
reg [31:0] UpperImm_WB;
reg [31:0] ALUData_WB;
reg [4:0] WBregister_WB;
reg jal_WB;
reg [31:0] PC_8_WB;

always @(posedge clk or negedge rst) 
begin
  if(~rst) 
  begin
	RegWrite_WB <= 1'b0;
	MemtoReg_WB <= 2'b0;	
	MemData_WB <= 32'b0;
	ALUData_WB <= 32'b0;
	UpperImm_WB <= 32'b0;
	WBregister_WB <= 5'b0;
	jal_WB <= 1'b0;
	PC_8_WB <= 32'b0;
  end
  else 
  begin
	RegWrite_WB <= RegWrite_MEM;
	MemtoReg_WB <= MemtoReg_MEM;	
	MemData_WB <= MemData_MEM;
	ALUData_WB <= ALUData_MEM;
	UpperImm_WB <= UpperImm_MEM;
	WBregister_WB <= WBregister_MEM;
	jal_WB <= jal_MEM;	
	PC_8_WB <= PC_8_MEM;
  end
end

endmodule
