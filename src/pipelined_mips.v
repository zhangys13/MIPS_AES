module pipelined_mips(clk,rst);
input clk;
input rst;

wire [31:0] PC_4;
wire [31:0] PC_Branch;
wire Branch_Zero;
wire [31:0] mux2_PC;
wire RegDst_ID,JumpReg_ID,ALUSrc_ID,RegWrite_ID,MemRead_ID,MemWrite_ID,Branch_ID,ZeroExt_ID,bne_ID,jal_ID;

MUX2_32bit mux_Branch(
	.data0_in(PC_4),
	.data1_in(PC_Branch),
	.sel(Branch_Zero),
	.data_out(mux2_PC)
	);

wire [31:0] Jump_Addr;
wire [31:0] mux_DataRs;
wire JumpReg, Jump;
wire [31:0] mux3_PC;

MUX3_32bit mux_Jump(
	.data0_in(mux2_PC),
	.data1_in(Jump_Addr),
	.data2_in(mux_DataRs),
	.sel({JumpReg_ID,Jump}),
	.data_out(mux3_PC)
	);

wire stall;
wire [31:0] pc;
PC PC(
	.clk(clk),
	.rst(rst),
	.stall(stall),
	.pc_in(mux3_PC),
	.pc_out(pc)
	);
Adder Adder_PC(
	.data1_in(pc),
	.data2_in(32'd4),
	.data_out(PC_4)
	);

wire [31:0] instr_IF;
icache Instr_Memory(
	.addr(pc[10:2]),
	.instr(instr_IF)
	);
wire flush;
wire [31:0] PC_4_ID;
wire [31:0] instr_ID;
assign flush = Branch_Zero || Jump || JumpReg_ID;
IF_ID IF_ID(
	.clk(clk),
	.rst(rst),
	.PC_4_IF(PC_4),
	.instr_IF(instr_IF),
	.stall(stall),
	.flush(flush),
	.PC_4_ID(PC_4_ID),
	.instr_ID(instr_ID)
	);
wire [31:0] PC_8_ID;
Adder Adder_PC_8(
	.data1_in(PC_4_ID),
	.data2_in(32'd4),
	.data_out(PC_8_ID)
	);
assign Jump_Addr = {PC_4[31:28],instr_ID[25:0],2'b00};
wire [5:0] opcode = instr_ID[31:26];
wire [5:0] funct_ID = instr_ID[5:0];
wire RegDst,ALUSrc,RegWrite,MemRead,MemWrite,Branch,ZeroExt,bne,jal;
wire [1:0] MemtoReg;
wire [2:0] ALUOp;
control decode(
	.Op(opcode),
	.funct(funct_ID),
	.RegDst(RegDst),
	.Jump(Jump),
	.JumpReg(JumpReg),
	.ALUSrc(ALUSrc),
	.MemtoReg(MemtoReg),
	.RegWrite(RegWrite),
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	.Branch(Branch),
	.ZeroExt(ZeroExt),
	.ALUOp(ALUOp),
	.bne(bne),
	.jal(jal)
	);
//Jump need not stall

wire [1:0] MemtoReg_ID;
wire [2:0] ALUOp_ID;
mux2_15bit mux_control(
	.data0_in(15'b0),
	.data1_in({RegDst,JumpReg,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ZeroExt,ALUOp,bne,jal}),
	.stall(stall),
	.data_out		({RegDst_ID,JumpReg_ID,ALUSrc_ID,MemtoReg_ID,RegWrite_ID,MemRead_ID,MemWrite_ID,Branch_ID,ZeroExt_ID,ALUOp_ID,bne_ID,jal_ID})
	);
wire [4:0] RegRs_ID = instr_ID[25:21];
wire [4:0] RegRt_ID = instr_ID[20:16];
wire [4:0] RegRd_ID = instr_ID[15:11];
wire [31:0] Sign_Imm;
SignExt SignExt(
	.addr_in(instr_ID[15:0]),
	.addr_out(Sign_Imm)
	);
wire [31:0] Zero_Imm;
ZeroExt ZeroExt1(
	.addr_in(instr_ID[15:0]),
	.addr_out(Zero_Imm)
	);
wire [31:0] Imm_ID;
MUX2_32bit mux_Imm(
	.data0_in(Sign_Imm),
	.data1_in(Zero_Imm),
	.sel(ZeroExt),
	.data_out(Imm_ID)
	);

wire [31:0] Shift_Addr;
addr_shift shift(
	.addr_in(Sign_Imm),
	.addr_out(Shift_Addr)
	);
Adder Adder_PC_Branch(
	.data1_in(PC_4_ID),
	.data2_in(Shift_Addr),
	.data_out(PC_Branch)
	);

wire [4:0] RegRd_WB;
wire RegWrite_WB;
wire [31:0] mux_DataRd_WB;
wire [31:0] DataRs_ID;
wire [31:0] DataRt_ID;
Register_File Register_File(
	.clk(clk),
	.rst(rst),
	.RegWrite(RegWrite_WB),
	.Rs_addr(RegRs_ID),
	.Rt_addr(RegRt_ID),
	.Rd_addr(RegRd_WB),
	.Rd_data(mux_DataRd_WB),
	.Rs_data(DataRs_ID),
	.Rt_data(DataRt_ID)
	);
wire [31:0] ALUData_MEM;
wire [31:0] muxA_EQ,muxB_EQ;
wire [1:0] ForwardA_EQ,ForwardB_EQ;
MUX3_32bit MUX_Rs_EQ(    
	.data0_in(DataRs_ID),
	.data1_in(mux_DataRd_WB),
	.data2_in(ALUData_MEM),
	.sel(ForwardA_EQ),
	.data_out(muxA_EQ)
	);
MUX3_32bit MUX_Rt_EQ(
	.data0_in(DataRt_ID),
	.data1_in(mux_DataRd_WB),
	.data2_in(ALUData_MEM),
	.sel(ForwardB_EQ),
	.data_out(muxB_EQ)
	);
wire Branch_beq;
equal Branch_Equal(
	.data0_in(muxA_EQ),
	.data1_in(muxB_EQ),
	.result(Branch_beq)
	);
wire Branch_bne;
not_equal Branch_Not_Equal(
	.data0_in(muxA_EQ),
	.data1_in(muxB_EQ),
	.result(Branch_bne)
	);
wire Branch_Taken;
assign Branch_Taken = bne? Branch_bne : Branch_beq;

assign Branch_Zero = Branch_ID & Branch_Taken;

wire Forward_Rs,Forward_Rt;
wire [31:0] mux_DataRt;
MUX2_32bit mux_Data_Rs(
	.data0_in(DataRs_ID),
	.data1_in(mux_DataRd_WB),
	.sel(Forward_Rs),
	.data_out(mux_DataRs)
	);
MUX2_32bit mux_Data_Rt(
	.data0_in(DataRt_ID),
	.data1_in(mux_DataRd_WB),
	.sel(Forward_Rt),
	.data_out(mux_DataRt)
	);

wire RegWrite_EX,MemRead_EX,MemWrite_EX,ALUSrc_EX,RegDst_EX,jal_EX;
wire [1:0] MemtoReg_EX;
wire [2:0] ALUOp_EX;
wire [31:0] DataRs_EX,DataRt_EX,Imm_EX;
wire [4:0] RegRs_EX,RegRt_EX,RegRd_EX;
wire [31:0] PC_8_EX;
ID_EX ID_EX(
	.clk(clk),
	.rst(rst),
	.RegWrite_ID(RegWrite_ID),
	.MemtoReg_ID(MemtoReg_ID),
	.MemRead_ID(MemRead_ID),
	.MemWrite_ID(MemWrite_ID),
	.ALUSrc_ID(ALUSrc_ID),
	.ALUOp_ID(ALUOp_ID),
	.RegDst_ID(RegDst_ID),
	.DataRs_ID(mux_DataRs),
	.DataRt_ID(mux_DataRt),
	.Immediate_ID(Imm_ID),
	.RegRs_ID(RegRs_ID),
	.RegRt_ID(RegRt_ID),
	.RegRd_ID(RegRd_ID),
	.jal_ID(jal_ID),
	.PC_8_ID(PC_4_ID),
	.RegWrite_EX(RegWrite_EX),
	.MemtoReg_EX(MemtoReg_EX),
	.MemRead_EX(MemRead_EX),
	.MemWrite_EX(MemWrite_EX),
	.ALUSrc_EX(ALUSrc_EX),
	.ALUOp_EX(ALUOp_EX),
	.RegDst_EX(RegDst_EX),
	.DataRs_EX(DataRs_EX),
	.DataRt_EX(DataRt_EX),
	.Immediate_EX(Imm_EX),
	.RegRs_EX(RegRs_EX),
	.RegRt_EX(RegRt_EX),
	.RegRd_EX(RegRd_EX),
	.jal_EX(jal_EX),
	.PC_8_EX(PC_8_EX)
	);
wire [1:0] ForwardA_ALU,ForwardB_ALU;
wire [31:0] mux_Rs_ALU,mux_Rt_ALU,mux2_Rt_ALU;
MUX3_32bit MUX_Rs_ALU(    
	.data0_in(DataRs_EX),
	.data1_in(mux_DataRd_WB),
	.data2_in(ALUData_MEM),
	.sel(ForwardA_ALU),
	.data_out(mux_Rs_ALU)
	);

MUX3_32bit MUX_Rt_ALU(
	.data0_in(DataRt_EX),
 	.data1_in(mux_DataRd_WB),
	.data2_in(ALUData_MEM),
	.sel(ForwardB_ALU),
	.data_out(mux_Rt_ALU)
	);

MUX2_32bit mux2_Rt_ALUSrc(
	.data0_in(mux_Rt_ALU),
	.data1_in(Imm_EX),
	.sel(ALUSrc_EX),
	.data_out(mux2_Rt_ALU)
	);
wire [3:0] ALUCtrl;
wire [31:0] ALUData_EX;
wire Zero;
ALU ALU(
	.data0_in(mux_Rs_ALU),
	.data1_in(mux2_Rt_ALU),
	.data2_in(Imm_EX[10:6]),
	.ALUCtrl(ALUCtrl),
	.data_out(ALUData_EX),
	.Zero(Zero)
	);
ALU_Control ALU_Control(
	.ALUOp(ALUOp_EX),
	.funct(Imm_EX[5:0]),
	.ALUCtrl(ALUCtrl)
	);
wire [31:0] UpperImm_EX = {Imm_EX[15:0],16'b0};
wire [4:0] mux_RegRd_EX;
wire [4:0] mux_jal_EX;
MUX2_5bit mux2_RegDst(
	.data0_in(RegRt_EX),
	.data1_in(RegRd_EX),
	.sel(RegDst_EX),
	.data_out(mux_RegRd_EX)
	);

MUX2_5bit mux2_jal(
	.data0_in(mux_RegRd_EX),
	.data1_in(5'd31),
	.sel(jal_EX),
	.data_out(mux_jal_EX)
	);
wire RegWrite_MEM,MemRead_MEM,MemWrite_MEM;
wire [1:0] MemtoReg_MEM;
wire [31:0] UpperImm_MEM,MemWriteData_MEM;
wire [4:0] RegRd_MEM;
wire [31:0] MemData_MEM;
wire jal_MEM;
wire [31:0] PC_8_MEM;
wire [31:0] ALUData_MEM_befmux;
EX_MEM EX_MEM(
	.clk(clk),
	.rst(rst),
	.RegWrite_EX(RegWrite_EX),	
	.MemtoReg_EX(MemtoReg_EX),	
	.MemRead_EX(MemRead_EX),		
	.MemWrite_EX(MemWrite_EX),	
	.ALUData_EX(ALUData_EX),
	.UpperImm_EX(UpperImm_EX),
	.MemWriteData_EX(mux_Rt_ALU),
	.WBregister_EX(mux_jal_EX),
	.jal_EX(jal_EX),
	.PC_8_EX(PC_8_EX),
	.RegWrite_MEM(RegWrite_MEM),	
	.MemtoReg_MEM(MemtoReg_MEM),	
	.MemRead_MEM(MemRead_MEM),	
	.MemWrite_MEM(MemWrite_MEM),
	.ALUData_MEM(ALUData_MEM_befmux),
	.UpperImm_MEM(UpperImm_MEM),
	.MemWriteData_MEM(MemWriteData_MEM),
	.WBregister_MEM(RegRd_MEM),
	.jal_MEM(jal_MEM),
	.PC_8_MEM(PC_8_MEM)
);

MUX2_32bit mux_ALUData_MEM(
	.data0_in(ALUData_MEM_befmux),
	.data1_in(UpperImm_MEM),
	.sel(MemtoReg_MEM[1]),
	.data_out(ALUData_MEM)
	);


/*Data_Memory Data_Memory(
	.clk(clk),
	.addr(ALUData_MEM),
	.data_in(MemWriteData_MEM),
    	.MemRead(MemRead_MEM),
        .MemWrite(MemWrite_MEM),
        .data_out(MemData_MEM)
	);
*/
Data_Memory Data_Memory(
	.clk(clk),
	.reset(rst),
	.we(MemWrite_MEM),
	.re(MemRead_MEM),
	.addr(ALUData_MEM),
	.wdata(MemWriteData_MEM),
	.rdata(MemData_MEM)
	);
wire [1:0] MemtoReg_WB;
wire [31:0] MemData_WB,ALUData_WB,UpperImm_WB;
wire jal_WB;
wire [31:0] PC_8_WB;
MEM_WB MEM_WB(
	.clk(clk),
	.rst(rst),
	.RegWrite_MEM(RegWrite_MEM),	
	.MemtoReg_MEM(MemtoReg_MEM),	
	.MemData_MEM(MemData_MEM),
	.ALUData_MEM(ALUData_MEM),
	.UpperImm_MEM(UpperImm_MEM),
	.WBregister_MEM(RegRd_MEM),
	.jal_MEM(jal_MEM),
	.PC_8_MEM(PC_8_MEM),
	.RegWrite_WB(RegWrite_WB),	
	.MemtoReg_WB(MemtoReg_WB),	
	.MemData_WB(MemData_WB),
	.ALUData_WB(ALUData_WB),
	.UpperImm_WB(UpperImm_WB),
	.WBregister_WB(RegRd_WB),
	.jal_WB(jal_WB),
	.PC_8_WB(PC_8_WB)
);
wire [31:0] mux_DataRd_WB1;
MUX2_32bit mux_DataRd(
	.data0_in(ALUData_WB),
	.data1_in(MemData_WB),
	.sel(MemtoReg_WB[0]),
	.data_out(mux_DataRd_WB1)
	);
MUX2_32bit mux_jal_DataRd(
	.data0_in(mux_DataRd_WB1),
	.data1_in(PC_8_WB),
	.sel(jal_WB),
	.data_out(mux_DataRd_WB)
	);



Forwarding Forwarding(
    .IfIdRegRs(RegRs_ID),
    .IfIdRegRt(RegRt_ID),
    .Branch(Branch_ID),
    .JumpReg(JumpReg_ID),
    .IdExRegRs(RegRs_EX),
    .IdExRegRt(RegRt_EX),
    .ExMemRegWrite(RegWrite_MEM),
    .ExMemRegRd(RegRd_MEM),
    .MemWbRegWrite(RegWrite_WB),
    .MemWbRegRd(RegRd_WB),
    .ForwardA_ALU(ForwardA_ALU),	
    .ForwardB_ALU(ForwardB_ALU), 
    .ForwardA_EQ(ForwardA_EQ),
    .ForwardB_EQ(ForwardB_EQ),
    .Forward_Rs(Forward_Rs),
    .Forward_Rt(Forward_Rt)
);

Hazard_Detection Hazard_Detection(
    .IFIDRegRs(RegRs_ID),
    .IFIDRegRt(RegRt_ID),
    .IDEXRegDST(mux_jal_EX),
    .IDEXMemRead(MemRead_EX),
    .IDEXRegWrite(RegWrite_EX),
    .Branch(Branch),
    .Stall(stall),
    .clk(clk)
	);
endmodule
