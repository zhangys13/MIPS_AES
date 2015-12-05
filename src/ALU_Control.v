module ALU_Control(ALUOp,funct,ALUCtrl);
input [2:0] ALUOp;
input [5:0] funct;
output [3:0] ALUCtrl;

reg [3:0] ALUCtrl;

always @(ALUOp or funct)
begin
case (ALUOp)
  3'b000:
	ALUCtrl = 4'b0010;   //add
  3'b001:
	ALUCtrl = 4'b0110;   //sub
  3'b010:
     case (funct)
	6'b100000:
	   ALUCtrl = 4'b0010; //add
	6'b100010:
	   ALUCtrl = 4'b0110; //sub
	6'b100100:
	   ALUCtrl = 4'b0000; //and
	6'b100101:
	   ALUCtrl = 4'b0001; //or
	6'b101010:
	   ALUCtrl = 4'b0111; //slt
	6'b100110:
	   ALUCtrl = 4'b0011; //xor
	6'b000000:
	   ALUCtrl = 4'b0100; //sll
	6'b000010:
	   ALUCtrl = 4'b0101; //srl
     endcase
   3'b011:
	ALUCtrl = 4'b0000;
   3'b100:
	ALUCtrl = 4'b0001;
   3'b101:
	ALUCtrl = 4'b0011;
endcase

end
endmodule
