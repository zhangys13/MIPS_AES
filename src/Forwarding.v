module Forwarding(
    IfIdRegRs,
    IfIdRegRt,
    Branch,
    JumpReg,
    IdExRegRs,
    IdExRegRt,
    ExMemRegWrite,
    ExMemRegRd,
    MemWbRegWrite,
    MemWbRegRd,
    ForwardA_ALU,	
    ForwardB_ALU, 
    ForwardA_EQ,
    ForwardB_EQ,
    Forward_Rs,
    Forward_Rt
);

input [4:0] IdExRegRs, IdExRegRt, ExMemRegRd, MemWbRegRd, IfIdRegRs, IfIdRegRt; 
input ExMemRegWrite,  MemWbRegWrite, Branch,JumpReg;
output [1:0] ForwardA_ALU, ForwardB_ALU, ForwardA_EQ, ForwardB_EQ;
output Forward_Rs,Forward_Rt;
reg [1:0] ForwardA_ALU, ForwardB_ALU, ForwardA_EQ, ForwardB_EQ;
reg Forward_Rs,Forward_Rt;


always @ (IdExRegRs or IdExRegRt or ExMemRegRd or MemWbRegRd or IfIdRegRs or IfIdRegRt or ExMemRegWrite or MemWbRegWrite or Branch or JumpReg) begin

if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IdExRegRs)) 
    ForwardA_ALU <= 2'b10;
else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IdExRegRs))
    ForwardA_ALU <= 2'b01;
  else
    ForwardA_ALU <= 2'b00;
    
if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IdExRegRt))
    ForwardB_ALU <= 2'b10;
else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IdExRegRt))
    ForwardB_ALU <= 2'b01;
  else
    ForwardB_ALU <= 2'b00;


if (Branch) begin
  if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IfIdRegRs)) 
    ForwardA_EQ <= 2'b10;
  else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IfIdRegRs))
    ForwardA_EQ <= 2'b01;
  else
    ForwardA_EQ <= 2'b00;
    
  if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IfIdRegRt))
    ForwardB_EQ <= 2'b10;
  else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IfIdRegRt))
    ForwardB_EQ <= 2'b01;
  else
    ForwardB_EQ <= 2'b00;
    
  end
if (JumpReg) begin
  if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IfIdRegRs)) 
      ForwardA_EQ <= 2'b10;
    else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IfIdRegRs))
      ForwardA_EQ <= 2'b01;
    else
      ForwardA_EQ <= 2'b00;
end
if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IfIdRegRs))
	Forward_Rs <= 1'b1;
else Forward_Rs <= 1'b0;

if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IfIdRegRt))
	Forward_Rt <= 1'b1;
else Forward_Rt <= 1'b0;
	

end


endmodule
