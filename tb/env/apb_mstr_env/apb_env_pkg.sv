///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_env_pkg.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB Environment Package for holding env files 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package apb_env_pkg;
    // include and import uvm_pkg
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    
    // import agent_pkg
    import apb_agent_pkg::*;
    
    `include "tb_defines.sv"
    
    // include env files
    `include "apb_env_config.sv"
    `include "apb_scoreboard.sv"
    `include "apb_env.sv"
endpackage: apb_env_pkg