/* CSED273 lab6 experiment 3 */
/* lab6_3.v */

`timescale 1ps / 1fs

/* Implement 369 game counter (0, 3, 6, 9, 13, 6, 9, 13, 6 ...)
 * You must first implement D flip-flop in lab6_ff.v
 * then you use D flip-flop of lab6_ff.v */
module counter_369(input reset_n, input clk, output [3:0] count);

    ////////////////////////
   wire Da, Db, Dc, Dd; 
   wire [3:0] cnt; 
   assign Da = (~count[3] & count[2]) | (count[3] & ~count[2]); 
   assign Db = count[0]; 
   assign Dc = (~count[3] & ~count[2]) | (count[2] & count[0]); 
   assign Dd = ~count[0] | (count[3] & ~count[2]); 
   
   edge_trigger_D_FF DA (reset_n, Da, clk, count[3], cnt[3]); 
   edge_trigger_D_FF DB (reset_n, Db, clk, count[2], cnt[2]); 
   edge_trigger_D_FF DC (reset_n, Dc, clk, count[1], cnt[1]); 
   edge_trigger_D_FF DD (reset_n, Dd, clk, count[0], cnt[0]); 
    ////////////////////////
	
endmodule
