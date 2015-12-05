module control(Op,funct,RegDst,Jump,JumpReg,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,
Branch,ZeroExt,ALUOp,bne,jal);
input [5:0] Op,funct;
output RegDst,Jump,JumpReg,ALUSrc,RegWrite,MemRead,MemWrite,Branch,ZeroExt,bne,jal;
output [2:0] ALUOp;
output [1:0] MemtoReg;
wire RegDst,Jump,JumpReg,ALUSrc,RegWrite,MemRead,MemWrite,Branch,ZeroExt,bne,jal;
wire [2:0] ALUOp;
wire [1:0] MemtoReg;

reg [15:0] temp; 
assign {RegDst,Jump,JumpReg,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ZeroExt,ALUOp,bne,jal} = temp;

always @(Op or funct)
begin
  case(Op)
	6'b000000:   //R
	  if(funct==6'b001000) //jr
		temp = 16'b0010000000000000;
	  else
		temp = 16'b1000001000001000;
	6'b100011:   //lw
	  temp = 16'b0001011100000000;
	6'b101011:   //sw
	  temp = 16'b0001000010000000;
	6'b000100:   //branch
	  temp = 16'b0000000001000100;
	6'b001000:  //addi
	  temp = 16'b0001001000000000;
	6'b001100:   //andi
	  temp = 16'b0001001000101100;
	6'b001101:   //ori
	  temp = 16'b0001001000110000;
	6'b001110:  //xori
	  temp = 16'b0001001000110100;
	6'b001111:  //lui
	  temp = 16'b0000101000000000;
	6'b000101:  //bne
	  temp = 16'b0000000001000110;
	6'b000010:  //j
	  temp = 16'b0100000000000000;
	6'b000011: //jal
	  temp = 16'b0100001000000001;
  endcase
end

endmodule
