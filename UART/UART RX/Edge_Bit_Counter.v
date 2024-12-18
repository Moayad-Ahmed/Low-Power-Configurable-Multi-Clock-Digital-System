module Edge_Bit_Counter #(parameter Prescale_Width = 6) (
    input wire [Prescale_Width-1:0]   Prescale,
    input wire                        Bit_Cnt_En,
    input wire                        clk,rst,
    output reg [Prescale_Width-1:0]   Edge_Cnt,
    output reg [3:0]                  Bit_Cnt
    );

// Sequential Always //

always @(posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        // reset
        Edge_Cnt <= 'b0;
        Bit_Cnt <= 'b0;
      end
    else if (Bit_Cnt_En)
      begin
        if (Edge_Cnt == Prescale - 1'b1)
          begin
            Edge_Cnt <= 'b0;
            Bit_Cnt <= Bit_Cnt + 1'b1;
          end
        else
          Edge_Cnt <= Edge_Cnt + 1'b1;
      end
    else
      begin
        Edge_Cnt <= 'b0;
        Bit_Cnt <= 'b0;
      end
end
endmodule