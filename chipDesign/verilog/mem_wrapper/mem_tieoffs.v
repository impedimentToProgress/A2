
// RAM block for the main memory
module sram_32Kx32_wrapper (
		  // Outputs
		  Q,
		  // Inputs
		  CLK, CE_n, BWE_n, A, D,
          
          // Scan chain test inputs
          scan_mem_sel, mem_use_scan, mem_trigger, mem_scan_reset_n,
          scan_addr, scan_d, scan_wen_n, scan_cen_n,scan_q, clk_scan, scan_EMA
		  );

    input 	      CLK;
    input             clk_scan;
    input  [14:0]  A;
    input  [31:0] D;

    input  	 BWE_n;
    input  CE_n;
    input  [2:0] scan_EMA;
    output [31:0] Q;
    
    // Scan chain test inputs/outputs
    input         scan_mem_sel;
    input         mem_use_scan;
    input         mem_trigger;
    input         mem_scan_reset_n;
    input  [14:0]  scan_addr;
    input  [31:0] scan_d;
    input         scan_wen_n;
    input         scan_cen_n;
    output [31:0] scan_q;

    // Wire definition
    wire   [14:0]  mem_addr;
    wire   [31:0] mem_d;
    wire   	  mem_bwen_n;
    wire          mem_cen_n;

    mem_scan #(.addrbits(15), .dqbits(32)) mem_scan_inst (
            // Control inputs from scan
            .scan_mem_sel(scan_mem_sel), .mem_use_scan(mem_use_scan),
            .mem_trigger(mem_trigger), .mem_scan_reset_n(mem_scan_reset_n),
            // Input from Memory
            .Q(Q),
            // Outputs to the memory
            .mem_addr(mem_addr), .mem_d(mem_d),
            .mem_bwen_n(mem_bwen_n), .mem_cen_n(mem_cen_n),
            // Inputs from the scan
            .scan_addr(scan_addr), .scan_d(scan_d),
            .scan_wen_n(scan_wen_n), .scan_cen_n(scan_cen_n), 
            // Output to the scan
            .scan_q(scan_q),
            // Inputs from the core
            .A(A), .D(D), .BWE_n(BWE_n), .CE_n(CE_n), 
            .CLK(clk_scan));

    wire clk_mem = mem_use_scan ? clk_scan : CLK;
 
    sram_32Kx32 mem_block_32K_32 (
			.Q(Q), 
			.CLK(clk_mem), 
			.CEN(mem_cen_n), 
			.WEN(mem_bwen_n), 
			.A(mem_addr), 
			.D(mem_d), 
			.EMA(scan_EMA), 
			.RETN(1'b1));


endmodule // sram_32Kx32_wrapper

