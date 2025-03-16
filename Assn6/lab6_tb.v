/* CSED273 lab6 experiments */
/* lab6_tb.v */

`timescale 1ps / 1fs

module lab6_tb();

    integer Passed;
    integer Failed;

    /* Define input, output and instantiate module */
    ////////////////////////
    
    reg reset1; 
    reg clk1; 
    wire [3:0] out1; 
    decade_counter test1 (.reset_n(reset1), .clk(clk1), .count(out1));
    
    
    reg reset2; 
    reg clk2; 
    wire [7:0] out2; 
    decade_counter_2digits test2 (.reset_n(reset2), .clk(clk2), .count(out2)); 
    
    
    reg reset3; 
    reg clk3; 
    wire [3:0] out3; 
    counter_369 test3 (.reset_n(reset3), .clk(clk3), .count(out3)); 
    
    
    initial begin 
        reset1 = 0; 
        reset2 = 0; 
        reset3 = 0; 
        clk1 = 0; 
        clk2 = 0; 
        clk3 = 0; 
   end
    ////////////////////////

    initial begin
        Passed = 0;
        Failed = 0;

        lab6_1_test;
        lab6_2_test;
        lab6_3_test;

        $display("Lab6 Passed = %0d, Failed = %0d", Passed, Failed);
        $finish;
    end

    /* Implement test task for lab6_1 */
    task lab6_1_test;
        ////////////////////////
        
        integer i;
        reg [3:0] out1_expected;
        begin
            $display("lab6_1_test_finish");
            clk1 = 1'b1;
            clk2 = 1'b1;
            clk3 = 1'b1;
            reset1 = 1'b0;
            reset2 = 1'b0;
            reset3 = 1'b0;
            #5 clk1 = 1'b0;
            #5 clk1 = 1;
            
            out1_expected = 4'h0;
            reset1 = 1'b1;
            for(i=0;i<10;i=i+1) begin
                if(out1_expected == 9)
                    out1_expected = 0;
                else out1_expected = i+1;
            #5 clk1 = 1'b0;
            #2;
            if(out1 == out1_expected) begin
                Passed = Passed + 1;
                end
            else begin
                Failed = Failed + 1;
                end
            #3 clk1 = 1'b1;
            end
        end   
        
        ////////////////////////
    endtask

    /* Implement test task for lab6_2 */
    task lab6_2_test;
        ////////////////////////
        
            integer i, j;
        reg [7:0] out2_expected;
        begin
            $display("lab6_2_test_finish");
            reset2 = 1'b0;
            #5 clk2 = 1'b0;
            #5 clk2 = 1;
            j=0;
            out2_expected = 7'h0;
            reset2 = 1'b1;
            for(i=0;i<100;i=i+1) begin
                if(out2_expected == 99)
                    out2_expected = 0;
                else out2_expected = i+1;
                #5 clk2 = 1'b0;
                #2;
                if(10*out2[7:4]+out2[3:0] == out2_expected) begin
                    Passed = Passed + 1; 
                    end
                else begin
                    Failed = Failed + 1;
                    end
                #3 clk2 = 1'b1;
            end
        end
        
        ////////////////////////
    endtask

    /* Implement test task for lab6_3 */
    task lab6_3_test;
        ////////////////////////
        
        integer i;
        reg [3:0] out3_expected;
        begin
            $display("lab6_3_test_finish");
            reset3 = 1'b0;
            #5 clk3 = 1'b0;
            #5 clk3 = 1;
            
            out3_expected = 4'h0;
            reset3 = 1'b1;
            for(i=0;i<14;i=i+1) begin
                if(out3_expected == 9)
                    out3_expected = 13;
                else if(out3_expected == 13)
                    out3_expected = 6;
                else out3_expected = out3_expected+3;
            #5 clk3 = 1'b0;
            #2;
            if(out3 == out3_expected) begin
                Passed = Passed + 1;
                end
            else begin
                Failed = Failed + 1;
                end
            #3 clk3 = 1'b1;
            end
        end
        
        ////////////////////////
    endtask

endmodule