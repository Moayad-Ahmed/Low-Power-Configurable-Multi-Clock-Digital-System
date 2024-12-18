module	ALU_TB ();	//No Port Declaration for TestBench//

// Declating TestBench Signals //

 reg	[15:0]	A_TB, B_TB;
 reg	[3:0]	ALU_FUN_TB;
 reg 		CLK_TB;
 wire	[15:0]	ALU_OUT_TB;
 wire		Carry_Flag_TB, Arith_Flag_TB,
		Logic_Flag_TB, CMP_Flag_TB, Shift_Flag_TB;

// DUT Instantiation //

ALU DUT (
    .A(A_TB),
    .B(B_TB),
    .ALU_FUN(ALU_FUN_TB),
    .CLK(CLK_TB),
    .ALU_OUT(ALU_OUT_TB),
    .Carry_Flag(Carry_Flag_TB),
    .Arith_Flag(Arith_Flag_TB),
    .Logic_Flag(Logic_Flag_TB),
    .CMP_Flag(CMP_Flag_TB),
    .Shift_Flag(Shift_Flag_TB)
    );

// Initial Block //

initial
  begin
    $dumpfile("ALU.vcd");
    $dumpvars;
    A_TB = 16'h0011;	//Initial Value for A = 17
    B_TB = 16'h0022;	//Initial Value for B = 34
    CLK_TB =1'b0;
    ALU_FUN_TB = 4'b1111;

    // Test 1: Addition
    $display("Starting Test 1: Addition");
    #3;
    ALU_FUN_TB = 4'b0000;
    #7
    $display("A = %d, B = %d, ALU_OUT = %d, Carry_Flag = %b", A_TB, B_TB, ALU_OUT_TB, Carry_Flag_TB);
    if (ALU_OUT_TB == 16'h0033 && Carry_Flag_TB == 0) 
        $display("Addition Test Succeeded");
    else 
        $display("Addition Test Failed");

    // Test 2: Addition with Carry
    $display("Starting Test 2: Addition with Carry");
    #3
    A_TB = 16'hFFFF;
    B_TB = 16'h0001;
    ALU_FUN_TB = 4'b0000;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d, Carry_Flag = %b", A_TB, B_TB, ALU_OUT_TB, Carry_Flag_TB);
    if (ALU_OUT_TB == 16'h0000 && Carry_Flag_TB == 1) 
        $display("Addition with Carry Test Succeeded");
    else 
        $display("Addition with Carry Test Failed");

    // Test 3: Subtraction
    $display("Starting Test 3: Subtraction");
    #3
    A_TB = 16'h0022;
    B_TB = 16'h0011;
    ALU_FUN_TB = 4'b0001;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d, Carry_Flag = %b", A_TB, B_TB, ALU_OUT_TB, Carry_Flag_TB);
    if (ALU_OUT_TB == 16'h0011 && Carry_Flag_TB == 0) 
        $display("Subtraction Test Succeeded");
    else 
        $display("Subtraction Test Failed");

    // Test 4: Subtraction with Borrow
    $display("Starting Test 4: Subtraction with Borrow");
    #3
    A_TB = 16'h0000;
    B_TB = 16'h0001;
    ALU_FUN_TB = 4'b0001;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d, Carry_Flag = %b", A_TB, B_TB, ALU_OUT_TB, Carry_Flag_TB);
    if (ALU_OUT_TB == 16'hFFFF && Carry_Flag_TB == 1) 
        $display("Subtraction with Borrow Test Succeeded");
    else 
        $display("Subtraction with Borrow Test Failed");

    // Test 5: Multiplication
    $display("Starting Test 5: Multiplication");
    #3
    A_TB = 16'h0002;
    B_TB = 16'h0003;
    ALU_FUN_TB = 4'b0010;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0006) 
        $display("Multiplication Test Succeeded");
    else 
        $display("Multiplication Test Failed");

    // Test 6: Division
    $display("Starting Test 6: Division");
    #3
    A_TB = 16'h0010;
    B_TB = 16'h0002;
    ALU_FUN_TB = 4'b0011;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0008) 
        $display("Division Test Succeeded");
    else 
        $display("Division Test Failed");

    // Test 7: AND
    $display("Starting Test 7: AND");
    #3
    A_TB = 16'h00FF;
    B_TB = 16'h0F0F;
    ALU_FUN_TB = 4'b0100;
    #7;
    $display("A = %h, B = %h, ALU_OUT = %h", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h000F) 
        $display("AND Test Succeeded");
    else 
        $display("AND Test Failed");

    // Test 8: OR
    $display("Starting Test 8: OR");
    #3
    A_TB = 16'h00FF;
    B_TB = 16'h0F0F;
    ALU_FUN_TB = 4'b0101;
    #7;
    $display("A = %h, B = %h, ALU_OUT = %h", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0FFF) 
        $display("OR Test Succeeded");
    else 
        $display("OR Test Failed");

    // Test 9: NAND
    $display("Starting Test 9: NAND");
    #3
    A_TB = 16'h00FF;
    B_TB = 16'h0F0F;
    ALU_FUN_TB = 4'b0110;
    #7;
    $display("A = %h, B = %h, ALU_OUT = %h", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'hFFF0) 
        $display("NAND Test Succeeded");
    else 
        $display("NAND Test Failed");

    // Test 10: NOR
    $display("Starting Test 10: NOR");
    #3
    A_TB = 16'h00FF;
    B_TB = 16'h0F0F;
    ALU_FUN_TB = 4'b0111;
    #7;
    $display("A = %h, B = %h, ALU_OUT = %h", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'hF000) 
        $display("NOR Test Succeeded");
    else 
        $display("NOR Test Failed");

    // Test 11: XOR
    $display("Starting Test 11: XOR");
    #3
    A_TB = 16'h00FF;
    B_TB = 16'h0F0F;
    ALU_FUN_TB = 4'b1000;
    #7;
    $display("A = %h, B = %h, ALU_OUT = %h", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0FF0) 
        $display("XOR Test Succeeded");
    else 
        $display("XOR Test Failed");

    // Test 12: XNOR
    $display("Starting Test 12: XNOR");
    #3
    A_TB = 16'h00FF;
    B_TB = 16'h0F0F;
    ALU_FUN_TB = 4'b1001;
    #7;
    $display("A = %h, B = %h, ALU_OUT = %h", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'hF00F) 
        $display("XNOR Test Succeeded");
    else 
        $display("XNOR Test Failed");

    // Test 13: Equal
    $display("Starting Test 13: Equal");
    #3
    A_TB = 16'h0027;
    B_TB = 16'h0027;
    ALU_FUN_TB = 4'b1010;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0001) 
        $display("Equal Test Succeeded");
    else 
        $display("Equal Test Failed");

    // Test 14: Greater Than
    $display("Starting Test 14: Greater Than");
    #3
    A_TB = 16'h0027;
    B_TB = 16'h0013;
    ALU_FUN_TB = 4'b1011;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0002) 
        $display("Greater Than Test Succeeded");
    else 
        $display("Greater Than Test Failed");

    // Test 15: Less Than
    $display("Starting Test 15: Less Than");
    #3
    A_TB = 16'h0010;
    B_TB = 16'h0027;
    ALU_FUN_TB = 4'b1100;
    #7;
    $display("A = %d, B = %d, ALU_OUT = %d", A_TB, B_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0003) 
        $display("Less Than Test Succeeded");
    else 
        $display("Less Than Test Failed");

    // Test 16: Shift Right
    $display("Starting Test 16: Shift Right");
    #3
    A_TB = 16'h0022;
    ALU_FUN_TB = 4'b1101;
    #7;
    $display("A = %d, ALU_OUT = %d", A_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0011) 
        $display("Shift Right Test Succeeded");
    else 
        $display("Shift Right Test Failed");

    // Test 17: Shift Left
    $display("Starting Test 17: Shift Left");
    #3
    A_TB = 16'h0011;
    ALU_FUN_TB = 4'b1110;
    #7;
    $display("A = %d, ALU_OUT = %d", A_TB, ALU_OUT_TB);
    if (ALU_OUT_TB == 16'h0022) 
        $display("Shift Left Test Succeeded");
    else 
        $display("Shift Left Test Failed");

    // Test 18: No Operation
    $display("Starting Test 18: NOP");
    #3
    A_TB = 16'h0000;
    B_TB = 16'h0000;
    ALU_FUN_TB = 4'b1111;
    #7;
    $display("Arithm Flag = %d, Carry Flag = %d, CMP Flag = %d, Logic Flag = %d, Shift Flag = %d", Arith_Flag_TB, Carry_Flag_TB, CMP_Flag_TB, Logic_Flag_TB, Shift_Flag_TB);
    if (ALU_OUT_TB == 16'h0000) 
        $display("NOP Test Succeeded");
    else 
        $display("NOP Test Failed");

    #100;
    $stop;
  end

// Clock Generator //

`timescale 1us/1ns
always #5 CLK_TB = ~CLK_TB;

endmodule

