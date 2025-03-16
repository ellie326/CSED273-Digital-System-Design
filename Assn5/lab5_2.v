/* CSED273 lab5 experiment 2 */
/* lab5_2.v */

`timescale 1ns / 1ps

/* Implement srLatch */
module srLatch(
    input s, r,
    output q, q_
    );

    ////////////////////////
    wire q1, q2; 
    
    nor (q1, r, q2); 
    nor(q2, s, q1); 
    assign q = q1; 
    assign q_ = q2; 
    ////////////////////////

endmodule

/* Implement master-slave JK flip-flop with srLatch module */
module lab5_2(
    input reset_n, j, k, clk,
    output q, q_
    );

    ////////////////////////
    wire and_k, and_j; 
    wire p, p_, and_p, and_p_; 
    wire q1, q2; 
    
    and(and_k, k, q1, clk); 
    and(and_j, j, q2, clk); 
    
    srLatch master (and_j & reset_n, and_k | ~reset_n, p, p_); 
    
    srLatch slave (p & ~clk, p_ & ~clk, q1, q2); 
    
    assign q = q1; 
    assign q_ = q2; 
    ////////////////////////
    
endmodule