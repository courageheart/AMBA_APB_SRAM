///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_rd_sequence.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB Read Sequence file. Generates read transfer in APB slave core. 
//              The address can be randomized or directed. If address is set with 0 it random address
//              will be generated. Otherwise directed address will be used.  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class apb_rd_sequence extends apb_base_sequence;
    `uvm_object_utils(apb_rd_sequence)
    
    bit rand_addr;  // flag for randomize addr
    
    // constructor function
    function new(string name="apb_rd_sequence");
        super.new(name);
    endfunction: new
    
    virtual task body();
//        $display("RD_SEQ:: addr:%0h", addr);
        if(rand_addr) begin  // random read 
            `uvm_do_with(item, {item.op_type == 0;})
        end
        else begin  // directed read
            `uvm_do_with(item, {
                                item.op_type == 0;
                                item.ADDR == local::addr;
                         })
        end
    endtask: body
endclass: apb_rd_sequence