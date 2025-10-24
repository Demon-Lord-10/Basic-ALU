module KSA_Adder(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    
    wire [3:0] p, g;
    wire [3:0] p1, g1;
    wire [3:0] p2, g2;
    
    // Stage 0: Pre-processing
    assign p = a ^ b;
    assign g = a & b;
    
    // Stage 1: First level prefix (span = 1)
    // Each g1[i] represents group generate from bit -1 (cin) to bit i
    assign p1[0] = p[0];
    assign g1[0] = g[0] | (p[0] & cin);
    
    assign p1[1] = p[1] & p[0];
    assign g1[1] = g[1] | (p[1] & g1[0]);  
    
    assign p1[2] = p[2] & p[1];
    assign g1[2] = g[2] | (p[2] & g1[1]);  
    
    assign p1[3] = p[3] & p[2];
    assign g1[3] = g[3] | (p[3] & g1[2]);  
    
    // Stage 2: Second level prefix (span = 2, 4)
    assign p2[0] = p1[0];
    assign g2[0] = g1[0];
    
    assign p2[1] = p1[1];
    assign g2[1] = g1[1];
    
    assign p2[2] = p1[2] & p1[0];
    assign g2[2] = g1[2] | (p1[2] & g1[0]);
    
    assign p2[3] = p1[3] & p1[1];
    assign g2[3] = g1[3] | (p1[3] & g1[1]);
    
    // Post-processing: Sum and carry out
    assign s[0] = p[0] ^ cin;
    assign s[1] = p[1] ^ g2[0];
    assign s[2] = p[2] ^ g2[1];
    assign s[3] = p[3] ^ g2[2];
    assign cout = g2[3];
    
endmodule

