module UART_MUX (
    input wire [1:0] Mux_Sel,
    input wire Ser_Data,
    input wire Par_bit,
    input wire clk,rst,
    output reg TX_Out
    );

// Local Patameters //

localparam Start_bit = 1'b0,
           Stop_bit = 1'b1;

// Internal Signals //

reg TX_Out_Comb;     // To Separate Comb & Seq Always

// Combinational Always //

always @(*)
  begin
    case (Mux_Sel)
     2'b00: TX_Out_Comb = Start_bit; 
     2'b01: TX_Out_Comb = Ser_Data;
     2'b10: TX_Out_Comb = Par_bit;
     2'b11: TX_Out_Comb = Stop_bit;
    endcase
  end

// Sequential Always //  

always @(posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        TX_Out <= Stop_bit;
      end
    else
      begin
        TX_Out <= TX_Out_Comb;
      end
  end
endmodule