module Parity_Check #(parameter Data_Width = 8) (
    input wire [Data_Width-1:0] P_Data,
    input wire                  Sampled_Bit,
    input wire                  Par_En,
    input wire                  Par_Type,
    input wire                  clk,rst,
    output reg                  Par_Err
    );

// Internal Signals //

reg Par_bit;
wire Par_Err_Comb;

// Combinational Always to Calculate Parity Bit //

always @(*)
  begin
    case (Par_Type)
     1'b0: Par_bit = ^P_Data;	     // Even Parity
     1'b1: Par_bit = ~^P_Data;     // Odd Parity
    endcase
end

// Sequential Always //

always @(posedge clk or negedge rst) 
  begin
    if (!rst) 
      begin
        Par_Err <= 1'b0;
      end
    else if (Par_En)
      begin
        Par_Err <= Par_Err_Comb;
      end
  end

assign Par_Err_Comb = (Sampled_Bit == Par_bit)? 1'b0 : 1'b1;  // If The Values are Equal No Error

endmodule