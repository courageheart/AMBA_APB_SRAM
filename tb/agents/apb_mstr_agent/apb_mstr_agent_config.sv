///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_mstr_agent_config.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: master agent config for configuring master agent
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class apb_mstr_agent_config extends uvm_object;
    `uvm_object_utils(apb_mstr_agent_config)
    
    // fields
    bit has_functional_coverage;                        // Flag for Enabling functional coverage sampling
    uvm_active_passive_enum is_active = UVM_PASSIVE;    // By default agent is passive mode
    bit exp_err;                                        // Expect error. Set this bit only when testing PSLVERR.
    
    // virtual interface instance
    virtual apb_interface apb_intf;
    
    // constructor function
    function new(string name="apb_mstr_agent_config");
        super.new(name);
    endfunction
    
endclass: apb_mstr_agent_config