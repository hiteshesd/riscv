module alu32(input [31:0] a,b,input [3:0] alu_op,output reg[31:0] result,output reg zero);
always@(*)
begin
case(alu_op)

  4'b0000: result = a + b;              // ADD
        4'b0001: result = a - b;              // SUB
        4'b0010: result = a & b;              // AND
        4'b0011: result = a | b;              // OR
        4'b0100: result = a ^ b;              // XOR
        4'b0101: result = a << b[4:0];        // SLL (shift left logical)
        4'b0110: result = a >> b[4:0];        // SRL (shift right logical)
        4'b0111: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT (set less than, signed)
        default: result = 32'b0;
    endcase

    
    zero = (result == 32'b0);
end

endmodule