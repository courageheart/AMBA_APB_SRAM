////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: tb_top.sv
// Author:    Farshad
// Email:     farshad112@gmail.com
// Date Created: 1-June-2018
// Revision: 0.1
// Description: tb_top module
// License: This project is licensed under MIT opensource license 3.0 available @ https://opensource.org/licenses/MIT
/******************************************* LICENSE BEGIN **************************************
Copyright 2018 Farshad

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

******************************************* LICENSE END **************************************/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
`include "tb_defines.sv"

module tb_top();
    // include and import uvm_pkg
    `include "uvm_macros.svh"
    import uvm_pkg::*;    
    
    // import test pkg
    import apb_test_pkg::*;
    
    // clock declaration
    bit clk_100MHz;

    // interface declaration
    apb_interface   apb_intf(clk_100MHz);
    
    // 100MHz clock generation block
    initial begin
        forever begin
            #((0.5/`APB_CLK_FREQ_MHZ) * 1s) clk_100MHz = ~clk_100MHz;
        end
    end
      
    // instantiation of DUT
    apb_v3_sram #(  // parameters
                        .ADDR_BUS_WIDTH(`ADDR_WIDTH),               // ADDR BUS Width
                        .DATA_BUS_WIDTH(`DATA_WIDTH),               // Data Bus Width
                        .MEMSIZE(`APB_SRAM_SIZE),                   // RAM Size
                        .MEM_BLOCK_SIZE(`APB_SRAM_MEM_BLOCK_SIZE),  // Each memory block size in RAM
                        .RESET_VAL(0),                              // Reset value of RAM
                        .EN_WAIT_DELAY_FUNC(`APB_SLV_WAIT_FUNC_EN), // Enable Slv wait state
                        .MIN_RAND_WAIT_CYC(`APB_SLV_MIN_WAIT_CYC),  // Min Slv wait delay in clock cycles
                        .MAX_RAND_WAIT_CYC(`APB_SLV_MAX_WAIT_CYC)   // Max Slv wait delay in clock cycles
                ) DUT (       
                        // IO ports
                        .PRESETn(apb_intf.PRESETn),             // Active low Reset
                        .PCLK(clk_100MHz),                          // 100MHz clock
                        .PSEL(apb_intf.PSEL),                   // Select Signal
                        .PENABLE(apb_intf.PENABLE),             // Enable Signal
                        .PWRITE(apb_intf.PWRITE),               // Write Strobe
                        .PADDR(apb_intf.PADDR),                 // Addr
                        .PWDATA(apb_intf.PWDATA),               // Write data
                        .PRDATA(apb_intf.PRDATA),               // Read data
                        .PREADY(apb_intf.PREADY),               // Slave Ready
                        .PSLVERR(apb_intf.PSLVERR)              // Slave Error Response
                    );
                    
    // set interface in uvm config db 
    initial begin
        uvm_config_db#(virtual apb_interface)::set(null, "*", "APB_INTF", apb_intf);
        // start the test
        run_test();
    end
    
endmodule: tb_top