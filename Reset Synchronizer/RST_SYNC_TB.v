/////////////////////////////////////////////////////////
/////////////// Timescale Adjustments ///////////////////
/////////////////////////////////////////////////////////

`timescale 1ns/100ps

module RST_SYNC_TB (); // No inputs or ouputs in TestBench

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter Clock_Period = 10;

/////////////////////////////////////////////////////////
///////////////// TestBench Signals /////////////////////
/////////////////////////////////////////////////////////

reg                      RST_TB;
reg                      CLK_TB;
wire                     SYNC_RST_TB;

/////////////////////////////////////////////////////////
////////////////// Initial Block //////////////////////// 
/////////////////////////////////////////////////////////

initial
  begin
  // Save Waveform //
  $dumpfile("RST_SYNC.vcd");
  $dumpvars;

  // Initialize //
  Initialize();

  // Test Case no. 1 //
  Apply_Reset(13,40);

  // Test Case no. 2 //
  Apply_Reset(26,40);

  #(Clock_Period*3);
  $stop;
end

/////////////////////////////////////////////////////////
/////////////////////// Tasks ///////////////////////////
/////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task Initialize;
  begin
  CLK_TB = 1'b0;
  RST_TB = 1'b1;
  end
endtask

///////////////////////// Reset /////////////////////////

task Apply_Reset;
  input [4:0] Reset_Time;
  input [7:0] Deassertion_Time;
  begin
  RST_TB = 1'b0;
  #Reset_Time
  RST_TB = 1'b1;
  #Deassertion_Time;
  end
endtask

/////////////////////////////////////////////////////////
/////////////////// Clock Generator /////////////////////
/////////////////////////////////////////////////////////

always #(Clock_Period/2) CLK_TB = ~CLK_TB;

/////////////////////////////////////////////////////////
//////////////// Design Instantiation ///////////////////
/////////////////////////////////////////////////////////

RST_SYNC DUT (
 .CLK(CLK_TB),
 .RST(RST_TB),
 .SYNC_RST(SYNC_RST_TB)
 );

endmodule