module Data_Sampling #(parameter Prescale_Width = 6) (
    input wire                      RX_In,
    input wire                      Data_Samp_En,
    input wire [Prescale_Width-1:0] Edge_Cnt,
    input wire [Prescale_Width-1:0] Prescale,
    input wire                      clk,rst,
    output reg                      Sampled_Bit
    );

// Internal Signals //

wire [4:0] Mid_Sample;

reg Sample1, Sample2, Sample3;

always @(posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        Sampled_Bit <= 1'b1;
        Sample1 <= 1'b1;
        Sample2 <= 1'b1;
        Sample3 <= 1'b1;
      end
    else if (Data_Samp_En)
      begin
        if (Edge_Cnt == Mid_Sample - 1'b1)
          Sample1 <= RX_In;
        else if (Edge_Cnt == Mid_Sample)
          Sample2 <= RX_In;
        else if (Edge_Cnt == Mid_Sample + 1'b1)
          Sample3 <= RX_In;
        else if (Edge_Cnt == Mid_Sample + 'd2)
          Sampled_Bit <= (Sample1 & Sample2) | (Sample2 & Sample3) | (Sample1 & Sample3);
      end
end

assign Mid_Sample = (Prescale >> 1) - 1'b1;

endmodule