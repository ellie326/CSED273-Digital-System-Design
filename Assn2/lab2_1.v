/* CSED273 lab2 experiment 1 */
/* lab2_1.v */

/* Unsimplifed equation
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_1(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT cal_gt(outGT, inA, inB);
    CAL_EQ cal_eq(outEQ, inA, inB);
    CAL_LT cal_lt(outLT, inA, inB);
    
endmodule

/* Implement output about "A>B" */
module CAL_GT(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    ////////////////////////
    wire gt1, gt2, gt3, gt4, gt5, gt6; 
    assign gt1 = (~inA[1]&inA[0]&~inB[1]&~inB[0]);
    assign gt2 = (inA[1]&~inA[0]&~inB[1]&~inB[0]);
    assign gt3 = (inA[1]&~inA[0]&~inB[1]&inB[0]);
    assign gt4 = (inA[1]&inA[0]&~inB[1]&~inB[0]);
    assign gt5 = (inA[1]&inA[0]&~inB[1]&inB[0]);
    assign gt6 = (inA[1]&inA[0]&inB[1]&~inB[0]);
     
    assign outGT = gt1|gt2|gt3|gt4|gt5|gt6; 
    ////////////////////////

endmodule

/* Implement output about "A=B" */
module CAL_EQ(
    output wire outEQ,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////    
    wire eq1, eq2, eq3, eq4; 
    assign eq1 = (~inA[1]&~inA[0]&~inB[1]&~inB[0]);
    assign eq2 = (~inA[1]&inA[0]&~inB[1]&inB[0]);
    assign eq3 = (inA[1]&~inA[0]&inB[1]&~inB[0]);
    assign eq4 = (inA[1]&inA[0]&inB[1]&inB[0]);
    
    assign outEQ = eq1|eq2|eq3|eq4; 
    ////////////////////////

endmodule

/* Implement output about "A<B" */
module CAL_LT(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////    
    wire lt1, lt2, lt3, lt4, lt5, lt6; 
    assign lt1 = (~inA[1]&~inA[0]&~inB[1]&inB[0]); 
    assign lt2 = (~inA[1]&~inA[0]&inB[1]&~inB[0]);
    assign lt3 = (~inA[1]&~inA[0]&inB[1]&inB[0]);
    assign lt4 = (~inA[1]&inA[0]&inB[1]&~inB[0]);
    assign lt5 = (~inA[1]&inA[0]&inB[1]&inB[0]);
    assign lt6 = (inA[1]&~inA[0]&inB[1]&inB[0]);
    
    assign outLT = lt1|lt2|lt3|lt4|lt5|lt6; 
    ////////////////////////

endmodule