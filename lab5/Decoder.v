//110550065
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    funct_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemRead_o,//
	MemWrite_o,//
	MemtoReg_o,//
	//Jump_o//
	Branch2_o//
	);
     
//I/O ports
input  [6-1:0] instr_op_i,funct_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output  ALUSrc_o;
output  RegDst_o;
output  Branch_o;
output         MemRead_o;//
output         MemWrite_o;//
output  MemtoReg_o;//
//output [2-1:0] Jump_o;//
output [2-1:0]    Branch2_o;//
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg     ALUSrc_o;
reg            RegWrite_o;
reg     RegDst_o;
reg     Branch_o;
reg            MemRead_o;//
reg            MemWrite_o;//
reg     MemtoReg_o;//
//reg    [2-1:0] Jump_o;//
reg    [2-1:0]     Branch2_o;//          
//Parameter


//Main function
always@(*) begin
    case(instr_op_i)
        6'b000000:begin//R-type
            ALU_op_o<=3'b100;
            ALUSrc_o<=1'b0;
            RegWrite_o<=1'b1;
            RegDst_o<=1'b1;
            Branch_o<=1'b0;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b00;
            //else Jump_o<=2'b01;
        end
        6'b000100:begin//beq
            ALU_op_o<=3'b001;
            ALUSrc_o<=1'b0;
            RegWrite_o<=1'b0;
            RegDst_o<=1'b0;
            Branch_o<=1'b1;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b00;
        end
        6'b001000:begin//addi
            ALU_op_o<=3'b000;
            ALUSrc_o<=1'b1;
            RegWrite_o<=1'b1;
            RegDst_o<=1'b0;
            Branch_o<=1'b0;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b00;
            //Jump_o<=2'b01;
        end
        6'b001010:begin//slti
            ALU_op_o<=3'b010;
            ALUSrc_o<=1'b1;
            RegWrite_o<=1'b1;
            RegDst_o<=1'b0;
            Branch_o<=1'b0;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b00;
            //Jump_o<=2'b01;
        end
        6'b100011:begin//lw
            ALU_op_o<=3'b000;
            ALUSrc_o<=1'b1;
            RegWrite_o<=1'b1;
            RegDst_o<=1'b0;
            Branch_o<=1'b0;
            MemRead_o<=1'b1;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b1;
            Branch2_o<=2'b00;
            //Jump_o<=2'b01;
        end
        6'b101011:begin//sw
            ALU_op_o<=3'b000;
            ALUSrc_o<=1'b1;
            RegWrite_o<=1'b0;
            RegDst_o<=1'b0;
            Branch_o<=1'b0;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b1;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b00;
            //Jump_o<=2'b01;
        end
        6'b000101:begin//bne
            ALU_op_o<=3'b001;
            ALUSrc_o<=1'b0;
            RegWrite_o<=1'b0;
            RegDst_o<=1'b0;
            Branch_o<=1'b1;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b01;
        end
        6'b000001:begin//bge
            ALU_op_o<=3'b001;
            ALUSrc_o<=1'b0;
            RegWrite_o<=1'b0;
            RegDst_o<=1'b0;
            Branch_o<=1'b1;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b10;
        end
        6'b000111:begin//bgt
            ALU_op_o<=3'b001;
            ALUSrc_o<=1'b0;
            RegWrite_o<=1'b0;
            RegDst_o<=1'b0;
            Branch_o<=1'b1;
            MemRead_o<=1'b0;
            MemWrite_o<=1'b0;
            MemtoReg_o<=1'b0;
            Branch2_o<=2'b11;
        end                
    endcase
end
endmodule





                    
                    