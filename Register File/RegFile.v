
module	RegFile # ( parameter Data = 8, Depth = 8, Addr = 3)

(
  input  wire                CLK,
  input  wire                RST,
  input  wire                WrEn,
  input  wire                RdEn,
  input  wire   [Addr-1:0]   Address,      // 3-bit Address bus to address 8 Registers
  input  wire   [Data-1:0]   WrData,       // 8-bit Write data bus
  output reg    [Data-1:0]   RdData,       // 8-bit Read data bus
  output wire   [Data-1:0]   REG0,         // Reserved for ALU Operand A
  output wire   [Data-1:0]   REG1,         // Reserved for ALU Operand B
  output wire   [Data-1:0]   REG2,         // Reserved for UART Configuration
  output wire   [Data-1:0]   REG3,         // Reserved for TX Clock Divide Ratio
  output reg                 RdData_Valid
);

reg [Data-1:0] RegMem [Depth-1:0];         // Register File: 8 Registers of 8-bit Width

integer I;

always @(posedge CLK or negedge RST)
  begin
  if (!RST)
    begin 			    // Asynchronous active low reset: Clear Registers
      RdData <= 'b0;
      RdData_Valid <= 1'b0;
      for ( I = 0 ; I < Depth ; I = I + 1 )
        begin
        if (I == 2)
          RegMem[I] <= 'b100000_01; //  Prescale: 32 & Parity Type: Even & Parity Enable: On
        else if (I == 3)
          RegMem[I] <= 'b00_100000; // TX Clock Division Ratio: 32
        else
          RegMem[I] <= 'b0;         // Reset remaining Registers
        end
    end
  else if (WrEn && !RdEn)		        // Can't Read and Write in the same time
    begin
      // Write operation
      RegMem[Address] <= WrData;
    end
  else if (RdEn && !WrEn)		        // Can't Read and Write in the same time
    begin
      // Read operation
      RdData <= RegMem[Address];
      RdData_Valid <= 1'b1;
    end
  else
    begin
      RdData <= 'b0;        // Output 0 when not reading
      RdData_Valid <= 1'b0;
    end
end

assign REG0 = RegMem[0] ;
assign REG1 = RegMem[1] ;
assign REG2 = RegMem[2] ;
assign REG3 = RegMem[3] ;

endmodule