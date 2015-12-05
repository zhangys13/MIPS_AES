
# NC-Sim Command File
# TOOL:	ncsim	09.20-s013
#
#
# You can restore this configuration with:
#
#     /software/cadence/ius/tools/bin/ncsim -cdslib /home/zhangys13/MIPS_AES/sim/cds.lib -logfile ncsim.log -errormax 15 -status worklib.TestBench:module -input /home/zhangys13/MIPS_AES/sim/aes_wave.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 1
set show_force 1
set force_reset_by_reinvoke 0
alias . run
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves TestBench.mips.Register_File.clk TestBench.mips.Register_File.rst TestBench.mips.Register_File.Register
probe -create -database waves TestBench.mips.PC.pc_in TestBench.mips.PC.pc_out

simvision -input /home/zhangys13/MIPS_AES/sim/aes_wave.tcl.svcf


run 100us
