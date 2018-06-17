///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_slv_err_test.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: power on reset test. Read the default value of the RAM after power on reset.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class apb_slv_err_test extends apb_base_test;
    `uvm_component_utils(apb_slv_err_test)

    // constructor function
    function new(string name="apb_slv_err_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new
    
    // build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase
    
    // connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction: connect_phase
    
    // run_phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);        
        phase.raise_objection(this);
            // set expect error bit high on agent config
            apb_env_cfg.apb_mstr_agnt_cfg.exp_err = 1;
            // trigger write transfer with directed address and random data
            generate_mem_wr_err(`APB_SRAM_SIZE, `APB_SRAM_SIZE, 0, 1);
            // trigger read transfer with directed address
            generate_mem_rd_err(`APB_SRAM_SIZE, 0);
        phase.drop_objection(this);
    endtask: run_phase
    
endclass: apb_slv_err_test