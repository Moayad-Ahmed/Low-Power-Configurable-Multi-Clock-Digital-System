////////////////////////////////////////////////////////
//////////////// Timescale Adjustment ////////////////// 
////////////////////////////////////////////////////////

`timescale 1ns/1ps


module UART_RX_TB ();


/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter Data_Width = 8 ;  
parameter TX_CLK_Period = 8680.55 ;    //115.2 KHz
integer   Succeeded;
integer   Failed;

/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////

reg                         RX_CLK_TB;
reg                         RST_TB;
reg                         RX_In_TB;
reg                         Par_En_TB;
reg   [5:0]                 Prescale_TB;
reg                         Par_Type_TB;
wire  [Data_Width-1:0]      P_Data_TB; 
wire                        Data_Valid_TB;

reg                         TX_CLK_TB;

////////////////////////////////////////////////////////
////////////////// initial block ///////////////////////
////////////////////////////////////////////////////////

initial
  begin

  // Save Waveform
  $dumpfile("UART_RX.vcd");
  $dumpvars;

  // Initialization
  Initialize() ;

  // Reset
  Reset() ; 

  ////////////// Test Case 1 //////////////////

  // RX Configuration (Parity Enable = 1 & Parity Type = Odd & Prescale = 8)
  RX_Config (1'b1,1'b1,6'd8);

  // Receive Data 
  Data_In(8'h55);     //'b 01010101

  // Check Output
  Check_Out(8'h55,1);

  ////////////// Test Case 2 //////////////////

  // RX Configuration (Parity Enable = 1 & Parity Type = Even & Prescale = 8)
  RX_Config (1'b1,1'b0,6'd8);

  // Receive Data 
  Data_In(8'h5D);     //'b 01011101 

  // Check Output
  Check_Out(8'h5d,2);

  ////////////// Test Case 3 //////////////////

  // RX Configuration (Parity Enable = 0 No Parity & Prescale = 8)
  RX_Config (1'b0,1'b0,6'd8);

  // Receive Data 
  Data_In(8'hC2);     //'b 11000010 

  // Check Output
  Check_Out(8'hC2,3);

  #(TX_CLK_Period*2)

  ////////////// Test Case 4 //////////////////

  // RX Configuration (Parity Enable = 1 & Parity Type = Odd & Prescale = 16)
  RX_Config (1'b1,1'b1,6'd16);
 
  // Receive Data 
  Data_In(8'h55);     //'b 01010101

  // Check Output
  Check_Out(8'h55,4);
 
  ////////////// Test Case 5 //////////////////

  // RX Configuration (Parity Enable = 1 & Parity Type = Even & Prescale = 16)
  RX_Config (1'b1,1'b0,6'd16);
 
  // Receive Data 
  Data_In(8'h5D);     //'b 01011101

  // Check Output
  Check_Out(8'h5D,5);
 
  ////////////// Test Case 6 //////////////////

  // RX Configuration (Parity Enable = 0 No Parity & Prescale = 16)
  RX_Config (1'b0,1'b0,6'd16);
 
  // Receive Data 
  Data_In(8'hC2);     //'b 11000010

  // Check Output
  Check_Out(8'hC2,6);

  #(TX_CLK_Period*2)

  ////////////// Test Case 7 //////////////////

  // RX Configuration (Parity Enable = 1 & Parity Type = Odd & Prescale = 32)
  RX_Config (1'b1,1'b1,6'd32);
 
  // Receive Data 
  Data_In(8'h55);     //'b 01010101

  // Check Output
  Check_Out(8'h55,7);
 
  ////////////// Test Case 8 //////////////////

  // RX Configuration (Parity Enable = 1 & Parity Type = Even & Prescale = 32)
  RX_Config (1'b1,1'b0,6'd32);
 
  // Receive Data 
  Data_In(8'h5D);     //'b 01011101

  // Check Output
  Check_Out(8'h5D,8);
 
  ////////////// Test Case 9 //////////////////

  // RX Configuration (Parity Enable = 0 No Parity & Prescale = 32)
  RX_Config (1'b0,1'b0,6'd32);
 
  // Receive Data 
  Data_In(8'hC2);     //'b 11000010

  // Check Output
  Check_Out(8'hC2,9);

  // Display no. of Successful and Failed Tests //
  $display("\nNumber of Successful Test cases : %0d", Succeeded);
  $display("Number of failed Test cases : %0d", Failed);
 
  #(TX_CLK_Period*5)

  $stop ;

end

////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task Initialize ;
  begin
	RX_CLK_TB         = 1'b0      ;
	TX_CLK_TB         = 1'b0      ;
	RST_TB            = 1'b1      ;    // rst is deactivated
	Prescale_TB       = 6'b1000   ;    // prescale = 8
	Par_En_TB         = 1'b0      ;    // Parity is disabled
	Par_Type_TB       = 1'b0      ;
	RX_In_TB          = 1'b1      ;
	Succeeded         = 0         ;
	Failed            = 0         ;
  end
endtask

///////////////////////// RESET /////////////////////////

task Reset ;
  begin
	RST_TB  = 1'b0;           // rst is activated
	#(TX_CLK_Period)
	RST_TB  = 1'b1;
	#(TX_CLK_Period);
  end
endtask

///////////////////// Configuration ////////////////////

task RX_Config ;
  input              PAR_EN   ;
  input              PAR_TYPE ;
  input    [5:0]     PRESCALE ;

  begin
	Par_En_TB        = PAR_EN   ;
	Par_Type_TB      = PAR_TYPE ;
	Prescale_TB      = PRESCALE ;    	
  end
endtask

/////////////////////// Data In /////////////////////////

task Data_In ;
 input   [Data_Width-1:0]  DATA ;
 integer i ;

 begin
	@(posedge TX_CLK_TB)
	RX_In_TB = 1'b0 ;              // Start_bit

	for(i=0; i<8; i=i+1)
		begin
		 #TX_CLK_Period 		
		 RX_In_TB = DATA[i] ;       // data bits
		end 

	if(Par_En_TB)
		begin
			#TX_CLK_Period 
			case(Par_Type_TB)
			1'b0 : RX_In_TB = ^DATA  ;     // Even Parity
			1'b1 : RX_In_TB = ~^DATA ;     // Odd Parity
			endcase	
		end
	
	#TX_CLK_Period
	RX_In_TB <= 1'b1 ;              // stop_bit
 end
endtask


//////////////////  Check Output  ////////////////////
task Check_Out ;
 input  [Data_Width-1:0]  expec_out ;
 input  [4:0]             Test_NUM  ;
  
 begin
	@(posedge Data_Valid_TB)	
	if(P_Data_TB == expec_out) 
		begin
			$display("Test Case %d Succeeded. Expected: %b Recieved: %b",Test_NUM, expec_out, P_Data_TB);
			Succeeded = Succeeded + 1 ;
		end
	else
		begin
			$display("Test Case %d Failed. Expected: %b Recieved: %b", Test_NUM, expec_out, P_Data_TB);
			Failed = Failed + 1 ;
		end
 end
endtask

///////////////////// Clock Generator //////////////////

always #((TX_CLK_Period / Prescale_TB)/2) RX_CLK_TB = ~RX_CLK_TB ;

always #(TX_CLK_Period/2) TX_CLK_TB = ~TX_CLK_TB ;
 
//////////////////////////////////////////////////////// 
///////////////// Design Instaniation //////////////////
////////////////////////////////////////////////////////

UART_RX DUT (
 .rst(RST_TB),
 .clk(RX_CLK_TB),
 .RX_In(RX_In_TB),
 .P_Data(P_Data_TB),
 .Par_En(Par_En_TB),
 .Prescale(Prescale_TB),
 .Par_Type(Par_Type_TB),
 .Data_Valid(Data_Valid_TB)
);

endmodule