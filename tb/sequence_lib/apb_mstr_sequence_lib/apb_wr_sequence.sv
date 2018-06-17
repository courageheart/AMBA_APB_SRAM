///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_wr_sequence.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: APB Write Sequence file. Generates write transfer in APB slave core. 
//              The address can be randomized or directed. If address is set with 0, random address
//              will be generated. Otherwise directed address will be used.
//              The data can also be randomized or directed. If data is set to 0, random data is generated.
//              Otherwise directed data will be generated.   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class apb_wr_sequence extends apb_base_sequence;
    `uvm_object_utils(apb_wr_sequence)
    
    bit rand_addr;  // flag for enabling randomized address
    bit rand_data;  // flag for enabling randomized data
    
    // constructor function
    function new(string name="apb_wr_sequence");
        super.new(name);
    endfunction: new
    
    // body
    virtual task body();
        if(rand_data) begin  // random data
            if(rand_addr) begin  // random address
                `uvm_do_with(item, {item.op_type == WRITE;})
            end
            else begin  // directed address
                `uvm_do_with(item, {
                                    item.op_type == WRITE; 
                                    item.ADDR == local::addr;
                            })
            end
        end
        else begin  // directed data
            if(rand_addr) begin  // random address
                `uvm_do_with(item, {
                                    item.op_type == WRITE;
                                    item.DATA == local::data;
                                   })
            end
            else begin  // directed address
                `uvm_do_with(item, {
                                    item.op_type == WRITE; 
                                    item.ADDR == local::addr;
                                    item.DATA == local::data;
                            })
            end
        end
    endtask: body
endclass: apb_wr_sequence