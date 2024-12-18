
module FIFO_WR # (parameter FIFO_DEPTH = 8)

(
 input  wire                 W_CLK,
 input  wire                 W_RST,
 input  wire                 W_INC,
 input  wire      [3:0]      R_PTR, // 3-bits for address & 1-bit for comparison
 output wire      [3:0]      GREY_W_PTR,
 output wire      [2:0]      WR_ADDR,
 output wire                 FULL
);

// Internal Signal //

reg [3:0] W_PTR;

// Increment Write Pointer //

always @(posedge W_CLK or negedge W_RST)
  begin
  if (!W_RST)
    begin
    W_PTR <= 1'b0;
    end
  else if (W_INC && !FULL)
    begin
	  W_PTR <= W_PTR + 1'b1;
    end
end

assign GREY_W_PTR = W_PTR ^ (W_PTR>>1) ; // Grey Scale Write Pointer

assign WR_ADDR = W_PTR[2:0] ;            // Memory Write Address

assign FULL = (GREY_W_PTR[3] != R_PTR[3] && 
	             GREY_W_PTR[2] != R_PTR[2] &&
	             GREY_W_PTR[1:0] == W_PTR[1:0])? 1'b1 : 1'b0 ; // Full Flag

endmodule