////////////////////////////////////////
///////// Timescale Adjustment /////////
////////////////////////////////////////

`timescale 1ns/100ps


module UART_TX_TB ();     // No inputs or ouputs for TestBench


////////////////////////////////////////
///////// TestBench Parameters /////////
////////////////////////////////////////

parameter Clock_Period = 5.0;
parameter Parallel_Data_Width = 8;

integer Succeeded;
integer Failed;

////////////////////////////////////////
////////// TestBench Signals ///////////
////////////////////////////////////////

reg [Parallel_Data_Width-1:0] P_Data_TB;
reg                           Data_Valid_TB;
reg                           Par_En_TB,Par_Type_TB;
reg                           clk_tb,rst_tb;
wire                          TX_Out_TB;
wire                          Busy_TB;

reg [Parallel_Data_Width+1:0] TX_Out_NoParity;
reg [Parallel_Data_Width+2:0] TX_Out_WithParity;

////////////////////////////////////////
////////// DUT Instantiation ///////////
////////////////////////////////////////

UART_TX DUT (
    .clk(clk_tb),
    .rst(rst_tb),
    .Busy(Busy_TB),
    .P_Data(P_Data_TB),
    .TX_Out(TX_Out_TB),
    .Par_En(Par_En_TB),
    .Par_Type(Par_Type_TB),
    .Data_Valid(Data_Valid_TB)
    );

////////////////////////////////////////
//////////// Initial Block /////////////
////////////////////////////////////////

initial
  begin
    // Save Waveform //
  	$dumpfile("UART_TX.vcd");
  	$dumpvars;

  	// Initialize and Reset //
  	Initialize();
  	Reset();

    // Send Data no. 1 //
    Send_NoParity_Data('hC7);

    // Send Data no. 2 //
    Send_EvenParity_Data('hA2);

    // Send Data no. 3 //
    Send_OddParity_Data('hB4);

    // Send Data no. 4 //
    Send_EvenParity_Data('h27);

    // Send Data no. 5 //
    Send_NoParity_Data('hD5);

    // Display no. of Successful and Failed Tests //
    $display("\nNumber of Successful Test cases : %0d", Succeeded);
    $display("Number of failed Test cases : %0d", Failed);

    #(10*Clock_Period)
    $stop;
  end

////////////////////////////////////////
//////////////// Tasks /////////////////
////////////////////////////////////////

//////// Signals Initialization ////////

task Initialize;
  begin
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    P_Data_TB = 1'b0;
    Data_Valid_TB = 1'b0;  
    Succeeded = 1'b0;
    Failed = 1'b0;
  end
endtask

//////////////// RESET /////////////////

task Reset;
  begin
    rst_tb = 1'b0;
    #Clock_Period
    rst_tb = 1'b1;
  end
endtask

///////////// Send Data with No Parity ///////////////

task Send_NoParity_Data;
  input [Parallel_Data_Width-1:0] Data_In1;
  integer i;
  begin
    P_Data_TB = Data_In1;
    Par_En_TB = 1'b0;
    Data_Valid_TB = 1'b1;
    TX_Out_NoParity = 'b0;
    #Clock_Period
    Data_Valid_TB = 1'b0;

    // Capture Start Bit //
    #Clock_Period
    TX_Out_NoParity[9] = TX_Out_TB;

    // Capture Data Bits //
    for(i=1; i<9; i=i+1)
      begin
        #(Clock_Period) TX_Out_NoParity[i] = TX_Out_TB;
      end

    // Capture Stop Bit //
    #Clock_Period
    TX_Out_NoParity[0] = TX_Out_TB;

    if(TX_Out_NoParity == {1'b0,Data_In1,1'b1} && Busy_TB == 1'b1) 
      begin
        $display("Test Case Succeeded | Data Transmitted Successfully : Sent: %b & Busy: %b", TX_Out_NoParity, Busy_TB);
        Succeeded = Succeeded +1;
      end
   else
      begin
        $display("Test Case is failed | Data Transmit Failed : Sent: %b & Expected: %b & Busy: %b", TX_Out_NoParity, Data_In1, Busy_TB);
        Failed = Failed +1;
      end

    #Clock_Period;
  end
endtask

///////////// Send Data with Even Parity ///////////////

task Send_EvenParity_Data;
  input [Parallel_Data_Width-1:0] Data_In2;
  integer n;
  begin
    P_Data_TB = Data_In2;
    Par_En_TB = 1'b1;
    Par_Type_TB = 1'b0;
    Data_Valid_TB = 1'b1;
    TX_Out_WithParity = 'b0;
    #Clock_Period
    Data_Valid_TB = 1'b0;

    // Capture Start Bit //
    #Clock_Period
    TX_Out_WithParity[10] = TX_Out_TB;

    // Capture Data Bits //
    for(n=2; n<10; n=n+1)
      begin
        #(Clock_Period) TX_Out_WithParity[n] = TX_Out_TB;
      end

    // Capture Parity Bit //
    #Clock_Period
    TX_Out_WithParity[1] = TX_Out_TB;

    // Capture Stop Bit //
    #Clock_Period
    TX_Out_WithParity[0] = TX_Out_TB;

    if(TX_Out_WithParity == {1'b0,Data_In2,^Data_In2,1'b1} && Busy_TB == 1'b1) 
      begin
        $display("Test Case Succeeded | Data Transmitted Successfully : Sent: %b & Busy: %b", TX_Out_WithParity, Busy_TB);
        Succeeded = Succeeded +1;
      end
   else
      begin
        $display("Test Case is failed | Data Transmit Failed : Sent: %b & Expected: %b & Busy: %b", TX_Out_WithParity, Data_In2, Busy_TB);
        Failed = Failed +1;
      end

    #Clock_Period;
  end
endtask

///////////// Send Data with Odd Parity ///////////////

task Send_OddParity_Data;
  input [Parallel_Data_Width-1:0] Data_In3;
  integer m;
  begin
    P_Data_TB = Data_In3;
    Par_En_TB = 1'b1;
    Par_Type_TB = 1'b1;
    Data_Valid_TB = 1'b1;
    TX_Out_WithParity = 'b0;
    #Clock_Period
    Data_Valid_TB = 1'b0;

    // Capture Start Bit //
    #Clock_Period
    TX_Out_WithParity[10] = TX_Out_TB;

    // Capture Data Bits //
    for(m=2; m<10; m=m+1)
      begin
        #Clock_Period TX_Out_WithParity[m] = TX_Out_TB;
      end

    // Capture Parity Bit //
    #Clock_Period
    TX_Out_WithParity[1] = TX_Out_TB;

    // Capture Stop Bit //
    #Clock_Period
    TX_Out_WithParity[0] = TX_Out_TB;

    if(TX_Out_WithParity == {1'b0,Data_In3,~^Data_In3,1'b1} && Busy_TB == 1'b1) 
      begin
        $display("Test Case Succeeded | Data Transmitted Successfully : Sent: %b & Busy: %b", TX_Out_WithParity, Busy_TB);
        Succeeded = Succeeded +1;
      end
   else
      begin
        $display("Test Case is failed | Data Transmit Failed : Sent: %b & Expected: %b & Busy: %b", TX_Out_WithParity, Data_In3, Busy_TB);
        Failed = Failed +1;
      end

    #Clock_Period;
  end
endtask

////////////////////////////////////////
/////////// Clock Generator ////////////
////////////////////////////////////////

always #(Clock_Period/2) clk_tb = ~clk_tb;

endmodule