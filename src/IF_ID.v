module IF_ID(clk,rst,PC_4_IF,instr_IF,stall,flush,
PC_4_ID,instr_ID);
input clk;
input rst;
input [31:0] PC_4_IF;
input [31:0] instr_IF;
input stall;
input flush;
output [31:0] PC_4_ID;
output [31:0] instr_ID;

reg [31:0] PC_4_ID;
reg [31:0] instr_ID;

always @(posedge clk or negedge rst)
begin
  if(~rst)
    begin
	PC_4_ID <= 32'b0;
	instr_ID <= 32'b0;
    end
  else if(stall)
    begin
	PC_4_ID <= PC_4_ID;
	instr_ID <= instr_ID;
    end
  else if(flush)
    begin
	PC_4_ID <= 32'b0;
	instr_ID <= 32'b0;
    end
  else
    begin
	PC_4_ID <= PC_4_IF;
	instr_ID <= instr_IF;
    end
end
endmodule
