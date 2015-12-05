module ID_EX (
	clk,
	rst,
	RegWrite_ID,
	MemtoReg_ID,
	MemRead_ID,
	MemWrite_ID,
	ALUSrc_ID,
	ALUOp_ID,
	RegDst_ID,
	DataRs_ID,
	DataRt_ID,
	Immediate_ID,
	RegRs_ID,
	RegRt_ID,
	RegRd_ID,
	jal_ID,
	PC_8_ID,
	RegWrite_EX,
	MemtoReg_EX,
	MemRead_EX,
	MemWrite_EX,
	ALUSrc_EX,
	ALUOp_EX,
	RegDst_EX,
	DataRs_EX,
	DataRt_EX,
	Immediate_EX,
	RegRs_EX,
	RegRt_EX,
	RegRd_EX,
	jal_EX,
	PC_8_EX
);

input clk;
input rst;
input RegWrite_ID;
input [1:0] MemtoReg_ID;
input MemRead_ID;
input MemWrite_ID;
input ALUSrc_ID;
input [2:0] ALUOp_ID;
input RegDst_ID;
input [31:0] DataRs_ID;
input [31:0] DataRt_ID;
input [31:0] Immediate_ID;
input [4:0] RegRs_ID;
input [4:0] RegRt_ID;
input [4:0] RegRd_ID;
input jal_ID;
input [31:0] PC_8_ID;
output RegWrite_EX;
output [1:0] MemtoReg_EX;
output MemRead_EX;
output MemWrite_EX;
output ALUSrc_EX;
output [2:0] ALUOp_EX;
output RegDst_EX;
output [31:0] DataRs_EX;
output [31:0] DataRt_EX;
output [31:0] Immediate_EX;
output [4:0] RegRs_EX;
output [4:0] RegRt_EX;
output [4:0] RegRd_EX;
output jal_EX;
output [31:0] PC_8_EX;

reg RegWrite_EX;
reg [1:0] MemtoReg_EX;
reg MemRead_EX;
reg MemWrite_EX;
reg ALUSrc_EX;
reg [2:0] ALUOp_EX;
reg RegDst_EX;
reg [31:0] DataRs_EX;
reg [31:0] DataRt_EX;
reg [31:0] Immediate_EX;
reg [4:0] RegRs_EX;
reg [4:0] RegRt_EX;
reg [4:0] RegRd_EX;
reg jal_EX;
reg [31:0] PC_8_EX;
always @(posedge clk or negedge rst) 
begin
  if(~rst) 
  begin
    RegWrite_EX	<= 1'b0;
    MemtoReg_EX <= 2'b0;
    MemRead_EX <= 1'b0;
    MemWrite_EX	<= 1'b0;
    ALUSrc_EX <= 1'b0;
    ALUOp_EX <= 3'b0;
    RegDst_EX <= 1'b0;
    DataRs_EX <= 32'b0;
    DataRt_EX <= 32'b0;
    Immediate_EX <= 32'b0;
    RegRs_EX <= 5'b0;
    RegRt_EX <= 5'b0;
    RegRd_EX <= 5'b0;
    jal_EX <= 1'b0;
    PC_8_EX <= 32'b0;
  end
  else 
  begin
    RegWrite_EX	<= RegWrite_ID;
    MemtoReg_EX	<= MemtoReg_ID;
    MemRead_EX <= MemRead_ID;
    MemWrite_EX	<= MemWrite_ID;
    ALUSrc_EX <= ALUSrc_ID;
    ALUOp_EX <= ALUOp_ID;
    RegDst_EX <= RegDst_ID;
    DataRs_EX <= DataRs_ID;
    DataRt_EX <= DataRt_ID;
    Immediate_EX <= Immediate_ID;
    RegRs_EX <= RegRs_ID;
    RegRt_EX <= RegRt_ID;
    RegRd_EX <= RegRd_ID;	
    jal_EX <= jal_ID;	
    PC_8_EX <= PC_8_ID;
  end
end

endmodule
