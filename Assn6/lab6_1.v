/* CSED273 lab6 experiment 1 */
/* lab6_1.v */

`timescale 1ps / 1fs

/* Implement synchronous BCD decade counter (0-9)
 * You must use JK flip-flop of lab6_ff.v */
module decade_counter(input reset_n, input clk, output [3:0] count);

    ////////////////////////
    wire Ka, Kb, Kc, Kd, Ja, Jb, Jc, Jd; 
    wire [3:0] cnt; 
    
    assign Ja = count[2] & count[1] & count[0]; 
    assign Ka = count[0]; 
    assign Jb = count[1] & count [0]; 
    assign Kb = count[1] & count [0];
    assign Jc = ~count[3] & count[0]; 
    assign Kc = count[0]; 
    assign Jd = 1; 
    assign Kd = 1; 
    
    edge_trigger_JKFF A (reset_n, Ja, Ka, clk, count[3], cnt[3]); 
    edge_trigger_JKFF B (reset_n, Jb, Kb, clk, count[2], cnt[2]); 
    edge_trigger_JKFF C (reset_n, Jc, Kc, clk, count[1], cnt[1]); 
    edge_trigger_JKFF D (reset_n, Jd, Kd, clk, count[0], cnt[0]); 
    
    ////////////////////////
	
endmodule