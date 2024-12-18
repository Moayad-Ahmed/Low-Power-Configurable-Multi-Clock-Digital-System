
module UART_TX #(parameter Data_Width = 8)

(
  input  wire   [Data_Width-1:0]   P_Data,
  input  wire                      Data_Valid,
  input  wire                      Par_En,
  input  wire                      Par_Type,
  input  wire                      clk,
  input  wire                      rst,
  output wire                      TX_Out,
  output wire                      Busy
);

// Internal Signals //

wire Ser_En, Ser_Data, Ser_Done, Par_bit;
wire [1:0] Mux_Sel;

// Serializer Unit Instantiation //

Serializer #(.Data_Width(Data_Width)) U_Serializer (
    .clk(clk),
    .rst(rst),
    .Busy(Busy),
    .P_Data(P_Data),
    .Ser_En(Ser_En),
    .Ser_Data(Ser_Data),
    .Ser_Done(Ser_Done),
    .Data_Valid(Data_Valid)
    );

// UART Finite State Machine Instanitation //

UART_TX_FSM U_TX_FSM (
    .clk(clk),
    .rst(rst),
    .Busy(Busy),
    .Par_En(Par_En),
    .Ser_En(Ser_En),
    .Mux_Sel(Mux_Sel),
    .Ser_Done(Ser_Done),
    .Data_Valid(Data_Valid)
    );

// Parity Calculator Instantiation //

Parity_Calc #(.Data_Width(Data_Width)) U_Parity (
    .clk(clk),
    .rst(rst),
    .Busy(Busy),
    .P_Data(P_Data),
    .Par_En(Par_En),
    .Par_bit(Par_bit),
    .Par_Type(Par_Type),
    .Data_Valid(Data_Valid)
    );

// UART Multiplexer Instantiation //

UART_MUX U_MUX (
    .clk(clk),
    .rst(rst),
    .TX_Out(TX_Out),
    .Mux_Sel(Mux_Sel),
    .Par_bit(Par_bit),
    .Ser_Data(Ser_Data)
    );

endmodule