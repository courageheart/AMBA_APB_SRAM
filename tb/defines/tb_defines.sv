///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: tb_defines.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Revision: 0.1
// Description: Contains testbench define Macros
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`define ADDR_WIDTH 16               // APB PADDR BUS width           
`define DATA_WIDTH 16               // APB PWDATA and PRDATA Bus width
`define APB_CLK_FREQ_MHZ 100        // 100MHz clock frequency
`define APB_SRAM_SIZE  64           // Size of memory in SRAM
`define APB_SRAM_MEM_BLOCK_SIZE 16  // Memory block size in SRAM
// defines to be overwriten by command line defines
`ifndef APB_SLV_WAIT_FUNC_EN
    `define APB_SLV_WAIT_FUNC_EN 0  // APB slave wait delay insertion
`endif
`ifndef APB_SLV_MIN_WAIT_CYC         
    `define APB_SLV_MIN_WAIT_CYC 1  // Minimum slave wait delay cycle
`endif
`ifndef APB_SLV_MAX_WAIT_CYC
    `define APB_SLV_MAX_WAIT_CYC 2  // Minimum slave wait delay cycle
`endif    
