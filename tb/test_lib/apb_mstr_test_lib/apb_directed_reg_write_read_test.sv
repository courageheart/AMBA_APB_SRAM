class apb_directed_reg_write_read_test extends apb_base_test;
    `uvm_component_utils(apb_directed_reg_write_read_test)

    // constructor function
    function new(string name="apb_directed_reg_write_read_test", uvm_component parent=null);
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
        int mid_data_val = (2**`DATA_WIDTH)/4;
        int mid_high_data_val = 2*(2**`DATA_WIDTH)/4;
        int high_data_val = 3*(2**`DATA_WIDTH)/4;
        
        super.run_phase(phase);        
        phase.raise_objection(this);
            // Write all memories with low range directed data
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                wr_data_2_mem(i, i, 0, 0);
            end
            // read all memories after write
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                rd_data_4m_mem(i, 0);
            end
            // Write all memories with mid range directed data
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                wr_data_2_mem(i, mid_data_val+i, 0, 0);
            end
            // read all memories after write
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                rd_data_4m_mem(i, 0);
            end
            // Write all memories with mid high range directed data
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                wr_data_2_mem(i, mid_high_data_val+i, 0, 0);
            end
            // read all memories after write
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                rd_data_4m_mem(i, 0);
            end
            // Write all memories with high range directed data
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                wr_data_2_mem(i, high_data_val+i, 0, 0);
            end
            // read all memories after write
            for(int i=0; i< `APB_SRAM_SIZE; i++) begin
                rd_data_4m_mem(i, 0);
            end
        phase.drop_objection(this);
    endtask: run_phase
    
endclass: apb_directed_reg_write_read_test