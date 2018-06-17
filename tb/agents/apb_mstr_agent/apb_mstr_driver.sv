///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_mstr_driver.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB Master driver
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class apb_master_driver extends uvm_driver#(apb_seq_item);
    `uvm_component_utils(apb_master_driver)
    
    // agent config instance
    apb_mstr_agent_config   apb_mstr_agnt_cfg;
    // virtual interface instance
    virtual apb_interface   apb_intf;
    
    // analysis port declaration
    uvm_analysis_port#(apb_seq_item) drv2scb;
    
    // constructor function
    function new(string name="apb_master_driver", uvm_component parent=null);
        super.new(name, parent);
        // create the analysis port
        drv2scb = new("drv2scb", this);
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
        apb_seq_item item;
        
        // reset the interface
        apb_intf.reset_intf();
        
        // get data from sequencer and drive to DUT
        forever begin
            @(apb_intf.cb);
            seq_item_port.get_next_item(item);
                if(item.op_type == WRITE) begin
                    wr_data(item);
                    // write expected data to analysis port
                    drv2scb.write(item);
                end
                else if(item.op_type == READ) begin
                    rd_data(item);
                end
            seq_item_port.item_done();
        end    
    endtask: run_phase
    
    ////////////////////////////////////////////////////////////////////
    // task name: wr_data
    // input parameter: apb_seq_item
    // Description: write data to dut
    ////////////////////////////////////////////////////////////////////
    task wr_data(input apb_seq_item item);
        apb_intf.cb.PSEL <= 1;
        apb_intf.cb.PWRITE <= 1;
        apb_intf.cb.PADDR <= item.ADDR;
        apb_intf.cb.PWDATA <= item.DATA;
        apb_intf.cb.PENABLE <= 0;
        @(apb_intf.cb);
        apb_intf.cb.PENABLE <= 1;
        @(apb_intf.cb);
        wait(apb_intf.cb.PREADY == 1);
        apb_intf.cb.PENABLE <= 0;
        apb_intf.cb.PSEL <= 0;
        @(apb_intf.cb);
    endtask: wr_data
    
    ////////////////////////////////////////////////////////////////////
    // task name: rd_data
    // input parameter: addr, data
    // Description: write data to dut
    ////////////////////////////////////////////////////////////////////
    task rd_data(input apb_seq_item item);
        apb_intf.cb.PSEL <= 1;
        apb_intf.cb.PWRITE <= 0;
        apb_intf.cb.PADDR <= item.ADDR;
        apb_intf.cb.PENABLE <= 0;
        @(apb_intf.cb);
        apb_intf.cb.PENABLE <= 1;
        wait(apb_intf.cb.PREADY == 1);
        apb_intf.cb.PENABLE <= 0;
        apb_intf.cb.PSEL <= 0;
    endtask: rd_data
endclass: apb_master_driver