//////////////////////////////////////////////////////////////
//////////////////// Timescale Adjustment ////////////////////
//////////////////////////////////////////////////////////////

`timescale 1ns/1ps


module SYS_TOP_TB ();


//////////////////////////////////////////////////////////////
///////////////////////// Parameters /////////////////////////
//////////////////////////////////////////////////////////////

parameter Div_Ratio = 32 ;
parameter Data_Width = 8 ;
parameter Frame_Width = 11 ;
parameter TX_CLK_Period = 8680.55 ;       //115.2 KHz
parameter REF_CLK_Period = 20 ;           // 50 MHz 
parameter UART_CLK_Period = 271.26736 ;   // 3.6864 MHz
integer   Succeeded ;
integer   Failed    ;
integer   i,j ;

//////////////////////////////////////////////////////////////
///////////////////////// TB Signals /////////////////////////
//////////////////////////////////////////////////////////////

reg                         RST_N_TB         ;
reg                         REF_CLK_TB       ;
reg                         UART_CLK_TB      ;
reg                         UART_RX_IN_TB    ;
wire                        UART_TX_O_TB     ;
wire                        parity_error_tb  ;
wire                        framing_error_tb ;

reg    [Frame_Width-1:0]    Gener_Out ;

//////////////////////////////////////////////////////////////
/////////////////////// Initial Block ////////////////////////
//////////////////////////////////////////////////////////////

initial
  begin

  // System Functions
  $dumpfile("SYS_TOP.vcd") ;
  $dumpvars ;

  // Initialization
  Initialize() ;

  // Reset
  Reset() ; 

  ////////////////////// Write Test Cases //////////////////////

  $display("------------------------ Starting Write Command Test Cases ------------------------") ;

  // Write Test Case 1
  Write_Data('b10_10101010_0, 'b11_00000100_0, 'b11_11010101_0, 1) ;   // Write Command: 0xAA, Address: 0x4, Data: 0xD5, Test Case: 1

  // Write Test Case 2
  Write_Data('b10_10101010_0, 'b10_00000101_0, 'b10_01101100_0, 2) ;   // Write Command: 0xAA, Address: 0x5, Data: 0x6C, Test Case: 2

  // Write Test Case 3
  Write_Data('b10_10101010_0, 'b10_00000110_0, 'b10_10100011_0, 3) ;   // Write Command: 0xAA, Address: 0x6, Data: 0xA3, Test Case: 3

  ////////////////////// Read Test Cases ///////////////////////

  $display("------------------------ Starting Read Command Test Cases ------------------------") ;

  // Read Test Case 1
  Read_Data('b10_10111011_0, 'b11_00000100_0) ;   // Read Command: 0xBB, Address: 0x4

  Check_Read('b11_11010101_0, 1) ;                // Expected Value: 0xD5, Test Case: 1

  // Read Test Case 2
  Read_Data('b10_10111011_0, 'b10_00000101_0) ;   // Read Command: 0xBB, Address: 0x5

  Check_Read('b10_01101100_0, 2) ;                // Expected Value: 0x6C, Test Case: 2

  // Read Test Case 3
  Read_Data('b10_10111011_0, 'b10_00000110_0) ;   // Read Command: 0xBB, Address: 0x6

  Check_Read('b10_10100011_0, 3) ;                // Expected Value: 0xA3, Test Case: 3

  //////////////// ALU With Operand Test Cases /////////////////

  $display("------------------------ Starting ALU With Operand Command Test Cases ------------------------") ;

  // ALU Operand Test Case 1
  ALU_Operand('b10_11001100_0, 'b11_01100100_0, 'b11_00110010_0, 'b10_00000000_0) ;  // ALU Command: 0xCC, A: 100, B: 50, Function: Addition

  Check_ALU_Op('b10_10010110_0_10_00000000_0, 1) ;  // Output 1st Frame, Output 2nd Frame, The Result: 150 Test Case: 1

  // ALU Operand Test Case 2
  ALU_Operand('b10_11001100_0, 'b11_00100011_0, 'b10_00001111_0, 'b11_00000001_0) ;  // ALU Command: 0xCC, A: 35, B: 15, Function: Subtraction

  Check_ALU_Op('b10_00010100_0_10_00000000_0, 2) ;  // Output 1st Frame, Output 2nd Frame, The Result: 20 Test Case: 2

  // ALU Operand Test Case 3
  ALU_Operand('b10_11001100_0, 'b10_00011011_0, 'b10_00001010_0, 'b11_00000010_0) ;  // ALU Command: 0xCC, A: 27, B: 10, Function: Multiplication

  Check_ALU_Op('b11_00001110_0_11_00000001_0, 3) ; // Output 1st Frame, Output 2nd Frame, The Result: 270 Test Case: 3

  /////////////// ALU Without Operand Test Cases ///////////////

  $display("------------------------ Starting ALU Without Operand Command Test Cases ------------------------") ;

  // ALU Without Operand Test Case 1
  ALU_No_Op('b10_11011101_0, 'b10_00000000_0) ;          // ALU Command: 0xDD, Function: Addition, Test Case: 1

  Check_ALU_No_Op('b11_00100101_0_10_00000000_0, 1) ;    // Output 1st Frame, Output 2nd Frame, The Result: 37 Test Case: 1

  // ALU Without Operand Test Case 2
  ALU_No_Op('b10_11011101_0, 'b11_00000001_0) ;          // ALU Command: 0xDD, Function: Subtraction, Test Case: 2

  Check_ALU_No_Op('b10_00010001_0_10_00000000_0, 2) ;    // Output 1st & Output 2nd Frame, The Result: 17 Test Case: 2

  // ALU Without Operand Test Case 3
  ALU_No_Op('b10_11011101_0, 'b11_00000010_0) ;          // ALU Command: 0xDD, Function: Multiplication, Test Case: 3

  Check_ALU_No_Op('b11_00001110_0_11_00000001_0, 3) ;    // Output 1st Frame, Output 2nd Frame, The Result: 270 Test Case: 3

  ///////// Display no. of Successful and Failed Tests /////////

  $display("------------------------ Showing Test Cases Results ------------------------") ;
  $display("Number of Successful Test cases : %0d", Succeeded) ;
  $display("Number of Failed Test cases : %0d \n", Failed) ;

  #(TX_CLK_Period*2)
  $stop ;

end

//////////////////////////////////////////////////////////////
/////////////////////////// Tasks ////////////////////////////
//////////////////////////////////////////////////////////////

/////////////////// Signals Initialization ///////////////////

task Initialize ;
  begin
   RST_N_TB            = 1'b1 ;
   REF_CLK_TB          = 1'b0 ;
   UART_CLK_TB         = 1'b0 ;
   UART_RX_IN_TB       = 1'b1 ;
   Gener_Out           = 0    ;
   Succeeded           = 0    ;
   Failed              = 0    ;
  end
endtask

/////////////////////////// Reset ////////////////////////////

task Reset ;
  begin
   RST_N_TB  = 1'b0 ;               // Reset is Activated & UART is Configured
   #(UART_CLK_Period*Div_Ratio) ;   // Wait For 1 Tx Clock Period
   RST_N_TB  = 1'b1 ;
  end
endtask

///////////////////////// Write Data /////////////////////////

task Write_Data ;
  input [Frame_Width-1:0] Command   ;
  input [Frame_Width-1:0] Address   ;
  input [Frame_Width-1:0] Wr_Data   ;
  input [1:0]             Test_Case ;
  begin
   // Insert Data into Rx
   Data_In(Command) ;
   Data_In(Address) ;
   Data_In(Wr_Data) ;

   // Check Written Data is Correct
   Check_Write(Wr_Data[8:1],Address[3:1],Test_Case) ;
  end
endtask

///////////////////////// Read Data //////////////////////////

task Read_Data ;
  input [Frame_Width-1:0] Command   ;
  input [Frame_Width-1:0] Address   ;
  begin
   // Insert Data into Rx
   Data_In(Command) ;
   Data_In(Address) ;
  end
endtask

////////////////////// ALU With Operand //////////////////////

task ALU_Operand ;
  input [Frame_Width-1:0] Command   ;
  input [Frame_Width-1:0] Input_A   ;
  input [Frame_Width-1:0] Input_B   ;
  input [Frame_Width-1:0] Function  ;
  begin
   // Insert Data into Rx
   Data_In(Command)  ;
   Data_In(Input_A)  ;
   Data_In(Input_B)  ;
   Data_In(Function) ;
  end
endtask

/////////////////////// ALU No Operand ///////////////////////

task ALU_No_Op ;
  input [Frame_Width-1:0] Command   ;
  input [Frame_Width-1:0] Function  ;
  begin
   // Insert Data into Rx
   Data_In(Command)  ;
   Data_In(Function) ;
  end
endtask

////////////////////////// Data In ///////////////////////////

task Data_In ;
  input [Frame_Width-1:0] Data_Frame ;
  begin
   for (i=0; i<11; i=i+1)
     begin 		
      UART_RX_IN_TB = Data_Frame[i] ;   // Entering Data Bits
      #(UART_CLK_Period*Div_Ratio)  ;   // Bit Every Tx Period
     end 
  end
endtask

//////////////////////// Check Write /////////////////////////

task Check_Write ;
  input  [Data_Width-1:0]  Expec_Data ;
  input  [2:0]             Reg_Addr   ;
  input  [1:0]             Test_Num   ;
  begin
   @(negedge DUT.U0_RegFile.WrEn);
   @(negedge REF_CLK_TB)
   if (DUT.U0_RegFile.RegMem[Reg_Addr] == Expec_Data)
    begin
     $display("Write Test Case %0d Succeeded. Expected: %0h Recieved: %0h",Test_Num, Expec_Data, DUT.U0_RegFile.RegMem[Reg_Addr]) ;
     Succeeded = Succeeded + 1 ;
    end
   else
    begin
     $display("Write Test Case %0d Failed. Expected: %0h Recieved: %0h", Test_Num, Expec_Data, DUT.U0_RegFile.RegMem[Reg_Addr]) ;
     Failed = Failed + 1 ;
    end
  end
endtask

///////////////////////// Check Read /////////////////////////

task Check_Read ;
  input  [Frame_Width-1:0]  Expec_Out ;
  input  [1:0]              Test_Num  ;
  begin
   @(posedge DUT.U0_UART.TX_OUT_V);
   for(j=0 ; j<11 ; j=j+1)
    begin
     @(negedge DUT.U0_UART.TX_CLK) Gener_Out[j] = UART_TX_O_TB ;
    end
   if (Gener_Out == Expec_Out)
    begin
     $display("Read Test Case %0d Succeeded. Expected: %0b Recieved: %0b",Test_Num, Expec_Out, Gener_Out) ;
     Succeeded = Succeeded + 1 ;
    end
   else
    begin
     $display("Read Test Case %0d Failed. Expected: %0b Recieved: %0b", Test_Num, Expec_Out, Gener_Out) ;
     Failed = Failed + 1 ;
    end
  end
endtask

////////////////////// Check ALU Op Out //////////////////////

task Check_ALU_Op ;
  input  [2*Frame_Width-1:0]  Expec_Out    ;
  input  [1:0]                Test_Num     ;
  reg    [Frame_Width-1:0]    ALU_Out_Reg  ;
  begin
   Data_Out() ;
   ALU_Out_Reg = Gener_Out ;
   Data_Out() ;
     if ({ALU_Out_Reg , Gener_Out} == Expec_Out)
    begin
     $display("ALU With Operand Test Case %0d Succeeded. Expected: %16b Recieved: %16b",Test_Num, 
               {Expec_Out[19:12] , Expec_Out[8:1]}, {ALU_Out_Reg[8:1] , Gener_Out[8:1]}) ;
     Succeeded = Succeeded + 1 ;
    end
   else
    begin
     $display("ALU With Operand Test Case %0d Failed. Expected: %16b Recieved: %16b", Test_Num, 
               {Expec_Out[19:12] , Expec_Out[8:1]}, {ALU_Out_Reg[8:1], Gener_Out[8:1]}) ;
     Failed = Failed + 1 ;
    end
  end
endtask

////////////////////// Check ALU No Op ///////////////////////

task Check_ALU_No_Op ;
  input  [2*Frame_Width-1:0]  Expec_Out   ;
  input  [1:0]                Test_Num    ;
  reg    [15:0]               ALU_Out_Reg ;
  begin
   Data_Out() ;
   ALU_Out_Reg = Gener_Out ;
   Data_Out() ;
   if ({ALU_Out_Reg , Gener_Out} == Expec_Out)
    begin
     $display("ALU Without Operand Test Case: %0d Succeeded. Expected: %16b Recieved: %16b",Test_Num, 
              {Expec_Out[19:12] , Expec_Out[8:1]}, {ALU_Out_Reg[8:1], Gener_Out[8:1]}) ;
     Succeeded = Succeeded + 1 ;
    end
   else
    begin
     $display("ALU Without Operand Test Case: %0d Failed. Expected: %16b Recieved: %16b", Test_Num, 
              {Expec_Out[19:12] , Expec_Out[8:1]}, {ALU_Out_Reg[8:1], Gener_Out[8:1]}) ;
     Failed = Failed + 1 ;
    end
  end
endtask

////////////////////////// Receive ///////////////////////////

task Data_Out ;
  begin
   @(posedge DUT.U0_UART.TX_OUT_V);
   for(i=0 ; i<11 ; i=i+1)
    begin
     @(negedge DUT.U0_UART.TX_CLK) Gener_Out[i] = UART_TX_O_TB ;
    end
  end
endtask

////////////////////// Clock Generator ///////////////////////

always #(REF_CLK_Period/2) REF_CLK_TB = ~REF_CLK_TB ;

always #(UART_CLK_Period/2) UART_CLK_TB = ~UART_CLK_TB ;
 
//////////////////////////////////////////////////////////////
//////////////////// Design Instantiation ////////////////////
//////////////////////////////////////////////////////////////

SYS_TOP DUT (
 .RST_N(RST_N_TB),
 .REF_CLK(REF_CLK_TB),
 .UART_CLK(UART_CLK_TB),
 .UART_TX_O(UART_TX_O_TB),
 .UART_RX_IN(UART_RX_IN_TB),
 .parity_error(parity_error_tb),
 .framing_error(framing_error_tb)
);

endmodule