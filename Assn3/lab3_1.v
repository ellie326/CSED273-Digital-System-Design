/* CSED273 lab3 experiment 1 */
/* lab3_1.v */


/* Active Low 2-to-4 Decoder
 * You must use this module to implement Active Low 4-to-16 decoder */
module decoder(
    input wire en,
    input wire [1:0] in,
    output wire [3:0] out 
    );

    nand(out[0], ~in[0], ~in[1], ~en);
    nand(out[1],  in[0], ~in[1], ~en);
    nand(out[2], ~in[0],  in[1], ~en);
    nand(out[3],  in[0],  in[1], ~en);

endmodule


/* Implement Active Low 4-to-16 Decoder
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level modeling (and, or, not) */
module lab3_1(
    input wire en,
    input wire [3:0] in,
    output wire [15:0] out
    );

    ////////////////////////
    wire a, b, c, d; 
    decoder decoder0 (en, {in[3],in[2]},{d, c, b, a}); 
    decoder decoder1 (a, {in[1],in[0]}, {out[3], out[2], out[1], out[0]}); 
    decoder decoder2 (b, {in[1],in[0]}, {out[7], out[6], out[5], out[4]}); 
    decoder decoder3 (c, {in[1],in[0]}, {out[11], out[10], out[9], out[8]}); 
    decoder decoder4 (d, {in[1],in[0]}, {out[15], out[14], out[13], out[12]}); 
    ////////////////////////

endmodule
