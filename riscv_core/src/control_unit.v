module control_unit (
    input  [6:0] opcode,
    output reg   reg_write,
    output reg   mem_read,
    output reg   mem_write,
    output reg   mem_to_reg,
    output reg   alu_src,
    output reg   branch,
    output reg   jump,
    output reg [3:0] alu_op
);

parameter OP_RTYPE  = 7'b0110011;
parameter OP_ITYPE  = 7'b0010011;
parameter OP_LOAD   = 7'b0000011;
parameter OP_STORE  = 7'b0100011;
parameter OP_BRANCH = 7'b1100011;
parameter OP_JAL    = 7'b1101111;

always @(*) begin
    reg_write  = 1'b0;
    mem_read   = 1'b0;
    mem_write  = 1'b0;
    mem_to_reg = 1'b0;
    alu_src    = 1'b0;
    branch     = 1'b0;
    jump       = 1'b0;
    alu_op     = 4'b0000;

    case (opcode)
        OP_RTYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
        end
        OP_ITYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 4'b0000;
        end
        OP_LOAD: begin
            reg_write  = 1'b1;
            mem_read   = 1'b1;
            mem_to_reg = 1'b1;
            alu_src    = 1'b1;
            alu_op     = 4'b0000;
        end
        OP_STORE: begin
            mem_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 4'b0000;
        end
        OP_BRANCH: begin
            branch = 1'b1;
            alu_op = 4'b0001;
        end
        OP_JAL: begin
            jump      = 1'b1;
            reg_write = 1'b1;
        end
        default: begin
        end
    endcase
end

endmodule