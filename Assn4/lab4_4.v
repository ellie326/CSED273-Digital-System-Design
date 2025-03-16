/* CSED273 lab4 experiment 4 */
/* lab4_4.v */

/* Implement 5x3 Binary Mutliplier
 * You must use lab4_2 module in lab4_2.v
 * You cannot use fullAdder or halfAdder module directly
 * You may use keword "assign" and bitwise operator
 * or just implement with gate-level modeling*/
module lab4_4(
    input [4:0]in_a,
    input [2:0]in_b,
    output [7:0]out_m
    );

    ////////////////////////
    assign zero = 0; 
    
    assign a0b0 = in_a[0]&in_b[0]; 
    assign a1b0 = in_a[1]&in_b[0]; 
    assign a2b0 = in_a[2]&in_b[0]; 
    assign a3b0 = in_a[3]&in_b[0]; 
    assign a4b0 = in_a[4]&in_b[0]; 
    
    assign a0b1 = in_a[0]&in_b[1]; 
    assign a1b1 = in_a[1]&in_b[1]; 
    assign a2b1 = in_a[2]&in_b[1]; 
    assign a3b1 = in_a[3]&in_b[1]; 
    assign a4b1 = in_a[4]&in_b[1]; 
    
    assign a0b2 = in_a[0]&in_b[2]; 
    assign a1b2 = in_a[1]&in_b[2]; 
    assign a2b2 = in_a[2]&in_b[2]; 
    assign a3b2 = in_a[3]&in_b[2]; 
    assign a4b2 = in_a[4]&in_b[2]; 
    
    wire cout1, cout2; 
    wire s4, s3, s2,s1, s0; 
    
    lab4_2 add1({zero, a4b0, a3b0, a2b0, a1b0}, {a4b1, a3b1, a2b1, a1b1, a0b1}, zero, {s4, s3, s2, s1, s0}, cout1);
    lab4_2 add2({cout1, s4, s3, s2, s1}, {a4b2, a3b2, a2b2, a1b2, a0b2}, zero, {out_m[6], out_m[5], out_m[4], out_m[3], out_m[2]}, cout2);
    assign out_m[7] = cout2;
    assign out_m[1] = s0;
    assign out_m[0] = a0b0;
    
    ////////////////////////
    
endmodule