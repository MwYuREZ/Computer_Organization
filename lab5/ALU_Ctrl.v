//110550065
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@(ALUOp_i,funct_i) begin
    if(ALUOp_i==3'b100)begin//R-type
        case(funct_i)
            6'b100000:ALUCtrl_o<=4'b0010;//add
            6'b100010:ALUCtrl_o<=4'b0110;//sub
            6'b100100:ALUCtrl_o<=4'b0000;//and
            6'b100101:ALUCtrl_o<=4'b0001;//or
            6'b101010:ALUCtrl_o<=4'b0111;//slt
            //new
            6'b011000:ALUCtrl_o<=4'b0011;//mult
            endcase
        end
      else if(ALUOp_i==3'b001) ALUCtrl_o<=4'b0110;//beq:if(a-b<0)=>branch
      else if(ALUOp_i==3'b000) ALUCtrl_o<=4'b0010;//addi lw sw 
      else if(ALUOp_i==3'b010) ALUCtrl_o<=4'b0111;//slti 
end   
endmodule     





                    
                    