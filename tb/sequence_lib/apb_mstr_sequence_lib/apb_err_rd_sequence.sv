///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_err_rd_sequence.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB READ Sequence file. Generates read transfer in APB slave core with ADDRESS OUT OF BOUND ERROR. 
//              The address can be randomized or directed. If address is set with 0, random address
//              will be generated. Otherwise directed address will be used.  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class apb_err_rd_sequence extends apb_base_sequence;
    `uvm_object_utils(apb_err_rd_sequence)
    
    bit rand_addr;  // flag for enabling randomized address
    
    // constructor function
    function new(string name="apb_err_rd_sequence");
        super.new(name);
    endfunction: new
    
    // body
    virtual task body();
        // construct seq item
        item = apb_seq_item::type_id::create("item");
        
        start_item(item);
            if(rand_addr) begin  // random address
                // turn off default constraints for address
                item.addr_constr.constraint_mode(0);
                assert(item.randomize() with {item.op_type == READ;
                                              item.ADDR > `APB_SRAM_SIZE;
                            });
            end
            else begin  // directed address
                // turn off default constraints for address
                item.addr_constr.constraint_mode(0);
                assert(item.randomize() with {item.op_type == READ;
                                              item.ADDR == local::addr;
                            });
            end
            
        finish_item(item);    
    endtask: body
endclass: apb_err_rd_sequence