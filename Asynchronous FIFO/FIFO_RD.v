
module FIFO_RD # (parameter FIFO_DEPTH = 8)

(
 input  wire                 R_CLK,
 input  wire                 R_RST,
 input  wire                 R_INC,
 input  wire      [3:0]      W_PTR, // 3-bits for address & 1-bit for comparison
 output wire      [3:0]      GREY_R_PTR,
 output wire      [2:0]      RD_ADDR,
 output wire                 EMPTY
);

// Internal Signals //

reg [3:0] R_PTR;

// Increment Read Pointer //

always @(posedge R_CLK or negedge R_RST)
  begin
  if (!R_RST)
    begin
    R_PTR <= 1'b0;
    end
  else if (R_INC && !EMPTY)
    begin
	  R_PTR <= R_PTR + 1'b1;
    end
end

assign GREY_R_PTR = R_PTR ^ (R_PTR>>1) ;  // Grey Scale Read Pointer

assign RD_ADDR = R_PTR[2:0] ;             // Memory Read Address

assign EMPTY = (GREY_R_PTR[3:0] == W_PTR[3:0])? 1'b1 : 1'b0 ; // Empty Flag

endmodule