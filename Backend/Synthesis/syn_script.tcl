
########################### Define Top Module ############################
                                                   
set top_module SYS_TOP

##################### Define Working Library Directory ######################
                                                   
define_design_lib work -path ./work

############################# Formality Setup File ##########################
                                                   
set_svf $top_module.svf

################## Design Compiler Library Files #setup ######################

puts "###########################################"
puts "#      #setting Design Libraries          #"
puts "###########################################"

#Add the path of the libraries and RTL files to the search_path variable

set PROJECT_PATH /home/IC/Projects/System/
set LIB_PATH     /home/IC/tsmc_fb_cl013g_sc/aci/sc-m

lappend search_path $LIB_PATH/synopsys
lappend search_path $PROJECT_PATH/RTL/ALU
lappend search_path $PROJECT_PATH/RTL/ASYNC_FIFO
lappend search_path $PROJECT_PATH/RTL/Clock_Divider
lappend search_path $PROJECT_PATH/RTL/Clock_Gating
lappend search_path $PROJECT_PATH/RTL/DATA_SYNC
lappend search_path $PROJECT_PATH/RTL/RegFile
lappend search_path $PROJECT_PATH/RTL/PULSE_GEN
lappend search_path $PROJECT_PATH/RTL/RST_SYNC
lappend search_path $PROJECT_PATH/RTL/SYS_CTRL
lappend search_path $PROJECT_PATH/RTL/CLKDIV_MUX
lappend search_path $PROJECT_PATH/RTL/UART/UART_RX
lappend search_path $PROJECT_PATH/RTL/UART/UART_TX
lappend search_path $PROJECT_PATH/RTL/UART/UART_TOP
lappend search_path $PROJECT_PATH/RTL/Top

set SSLIB "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set TTLIB "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set FFLIB "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"

## Standard Cell libraries 
set target_library [list $SSLIB $TTLIB $FFLIB]

## Standard Cell & Hard Macros libraries 
set link_library [list * $SSLIB $TTLIB $FFLIB]  

######################## Reading RTL Files #################################

puts "###########################################"
puts "#             Reading RTL Files           #"
puts "###########################################"

set file_format_1 verilog
set file_format_2 sverilog

#ALU
analyze -format $file_format_1 ALU.v
#FIFO
analyze -format $file_format_1 DF_SYNC.v
analyze -format $file_format_1 FIFO_MEM_CNTRL.v
analyze -format $file_format_1 FIFO_RD.v
analyze -format $file_format_1 FIFO_WR.v
analyze -format $file_format_1 ASYNC_FIFO.v
#CLK_DIVIDER MUX
analyze -format $file_format_1 CLKDIV_MUX.v
#CLK_DIVIDER
analyze -format $file_format_1 ClkDiv.v
#CLK_GATING
analyze -format $file_format_1 CLK_GATE.v
#DATA_SYNC
analyze -format $file_format_1 DATA_SYNC.v
#REGISTER_FILE
analyze -format $file_format_1 RegFile.v
#PULSE_GENERATOR
analyze -format $file_format_1 PULSE_GEN.v
#RST_SYNC
analyze -format $file_format_1 RST_SYNC.v
#SYS_CONTROLLER
analyze -format $file_format_2 SYS_CTRL.sv
#UART_RX
analyze -format $file_format_1 Data_Sampling.v
analyze -format $file_format_1 Deserializer.v
analyze -format $file_format_1 Edge_Bit_Counter.v
analyze -format $file_format_1 Parity_Check.v
analyze -format $file_format_1 Stop_Check.v
analyze -format $file_format_1 Start_Check.v
analyze -format $file_format_1 UART_RX.v
analyze -format $file_format_2 UART_RX_FSM.sv
#UART_TX
analyze -format $file_format_1 UART_MUX.v
analyze -format $file_format_1 Parity_Calc.v
analyze -format $file_format_1 Serializer.v
analyze -format $file_format_1 UART_TX.v
analyze -format $file_format_2 UART_TX_FSM.sv
#UART_TOP
analyze -format $file_format_1 UART.v
#SYS_TOP
analyze -format $file_format_1 SYS_TOP.v

elaborate -lib WORK SYS_TOP

###################### Defining toplevel ###################################

current_design $top_module

#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## Liniking All The Design Parts ########"
puts "###############################################"

link 

#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## checking design consistency ##########"
puts "###############################################"

check_design >> reports/check_design.rpt

#################### Define Design Constraints #########################
puts "###############################################"
puts "############ Design Constraints #### ##########"
puts "###############################################"

source -echo ./cons.tcl

###################### Mapping and optimization ########################
puts "###############################################"
puts "########## Mapping & Optimization #############"
puts "###############################################"

compile 

##################### Close Formality Setup file ###########################

set_svf -off

#############################################################################
# Write out files
#############################################################################

write_file -format verilog -hierarchy -output netlists/$top_module.ddc
write_file -format verilog -hierarchy -output netlists/$top_module.v
write_sdf  sdf/$top_module.sdf
write_sdc  -nosplit sdc/$top_module.sdc

####################### reporting ##########################################

report_area -hierarchy > reports/area.rpt
report_power -hierarchy > reports/power.rpt
report_timing -delay_type min -max_paths 20 > reports/hold.rpt
report_timing -delay_type max -max_paths 20 > reports/setup.rpt
report_clock -attributes > reports/clocks.rpt
report_constraint -all_violators -nosplit > reports/constraints.rpt

############################################################################
# DFT Preparation Section
############################################################################

set flops_per_chain 100

set num_flops [sizeof_collection [all_registers -edge_triggered]]

set num_chains [expr $num_flops / $flops_per_chain + 1 ]

################# starting graphical user interface #######################

#gui_start

#exit
