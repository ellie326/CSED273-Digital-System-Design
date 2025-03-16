/* CSED273 lab1 experiment 1 */
/* lab1_1_tb.v */

`timescale 1ns / 1ps

module lab1_1_tb();
    wire out;
    reg A, B;
    
    lab1_1 AND(out, A,B);
    
	/* Initialize A and B */
    initial begin
		////////////////////////
		A=1;                          //initialize both A and B to 1
		B=1; 
		#10 $finish;                  //program finishes after 10ns 
		////////////////////////
    end
	
	/* Flip A every 1ns */
    always begin
		#1 A <= !A;
    end
	
	/* Flip B every 2ns */
    always begin
		////////////////////////
		#2 B <= !B; 
		////////////////////////
    end
endmodule
