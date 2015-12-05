module EX_MEM(
	clk,
	rst,
	RegWrite_EX,	// WB
	MemtoReg_EX,	// WB
	MemRead_EX,		// M
	MemWrite_EX,	// M
	ALUData_EX,
	UpperImm_EX,
	MemWriteData_EX,
	WBregister_EX,
	jal_EX,
	PC_8_EX,
	RegWrite_MEM,	// WB
	MemtoReg_MEM,	// WB
	MemRead_MEM,	// M
	MemWrite_MEM,
	ALUData_MEM,
	UpperImm_MEM,
	MemWriteData_MEM,
	WBregister_MEM,
	jal_MEM,
	PC_8_MEM
);

input clk;
input rst;
input RegWrite_EX;
input [1:0] MemtoReg_EX;
input MemRead_EX;
input MemWrite_EX;
input [31:0] ALUData_EX;
input [31:0] UpperImm_EX;
input [31:0] MemWriteData_EX;
input [4:0] WBregister_EX;
input jal_EX;
input [31:0] PC_8_EX;

output RegWrite_MEM;
output [1:0] MemtoReg_MEM;
output MemRead_MEM;
output MemWrite_MEM;
output [31:0] ALUData_MEM;
output [31:0] UpperImm_MEM;
output [31:0] MemWriteData_MEM;
output [4:0] WBregister_MEM;
output jal_MEM;
output [31:0] PC_8_MEM;

reg RegWrite_MEM;
reg [1:0] MemtoReg_MEM;
reg MemRead_MEM;
reg MemWrite_MEM;
reg [31:0] ALUData_MEM;
reg [31:0] UpperImm_MEM;
reg [31:0] MemWriteData_MEM;
reg [4:0] WBregister_MEM;
reg jal_MEM;
reg [31:0] PC_8_MEM;
always @(posedge clk or negedge rst) 
begin
  if(~rst) 
  begin
     RegWrite_MEM <= 1'b0;
     MemtoReg_MEM <= 2'b0;
     MemRead_MEM <= 1'b0;
     MemWrite_MEM <= 1'b0;
     ALUData_MEM <= 32'b0;
     UpperImm_MEM <= 32'b0;
     MemWriteData_MEM <= 32'b0;
     WBregister_MEM <= 5'b0;	
     jal_MEM <= 1'b0;	
     PC_8_MEM <= 32'b0;
  end
  else 
  begin
     RegWrite_MEM <= RegWrite_EX;
     MemtoReg_MEM <= MemtoReg_EX;
     MemRead_MEM <= MemRead_EX;
     MemWrite_MEM <= MemWrite_EX;
     ALUData_MEM <= ALUData_EX;
     UpperImm_MEM <= UpperImm_EX;
     MemWriteData_MEM <= MemWriteData_EX;
     WBregister_MEM <= WBregister_EX;	
     jal_MEM <= jal_EX;
     PC_8_MEM <= PC_8_EX;
  end

end

endmodule
