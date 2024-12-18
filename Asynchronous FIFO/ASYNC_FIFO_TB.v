/////////////////////////////////////////////////////////
//////////////// Timescale Adjustment ///////////////////
/////////////////////////////////////////////////////////

`timescale 1ns/1ps

module ASYNC_FIFO_TB ();

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

integer I,J;
parameter Address = 3;
parameter Data_Width = 8;
parameter FIFO_DEPTH = 8;
parameter W_Clk_Period = 10;
parameter R_Clk_Period = 25;
reg [Data_Width-1:0] MEM_IN [3*FIFO_DEPTH-1:0]; // Memory to write in FIFO
reg [Data_Width-1:0] MEM_OUT [3*FIFO_DEPTH-1:0]; // Memory to Read from FIFO

/////////////////////////////////////////////////////////
///////////////// TestBench Signals /////////////////////
/////////////////////////////////////////////////////////

reg                            W_CLK_TB;
reg                            W_RST_TB;
reg                            W_INC_TB;
reg                            R_CLK_TB;
reg                            R_RST_TB;
reg                            R_INC_TB;
reg      [Data_Width-1:0]      WR_DATA_TB;
wire     [Data_Width-1:0]      RD_DATA_TB;
wire                           EMPTY_TB;
wire                           FULL_TB;

/////////////////////////////////////////////////////////
////////////////// Initial Block ////////////////////////
/////////////////////////////////////////////////////////

initial
  begin
  // System Functions //
  $dumpfile("ASYNC_FIFO.vcd");
  $dumpvars;

  // Initialize Signals //
  Initialize();

  // Prepare Data //
  for (I = 0 ; I < 3*FIFO_DEPTH ; I = I + 1)
     MEM_IN[I] = $random %(3*Data_Width - 1);
end

/////////////////////////////////////////////////////////
/////////////// Write Initial Block /////////////////////
/////////////////////////////////////////////////////////

initial
  begin
  // Reset //
  W_Reset();

  // Writing Data in FIFO //
  Write_Data();
end

/////////////////////////////////////////////////////////
/////////////// Read Initial Block //////////////////////
/////////////////////////////////////////////////////////

initial
  begin
  // Reset //
  R_Reset();

  // Read Data From FIFO //
  Read_Data();

  // Check Out //
  for (J = 0 ; J < 3*FIFO_DEPTH ; J = J + 1)
    begin
    if (MEM_OUT[J] == MEM_IN[J])
      $display("Memory[%0d]: Data Write & Read Succeeded",J);
    else
      $display("Memory[%0d]: Data Write & Read Failed",J);
    end

  #(R_Clk_Period*5)
  $stop;
end

/////////////////////////////////////////////////////////
/////////////////////// Tasks ///////////////////////////
/////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task Initialize;
  begin
  W_CLK_TB = 0;
  W_RST_TB = 1;
  W_INC_TB = 0;
  R_CLK_TB = 0;
  R_RST_TB = 1;
  R_INC_TB = 0;
  WR_DATA_TB = 0;
  end
endtask

///////////////////////// Reset /////////////////////////

task W_Reset;
  begin
  W_RST_TB = 0;
  #W_Clk_Period;
  W_RST_TB = 1;
  end
endtask
/////////////////////////////////////////////////////////
task R_Reset;
  begin
  R_RST_TB = 0;
  #R_Clk_Period;
  R_RST_TB = 1;
  #R_Clk_Period;
  end
endtask

////////////////////// Write Data ///////////////////////

task Write_Data;
  begin
  for (I = 0 ; I < 3*FIFO_DEPTH ; I = I + 1)
     begin
     wait(!FULL_TB)
     @(negedge W_CLK_TB)
     WR_DATA_TB = MEM_IN[I];
     W_INC_TB = 1;
     #W_Clk_Period   // Wait for a write cycle
     W_INC_TB = 0;
     #W_Clk_Period;
     end
  end
endtask

////////////////////// Read Data ////////////////////////

task Read_Data;
  begin
  for (J = 0 ; J < 3*FIFO_DEPTH ; J = J + 1)
     begin
     wait (!EMPTY_TB)
     @(negedge R_CLK_TB)
     MEM_OUT[J] = RD_DATA_TB;
     R_INC_TB = 1;
     #R_Clk_Period;  // Wait for a read cycle
     end
  end
endtask

/////////////////////////////////////////////////////////
/////////////////// Clock Generator /////////////////////
/////////////////////////////////////////////////////////

// Clock Generation for Write Clock (100MHz = 10ns)
always #(W_Clk_Period/2) W_CLK_TB = ~W_CLK_TB;

// Clock Generation for Read Clock (40MHz = 25ns)
always #(R_Clk_Period/2.0) R_CLK_TB = ~R_CLK_TB;

/////////////////////////////////////////////////////////
//////////////// Design Instantiation ///////////////////
/////////////////////////////////////////////////////////

ASYNC_FIFO DUT (
 .FULL(FULL_TB),
 .EMPTY(EMPTY_TB),
 .W_CLK(W_CLK_TB),
 .W_RST(W_RST_TB),
 .W_INC(W_INC_TB),
 .R_CLK(R_CLK_TB),
 .R_RST(R_RST_TB),
 .R_INC(R_INC_TB),
 .WR_DATA(WR_DATA_TB),
 .RD_DATA(RD_DATA_TB)
);

endmodule