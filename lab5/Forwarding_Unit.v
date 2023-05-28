//110550065

module Forwarding_Unit(
       Rs,
       Rt,
       Rd_MEM,
       Rd_WB,
       RegWrite_MEM,
       RegWrite_WB,
       ForwardA,
       ForwardB
	);
     
input [5-1:0] Rs;
input [5-1:0] Rt;
input [5-1:0] Rd_MEM;
input [5-1:0] Rd_WB;
input RegWrite_MEM,RegWrite_WB;
output [2-1:0] ForwardA,ForwardB;

reg [2-1:0] ForwardA,ForwardB;

always@(*) begin
    //A-Rs
    if(RegWrite_MEM==1'b1&&(Rd_MEM!=0)&&(Rd_MEM==Rs))
        ForwardA<=2'b01;//EX hazard
    else if (RegWrite_WB==1'b1&&Rd_WB!=0&&Rd_WB==Rs)
        ForwardA<=2'b10;//MEM hazard
    else 
        ForwardA<=2'b00;
        
    //B-Rt
    if(RegWrite_MEM==1'b1&&(Rd_MEM!=0)&&(Rd_MEM==Rt))
        ForwardB<=2'b01;
    else if (RegWrite_WB==1'b1&&Rd_WB!=0&&Rd_WB==Rt)
        ForwardB<=2'b10;
    else 
        ForwardB<=2'b00;    

end
endmodule