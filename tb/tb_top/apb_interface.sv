////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: apb_interface.sv
// Author:    Farshad
// Email:     farshad112@gmail.com
// Date Created: 1-June-2018
// Revision: 0.1
// Description: AMBA APB interface
// License: This project is licensed under MIT opensource license 3.0 available @ https://opensource.org/licenses/MIT
/******************************************* LICENSE BEGIN **************************************
Copyright 2018 Farshad

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

******************************************* LICENSE END **************************************/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`include "tb_defines.sv"
interface apb_interface(input PCLK);   
    logic                   PRESETn;    // Active low reset
    logic                   PSEL;       // Select signal
    logic                   PENABLE;    // Enable signal
    logic                   PWRITE;     // Write Strobe
    logic [`ADDR_WIDTH-1:0] PADDR;      // Addr 
    logic [`DATA_WIDTH-1:0] PWDATA;     // Write Data
    logic [`DATA_WIDTH-1:0] PRDATA;     // Read Data
    logic                   PREADY;     // Slave Ready Signal
    logic                   PSLVERR;    // Slave Error Response
    
    // clocking block declarations
    clocking cb @(posedge PCLK);
        default input #1ns output #1ns;  // default delay skew
        output  PSEL;
        output  PENABLE;
        output  PWRITE;
        output  PADDR;
        output  PWDATA;
        input   PREADY;
        input   PRDATA;
        input   PSLVERR;
    endclocking: cb
    
    // modport declarations
    modport dut(output PRESETn, clocking cb);
    
    ///////////////////////////////////// property check assertions ////////////////////////////////////
    // apb_read transfer seq check
    property apb_read_seq_prop;
        @(posedge PCLK) disable iff(!PRESETn)
        PSEL && !PWRITE && PADDR!='bx |=> PENABLE ##[1:$] PREADY ##1 !PENABLE |-> !PSEL;
    endproperty    
    
    // apb_write transfer seq check
    property apb_write_seq_prop;
        @(posedge PCLK) disable iff(!PRESETn)
        PSEL && PWRITE && PADDR!='bx |=> PENABLE ##[1:$] PREADY ##1 !PENABLE |-> !PSEL;
    endproperty
    
    // property check assertions
    assert property(apb_read_seq_prop); 
    assert property(apb_write_seq_prop);
    
    ///////////////////////////////////// Interface Tasks /////////////////////////////////////////////
    // interface reset task
    task reset_intf();
        PRESETn = 0;  // trigger Reset
        PSEL = 0;
        PENABLE = 0;
        PWRITE = 0;
        repeat(2) 
            @(posedge PCLK);
        PRESETn = 1;  // back to normal operation
        @(posedge PCLK);
    endtask
endinterface : apb_interface