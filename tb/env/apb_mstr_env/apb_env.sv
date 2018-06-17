///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_env.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB Environment 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class apb_environment extends uvm_env;
    `uvm_component_utils(apb_environment)
    
    // instance of env_cfg
    apb_env_config  apb_env_cfg;
    // instance of scoreboard
    apb_scoreboard  apb_scb;
    // instance of agent
    apb_mstr_agent  apb_mstr_agnt;
    
    // constructor function
    function new(string name="apb_environment", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    // build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // get env_cfg from uvm_config_db
        if(!uvm_config_db#(apb_env_config)::get(this, "", "APB_ENV_CFG", apb_env_cfg)) begin
            `uvm_fatal("ENV_CFG Not Found ERROR", $sformatf("Unable to retrieve env_cfg from uvm_config_db"))
        end
        
        // build agent
        apb_mstr_agnt = apb_mstr_agent::type_id::create("apb_mstr_agnt", this);
        
        // build scoreboard if enabled
        if(apb_env_cfg.has_scoreboard) begin
            apb_scb = apb_scoreboard::type_id::create("apb_scb", this);
        end
        
        // set agent config in uvm_config_db
        uvm_config_db#(apb_mstr_agent_config)::set(null, "*", "APB_MSTR_AGNT_CFG", apb_env_cfg.apb_mstr_agnt_cfg);
    endfunction: build_phase
    
    // connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // connect scoreboard to monitor and driver if enabled
        if(apb_env_cfg.has_scoreboard) begin
            // connect monitor and scoreboard
            apb_mstr_agnt.apb_mntr.ap.connect(apb_scb.ap_mntr2scb);
            // connect driver and scoreboard
            apb_mstr_agnt.apb_mstr_drvr.drv2scb.connect(apb_scb.ap_drv2scb);
        end    
    endfunction: connect_phase
    
    // run_phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase
endclass: apb_environment

