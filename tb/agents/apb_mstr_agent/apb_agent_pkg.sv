///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_agent_pkg.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: agent package for holding agent files
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package apb_agent_pkg;
    // include and import uvm_pkg
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "tb_defines.sv"
    
    // typedefines
    typedef enum {READ=0, WRITE=1} op_type_e;
    
    // include agent files
    `include "apb_seq_item.sv"
    `include "apb_mstr_agent_config.sv"
    `include "apb_mstr_driver.sv"
    `include "apb_monitor.sv"
    `include "apb_mstr_sequencer.sv"
    `include "apb_coverage_monitor.sv"
    `include "apb_mstr_agent.sv"
endpackage: apb_agent_pkg