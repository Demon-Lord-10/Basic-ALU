// ============================================
// Full Adder Module
// ============================================
module fulladd(p1, q1, car, fad, cout);
    input p1, q1, car;
    output fad, cout;
    
    assign fad = p1 ^ q1 ^ car;
    assign cout = (p1 & q1) | (q1 & car) | (p1 & car);
endmodule

// ============================================
// DADDA MULTIPLIER MODULE (Fixed)
// ============================================
module daddamul(A, B, Y);
    input [3:0] A;
    input [3:0] B;   
    output [7:0] Y;

    wire [3:0] sum;
    wire [3:0] hcar;
    wire [2:0] smm;
    wire [3:0] caar;
    wire [2:0] crr;
    
    // Generating products
    wire gen_pp [0:3][0:3];    
    genvar i, j;
    
    generate
        for(i = 0; i < 4; i = i + 1) begin : pp_rows
            for(j = 0; j < 4; j = j + 1) begin : pp_cols
                assign gen_pp[i][j] = A[j] * B[i];
            end
        end
    endgenerate
    
    // LEVEL 1: 4 to 3 reduction
    assign Y[0] = gen_pp[0][0];
    fulladd fle0(.p1(gen_pp[1][0]), .q1(gen_pp[0][1]), .car(1'b0), .fad(Y[1]), .cout(hcar[0]));      
    fulladd fle1(.p1(gen_pp[2][0]), .q1(gen_pp[1][1]), .car(gen_pp[0][2]), .fad(sum[1]), .cout(hcar[1]));
    fulladd fle2(.p1(gen_pp[3][0]), .q1(gen_pp[2][1]), .car(gen_pp[1][2]), .fad(sum[2]), .cout(hcar[2]));
    fulladd fle3(.p1(gen_pp[3][1]), .q1(1'b0), .car(gen_pp[2][2]), .fad(sum[3]), .cout(hcar[3]));   
    
    // LEVEL 2: 3 to 2 reduction
    fulladd fg0(.p1(hcar[0]), .q1(sum[1]), .car(1'b0), .fad(Y[2]), .cout(caar[0]));                
    fulladd fg1(.p1(gen_pp[0][3]), .q1(sum[2]), .car(hcar[1]), .fad(smm[0]), .cout(caar[1]));
    fulladd fg2(.p1(sum[3]), .q1(hcar[2]), .car(gen_pp[1][3]), .fad(smm[1]), .cout(caar[2]));
    fulladd fg3(.p1(gen_pp[3][2]), .q1(hcar[3]), .car(gen_pp[2][3]), .fad(smm[2]), .cout(caar[3]));
    
    // LEVEL 3: 2 to 1 reduction
    fulladd ff0(.p1(smm[0]), .q1(caar[0]), .car(1'b0), .fad(Y[3]), .cout(crr[0]));                
    fulladd ff1(.p1(smm[1]), .q1(caar[1]), .car(crr[0]), .fad(Y[4]), .cout(crr[1]));
    fulladd ff2(.p1(smm[2]), .q1(caar[2]), .car(crr[1]), .fad(Y[5]), .cout(crr[2]));
    fulladd ff3(.p1(gen_pp[3][3]), .q1(caar[3]), .car(crr[2]), .fad(Y[6]), .cout(Y[7]));
    
endmodule

