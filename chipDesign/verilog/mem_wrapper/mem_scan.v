module mem_scan(
   // Control inputs from scan
   scan_mem_sel, mem_use_scan, mem_trigger, mem_scan_reset_n,
   // Input from Memory
   Q,
   // Outputs to the memory
   mem_addr, mem_d, mem_bwen_n, mem_cen_n,

   // Inputs from the scan
   scan_addr, scan_d, scan_wen_n, scan_cen_n, 
   // Output to the scan
   scan_q,

   // Inputs from the core
   A, D, BWE_n, CE_n, 
   CLK);

   parameter addrbits=16;
   parameter dqbits=32;

   input                   scan_mem_sel;
   
   input  [addrbits-1:0]   A;
   input  [addrbits-1:0]   scan_addr;
   output [addrbits-1:0]   mem_addr;

   input  [dqbits-1:0]     D;
   input  [dqbits-1:0]     scan_d;
   output [dqbits-1:0]     mem_d;
   
   input  		   BWE_n;
   input                   scan_wen_n;
   output 		   mem_bwen_n;
   
   input                   CE_n;
   input                   scan_cen_n;
   output                  mem_cen_n;
   
   input      [dqbits-1:0] Q;
   output reg [dqbits-1:0] scan_q;

   input                   mem_use_scan;
   input                   mem_trigger;
   input                   CLK;
   input                   mem_scan_reset_n;
   
   assign                mem_addr = mem_use_scan ? scan_addr : A;
   assign                mem_d = mem_use_scan ? scan_d : D;
   assign                mem_bwen_n = mem_use_scan ? {dqbits{scan_wen_n}} : BWE_n;
   reg                   access_ce;
   reg                   access_ce_last;
   assign                mem_cen_n = mem_use_scan ? ~(~scan_cen_n & access_ce) : CE_n;

   reg [3:0]             mem_trigger_sync;
   always @(posedge CLK or negedge mem_scan_reset_n)
   begin
      if(!mem_scan_reset_n)
      begin
         /*AUTORESET*/
         // Beginning of autoreset for uninitialized flops
         access_ce <= 1'h0;
         access_ce_last <= 1'h0;
         mem_trigger_sync <= 4'h0;
         scan_q <= {dqbits{1'b0}};
         // End of automatics
      end
      else
      begin
         mem_trigger_sync <= {mem_trigger_sync[2:0], mem_trigger};
         access_ce <= (mem_trigger_sync[3] ^ mem_trigger_sync[2]) & scan_mem_sel;
         access_ce_last <= access_ce & ~scan_cen_n;
         if(access_ce_last) begin
            scan_q <= Q;
         end
      end
   end
   
endmodule

