
module SYS_TOP # ( parameter ALU_Width = 16, Data_Width = 8, Memo_Depth = 8, Prescale_Width = 6, Func_Width = 4, Addr_Width = 3 )
(
 input   wire                          RST_N,
 input   wire                          REF_CLK,
 input   wire                          UART_CLK,
 input   wire                          UART_RX_IN,
 output  wire                          UART_TX_O,
 output  wire                          parity_error,
 output  wire                          framing_error
);

///********************************************************///
//////////////////// Internal Connections ////////////////////
///********************************************************///

///////////////////// Clock MUX Outputs //////////////////////

wire    [Data_Width-1:0]    Rx_Div_Ratio ;

//////////////////// Clock Gating Outputs ////////////////////

wire                        ALU_GAT_CLK ;

////////////////// Pulse Generator Outputs ///////////////////

wire                        Rd_INC ;

//////////////// Reset Synchronizers Outputs /////////////////

wire                        SYNC_UART_RST ;
wire                        SYNC_REF_RST  ;

///////////////// Data Synchronizer Outputs //////////////////

wire    [Data_Width-1:0]    Sync_Rx_Out ;
wire                        Rx_V_Pulse  ;

//////////////////////// ALU Outputs /////////////////////////

wire    [ALU_Width-1:0]     ALU_OUT   ;
wire                        OUT_Valid ;

/////////////////// Clock Dividers Outputs ///////////////////

wire                        TX_CLK ;
wire                        RX_CLK ;

///////////////////// Async FIFO Outputs /////////////////////

wire    [Data_Width-1:0]    FIFO_RdData ;
wire                        FIFO_EMPTY  ;
wire                        FIFO_FULL   ;

//////////////////// UART Rx & Tx Outputs ////////////////////

wire    [Data_Width-1:0]    Rx_Par_Out ;
wire                        Rx_Data_V  ;
wire                        Tx_Busy    ;

///////////////// System Controller Outputs //////////////////

wire    [Data_Width-1:0]    FIFO_WrData ;
wire    [Data_Width-1:0]    Reg_WrData  ;
wire    [Addr_Width-1:0]    Address     ;
wire    [Func_Width-1:0]    ALU_FUN     ;
wire                        ALU_EN      ;
wire                        CLK_EN      ;
wire                        Wr_INC      ;
wire                        RdEn        ;
wire                        WrEn        ;
wire                        clk_div_en  ;

/////////////////// Register File Outputs ////////////////////

wire    [Data_Width-1:0]    UART_Config  ;
wire    [Data_Width-1:0]    Reg_RdData   ;
wire    [Data_Width-1:0]    Div_Ratio    ;
wire    [Data_Width-1:0]    Oper_A       ;
wire    [Data_Width-1:0]    Oper_B       ;
wire                        RdData_Valid ;


///********************************************************///
//////////////////// Reset Synchronizers /////////////////////
///********************************************************///

RST_SYNC U0_REF_RST_SYNC (
 .RST      (RST_N),
 .CLK      (REF_CLK),
 .SYNC_RST (SYNC_REF_RST)
 );

RST_SYNC U1_UART_RST_SYNC (
 .RST      (RST_N),
 .CLK      (UART_CLK),
 .SYNC_RST (SYNC_UART_RST)
 );

///********************************************************///
///////////////////// Data Synchronizers /////////////////////
///********************************************************///

DATA_SYNC U0_RX_DATA_SYNC (
 .CLK          (REF_CLK),
 .RST          (SYNC_REF_RST),
 .Sync_Bus     (Sync_Rx_Out),
 .Unsync_Bus   (Rx_Par_Out),
 .Bus_Enable   (Rx_Data_V),
 .Enable_Pulse (Rx_V_Pulse)
 );

///********************************************************///
///////////////////////// Async FIFO /////////////////////////
///********************************************************///

ASYNC_FIFO # ( .Data_Width (Data_Width),
	           .FIFO_Depth (Memo_Depth),
	           .Addr_Width (Addr_Width) )
U0_ASYNC_FIFO (
 .FULL    (FIFO_FULL),
 .EMPTY   (FIFO_EMPTY),
 .W_CLK   (REF_CLK),
 .W_RST   (SYNC_REF_RST),
 .W_INC   (Wr_INC),
 .R_CLK   (TX_CLK),
 .R_RST   (SYNC_UART_RST),
 .R_INC   (Rd_INC),
 .WR_DATA (FIFO_WrData),
 .RD_DATA (FIFO_RdData)
 );

///********************************************************///
/////////////////////// Pulse Generator //////////////////////
///********************************************************///

PULSE_GEN U0_PULSE_GEN (
 .clk       (TX_CLK),
 .rst       (SYNC_UART_RST),
 .lvl_sig   (Tx_Busy),
 .pulse_sig (Rd_INC)
 );

///********************************************************///
//////////////////// UART_TX Clock Divider ///////////////////
///********************************************************///

ClkDiv U0_TX_ClkDiv (
 .i_rst       (SYNC_UART_RST),
 .i_clk_en    (clk_div_en),
 .i_ref_clk   (UART_CLK),
 .o_div_clk   (TX_CLK),
 .i_div_ratio (Div_Ratio)
 );

///********************************************************///
////////////////////// Custom Mux Clock //////////////////////
///********************************************************///

CLKDIV_MUX U0_CLK_MUX (
 .IN  (UART_Config[7:2]),
 .OUT (Rx_Div_Ratio)
 );

///********************************************************///
//////////////////// UART_RX Clock Divider ///////////////////
///********************************************************///

ClkDiv U1_RX_ClkDiv (
 .i_rst       (SYNC_UART_RST),
 .i_clk_en    (clk_div_en),
 .i_ref_clk   (UART_CLK),
 .o_div_clk   (RX_CLK),
 .i_div_ratio (Rx_Div_Ratio)
 );

///********************************************************///
//////////////////////////// UART ////////////////////////////
///********************************************************///

UART # ( .Data_Width     (Data_Width),
	     .Prescale_Width (Prescale_Width) ) 
U0_UART (
 .RST         (SYNC_UART_RST),
 .TX_CLK      (TX_CLK),
 .RX_CLK      (RX_CLK),
 .PAR_EN      (UART_Config[0]),
 .PAR_TYP     (UART_Config[1]),
 .RX_IN_S     (UART_RX_IN),
 .TX_IN_V     (!FIFO_EMPTY),
 .TX_IN_P     (FIFO_RdData),
 .Prescale    (UART_Config[7:2]),
 .TX_OUT_V    (Tx_Busy),
 .TX_OUT_S    (UART_TX_O),
 .RX_OUT_V    (Rx_Data_V),
 .RX_OUT_P    (Rx_Par_Out),
 .PARITY_ERR  (parity_error),
 .FRAMING_ERR (framing_error)
 );


///********************************************************///
///////////////////// System Controller //////////////////////
///********************************************************///

SYS_CTRL # ( .ALU_Width  (ALU_Width),
	         .Data_Width (Data_Width),
	         .Addr_Width (Addr_Width),
	         .Func_Width (Func_Width) )
U0_SYS_CTRL (
 .RST          (SYNC_REF_RST),
 .CLK          (REF_CLK),
 .ALU_OUT      (ALU_OUT),
 .OUT_Valid    (OUT_Valid),
 .RdData       (Reg_RdData),
 .RdData_Valid (RdData_Valid),
 .RX_P_DATA    (Sync_Rx_Out),
 .RX_D_VLD     (Rx_V_Pulse),
 .FIFO_FULL    (FIFO_FULL),
 .ALU_FUN      (ALU_FUN),
 .ALU_EN       (ALU_EN),
 .CLK_EN       (CLK_EN),
 .Address      (Address),
 .WrData       (Reg_WrData),
 .RdEn         (RdEn),
 .WrEn         (WrEn),
 .TX_P_DATA    (FIFO_WrData),
 .TX_D_VLD     (Wr_INC),
 .clk_div_en   (clk_div_en)
 );

///********************************************************///
/////////////////////// Register File ////////////////////////
///********************************************************///

RegFile # ( .Addr  (Addr_Width),
	        .Data  (Data_Width),
            .Depth (Memo_Depth) )
U0_RegFile (
 .CLK          (REF_CLK),
 .RST          (SYNC_REF_RST),
 .WrEn         (WrEn),
 .RdEn         (RdEn),
 .REG0         (Oper_A),
 .REG1         (Oper_B),
 .REG2         (UART_Config),
 .REG3         (Div_Ratio),
 .WrData       (Reg_WrData),
 .RdData       (Reg_RdData),
 .Address      (Address),
 .RdData_Valid (RdData_Valid)
 );

///********************************************************///
//////////////////////////// ALU /////////////////////////////
///********************************************************///
 
ALU # ( .Op_Width (Data_Width),
	    .Out_Width (ALU_Width),
	    .Fun_Width (Func_Width) )
U0_ALU (
 .A         (Oper_A),
 .B         (Oper_B),
 .CLK       (ALU_GAT_CLK),
 .RST       (SYNC_REF_RST),
 .ENABLE    (ALU_EN),
 .ALU_FUN   (ALU_FUN),
 .ALU_OUT   (ALU_OUT),
 .OUT_VALID (OUT_Valid)
 );

///********************************************************///
//////////////////////// Clock Gating ////////////////////////
///********************************************************///

CLK_GATE U0_CLK_GATE (
 .CLK       (REF_CLK),
 .CLK_EN    (CLK_EN),
 .GATED_CLK (ALU_GAT_CLK)
);

endmodule