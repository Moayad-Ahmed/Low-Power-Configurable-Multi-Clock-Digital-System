module Deserializer #(parameter Data_Width = 8, Prescale_Width = 6) (
    input wire                      Sampled_Bit,
    input wire                      Deser_En,
    input wire [Prescale_Width-1:0] Prescale,
    input wire [Prescale_Width-1:0] Edge_Cnt,
    input wire                      clk,rst,
    output reg [Data_Width-1:0]     P_Data
    );

// Internal Signals //

wire Sample_Ready;

// Sequential Always //

always @(posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        P_Data <= 'b0;
      end
    else if (Deser_En && Sample_Ready)
      begin
        P_Data <= {Sampled_Bit,P_Data[Data_Width-1:1]}; 
      end
end

assign Sample_Ready = (Edge_Cnt == ((Prescale >> 1) + 3));

endmodule