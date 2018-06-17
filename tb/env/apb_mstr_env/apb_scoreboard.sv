///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_scoreboard.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: Scoreboard file for matching expected and captured data from DUT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`uvm_analysis_imp_decl(_drv2scb)
`uvm_analysis_imp_decl(_mntr2scb)
class apb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(apb_scoreboard)
    
    apb_seq_item            exp_seq_item;       // expected data queue
    apb_seq_item            exp_seq_item_q[$];  // expected seq_item_data_q
    apb_seq_item            rcvd_seq_item_q[$]; // received seq_item_data_q
    
    // analysis port declaration
    uvm_analysis_imp_drv2scb#(apb_seq_item, apb_scoreboard)     ap_drv2scb;     // driver to scoreboard
    uvm_analysis_imp_mntr2scb#(apb_seq_item, apb_scoreboard)    ap_mntr2scb;    /// monitor to scoreboard

    // constructor function
    function new(string name="apb_scoreboard", uvm_component parent);
        super.new(name, parent);
        // create analysis ports
        ap_drv2scb = new("ap_drv2scb", this);
        ap_mntr2scb = new("ap_mntr2scb", this);
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
        apb_seq_item  exp_pkt, rcvd_pkt;
        super.run_phase(phase);
        
 /*       forever begin
            wait(exp_seq_item_q.size() !=0 && rcvd_seq_item_q.size() !=0);
                exp_pkt = exp_seq_item_q.pop_front();
                rcvd_pkt = rcvd_seq_item_q.pop_front();
                compare_pkt(exp_pkt, rcvd_pkt);                
        end  
*/      
    endtask: run_phase
    
    // driver to scoreboard write function
    function void write_drv2scb(apb_seq_item item);
        // print seq_item details received from driver
        `uvm_info("SCB", $sformatf("Seq_item written from driver: \n"), UVM_HIGH)
        item.print();
        
        // push the expected seq_item in queue
        exp_seq_item_q.push_back(item);
    endfunction: write_drv2scb
    
    // monitor to scoreboard write function
    function void write_mntr2scb(apb_seq_item item);
        // print seq_item details received from monitor
        `uvm_info("SCB", $sformatf("Seq_item written from monitor: \n"), UVM_HIGH)
        item.print();
        
        // push captured seq_item into queue
        rcvd_seq_item_q.push_back(item);
    endfunction: write_mntr2scb
    
    // compare packets
    function void compare_pkt(input apb_seq_item exp_pkt, apb_seq_item rcvd_pkt);
        if(exp_pkt.ADDR == rcvd_pkt.ADDR) begin
            if(exp_pkt.DATA != rcvd_pkt.DATA) begin
                `uvm_error("DATA MISMATCH ERROR", $sformatf("SCB:: For ADDR: %0h Expecting DATA:%0h but Received DATA: %0h", exp_pkt.ADDR, exp_pkt.DATA, rcvd_pkt.DATA))
            end
        end
        else begin
            `uvm_error("ADDR MISMATCH ERROR", $sformatf("SCB:: Expected ADDR:%0h But received ADDR: %0h", exp_pkt.ADDR, rcvd_pkt.ADDR))
        end
    endfunction: compare_pkt
    
    // construct expected data pkt
    function void construct_nd_push_exp_pkt(input reg [`ADDR_WIDTH-1:0] ADDR, input reg [`DATA_WIDTH-1:0] DATA);
        // construct seq_item
        exp_seq_item = apb_seq_item::type_id::create("exp_seq_item");
        // add exp value to fields
        exp_seq_item.ADDR = ADDR;
        exp_seq_item.DATA = DATA;
        // push exp_pkt in queue
        exp_seq_item_q.push_back(exp_seq_item);
    endfunction: construct_nd_push_exp_pkt
endclass: apb_scoreboard