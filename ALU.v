// ============================================
// 4-BIT ALU WITH MULTIPLE OPERATIONS
// ============================================
module alu_4bit(
    input [3:0] A,
    input [3:0] B,
    input [1:0] TT,      // Operation selector
    output [7:0] Result, // 8-bit output for multiplication
    output cout          // Carry out (for ADD/SUB only)
);
    
    // Internal wires
    wire [3:0] add_sum, sub_sum;
    wire add_cout, sub_cout;
    wire [7:0] mul_result;
    wire [3:0] and_result;
    wire [3:0] b_inverted;
    
    // For subtraction: invert B (1's complement)
    assign b_inverted = ~B;
    
    // ADD operation using KSA (TT = 00)
    KSA_Adder adder (
        .a(A),
        .b(B),
        .cin(1'b0),
        .s(add_sum),
        .cout(add_cout)
    );
    
    // SUB operation using KSA with inverted B and cin=1 (TT = 01)
    // This implements A - B = A + (~B) + 1 (2's complement)
    KSA_Adder subtractor (
        .a(A),
        .b(b_inverted),
        .cin(1'b1),          // Add 1 for 2's complement
        .s(sub_sum),
        .cout(sub_cout)
    );
    
    // MUL operation using Dadda multiplier (TT = 10)
    daddamul multiplier (
        .A(A),
        .B(B),
        .Y(mul_result)
    );
    
    // AND operation (TT = 11)
    assign and_result = A & B;
    
    // Output multiplexer based on TT
    reg [7:0] result_reg;
    reg cout_reg;
    
    always @(*) begin
        case (TT)
            2'b00: begin  // ADD
                result_reg = {4'b0000, add_sum};
                cout_reg = add_cout;
            end
            2'b01: begin  // SUB
                result_reg = {4'b0000, sub_sum};
                cout_reg = sub_cout;
            end
            2'b10: begin  // MUL
                result_reg = mul_result;
                cout_reg = 1'b0;  // No carry for multiplication
            end
            2'b11: begin  // AND
                result_reg = {4'b0000, and_result};
                cout_reg = 1'b0;  // No carry for AND
            end
            default: begin
                result_reg = 8'b0;
                cout_reg = 1'b0;
            end
        endcase
    end
    
    assign Result = result_reg;
    assign cout = cout_reg;
    
endmodule

