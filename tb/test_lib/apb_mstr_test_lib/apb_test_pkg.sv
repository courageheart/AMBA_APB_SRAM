///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_test_pkg.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: test package for holding tests
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package apb_test_pkg;
    // include and import uvm_pkg
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    
    `include "tb_defines.sv"
    
    // import agent pkg
    import apb_agent_pkg::*;
    // import env_pkg
    import apb_env_pkg::*;
    // import seq_lib_pkg
    import apb_seq_lib_pkg::*;
    
    // include tests
    `include "apb_base_test.sv"
    `include "apb_reg_por_read_test.sv"
    `include "apb_directed_reg_write_read_test.sv"
    `include "apb_rand_reg_write_read_test.sv"
    `include "apb_reg_alias_test.sv"
    `include "apb_slv_err_test.sv"
endpackage: apb_test_pkg