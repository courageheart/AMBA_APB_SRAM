///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_seq_item.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: sequence item file
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class apb_seq_item extends uvm_sequence_item;
    rand bit [`ADDR_WIDTH-1:0]   ADDR;      // Address
    rand bit [`DATA_WIDTH-1:0]   DATA;      // data
    rand op_type_e              op_type;    // operation type

    // constructor function
    function new(string name="apb_seq_item");
        super.new(name);
    endfunction: new
    
    // default addr constraints
    constraint addr_constr{
        ADDR < `APB_SRAM_SIZE;
    }
    
    // default operation type constraints
    constraint op_type_constr{
        op_type inside {WRITE, READ};
    }
    
    // register fields with uvm_factory
    `uvm_object_utils_begin(apb_seq_item)
        `uvm_field_int(ADDR, UVM_ALL_ON)
        `uvm_field_int(DATA, UVM_ALL_ON)
        `uvm_field_enum(op_type_e, op_type, UVM_ALL_ON)
    `uvm_object_utils_end
    
endclass : apb_seq_item