/* CSED273 lab2 experiment 2 */
/* lab2_2.v */

/* Simplifed equation by K-Map method
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_2(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT_2 cal_gt2(outGT, inA, inB);
    CAL_EQ_2 cal_eq2(outEQ, inA, inB);
    CAL_LT_2 cal_lt2(outLT, inA, inB);

endmodule

/* Implement output about "A>B" */
module CAL_GT_2(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    ////////////////////////
    wire gt1, gt2, gt3; 
    assign gt1 = (inA[1]&~inB[1]); 
    assign gt2 = (inA[1]&inA[0]&~inB[0]); 
    assign gt3 = (inA[0]&~inB[1]&~inB[0]); 

    assign outGT = gt1|gt2|gt3; 
    ////////////////////////

endmodule

/* Implement output about "A=B" */
module CAL_EQ_2(
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
module CAL_LT_2(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    ////////////////////////    
    wire lt1, lt2, lt3; 
    assign lt1 = (~inA[1]&inB[1]); 
    assign lt2 = (~inA[1]&~inA[0]&inB[0]); 
    assign lt3 = (~inA[0]&inB[1]&inB[0]); 

    assign outLT = lt1|lt2|lt3; 
    ////////////////////////

endmodule