//110550065
`timescale 1ns / 1ps
// TA
module Pipe_CPU_1(
    clk_i,
    rst_i
);
    
/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk_i;
input rst_i;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

/**** IF stage ****/
wire [32-1:0] pc_in_IF;
wire [32-1:0] pc_out_IF;
wire [32-1:0] Add1_out_IF;
wire [32-1:0] instruction_IF;

/**** ID stage ****/
wire [32-1:0] Add1_out_ID;
wire [32-1:0] instruction_ID;
wire [32-1:0] ReadData1_ID,ReadData2_ID;
wire [32-1:0] signexout_ID;

wire PCWrite,IFIDWrite,IF_Flush,ID_Flush,EX_Flush;
wire RegWrite_ID;
wire [3-1:0] ALUOp_ID;
wire ALUSrc_ID;
wire RegDst_ID;
wire Branch_ID;
wire [2-1:0] BranchType_ID;
wire MemRead_ID;
wire MemWrite_ID;
wire MemtoReg_ID;
//wire PCSrc_ID;
/**** EX stage ****/
wire [32-1:0] Add1_out_EX;
wire [32-1:0] ReadData1_EX,ReadData2_EX;
wire [32-1:0] signexout_EX;
wire [5-1:0] instruction25_21_EX,instruction20_16_EX,instruction15_11_EX;

wire [32-1:0] sl2_out_EX;
wire [32-1:0] Add2_out_EX;
wire [32-1:0] ALUResult_EX;
wire [4-1:0] ALUCtrl_EX;
wire [32-1:0] MUX1_out_EX;
wire [5-1:0] MUX2_out_EX;
wire zero_EX;

wire [2-1:0] forwarda,forwardb;
wire [32-1:0] forwarda_data,forwardb_data;

wire RegWrite_EX;
wire [3-1:0] ALUOp_EX;//ex
wire ALUSrc_EX;//ex
wire RegDst_EX;//ex
wire Branch_EX;
wire [2-1:0] BranchType_EX;
wire MemRead_EX;
wire MemWrite_EX;
wire MemtoReg_EX;
// PCSrc_EX;
/**** MEM stage ****/
wire [32-1:0] Add2_out_MEM;
wire zero_MEM;
wire [32-1:0] ALUResult_MEM;
wire [32-1:0] ReadData2_MEM;
wire [5-1:0] MUX2_out_MEM;
wire [32-1:0] DM_out_MEM;

wire RegWrite_MEM;
wire Branch_MEM;//mem
wire [2-1:0] BranchType_MEM;
wire MemRead_MEM;//mem
wire MemWrite_MEM;//mem
wire MemtoReg_MEM;

/**** WB stage ****/
wire [32-1:0] DM_out_WB;
wire [32-1:0] ALUResult_WB;
wire [5-1:0] MUX2_out_WB;
wire [32-1:0] MUX3_out_WB;

wire RegWrite_WB;//wb
wire MemtoReg_WB;//wb


/*==================================================================*/
/*                              design                              */
/*==================================================================*/

//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux0( // Modify N, which is the total length of input/output
               .data0_i(Add1_out_IF),
               .data1_i(Add2_out_MEM),
               .select_i(Branch_MEM&BranchTResult),
               .data_o(pc_in_IF)
);

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_write(PCWrite),
    .pc_in_i(pc_in_IF),
    .pc_out_o(pc_out_IF)
);

Instruction_Memory IM(
    .addr_i(pc_out_IF),
    .instr_o(instruction_IF)
);
			
Adder Add_pc(
    .src1_i(pc_out_IF),
    .src2_i(32'd4),
    .sum_o(Add1_out_IF)
);
		
Pipe_Reg #(.size(64)) IF_ID( // Modify N, which is the total length of input/output N=32
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IF_Flush),
    .write(IFIDWrite),
    .data_i({Add1_out_IF,instruction_IF}),//32+32
    .data_o({Add1_out_ID,instruction_ID})
);


//Instantiate the components in ID stage
Hazard_Detection Detect(
    .Op_ID(instruction_ID[31:26]),
    .Rs_ID(instruction_ID[25:21]),
    .Rt_ID(instruction_ID[20:16]),
    .Rt_EX(instruction20_16_EX),
    .MemRead_EX(MemRead_EX),
    .PCSrc(Branch_MEM&BranchTResult),
    .PCWrite(PCWrite),
    .IFIDWrite(IFIDWrite),
    .IF_Flush(IF_Flush),
    .ID_Flush(ID_Flush),
    .EX_Flush(EX_Flush)
);

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(instruction_ID[25:21]),
    .RTaddr_i(instruction_ID[20:16]),
    .RDaddr_i(MUX2_out_WB),
    .RDdata_i(MUX3_out_WB),
    .RegWrite_i(RegWrite_WB),
    .RSdata_o(ReadData1_ID),
    .RTdata_o(ReadData2_ID)
);

Decoder Control(
    .instr_op_i(instruction_ID[31:26]),
    .funct_i(instruction_ID[5:0]),
	.RegWrite_o(RegWrite_ID),
	.ALU_op_o(ALUOp_ID),
	.ALUSrc_o(ALUSrc_ID),
	.RegDst_o(RegDst_ID),
	.Branch_o(Branch_ID),
	.Branch2_o(BranchType_ID),
	.MemRead_o(MemRead_ID),//
	.MemWrite_o(MemWrite_ID),//
	.MemtoReg_o(MemtoReg_ID)//
	//.Jump_o(PCSrc_ID)//
);

Sign_Extend SE(
    .data_i(instruction_ID[15:0]),
    .data_o(signexout_ID)
);

Pipe_Reg #(.size(155)) ID_EX( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(ID_Flush),
    .write(1'b1),
    .data_i({RegWrite_ID,ALUOp_ID,ALUSrc_ID,RegDst_ID,Branch_ID,BranchType_ID,MemRead_ID,MemWrite_ID,MemtoReg_ID,
              Add1_out_ID,ReadData1_ID,ReadData2_ID,signexout_ID,instruction_ID[25:21],instruction_ID[20:16],instruction_ID[15:11]}),
    .data_o({RegWrite_EX,ALUOp_EX,ALUSrc_EX,RegDst_EX,Branch_EX,BranchType_EX,MemRead_EX,MemWrite_EX,MemtoReg_EX,
              Add1_out_EX,ReadData1_EX,ReadData2_EX,signexout_EX,instruction25_21_EX,instruction20_16_EX,instruction15_11_EX})
    //control:12+32+32+32+32+5+5=150
);


//Instantiate the components in EX stage
MUX_3to1 #(.size(32)) Mux_FA(
        .data0_i(ReadData1_EX),
        .data1_i(ALUResult_MEM),
        .data2_i(MUX3_out_WB),
        .select_i(forwarda),
        .data_o(forwarda_data)
);

Shift_Left_Two_32 Shifter(
    .data_i(signexout_EX),
    .data_o(sl2_out_EX)
);

ALU ALU(
    .src1_i(forwarda_data),
	.src2_i(MUX1_out_EX),
	.ctrl_i(ALUCtrl_EX),
	.result_o(ALUResult_EX),
	.zero_o(zero_EX)
);
		
ALU_Ctrl ALU_Control(
    .funct_i(signexout_EX[5:0]),
    .ALUOp_i(ALUOp_EX),
    .ALUCtrl_o(ALUCtrl_EX)
);

MUX_3to1 #(.size(32)) Mux_FB(
        .data0_i(ReadData2_EX),
        .data1_i(ALUResult_MEM),
        .data2_i(MUX3_out_WB),
        .select_i(forwardb),
        .data_o(forwardb_data)
);

MUX_2to1 #(.size(32)) Mux1( // Modify N, which is the total length of input/output
      .data0_i(forwardb_data),
      .data1_i(signexout_EX),
      .select_i(ALUSrc_EX),
      .data_o(MUX1_out_EX)                
);
		
MUX_2to1 #(.size(5)) Mux2( // Modify N, which is the total length of input/output
       .data0_i(instruction20_16_EX),
       .data1_i(instruction15_11_EX),
       .select_i(RegDst_EX),
       .data_o(MUX2_out_EX)
);

Adder Add_pc_branch(
    .src1_i(Add1_out_EX),
	.src2_i(sl2_out_EX),
	.sum_o(Add2_out_EX)    
);

Forwarding_Unit FU(
        .Rs(instruction25_21_EX),
        .Rt(instruction20_16_EX),
        .Rd_MEM(MUX2_out_MEM),
        .Rd_WB(MUX2_out_WB),
        .RegWrite_MEM(RegWrite_MEM),
        .RegWrite_WB(RegWrite_WB),
        .ForwardA(forwarda),
        .ForwardB(forwardb)
);

Pipe_Reg #(.size(109)) EX_MEM( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(EX_Flush),
    .write(1'b1),
    .data_i({RegWrite_EX,Branch_EX,BranchType_EX,MemRead_EX,MemWrite_EX,MemtoReg_EX,
             Add2_out_EX,zero_EX,ALUResult_EX,forwardb_data,MUX2_out_EX}),
    .data_o({RegWrite_MEM,Branch_MEM,BranchType_MEM,MemRead_MEM,MemWrite_MEM,MemtoReg_MEM,
             Add2_out_MEM,zero_MEM,ALUResult_MEM,ReadData2_MEM,MUX2_out_MEM})    
    //control:7+32+1+32+32+5=109
);


//Instantiate the components in MEM stage
MUX_4to1 #(.size(1)) Branch_Type(
        .data0_i(zero_MEM),
        .data1_i(~zero_MEM),
        .data2_i(~ALUResult_MEM[31]),
        .data3_i(~(zero_MEM|ALUResult_MEM[31])),
        .select_i(BranchType_MEM),
        .data_o(BranchTResult)
);

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(ALUResult_MEM),
    .data_i(ReadData2_MEM),
    .MemRead_i(MemRead_MEM),
    .MemWrite_i(MemWrite_MEM),
    .data_o(DM_out_MEM)        
);

Pipe_Reg #(.size(71)) MEM_WB( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({RegWrite_MEM,MemtoReg_MEM,
             DM_out_MEM,ALUResult_MEM,MUX2_out_MEM}),
    .data_o({RegWrite_WB,MemtoReg_WB,
             DM_out_WB,ALUResult_WB,MUX2_out_WB}) 
    //control:2+32+32+5=71       
);


//Instantiate the components in WB stage

MUX_2to1 #(.size(32)) Mux3( // Modify N, which is the total length of input/output
               .data0_i(ALUResult_WB),
               .data1_i(DM_out_WB),
               .select_i(MemtoReg_WB),
               .data_o(MUX3_out_WB)
);


endmodule