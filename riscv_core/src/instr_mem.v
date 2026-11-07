module instr_mem (
    input  [31:0] addr,
    output reg [31:0] instr
);

always @(*) begin
    case (addr[31:2])
        30'd0: instr = 32'h00A00093; // addi x1, x0, 10
        30'd1: instr = 32'h00B00113; // addi x2, x0, 11
        30'd2: instr = 32'h002081B3; // add  x3, x1, x2
        default: instr = 32'h00000013; // NOP
    endcase
end

endmodule