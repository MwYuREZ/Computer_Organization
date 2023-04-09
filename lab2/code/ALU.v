//110550065
//Subject:     CO project 2 - ALU
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
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input signed [32-1:0]  src1_i;
input signed [32-1:0]  src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter
assign zero_o=(result_o==0);
//Main function
always@(ctrl_i,src1_i,src2_i) begin
    case(ctrl_i)
        4'b0000:begin//and
            result_o<=(src1_i&src2_i);
        end
        4'b0001:begin//or
            result_o<=(src1_i|src2_i);
        end
        4'b0010:begin//add
            result_o<=(src1_i+src2_i);
        end
        4'b0110:begin//sub
            result_o<=(src1_i-src2_i);
        end
        4'b0111:begin//slt
            result_o<=(src1_i<src2_i)?1:0;
        end
        4'b1100:begin//nor
            result_o<=~(src1_i|src2_i);
        end
        default:result_o<=0;
     endcase
end
endmodule





                    
                    