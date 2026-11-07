module reg_file(input clk,we,input[4:0] waddr,input[31:0] wdata,input[4:0] raddr1,raddr2,output[31:0] rdata1,rdata2);
reg [31:0] regs[0:31];
always@(posedge clk)
begin
    if(we && waddr!=5'b0)
    regs[waddr]<=wdata;
end
assign rdata1=(raddr1==5'b0)?32'b0:regs[raddr1];
assign rdata2=(raddr2==5'b0)?32'b0:regs[raddr2];
endmodule    
