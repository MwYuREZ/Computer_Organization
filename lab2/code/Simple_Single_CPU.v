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
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire[32-1:0] pc_in,pc_out,add1_out,add2_out,instruction;
wire[32-1:0] RSdata_out,RTdata_out;
wire[32-1:0] signex_out;
wire[32-1:0] ALU_result;
wire[32-1:0] shift_out;
wire[32-1:0] MUX32_out;
wire[5-1:0] MUX5_out;
wire[4-1:0] ALUCtrl_out;
wire[3-1:0] ALUOp;
wire RegDst,RegWrite,ALUSrc,branch,zero;
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
        .select_i(RegDst),
        .data_o(MUX5_out)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(MUX5_out) ,  
        .RDdata_i(ALU_result)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RSdata_out) ,  
        .RTdata_o(RTdata_out)   
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instruction[6-1:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl_out) 
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(signex_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_out),
        .data1_i(signex_out),
        .select_i(ALUSrc),
        .data_o(MUX32_out)
        );	
		
ALU ALU(
        .src1_i(RSdata_out),
	    .src2_i(MUX32_out),
	    .ctrl_i(ALUCtrl_out),
	    .result_o(ALU_result),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(shift_out),     
	    .src2_i(add1_out),     
	    .sum_o(add2_out)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(signex_out),
        .data_o(shift_out)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(add1_out),
        .data1_i(add2_out),
        .select_i(zero&branch),
        .data_o(pc_in)
        );	

endmodule
		  


