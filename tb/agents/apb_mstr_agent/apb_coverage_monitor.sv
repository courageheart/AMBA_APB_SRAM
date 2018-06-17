///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_coverage_monitor.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB Coverage Monitor for sampling coverage
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class apb_coverage_monitor extends uvm_subscriber#(apb_seq_item);
    `uvm_component_utils(apb_coverage_monitor)
    
    // instance of seq_item
    apb_seq_item item;
    
    // ADDR value space bounds
    localparam MAX_POSS_ADDR = 2**`ADDR_WIDTH -1; 
    
    // DATA value space bounds
    localparam DATA_BOUND_1 = (2**`DATA_WIDTH)/4;
    localparam DATA_BOUND_2 = 2*((2**`DATA_WIDTH)/4);
    localparam DATA_BOUND_3 = 3*((2**`DATA_WIDTH)/4);
    localparam DATA_BOUND_4 = 4*((2**`DATA_WIDTH)/4);
    
    // covergroup
    covergroup apb_cg;
        ADDRESS: coverpoint item.ADDR{
            option.auto_bin_max = `APB_SRAM_SIZE;
            bins valid_addr[`APB_SRAM_SIZE] = {[`APB_SRAM_SIZE-1:0]} iff(`APB_SRAM_SIZE < MAX_POSS_ADDR);
            ignore_bins out_of_bound_addr[] = {[MAX_POSS_ADDR:`APB_SRAM_SIZE]} iff(`APB_SRAM_SIZE < MAX_POSS_ADDR); 
        }
        DATA: coverpoint item.DATA{
            bins low_val_data = {[DATA_BOUND_1-1:0]};
            bins mid_val_data = {[DATA_BOUND_2-1: DATA_BOUND_1]};
            bins mid_high_val_data = {[DATA_BOUND_3-1: DATA_BOUND_2]};
            bins high_val_data = {[DATA_BOUND_4-1: DATA_BOUND_3]};
        }
        OP_TYPE: coverpoint item.op_type{
            bins WRITE_OP = {1};
            bins READ_OP = {0};
        }
        
        ALL_CROSS: cross ADDRESS, DATA, OP_TYPE{
        
        }
    endgroup
    
    // instance of covergroup
    //apb_cg cg;
    
    // constructor function
    function new(string name="apb_coverage_monitor", uvm_component parent);
        super.new(name, parent);
        
        // create covergroup
        apb_cg = new();
    endfunction: new

    // analysis port write function
    virtual function void write(apb_seq_item t);
        // create item
        item = apb_seq_item::type_id::create("item");
        
        // copy item fields
        item.ADDR = t.ADDR;
        item.DATA = t.DATA;
        item.op_type = t.op_type;
        
        // sample coverage
        apb_cg.sample();
    endfunction: write

endclass: apb_coverage_monitor