/////////////////////////////////////////////////
// include rtl directory
+incdir+../rtl
// include testbench directory
+incdir+../tb
// include defines directory
+incdir+../tb/defines
// include agents directory
+incdir+../tb/agents
+incdir+../tb/agents/apb_mstr_agent
// include env directory
+incdir+../tb/env
+incdir+../tb/env/apb_mstr_env
// include sequence library directory 
+incdir+../tb/sequence_lib
+incdir+../tb/sequence_lib/apb_mstr_sequence_lib
// include test library directory
+incdir+../tb/test_lib
+incdir+../tb/test_lib/apb_mstr_test_lib
// include tb_top directory
+incdir+../tb/tb_top

//////// RTL files ////////////
../rtl/apb_v3_sram.v

//////// TESTBENCH Files //////
../tb/defines/apb_global_pkg.sv
../tb/tb_top/apb_interface.sv
../tb/agents/apb_mstr_agent/apb_agent_pkg.sv
../tb/env/apb_mstr_env/apb_env_pkg.sv
../tb/sequence_lib/apb_mstr_sequence_lib/apb_seq_lib_pkg.sv
../tb/test_lib/apb_mstr_test_lib/apb_test_pkg.sv
../tb/tb_top/tb_top.sv

 