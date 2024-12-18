module Parity_Calc #(parameter Data_Width = 8) (
    input wire [Data_Width-1:0] P_Data,
    input wire                  Par_Type,
    input wire                  Par_En,
    input wire                  Busy,
    input wire                  Data_Valid,
    input wire                  clk,rst,
    output reg                  Par_bit
    );

// Internal Signals //

reg Par_bit_Comb;
reg [Data_Width-1:0] Store_Data;

// Combinational Always //

always @(*)
  begin
    case (Par_Type)
     1'b0: Par_bit_Comb = ^Store_Data;	    // Even Parity
     1'b1: Par_bit_Comb = ~^Store_Data;     // Odd Parity
    endcase
end

// Sequential Always to Store Data //

always @(posedge clk or negedge rst)
  begin
    if (!rst) 
      begin
        // reset
        Store_Data <= 'b0;
      end
    else if (Data_Valid && !Busy) 
      begin
        Store_Data <= P_Data;
      end
  end

// Sequential Always of Output //

always @(posedge clk or negedge rst) 
  begin
    if (!rst) 
      begin
        Par_bit <= 1'b1;
      end
    else if (Par_En)
      begin
        Par_bit <= Par_bit_Comb;
      end
  end
endmodule