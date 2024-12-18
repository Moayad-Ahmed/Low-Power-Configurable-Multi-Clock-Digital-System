module RegFile_tb ();

//parameters
parameter WIDTH = 16 ; 
parameter DEPTH = 8 ; 
parameter ADDR = 3 ;

//Testbench Signals
reg                 clk_TB;
reg                 rst_TB;
reg                 RdEn_TB;
reg                 WrEn_TB;
reg    [ADDR-1:0]   Address_TB;
reg    [WIDTH-1:0]  WrData_TB;
wire   [WIDTH-1:0]  RdData_TB;



//Initial 
initial
 begin

//initial values
clk_TB = 1'b0  ;
rst_TB = 1'b1  ;    // rst is deactivated
RdEn_TB = 1'b0 ;
WrEn_TB = 1'b0 ;

//Reset the design
#5
rst_TB = 1'b0;    // rst is activated
#5
rst_TB = 1'b1;    // rst is deactivated

//Register Write Operations
#10
WrEn_TB = 1'b1;
RdEn_TB = 1'b0 ;
Address_TB = 3'b11;
WrData_TB = 16'b001011;

#10
WrEn_TB = 1'b1;
RdEn_TB = 1'b0 ;
Address_TB = 3'b111;
WrData_TB = 16'b01;

#10
WrEn_TB = 1'b1;
RdEn_TB = 1'b0 ;
Address_TB = 3'b001;
WrData_TB = 16'b11100;

//Register Read Operations
#10
WrEn_TB = 1'b0 ;
RdEn_TB = 1'b1 ;
Address_TB = 3'b0011;
#10
 if(RdData_TB != 16'b001011)
   $display("READ Operation 1 IS Failed");
 else
   $display("READ Operation 1 IS Passed");
 

#10
WrEn_TB = 1'b0 ;
RdEn_TB = 1'b1 ;
Address_TB = 3'b001;
#10
 if(RdData_TB != 16'b11100)
   $display("READ Operation 2 IS Failed");
 else
   $display("READ Operation 2 IS Passed");


#10
WrEn_TB = 1'b0 ;
RdEn_TB = 1'b1 ;
Address_TB = 3'b111;
#10
 if(RdData_TB != 16'b1)
   $display("READ Operation 3 IS Failed");
 else
   $display("READ Operation 3 IS Passed");


#100

$stop ;

end


// Clock Generator
always #5 clk_TB = ~clk_TB ;


// Design Instaniation
RegFile DUT (
.clk(clk_TB),
.rst(rst_TB),
.RdEn(RdEn_TB),
.WrEn(WrEn_TB),
.Address(Address_TB),
.WrData(WrData_TB),
.RdData(RdData_TB)
);

endmodule