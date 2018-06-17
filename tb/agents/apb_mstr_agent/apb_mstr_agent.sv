///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_mstr_agent.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB Master agent
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class apb_mstr_agent extends uvm_agent;
    `uvm_component_utils(apb_mstr_agent)
    
    // agent config instance
    apb_mstr_agent_config   apb_mstr_agnt_cfg;
    
    // apb_mstr_driver instance
    apb_master_driver       apb_mstr_drvr;
    
    // apb_monitor instance
    apb_monitor             apb_mntr;
    
    // apb_coverage_monitor instance
    apb_coverage_monitor    apb_cov_mntr;
    
    // apb_mstr_sequencer instance
    apb_mstr_sequencer      apb_mstr_seqr;
    
    // constructor function
    function new(string name="apb_mstr_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    // build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // get agent config from uvm_config_db
        if(!uvm_config_db#(apb_mstr_agent_config)::get(this, "", "APB_MSTR_AGNT_CFG", apb_mstr_agnt_cfg)) begin
            `uvm_fatal("AGENT CONFIG OBJECT NOT FOUND ERROR", $sformatf("ERROR:: Unable to retrieve apb_mstr_agnt_cfg from uvm_config_db"))
        end
        
        // build monitor
        apb_mntr = apb_monitor::type_id::create("apb_mntr", this);
        
        // build driver and sequencer if agent is active
        if(apb_mstr_agnt_cfg.is_active == UVM_ACTIVE) begin
            // build driver
            apb_mstr_drvr = apb_master_driver::type_id::create("apb_mstr_drvr", this);
            
            // build sequencer
            apb_mstr_seqr = apb_mstr_sequencer::type_id::create("apb_mstr_seqr", this);
        end
        
        // build coverage monitor if functional coverage is enabled
        if(apb_mstr_agnt_cfg.has_functional_coverage) begin
            apb_cov_mntr = apb_coverage_monitor::type_id::create("apb_cov_mntr", this);
        end
    endfunction: build_phase
    
    // connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // connect driver and sequencer ports and interface handles if agent is active
        if(apb_mstr_agnt_cfg.is_active == UVM_ACTIVE) begin
            // connect agent_cfg with agent_cfg inside driver
            apb_mstr_drvr.apb_mstr_agnt_cfg = apb_mstr_agnt_cfg;
            // connect interface handle inside driver with interface handle from agent_cfg
            apb_mstr_drvr.apb_intf = apb_mstr_agnt_cfg.apb_intf;
            
            // connect sequence item ports of driver and sequencer
            apb_mstr_drvr.seq_item_port.connect(apb_mstr_seqr.seq_item_export);
        end
        
        // connect analysis ports of monitor and coverage monitor if functional coverage is enabled
        if(apb_mstr_agnt_cfg.has_functional_coverage) begin
            apb_mntr.mntr2cov.connect(apb_cov_mntr.analysis_export);
        end
        
        // connect monitor interface with agent_cfg interface
        apb_mntr.apb_intf = apb_mstr_agnt_cfg.apb_intf;
        
        // connect monitor agent_cfg with agent_cfg of agent
        apb_mntr.apb_mstr_agnt_cfg = apb_mstr_agnt_cfg;
    endfunction: connect_phase
endclass: apb_mstr_agent