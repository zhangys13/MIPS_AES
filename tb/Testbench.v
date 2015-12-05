module TestBench;

reg         clk;
reg         rst;
integer     i, outfile, counter;

always #10 clk = ~clk;    

pipelined_mips mips(
    .clk(clk),
    .rst(rst)
);
  
initial begin
    // Initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        mips.Instr_Memory.memory[i] = 32'b0;
    end
    
   
        
   
    
    // Load instructions into instruction memory
    $readmemh("../tb/instruction.txt", mips.Instr_Memory.memory);
    
    
    // Open output file
    outfile = $fopen("../tb/output.txt");
    
    
   // mips.Data_Memory.memory[22] = 32'h5;       
    
    counter = 0;
    clk = 0;
    rst = 0;
    
    #20
    rst = 1;
    
end


  
/*always@(posedge clk) begin
    if(counter == 600)    // stop after 60 cycles
        $stop;
        
    // print PC
    $fdisplay(outfile, "PC = %d", mips.PC.pc_out);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0= %d, R8= %d, R16= %d, R24= %d", mips.Register_File.Register[0], mips.Register_File.Register[8], mips.Register_File.Register[16], mips.Register_File.Register[24]);
    $fdisplay(outfile, "R1= %d, R9= %d, R17= %d, R25= %d", mips.Register_File.Register[1], mips.Register_File.Register[9] , mips.Register_File.Register[17], mips.Register_File.Register[25]);
    $fdisplay(outfile, "R2= %d, R10= %d, R18= %d, R26= %d", mips.Register_File.Register[2], mips.Register_File.Register[10], mips.Register_File.Register[18], mips.Register_File.Register[26]);
    $fdisplay(outfile, "R3= %d, R11= %d, R19= %d, R27= %d", mips.Register_File.Register[3], mips.Register_File.Register[11], mips.Register_File.Register[19], mips.Register_File.Register[27]);
    $fdisplay(outfile, "R4= %d, R12= %d, R20= %d, R28= %d", mips.Register_File.Register[4], mips.Register_File.Register[12], mips.Register_File.Register[20], mips.Register_File.Register[28]);
    $fdisplay(outfile, "R5= %d, R13= %d, R21= %d, R29= %d", mips.Register_File.Register[5], mips.Register_File.Register[13], mips.Register_File.Register[21], mips.Register_File.Register[29]);
    $fdisplay(outfile, "R6= %d, R14= %d, R22= %d, R30= %d", mips.Register_File.Register[6], mips.Register_File.Register[14], mips.Register_File.Register[22], mips.Register_File.Register[30]);
    $fdisplay(outfile, "R7= %d, R15= %d, R23= %d, R31= %d", mips.Register_File.Register[7], mips.Register_File.Register[15], mips.Register_File.Register[23], mips.Register_File.Register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 =%d", {mips.Data_Memory.memory[3] , mips.Data_Memory.memory[2] , mips.Data_Memory.memory[1] , mips.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 =%d", {mips.Data_Memory.memory[7] , mips.Data_Memory.memory[6] , mips.Data_Memory.memory[5] , mips.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 =%d", {mips.Data_Memory.memory[11], mips.Data_Memory.memory[10], mips.Data_Memory.memory[9] , mips.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c =%d", {mips.Data_Memory.memory[15], mips.Data_Memory.memory[14], mips.Data_Memory.memory[13], mips.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 =%d", {mips.Data_Memory.memory[19], mips.Data_Memory.memory[18], mips.Data_Memory.memory[17], mips.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 =%d", {mips.Data_Memory.memory[23], mips.Data_Memory.memory[22], mips.Data_Memory.memory[21], mips.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 =%d", {mips.Data_Memory.memory[27], mips.Data_Memory.memory[26], mips.Data_Memory.memory[25], mips.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c =%d", {mips.Data_Memory.memory[31], mips.Data_Memory.memory[30], mips.Data_Memory.memory[29], mips.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
   

    counter = counter + 1;
end
*/

  
endmodule
