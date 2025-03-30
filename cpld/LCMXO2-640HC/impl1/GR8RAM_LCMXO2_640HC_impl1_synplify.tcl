#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology MACHXO2
set_option -part LCMXO2_640HC
set_option -package TG100C
set_option -speed_grade -4

#compilation/mapping options
set_option -symbolic_fsm_compiler false
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency 100
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe false
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false

add_file -constraint {//Mac/iCloud/Repos/GR8RAM/cpld/GR8RAM.sdc}
set_option -default_enum_encoding default

#simulation options


#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0



#-- add_file options
set_option -include_path {//Mac/iCloud/Repos/GR8RAM/cpld/LCMXO2-640HC}
add_file -verilog {//Mac/iCloud/Repos/GR8RAM/cpld/GR8RAM.v}
add_file -verilog {//Mac/iCloud/Repos/GR8RAM/cpld/SlinkyRegisters.v}
add_file -verilog {//Mac/iCloud/Repos/GR8RAM/cpld/BusInterface.v}
add_file -verilog {//Mac/iCloud/Repos/GR8RAM/cpld/InitController.v}
add_file -verilog {//Mac/iCloud/Repos/GR8RAM/cpld/SDRAMController.v}

#-- top module name
set_option -top_module GR8RAM

#-- set result format/file last
project -result_file {//Mac/iCloud/Repos/GR8RAM/cpld/LCMXO2-640HC/impl1/GR8RAM_LCMXO2_640HC_impl1.edi}

#-- error message log file
project -log_file {GR8RAM_LCMXO2_640HC_impl1.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run
