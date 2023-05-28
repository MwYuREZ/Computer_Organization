//110550065
module Hazard_Detection(
    Op_ID,
    Rs_ID,
    Rt_ID,
    Rt_EX,
    MemRead_EX,
    PCSrc,
    PCWrite,
    IFIDWrite,
    IF_Flush,
    ID_Flush,
    EX_Flush
	);

input [6-1:0] Op_ID;
input [5-1:0] Rs_ID,Rt_ID;
input [5-1:0] Rt_EX;
input MemRead_EX;
input PCSrc;
output PCWrite,IFIDWrite,IF_Flush,ID_Flush,EX_Flush; 

reg PCWrite;
reg IFIDWrite;
reg IF_Flush;
reg ID_Flush;
reg EX_Flush;

always@(*) begin
    if(PCSrc==1)begin
        PCWrite<=1;
        IFIDWrite<=1;
        IF_Flush<=1;
        ID_Flush<=1;
        EX_Flush<=1;
    end
    else begin
        if(MemRead_EX==1&&(Rs_ID==Rt_EX||Rt_ID==Rt_EX&&Op_ID!=6'b001000))begin
            PCWrite<=0;
            IFIDWrite<=0;
            IF_Flush<=0;
            ID_Flush<=1;
            EX_Flush<=0;
        end
        else begin
            PCWrite<=1;
            IFIDWrite<=1;
            IF_Flush<=0;
            ID_Flush<=0;
            EX_Flush<=0;
        end
    end
end

endmodule
     




                    
                    