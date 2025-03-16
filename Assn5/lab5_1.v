/* CSED273 lab5 experiment 1 */
/* lab5_1.v */

`timescale 1ps / 1fs

/* Implement adder 
 * You must not use Verilog arithmetic operators */
module adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,             // Carry in
    output [3:0] out,
    output c_out            // Carry out
); 

    ////////////////////////
    wire cout1, cout2, cout3; 
    wire a0, a1, a2, a3, b0, b1, b2, b3, c0, c1, c2, c3, c4;
    // for x0 and y0: 
    xor(a0, x[0], y[0]); 
    and(b0, x[0],y[0]); 
    xor(out[0], a0, c_in); 
    and(c0, c_in, a0); 
    or(cout1, c0, b0); 
    
    //for x1 and y1: 
    xor(a1, x[1], y[1]); 
    and(b1, x[1],y[1]); 
    xor(out[1], a1, cout1); 
    and(c1, cout1, a1); 
    or(cout2, c1, b1); 
    
    //for x2 and y2: 
    xor(a2, x[2], y[2]); 
    and(b2, x[2],y[2]); 
    xor(out[2], a2, cout2); 
    and(c2, cout2, a2); 
    or(cout3, c2, b2); 
    
    //for x3 and y3: 
    xor(a3, x[3], y[3]); 
    and(b3, x[3],y[3]); 
    xor(out[3], a3, cout3); 
    and(c3, cout3, a3); 
    or(c_out, c3, b3); 
    
    ////////////////////////

endmodule

/* Implement arithmeticUnit with adder module
 * You must use one adder module.
 * You must not use Verilog arithmetic operators */
module arithmeticUnit(
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    wire [3:0] add; 
    or(add[3], select[1]&y[3], select[2]&(~y[3])); 
    or(add[2], select[1]&y[2], select[2]&(~y[2])); 
    or(add[1], select[1]&y[1], select[2]&(~y[1])); 
    or(add[0], select[1]&y[0], select[2]&(~y[0])); 
    
    adder add_ALU (x[3:0], add[3:0], select [0], out [3:0], c_out); 
    ////////////////////////

endmodule

/* Implement 4:1 mux */
module mux4to1(
    input [3:0] in,
    input [1:0] select,
    output out
);

    ////////////////////////
    wire [3:0] d; 
    and (d[0], in[0], ~select[1]&~select[0]); 
    and (d[1], in[1], ~select[1]&select[0]); 
    and (d[2], in[2], select[1]&~select[0]); 
    and (d[3], in[3], select[1]&select[0]); 
    
    or (out, d[3], d[2], d[1], d[0]); 
    ////////////////////////

endmodule

/* Implement logicUnit with mux4to1 */
module logicUnit(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output [3:0] out
);

    ////////////////////////
    wire [3:0] op_and; 
    wire [3:0] op_or; 
    wire [3:0] op_xor; 
    wire [3:0] op_not; 
    
    and (op_and[3], x[3], y[3]); 
    and (op_and[2], x[2], y[2]); 
    and (op_and[1], x[1], y[1]); 
    and (op_and[0], x[0], y[0]); 
    
    or (op_or[3], x[3], y[3]); 
    or (op_or[2], x[2], y[2]); 
    or (op_or[1], x[1], y[1]); 
    or (op_or[0], x[0], y[0]);
    
    xor (op_xor[3], x[3], y[3]); 
    xor (op_xor[2], x[2], y[2]); 
    xor (op_xor[1], x[1], y[1]); 
    xor (op_xor[0], x[0], y[0]);
    
    not (op_not[3], x[3]); 
    not (op_not[2], x[2]);
    not (op_not[1], x[1]);
    not (op_not[0], x[0]);
    
    mux4to1 m3 ({op_not[3], op_xor[3], op_or[3], op_and[3]}, {select[1], select[0]}, out[3]); 
    mux4to1 m2 ({op_not[2], op_xor[2], op_or[2], op_and[2]}, {select[1], select[0]}, out[2]); 
    mux4to1 m1 ({op_not[1], op_xor[1], op_or[1], op_and[1]}, {select[1], select[0]}, out[1]); 
    mux4to1 m0 ({op_not[0], op_xor[0], op_or[0], op_and[0]}, {select[1], select[0]}, out[0]); 
    ////////////////////////

endmodule

/* Implement 2:1 mux */
module mux2to1(
    input [1:0] in,
    input  select,
    output out
);

    ////////////////////////
    or(out, in[1]&select, in[0]&~select); 
    ////////////////////////

endmodule

/* Implement ALU with mux2to1 */
module lab5_1(
    input [3:0] x,
    input [3:0] y,
    input [3:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    wire [3:0] arith; 
    wire [3:0] logic; 
    
    arithmeticUnit au (x[3:0], y[3:0], select[2:0], arith[3:0], c_out); 
    logicUnit lu (x[3:0], y[3:0], select[1:0], logic[3:0]); 
    
    mux2to1 mu3 ({logic[3], arith[3]}, select[3], out[3]); 
    mux2to1 mu2 ({logic[2], arith[2]}, select[3], out[2]); 
    mux2to1 mu1 ({logic[1], arith[1]}, select[3], out[1]); 
    mux2to1 mu0 ({logic[0], arith[0]}, select[3], out[0]); 
    ////////////////////////

endmodule
