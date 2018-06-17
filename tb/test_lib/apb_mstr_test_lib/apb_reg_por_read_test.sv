///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_reg_por_read_test.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: power on reset test. Read the default value of the RAM after power on reset.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class apb_reg_por_read_test extends apb_base_test;
    `uvm_component_utils(apb_reg_por_read_test)

    // constructor function
    function new(string name="apb_reg_por_read_test", uvm_component parent=null);
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
            // read all memories after reset
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                rd_nd_compare_mem(i, 0);
            end
        phase.drop_objection(this);
    endtask: run_phase
    
endclass: apb_reg_por_read_test