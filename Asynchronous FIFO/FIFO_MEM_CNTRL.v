
module FIFO_MEM_CNTRL # (parameter Data_Width = 8, FIFO_DEPTH = 8, Address = 3)

(
 input  wire                          W_CLK,
 input  wire                          W_RST,
 input  wire                          W_CKEN,
 input  wire     [Address-1:0]        WR_ADDR,
 input  wire     [Address-1:0]        RD_ADDR,
 input  wire     [Data_Width-1:0]     WR_DATA,
 output wire     [Data_Width-1:0]     RD_DATA
);

// Register File of 8 Registers each of 8-bits width

reg [Data_Width-1:0] FIFO_MEM [FIFO_DEPTH-1:0];

integer i;

// Write Operation Always Block //

always @(posedge W_CLK or negedge W_RST)
  begin
  if (!W_RST)
    begin
    // Reset Memory
    for (i=0 ; i<FIFO_DEPTH ; i=i+1)
      begin
      FIFO_MEM[i] <= 'b0;
      end 	
    end
  else if (W_CKEN)
    begin
    FIFO_MEM[WR_ADDR] <= WR_DATA;
    end
end

// Read Operation (Combinational) //

assign RD_DATA = FIFO_MEM[RD_ADDR];

endmodule