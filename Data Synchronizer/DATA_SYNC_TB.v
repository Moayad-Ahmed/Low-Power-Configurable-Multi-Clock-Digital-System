/////////////////////////////////////////////////////////
//////////////// Timescale Adjustment ///////////////////
/////////////////////////////////////////////////////////

`timescale 1ns/1ns

module DATA_SYNC_TB ();  // No inputs/ouputs in TestBench

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter Clock_Period = 10;
parameter Bus_Width = 8;
integer Succeeded;
integer Failed;

/////////////////////////////////////////////////////////
///////////////// TestBench Signals /////////////////////
/////////////////////////////////////////////////////////

reg                           CLK_TB;
reg                           RST_TB;
reg      [Bus_Width-1:0]      Unsync_Bus_TB;
reg                           Bus_Enable_TB;
wire     [Bus_Width-1:0]      Sync_Bus_TB;
wire                          Enable_Pulse_TB;

/////////////////////////////////////////////////////////
////////////////// Initial Block //////////////////////// 
/////////////////////////////////////////////////////////

initial
  begin
  // Save Waveform //
  $dumpfile("DATA_SYNC.vcd");
  $dumpvars;

  // Initialize and Reset //
  Initialize();
  Reset();

  // Test Case no. 1 //
  Apply_Data(8'hBE);

  Check_Out();

  // Test Case no. 2 //
  Apply_Data(8'hAC);

  Check_Out();

  // Test Case no. 3 //
  Apply_Data(8'h92);

  Check_Out();

  $display("Number of Successfull Cases = %d", Succeeded);
  $display("Number of Failed Cases = %d", Failed);

  #(Clock_Period*3)
  $stop;
end

/////////////////////////////////////////////////////////
/////////////////////// Tasks ///////////////////////////
/////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task Initialize;
  begin
  CLK_TB        = 1'b0;
  RST_TB        = 1'b1;
  Failed        = 1'b0;
  Succeeded     = 1'b0;
  Unsync_Bus_TB = 1'b0;
  Bus_Enable_TB = 1'b0;
  end
endtask

///////////////////////// Reset /////////////////////////

task Reset;
  begin
  RST_TB = 1'b0;
  #Clock_Period
  RST_TB = 1'b1;
  #Clock_Period;
  end
endtask

////////////////////// Apply Data ///////////////////////

task Apply_Data;
  input  [Bus_Width-1:0] Data_In;
  begin
  Unsync_Bus_TB = Data_In;
  Bus_Enable_TB = 1'b1;
  #Clock_Period
  Bus_Enable_TB = 1'b0;
  end
endtask

/////////////////////// Check Out ///////////////////////

task Check_Out;
  // input [Bus_Width-1:0] expec_out;
  begin
  #(Clock_Period*2)     // Enable is Ready after 2 Clock Cycles (FF no. Chain) and Output is Passed on the 3rd
  if (Sync_Bus_TB == Unsync_Bus_TB)
  begin
  $display("Test Case Succeeded Unsync Bus: %h, Sync Bus: %h, Enable Pulse: %b", Unsync_Bus_TB, Sync_Bus_TB, Enable_Pulse_TB);
  Succeeded = Succeeded + 1;
  end
  else
  begin
  $display("Test Case Failed Unsync Bus: %h, Sync Bus: %h, Enable Pulse: %b", Unsync_Bus_TB, Sync_Bus_TB, Enable_Pulse_TB);
  Failed = Failed + 1;
  end
  end
endtask

/////////////////////////////////////////////////////////
/////////////////// Clock Generator /////////////////////
/////////////////////////////////////////////////////////

always #(Clock_Period/2) CLK_TB = ~CLK_TB;

/////////////////////////////////////////////////////////
//////////////// Design Instantiation ///////////////////
/////////////////////////////////////////////////////////

DATA_SYNC DUT (
 .CLK(CLK_TB),
 .RST(RST_TB),
 .Sync_Bus(Sync_Bus_TB),
 .Unsync_Bus(Unsync_Bus_TB),
 .Bus_Enable(Bus_Enable_TB),
 .Enable_Pulse(Enable_Pulse_TB)
 );

endmodule