
module SYS_CTRL # (parameter ALU_Width = 16, Data_Width = 8, Func_Width = 4,  Addr_Width = 3)

(
  input wire                      CLK,
  input wire                      RST,
  input wire   [ALU_Width-1:0]    ALU_OUT,
  input wire                      OUT_Valid,
  input wire   [Data_Width-1:0]   RdData,
  input wire                      RdData_Valid,
  input wire   [Data_Width-1:0]   RX_P_DATA,
  input wire                      RX_D_VLD,
  input wire                      FIFO_FULL,
  output reg   [Func_Width-1:0]   ALU_FUN,
  output reg                      ALU_EN,
  output reg                      CLK_EN,
  output reg   [Addr_Width-1:0]   Address,
  output reg                      RdEn,
  output reg   [Data_Width-1:0]   WrData,
  output reg                      WrEn,
  output reg   [Data_Width-1:0]   TX_P_DATA,
  output reg                      TX_D_VLD,
  output reg                      clk_div_en
);

// Gray Code System States Encoding //

typedef enum bit [3:0] 
{
  Idle_State  = 4'b0000,     // Idle State of The System
  RF_Wr_Addr  = 4'b0001,
  RF_Wr_Data  = 4'b0011,
  RF_Rd_Addr  = 4'b0010,
  RF_Rd_Out   = 4'b0110,
  ALU_Op_A    = 4'b0111,
  ALU_Op_B    = 4'b0101,
  ALU_Func    = 4'b0100,
  ALU_0to7    = 4'b1100,
  ALU_8to15   = 4'b1101
} state;

// System State Signals //

state Current_State;
state Next_State;

// System Commands Encoding //

localparam RF_Wr_CMD   = 8'hAA;
localparam RF_Rd_CMD   = 8'hBB;
localparam ALU_OP_CMD  = 8'hCC;
localparam ALU_NOP_CMD = 8'hDD;

// Internal Connections //

reg   [Addr_Width-1:0]   Addr_Reg; // Register to Store Address
reg   [Func_Width-1:0]   Func_Reg; // Register to Store Function

wire   Addr_Change;          // Flag When to Store The Address
wire   Func_Change;          // Flag When to Store The Function

// State Transition Sequential Always Block //

always @(posedge CLK or negedge RST) 
  begin
    if (!RST) 
      begin
        Current_State <= Idle_State;
      end
    else
      begin
        Current_State <= Next_State;
      end
end

// Next State Logic Combinational Always Block//

always @(*)
  begin
    case (Current_State)
     Idle_State: begin
                   if (RX_D_VLD)
                     case (RX_P_DATA)
                      RF_Wr_CMD:   Next_State = RF_Wr_Addr;
                      RF_Rd_CMD:   Next_State = RF_Rd_Addr;
                      ALU_OP_CMD:  Next_State = ALU_Op_A;
                      ALU_NOP_CMD: Next_State = ALU_Func;
                      default:     Next_State = Idle_State;
                     endcase
                   else
                     Next_State = Idle_State;
                 end
     RF_Wr_Addr: begin
                   if (RX_D_VLD)
                     Next_State = RF_Wr_Data;
                   else
                     Next_State = RF_Wr_Addr;
                 end
     RF_Wr_Data: begin
                   if (RX_D_VLD)
                     Next_State = Idle_State;
                   else
                     Next_State = RF_Wr_Data;
                 end
     RF_Rd_Addr: begin
                   if (RX_D_VLD)
                     Next_State = RF_Rd_Out;
                   else
                     Next_State = RF_Rd_Addr;
                 end
     RF_Rd_Out:  begin
                   if (RdData_Valid && !FIFO_FULL)
                     Next_State = Idle_State;
                   else
                     Next_State = RF_Rd_Out;
                 end
     ALU_Op_A:   begin
                   if (RX_D_VLD)
                     Next_State = ALU_Op_B;
                   else
                     Next_State = ALU_Op_A;
                 end
     ALU_Op_B:   begin
                   if (RX_D_VLD)
                     Next_State = ALU_Func;
                   else
                     Next_State = ALU_Op_B;
                 end
     ALU_Func:   begin
                   if (RX_D_VLD)
                     Next_State = ALU_0to7;
                   else
                     Next_State = ALU_Func;
                 end
     ALU_0to7:    begin
                   if (OUT_Valid && !FIFO_FULL)
                     Next_State = ALU_8to15;
                   else
                     Next_State = ALU_0to7;
                 end
     ALU_8to15:  begin
                   if (!FIFO_FULL)
                     Next_State = Idle_State;
                   else
                     Next_State = ALU_8to15;
                 end
     default:    Next_State = Idle_State;
    endcase
end

// Output Logic Combinational Always Block //

always @(*)
  begin
    Address     = Addr_Reg;
    WrEn        = 1'b0;
    RdEn        = 1'b0;
    WrData      = 1'b0;
    ALU_EN      = 1'b0;
    CLK_EN      = 1'b0;
    ALU_FUN     = 1'b0;
    TX_D_VLD    = 1'b0;
    TX_P_DATA   = 1'b0;
    clk_div_en  = 1'b1;      // Clock Divider Enable Always 1 as it Drives the UART (Interface with User)
    case (Current_State)
     Idle_State: begin
                   WrEn        = 1'b0;
                   RdEn        = 1'b0;
                   WrData      = 1'b0;
                   ALU_EN      = 1'b0;
                   CLK_EN      = 1'b0;
                   Address     = 1'b0;
                   ALU_FUN     = 1'b0;
                   TX_D_VLD    = 1'b0;
                   TX_P_DATA   = 1'b0;
                 end
     RF_Wr_Addr: begin
                   if (RX_D_VLD)
                     begin
                     Address = RX_P_DATA;
                     end
                   else
                     begin
                     Address = 1'b0;
                     end
                 end
     RF_Wr_Data: begin
                   if (RX_D_VLD)
                     begin
                     RdEn = 1'b0;
                     WrEn = 1'b1;
                     WrData = RX_P_DATA;
                     Address = Addr_Reg;
                     end
                   else
                     begin
                     RdEn = 1'b0;
                     WrEn = 1'b0;
                     WrData = 1'b0;
                     Address = Addr_Reg;
                     end
                 end
     RF_Rd_Addr: begin
                   if (RX_D_VLD)
                     begin
                     WrEn = 1'b0;
                     RdEn = 1'b1;
                     Address = RX_P_DATA;
                     end
                   else
                     begin
                     WrEn = 1'b0;
                     RdEn = 1'b0;
                     Address = 1'b0;
                     end
                 end
     RF_Rd_Out:  begin
                   if (RdData_Valid && !FIFO_FULL)
                     begin
                     Address = 1'b0;
                     TX_D_VLD = 1'b1;
                     TX_P_DATA = RdData;
                     end
                   else
                     begin
                     Address = Addr_Reg;
                     TX_D_VLD = 1'b0;
                     TX_P_DATA = 1'b0;
                     end
                 end
     ALU_Op_A:   begin
                   if (RX_D_VLD)
                     begin
                     RdEn = 1'b0;
                     WrEn = 1'b1;
                     WrData = RX_P_DATA;
                     Address = 3'b000;
                     end
                   else
                     begin
                     RdEn = 1'b0;
                     WrEn = 1'b0;
                     WrData = 1'b0;
                     Address = 1'b0;
                     end
                 end
     ALU_Op_B:   begin
                   if (RX_D_VLD)
                     begin
                     RdEn = 1'b0;
                     WrEn = 1'b1;
                     WrData = RX_P_DATA;
                     Address = 3'b001;
                     end
                   else
                     begin
                     RdEn = 1'b0;
                     WrEn = 1'b0;
                     WrData = 1'b0;
                     end
                 end
     ALU_Func:   begin
                   CLK_EN = 1'b1;
                   ALU_EN = 1'b1;
                   if (RX_D_VLD)
                     ALU_FUN = RX_P_DATA;
                   else
                     ALU_FUN = 4'b1111;   // No Operation ALU Output = 0
                 end
     ALU_0to7:   begin
                   CLK_EN = 1'b1;
                   ALU_EN = 1'b1;
                   ALU_FUN = Func_Reg;
                   if (OUT_Valid && !FIFO_FULL)
                     begin
                     TX_D_VLD = 1'b1;
                     TX_P_DATA = ALU_OUT[Data_Width-1:0];
                     end
                   else
                     begin
                     TX_D_VLD = 1'b0;
                     TX_P_DATA = 1'b0;
                     end
                 end
     ALU_8to15:  begin
                   CLK_EN = 1'b1;
                   ALU_EN = 1'b1;        // To Keep the Same ALU Output Value
                   ALU_FUN = Func_Reg;
                   TX_D_VLD = 1'b1;
                   TX_P_DATA = ALU_OUT[ALU_Width-1:Data_Width];
                 end
     default:    begin
                   WrEn        = 1'b0;
                   RdEn        = 1'b0;
                   WrData      = 1'b0;
                   ALU_EN      = 1'b0;
                   CLK_EN      = 1'b0;
                   ALU_FUN     = 1'b0;
                   Address     = 1'b0;
                   TX_D_VLD    = 1'b0;
                   TX_P_DATA   = 1'b0;
                   clk_div_en  = 1'b1;
                 end
    endcase
end

// Sequential Always Block to Store Address //

always @(posedge CLK or negedge RST) 
  begin
    if (!RST) 
      begin
        Addr_Reg <= 1'b0;
      end
    else if (Addr_Change)
      begin
        Addr_Reg <= RX_P_DATA;
      end
end

assign Addr_Change = (RX_D_VLD && ((Current_State == RF_Wr_Addr) || (Current_State == RF_Rd_Addr))) ; // Implementing Address Register Flag Logic

// Sequential Always Block to Store ALU Function //

always @(posedge CLK or negedge RST) 
  begin
    if (!RST) 
      begin
        Func_Reg <= 1'b0;
      end
    else if (Func_Change)
      begin
        Func_Reg <= RX_P_DATA;
      end
end

assign Func_Change = (RX_D_VLD && (Current_State == ALU_Func)) ; // Implementing Function Register Flag Logic

endmodule