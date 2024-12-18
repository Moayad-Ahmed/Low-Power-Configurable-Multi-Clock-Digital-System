module Start_Check (
    input wire sampled_bit,
    input wire strt_chk_en,
    input wire clk,rst,
    output reg strt_glitch
    );

// Sequential Always //

always @(posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        strt_glitch <= 1'b0;
      end
    else if (strt_chk_en)
      begin
        strt_glitch <= sampled_bit; // If Sampled Bit 0 = No Glitch
      end
end

endmodule