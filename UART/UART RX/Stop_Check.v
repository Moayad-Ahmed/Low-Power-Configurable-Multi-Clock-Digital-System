module Stop_Check (
    input wire sampled_bit,
    input wire stp_chk_en,
    input wire clk,rst,
    output reg stp_err
    );

// Sequential Always //

always @(posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        stp_err <= 1'b0;
      end
    else if (stp_chk_en)
      begin
        stp_err <= !sampled_bit;  // If Sampled Bit 1 = No Error
      end
end

endmodule