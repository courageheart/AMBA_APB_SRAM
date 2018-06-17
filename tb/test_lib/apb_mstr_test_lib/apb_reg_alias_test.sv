///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_reg_alias_test.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: power on reset test. Read the default value of the RAM after power on reset.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class apb_reg_alias_test extends apb_base_test;
    `uvm_component_utils(apb_reg_alias_test)

    // constructor function
    function new(string name="apb_reg_alias_test", uvm_component parent=null);
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
        reg [`DATA_WIDTH-1:0] wr_data_pattern[2] = {{(`DATA_WIDTH/4){4'hA}}, {(`DATA_WIDTH/4){4'h5}}};
        
        super.run_phase(phase);        
        phase.raise_objection(this);
            // write each data pattern to the memory for alias testing
            foreach(wr_data_pattern[k]) begin
                // write to one memory each time
                for(int j=0; j<`APB_SRAM_SIZE; j++) begin
                    wr_data_2_mem(j, wr_data_pattern[k], 0, 0);
                    // read all memories after write
                    for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                        rd_data_4m_mem(i, 0);
                    end
                    // Reset RAM
                    reset_dut();
                end 
            end
        phase.drop_objection(this);
    endtask: run_phase
    
endclass: apb_reg_alias_test