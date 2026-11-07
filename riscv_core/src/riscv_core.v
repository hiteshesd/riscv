module riscv_core (
    input clk,
    input rst,
    output [31:0] pc_out,
    output [31:0] instr_out,
    output [31:0] alu_result_out
);

wire [31:0] pc, pc_next, pc_plus4;
wire [31:0] instr;
wire [6:0]  opcode = instr[6:0];
wire [4:0]  rd     = instr[11:7];
wire [2:0]  funct3 = instr[14:12];
wire [4:0]  rs1    = instr[19:15];
wire [4:0]  rs2    = instr[24:20];
wire [6:0]  funct7 = instr[31:25];

wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
wire [31:0] imm_b = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
wire [31:0] imm_j = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

wire reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, jump;
wire [3:0] alu_op_ctrl;
wire [3:0] alu_op;

wire [31:0] reg_data1, reg_data2, alu_b_in, alu_result;
wire zero;
wire [31:0] write_back_data;
wire [31:0] branch_target = pc + imm_b;
wire [31:0] jump_target   = pc + imm_j;
wire pc_src = branch & zero;

assign pc_plus4 = pc + 4;
assign pc_next  = jump ? jump_target : (pc_src ? branch_target : pc_plus4);

pc_reg u_pc (
    .clk(clk), .rst(rst), .pc_next(pc_next), .pc(pc)
);

instr_mem u_imem (
    .addr(pc), .instr(instr)
);

control_unit u_ctrl (
    .opcode(opcode),
    .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write),
    .mem_to_reg(mem_to_reg), .alu_src(alu_src), .branch(branch), .jump(jump),
    .alu_op(alu_op_ctrl)
);

assign alu_op = (opcode == 7'b0110011) ?
                 ((funct3 == 3'b000) ? (funct7[5] ? 4'b0001 : 4'b0000) :
                  (funct3 == 3'b111) ? 4'b0010 :
                  (funct3 == 3'b110) ? 4'b0011 :
                  (funct3 == 3'b100) ? 4'b0100 :
                  4'b0000)
                 : alu_op_ctrl;

reg_file u_regs (
    .clk(clk), .we(reg_write),
    .waddr(rd), .wdata(write_back_data),
    .raddr1(rs1), .raddr2(rs2),
    .rdata1(reg_data1), .rdata2(reg_data2)
);

assign alu_b_in = alu_src ? imm_i : reg_data2;

alu32 u_alu (
    .a(reg_data1), .b(alu_b_in), .alu_op(alu_op),
    .result(alu_result), .zero(zero)
);

assign write_back_data = alu_result;
assign pc_out = pc;
assign instr_out = instr;
assign alu_result_out = alu_result;

endmodule
