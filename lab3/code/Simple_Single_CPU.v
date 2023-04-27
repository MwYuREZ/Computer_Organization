//110550065
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_in,pc_out,add1_out,add2_out,instruction;
wire [32-1:0] ReadData1,ReadData2;
wire [32-1:0] RDdata;
wire [32-1:0] signex;
wire [32-1:0] ALUIn,ALUResult;
wire [32-1:0] DataMemory_out;
wire [32-1:0] SH1,SH2;
wire [32-1:0] branch_out;
wire [5-1:0] RDaddr;
wire [4-1:0] ALUCtrl;
wire [3-1:0] ALUOp;
wire [2-1:0] RegDst,ALUSrc,branch,MemToReg,jump;
wire RegWrite,MemRead,MemWrite,zero;
wire branch_bit;
assign branch_bit=branch[0];
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),     
	    .sum_o(add1_out)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instruction)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .data2_i(5'b11111),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(RDaddr) ,  
        .RDdata_i(RDdata)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(ReadData1) ,  
        .RTdata_o(ReadData2)   
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]),
        .funct_i(instruction[5:0]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch),
		.MemRead_o(MemRead),
		.MemWrite_o(MemWrite),
		.MemtoReg_o(MemToReg),
		.Jump_o(jump)   
	    );

ALU_Ctrl AC(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(signex)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(ReadData2),
        .data1_i(signex),
        .data2_i(32'b0),//never
        .select_i(ALUSrc),
        .data_o(ALUIn)
        );	
		
ALU ALU(
        .src1_i(ReadData1),
	    .src2_i(ALUIn),
	    .ctrl_i(ALUCtrl),
	    .result_o(ALUResult),
		.zero_o(zero)
	    );
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALUResult),
	.data_i(ReadData2),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(DataMemory_out)
	);
	
Adder Adder2(
        .src1_i(add1_out),     
	    .src2_i(SH2),     
	    .sum_o(add2_out)      
	    );
		
Shift_Left_Two_32 Shifter1(
        .data_i(instruction),
        .data_o(SH1)
        );         		

Shift_Left_Two_32 Shifter2(
        .data_i(signex),
        .data_o(SH2)
        ); 

MUX_2to1 #(.size(32)) Mux_MemToReg(
        .data0_i(ALUResult),
        .data1_i(DataMemory_out),
        .data2_i(add1_out),
        .select_i(MemToReg),
        .data_o(RDdata)
        );	
        
MUX_2to1 #(.size(32)) Mux_branch(
        .data0_i(add1_out),
        .data1_i(add2_out),
        .data2_i(32'b0),//never
        .select_i({1'b0,branch_bit&&zero}),
        .data_o(branch_out)
        );	
                         			
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i({add1_out[31:28],SH1[27:0]}),
        .data1_i(branch_out),
        .data2_i(ReadData1),
        .select_i(jump),
        .data_o(pc_in)
        );	

endmodule
		  


