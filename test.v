module tb_alu_simple;
    // Inputs
    reg [3:0] A, B;
    reg [1:0] TT;
    
    // Outputs
    wire [7:0] Result;
    wire cout;
    
    // Instantiate the ALU
    alu_4bit uut (
        .A(A),
        .B(B),
        .TT(TT),
        .Result(Result),
        .cout(cout)
    );
    
    // Test stimulus
    initial begin
        // Display header
        $display("\n========================================");
        $display("   4-BIT ALU Simple Test");
        $display("========================================");
        $display("Time\tTT\tA\tB\tResult\tCout");
        $display("----------------------------------------");
        
        // Monitor changes
        $monitor("%0t\t%b\t%d\t%d\t%d\t%b", 
                 $time, TT, A, B, Result, cout);
        
        // Test ADD (TT = 00)
        TT = 2'b00; A = 4'd5; B = 4'd3; #10;
        TT = 2'b00; A = 4'd12; B = 4'd7; #10;
        TT = 2'b00; A = 4'd15; B = 4'd15; #10;
        
        // Test SUB (TT = 01)
        TT = 2'b01; A = 4'd10; B = 4'd3; #10;
        TT = 2'b01; A = 4'd8; B = 4'd5; #10;
        TT = 2'b01; A = 4'd5; B = 4'd5; #10;
        
        // Test MUL (TT = 10)
        TT = 2'b10; A = 4'd3; B = 4'd5; #10;
        TT = 2'b10; A = 4'd7; B = 4'd9; #10;
        TT = 2'b10; A = 4'd15; B = 4'd15; #10;
        
        // Test AND (TT = 11)
        TT = 2'b11; A = 4'b1111; B = 4'b1010; #10;
        TT = 2'b11; A = 4'b1100; B = 4'b0011; #10;
        TT = 2'b11; A = 4'd15; B = 4'd7; #10;
        
        $display("========================================");
        $display("   All Tests Complete!");
        $display("========================================\n");
        
        #10;
        $finish;
    end
    
    // Generate VCD file for GTKWave
    initial begin
        $dumpfile("alu_waveform.vcd");
        $dumpvars(0, tb_alu_simple);
    end
    
endmodule

