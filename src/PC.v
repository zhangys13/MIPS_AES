module PC(clk,rst,stall,pc_in,pc_out);
input clk;
input rst;
input stall;
input [31:0] pc_in;
output [31:0] pc_out;
reg [31:0] pc_out;

always @(posedge clk or negedge rst)
begin
  if(~rst)
  begin
      pc_out <= 32'b0;
  end
  else 
  begin
      if(stall) //hazard stall occur
      begin
      pc_out <= pc_out;
      end
      else      //normal executing
      begin
      pc_out <= pc_in;
      end
  end
end

endmodule
    

