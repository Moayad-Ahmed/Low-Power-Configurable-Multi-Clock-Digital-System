onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {TestBench Signals} -color Red -itemcolor Red -radix binary -radixshowbase 1 /SYS_TOP_TB/RST_N_TB
add wave -noupdate -expand -group {TestBench Signals} -color Cyan -itemcolor Cyan -radix binary -radixshowbase 1 /SYS_TOP_TB/REF_CLK_TB
add wave -noupdate -expand -group {TestBench Signals} -color Cyan -itemcolor Cyan -radix binary -radixshowbase 1 /SYS_TOP_TB/UART_CLK_TB
add wave -noupdate -expand -group {TestBench Signals} -color Cyan -itemcolor Cyan -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_UART/TX_CLK
add wave -noupdate -expand -group {TestBench Signals} -color Gold -itemcolor Gold -radix binary -radixshowbase 1 /SYS_TOP_TB/UART_RX_IN_TB
add wave -noupdate -expand -group {TestBench Signals} -color Gold -itemcolor Gold -radix binary -radixshowbase 1 /SYS_TOP_TB/UART_TX_O_TB
add wave -noupdate -expand -group {TestBench Signals} -color Gold -itemcolor Gold /SYS_TOP_TB/Gener_Out
add wave -noupdate -expand -group {TestBench Signals} -color Magenta -itemcolor Magenta -radix binary -radixshowbase 1 /SYS_TOP_TB/parity_error_tb
add wave -noupdate -expand -group {TestBench Signals} -color Magenta -itemcolor Magenta -radix binary -radixshowbase 1 /SYS_TOP_TB/framing_error_tb
add wave -noupdate -expand -group {UART RX Signals} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_UART/RX_OUT_V
add wave -noupdate -expand -group {UART RX Signals} -radix hexadecimal -radixshowbase 1 /SYS_TOP_TB/DUT/U0_UART/RX_OUT_P
add wave -noupdate -group {Data Synchronizer} -radix unsigned -radixshowbase 1 /SYS_TOP_TB/DUT/U0_RX_DATA_SYNC/Unsync_Bus
add wave -noupdate -group {Data Synchronizer} /SYS_TOP_TB/DUT/U0_RX_DATA_SYNC/Bus_Enable
add wave -noupdate -group {Data Synchronizer} /SYS_TOP_TB/DUT/U0_RX_DATA_SYNC/Enable_Pulse
add wave -noupdate -group {Data Synchronizer} /SYS_TOP_TB/DUT/U0_RX_DATA_SYNC/Sync_Bus
add wave -noupdate -expand -group {System Controller} /SYS_TOP_TB/DUT/U0_SYS_CTRL/ALU_OUT
add wave -noupdate -expand -group {System Controller} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_SYS_CTRL/OUT_Valid
add wave -noupdate -expand -group {System Controller} -color Magenta -itemcolor Magenta /SYS_TOP_TB/DUT/U0_SYS_CTRL/RX_P_DATA
add wave -noupdate -expand -group {System Controller} -color Magenta -itemcolor Magenta -radix binary /SYS_TOP_TB/DUT/U0_SYS_CTRL/RX_D_VLD
add wave -noupdate -expand -group {System Controller} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_SYS_CTRL/FIFO_FULL
add wave -noupdate -expand -group {System Controller} -color Gold -itemcolor Gold /SYS_TOP_TB/DUT/U0_SYS_CTRL/ALU_FUN
add wave -noupdate -expand -group {System Controller} -color Gold -itemcolor Gold -radix binary /SYS_TOP_TB/DUT/U0_SYS_CTRL/ALU_EN
add wave -noupdate -expand -group {System Controller} -color Gold -itemcolor Gold -radix binary /SYS_TOP_TB/DUT/U0_SYS_CTRL/CLK_EN
add wave -noupdate -expand -group {System Controller} -color Cyan -itemcolor Cyan /SYS_TOP_TB/DUT/U0_SYS_CTRL/RdData
add wave -noupdate -expand -group {System Controller} -color Cyan -itemcolor Cyan -radix binary /SYS_TOP_TB/DUT/U0_SYS_CTRL/RdData_Valid
add wave -noupdate -expand -group {System Controller} -color Cyan -itemcolor Cyan /SYS_TOP_TB/DUT/U0_SYS_CTRL/Address
add wave -noupdate -expand -group {System Controller} -color Cyan -itemcolor Cyan -radix binary /SYS_TOP_TB/DUT/U0_SYS_CTRL/RdEn
add wave -noupdate -expand -group {System Controller} -color Cyan -itemcolor Cyan /SYS_TOP_TB/DUT/U0_SYS_CTRL/WrData
add wave -noupdate -expand -group {System Controller} -color Cyan -itemcolor Cyan -radix binary /SYS_TOP_TB/DUT/U0_SYS_CTRL/WrEn
add wave -noupdate -expand -group {System Controller} /SYS_TOP_TB/DUT/U0_SYS_CTRL/TX_P_DATA
add wave -noupdate -expand -group {System Controller} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_SYS_CTRL/TX_D_VLD
add wave -noupdate -expand -group {System Controller} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_SYS_CTRL/clk_div_en
add wave -noupdate -expand -group {System Controller} -color Red -itemcolor Red /SYS_TOP_TB/DUT/U0_SYS_CTRL/Current_State
add wave -noupdate -expand -group {System Controller} -color Red -itemcolor Red /SYS_TOP_TB/DUT/U0_SYS_CTRL/Next_State
add wave -noupdate -group {Register File} /SYS_TOP_TB/DUT/U0_RegFile/RdData
add wave -noupdate -group {Register File} -color Gold -itemcolor Gold -radix unsigned -radixshowbase 1 /SYS_TOP_TB/DUT/U0_RegFile/REG0
add wave -noupdate -group {Register File} -color Gold -itemcolor Gold -radix unsigned -radixshowbase 1 /SYS_TOP_TB/DUT/U0_RegFile/REG1
add wave -noupdate -group {Register File} -color Cyan -itemcolor Cyan /SYS_TOP_TB/DUT/U0_RegFile/RdData_Valid
add wave -noupdate -group {Register File} -childformat {{{/SYS_TOP_TB/DUT/U0_RegFile/RegMem[7]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_RegFile/RegMem[6]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_RegFile/RegMem[5]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_RegFile/RegMem[4]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_RegFile/RegMem[3]} -radix unsigned}} -subitemconfig {{/SYS_TOP_TB/DUT/U0_RegFile/RegMem[7]} {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal -radixshowbase 1} {/SYS_TOP_TB/DUT/U0_RegFile/RegMem[6]} {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal -radixshowbase 1} {/SYS_TOP_TB/DUT/U0_RegFile/RegMem[5]} {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal -radixshowbase 1} {/SYS_TOP_TB/DUT/U0_RegFile/RegMem[4]} {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal -radixshowbase 1} {/SYS_TOP_TB/DUT/U0_RegFile/RegMem[3]} {-color Red -height 15 -itemcolor Red -radix unsigned} {/SYS_TOP_TB/DUT/U0_RegFile/RegMem[2]} {-color Red -height 15 -itemcolor Red} {/SYS_TOP_TB/DUT/U0_RegFile/RegMem[1]} {-color Gold -height 15 -itemcolor Gold} {/SYS_TOP_TB/DUT/U0_RegFile/RegMem[0]} {-color Gold -height 15 -itemcolor Gold}} /SYS_TOP_TB/DUT/U0_RegFile/RegMem
add wave -noupdate -group {ALU Signals} -radix unsigned -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ALU/A
add wave -noupdate -group {ALU Signals} -radix unsigned -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ALU/B
add wave -noupdate -group {ALU Signals} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ALU/ENABLE
add wave -noupdate -group {ALU Signals} -color Gold -itemcolor Gold -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ALU/ALU_FUN
add wave -noupdate -group {ALU Signals} -color Cyan -itemcolor Cyan -radix unsigned -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ALU/ALU_OUT
add wave -noupdate -group {ALU Signals} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ALU/OUT_VALID
add wave -noupdate -group {Async FIFO} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/W_INC
add wave -noupdate -group {Async FIFO} -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/R_INC
add wave -noupdate -group {Async FIFO} -color Cyan -itemcolor Cyan -radix hexadecimal -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/WR_DATA
add wave -noupdate -group {Async FIFO} -color Cyan -itemcolor Cyan -radix hexadecimal -radixshowbase 1 /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/RD_DATA
add wave -noupdate -group {Async FIFO} -color Gold -itemcolor Gold -radix binary -radixshowbase 0 /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/EMPTY
add wave -noupdate -group {Async FIFO} -color Gold -itemcolor Gold -radix binary -radixshowbase 0 /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/FULL
add wave -noupdate -group {Async FIFO} /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/WR_ADDR
add wave -noupdate -group {Async FIFO} /SYS_TOP_TB/DUT/U0_ASYNC_FIFO/RD_ADDR
add wave -noupdate -group {UART TX Signals} -color Cyan -itemcolor Cyan -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_UART/TX_IN_V
add wave -noupdate -group {UART TX Signals} -radix hexadecimal -childformat {{{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[7]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[6]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[5]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[4]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[3]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[2]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[1]} -radix hexadecimal} {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[0]} -radix hexadecimal}} -radixshowbase 0 -subitemconfig {{/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[7]} {-height 15 -radix hexadecimal -radixshowbase 0} {/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[6]} {-height 15 -radix hexadecimal -radixshowbase 0} {/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[5]} {-height 15 -radix hexadecimal -radixshowbase 0} {/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/SYS_TOP_TB/DUT/U0_UART/TX_IN_P[0]} {-height 15 -radix hexadecimal -radixshowbase 0}} /SYS_TOP_TB/DUT/U0_UART/TX_IN_P
add wave -noupdate -group {UART TX Signals} -color Gold -itemcolor Gold -radix binary -radixshowbase 1 /SYS_TOP_TB/DUT/U0_UART/TX_OUT_V
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {488418034 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 293
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {4894982594 ps} {4896318510 ps}
