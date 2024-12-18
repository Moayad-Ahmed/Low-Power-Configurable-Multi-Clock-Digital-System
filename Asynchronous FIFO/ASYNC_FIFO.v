
module ASYNC_FIFO # (parameter Data_Width = 8, FIFO_Depth = 8, Addr_Width = 3)

(
 input  wire                          W_CLK,
 input  wire                          W_RST,
 input  wire                          W_INC,
 input  wire                          R_CLK,
 input  wire                          R_RST,
 input  wire                          R_INC,
 input  wire     [Data_Width-1:0]     WR_DATA,
 output wire     [Data_Width-1:0]     RD_DATA,
 output wire                          EMPTY,
 output wire                          FULL
);

// Internal Connections //

wire        [2:0]         WR_ADDR;
wire        [2:0]         RD_ADDR;
wire        [3:0]         W_GRPTR;
wire        [3:0]         R_GWPTR;
wire        [3:0]         GREY_W_PTR;
wire        [3:0]         GREY_R_PTR;

// FIFO Memory Instantiation //

FIFO_MEM_CNTRL # (.Data_Width(Data_Width), .FIFO_DEPTH(FIFO_Depth), .Address(Addr_Width)) U_FIFO_MEM (
 .W_CLK(W_CLK),
 .W_RST(W_RST),
 .WR_DATA(WR_DATA),
 .WR_ADDR(WR_ADDR),
 .RD_DATA(RD_DATA),
 .RD_ADDR(RD_ADDR),
 .W_CKEN(W_INC & !FULL)
);

// FIFO Write Address Instantiation //

FIFO_WR U_FIFO_WR (
 .FULL(FULL),
 .W_CLK(W_CLK),
 .W_RST(W_RST),
 .W_INC(W_INC),
 .R_PTR(W_GRPTR),
 .WR_ADDR(WR_ADDR),
 .GREY_W_PTR(GREY_W_PTR)
 );

// Write Pointer Synchronizer //

DF_SYNC U_SYNC_W2R (
 .CLK(R_CLK),
 .RST(R_RST),
 .SYNC_DATA(R_GWPTR),
 .ASYNC_DATA(GREY_W_PTR)
 );

// FIFO Read Address Instantiation //

FIFO_RD U_FIFO_RD (
 .EMPTY(EMPTY),
 .R_CLK(R_CLK),
 .R_RST(R_RST),
 .R_INC(R_INC),
 .W_PTR(R_GWPTR),
 .RD_ADDR(RD_ADDR),
 .GREY_R_PTR(GREY_R_PTR)
 );

// Read Pointer Synchronizer //

DF_SYNC U_SYNC_R2W (
 .CLK(W_CLK),
 .RST(W_RST),
 .SYNC_DATA(W_GRPTR),
 .ASYNC_DATA(GREY_R_PTR)
 );

endmodule