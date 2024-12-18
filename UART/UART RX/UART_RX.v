
module UART_RX # (parameter Data_Width = 8, Prescale_Width = 6)

(
  input  wire                            clk,
  input  wire                            rst,
  input  wire                            RX_In,
  input  wire                            Par_En,
  input  wire                            Par_Type,
  input  wire  [Prescale_Width-1:0]      Prescale,
  output wire  [Data_Width-1:0]          P_Data,
  output wire                            Data_Valid,
  output wire                            Parity_Error,
  output wire                            Framing_Error
);

// Internal Signals //

wire    [3:0]      Bit_Cnt;
wire    [5:0]      Edge_Cnt;
wire               Deser_En;
wire               Bit_Cnt_En;
wire               Sampled_Bit;
wire               strt_chk_en;
wire               strt_glitch;
wire               stp_chk_en;
wire               par_chk_en;
wire               Data_Samp_En;

// Finite State Machine Instantiation //

UART_RX_FSM U_RX_FSM (
 .clk(clk),
 .rst(rst),
 .RX_In(RX_In),
 .Par_En(Par_En),
 .Bit_Cnt(Bit_Cnt),
 .Edge_Cnt(Edge_Cnt),
 .Deser_En(Deser_En),
 .Prescale(Prescale),
 .Par_Err(Parity_Error),
 .Stp_Err(Framing_Error),
 .par_chk_en(par_chk_en),
 .stp_chk_en(stp_chk_en),
 .Bit_Cnt_En(Bit_Cnt_En),
 .Data_Valid(Data_Valid),
 .Strt_Glitch(strt_glitch),
 .strt_chk_en(strt_chk_en),
 .Data_Samp_En(Data_Samp_En)
);

// Parity Checker Instantiation //

Parity_Check #(.Data_Width(Data_Width)) U_Parity_Check (
 .clk(clk),
 .rst(rst),
 .P_Data(P_Data),
 .Par_En(par_chk_en),
 .Par_Type(Par_Type),
 .Par_Err(Parity_Error),
 .Sampled_Bit(Sampled_Bit)
 );

// Data Sampling Instantiation //

Data_Sampling #(.Prescale_Width(Prescale_Width)) U_Sampler (
 .clk(clk),
 .rst(rst),
 .RX_In(RX_In),
 .Prescale(Prescale),
 .Edge_Cnt(Edge_Cnt),
 .Sampled_Bit(Sampled_Bit),
 .Data_Samp_En(Data_Samp_En)
 );

// Edge Bit Counter Instatiation //

Edge_Bit_Counter #(.Prescale_Width(Prescale_Width)) U_Counter (
 .clk(clk),
 .rst(rst),
 .Bit_Cnt(Bit_Cnt),
 .Edge_Cnt(Edge_Cnt),
 .Prescale(Prescale),
 .Bit_Cnt_En(Bit_Cnt_En)
 );

// Deserializer Instantiation //

Deserializer #(.Data_Width(Data_Width), .Prescale_Width(Prescale_Width)) U_Deserializer (
 .clk(clk),
 .rst(rst),
 .P_Data(P_Data),
 .Prescale(Prescale),
 .Edge_Cnt(Edge_Cnt),
 .Deser_En(Deser_En),
 .Sampled_Bit(Sampled_Bit)
 );

// Start Check Instantiation //

Start_Check U_Start (
 .clk(clk),
 .rst(rst),
 .sampled_bit(Sampled_Bit),
 .strt_chk_en(strt_chk_en),
 .strt_glitch(strt_glitch)
 );

// Stop Check Instantiation //

Stop_Check U_Stop (
 .clk(clk),
 .rst(rst),
 .stp_err(Framing_Error),
 .stp_chk_en(stp_chk_en),
 .sampled_bit(Sampled_Bit)
 );

endmodule