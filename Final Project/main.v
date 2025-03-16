`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 

// 
// Create Date: 2023/05/30 20:20:10
// Design Name: 
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module main(
    input clk,
    input Action,    // FPGA의 가운데 버튼
    input p_Sel1,    // FPGA의 왼쪽 버튼
    input p_Sel2,    // FPGA의 오른쪽 버튼
    input p_reInput, // FPGA의 아래쪽 버튼
    input [7:0] p_sw, // switch 입력, userInput에 사용
    output [3:0] ssSel,
    output [7:0] ssDisp,
    output reg [15:0] led
);
    reg [5:0] targetNumber;
    reg [2:0] state;
    reg [5:0] userInput;
    integer counter;
    integer seq_count0, seq_count1, seq_count00, seq_count01, seq_count10, seq_count11;
    integer count0, count1, count00, count01, count10, count11;
    integer i;
    reg [15:0] gbuf;    // ssDis 출력 저장
    reg [5:0] random;
    
    reg Sel1, Sel2, reInput;
    reg [7:0] sw;
    reg [7:0] d_sw;
    
    initial begin
        state <= 0;
        counter <= 0;
        count0 <= 0;
        count1 <= 0;
        count00 <= 0;
        count01 <= 0;
        count10 <= 0;
        count11 <= 0;    
        gbuf <= 16'b1111111111111111;
        Sel1 <= 0;
        Sel2 <= 0;
        reInput <= 0;
        sw <= 8'b00000000;
        d_sw <= 8'b00000000;
        random <= 0;
        
        led[15:0] = 16'b1010101100000000;
    end
    
    
    led_renderer renderer (
        .graphics(gbuf),
        .clk(clk),
        .segSel(ssSel),
        .seg(ssDisp)
    );

    
    
    always @(posedge p_Sel1) begin
        if(Sel1 == 1) begin
            Sel1 <= 0;
            led[10] <= 0;
        end else begin
            Sel1 <= 1;
            led[10] <= 1;
        end
    end
    
    
    always @(posedge p_Sel2) begin
        if(Sel2 == 1) begin
            Sel2 <= 0;
            led[12] <= 0;
        end else begin
            Sel2 <= 1;
            led[12] <= 1;
        end
    end
    
    always @(posedge p_reInput) begin
        if(reInput == 1) begin
            reInput <= 0;
            led[14] <= 0;
        end else begin
            reInput <= 1;
            led[14] <= 1;
        end    
    end
    
    always @(*) begin
        sw<=~p_sw;	// 빵판에 연결한 스위치 입력이 반전시켜야 목표하는 작동을 하여 반전시킴(보고서에 관련 서술함)
        led[7:0] <= sw;
    end
    
    
    
    always @(posedge clk) begin
        if(random == 6'b111111)
            random <= 0;
        else 
            random <= random + 1;
    end
    
    
    // Action
    always @(posedge Action) begin
        
        case (state)
            0: begin
           
            ///// targetNumber 계산 //////////////
            if(counter == 0) begin
                // COnE : preparing step display (Configuration으로 COnF를 하려다가 F 자리가 없어서 E로 표현함)
                gbuf[3:0] = 4'b1110;
                gbuf[7:4] = 4'b1000;
                gbuf[11:8] = 4'b1100;
                gbuf[15:12] = 4'b1101; 
                
                counter = 1;
            end else if(counter == 1) begin
            
                /////////////////////////////////////////        
                
                // display
                gbuf[3:0] = 4'b1000;//0 출력 
                gbuf[15:4] = 12'b111111111111;
                
                //
                targetNumber = random;
                
                
                ///// testcode ////// answer display
                gbuf[15] = 0;
                gbuf[14:12] = targetNumber [5:3];
                                
                gbuf[11] = 0;
                gbuf[10:8] = targetNumber [2:0];
                /////////////////////////
                
                
                ///// targetNumber의 count를 계산/////////////////
                for (i = 5; i > 0; i = i - 1) begin
                    if (targetNumber[i] == 0) begin
                        seq_count0 = seq_count0 + 1;
                        if (targetNumber[i-1] == 0) begin
                            seq_count00 = seq_count00 + 1;
                        end else begin
                            seq_count01 = seq_count01 + 1;
                        end
                    end else begin
                        if (targetNumber[i-1] == 0) begin
                            seq_count10 = seq_count10 + 1;
                        end else begin
                            seq_count11 = seq_count11 + 1;
                        end
                    end
                end
                
                if (targetNumber[0] == 0) begin
                    seq_count0 = seq_count0 + 1;
                end
                seq_count1 = 6 - seq_count0;
                ///////////////////////////////////////////
                counter = 2;
                
            end else if(counter == 2) begin
                
                counter = 0;
                state = 1;
                gbuf[3:0] = 4'b0000;   
                gbuf[15:4] = 12'b111111111111;
            end
        end
            
            
            
            1: begin
                //display
                gbuf[3:0] = 4'b0000;   
               
                
                // 단일 입력만 받아서 처리하지만, 정상 작동만 가정하고서 아래와 같이 처리함
                if(counter == 0) begin
                    userInput[2] = sw[7] | sw[6] | sw[5] | sw[4];
                    userInput[1] = sw[7] | sw[6] | sw[3] | sw[2];
                    userInput[0] = sw[7] | sw[5] | sw[3] | sw[1];
                
                    //display
                    gbuf[11] = 0;
                    gbuf[10:8] = userInput[2:0];
                    
                end else if (counter == 1) begin
                    userInput[5] = sw[7] | sw[6] | sw[5] | sw[4];
                    userInput[4] = sw[7] | sw[6] | sw[3] | sw[2];
                    userInput[3] = sw[7] | sw[5] | sw[3] | sw[1];
                
                    //display
                    gbuf[15] = 0;
                    gbuf[14:12] = userInput[5:3];
                
                end

                
                if(counter == 2) begin
                    if(userInput == targetNumber) begin   // 입력한 숫자가 정답인 경우
                        state = 5;
                        
                        // End 출력        
                        gbuf[15:0] = 16'b1111111111111111;
                        gbuf[15:12] <= 4'b1011;
                        gbuf[11:8] <= 4'b1100;
                        gbuf[7:4] <= 4'b1101;
                    end else begin                          // 정답이 아닌 경우
                        state = 2;
                        gbuf[3:0] = 4'b0001;
                        gbuf[15:4] = 12'b111111111111;
                        
                    end
                    counter = 0;                    // 재실행을 위한 초기화
                    
                    ///// userInput의 count를 계산/////////////////
                    for(i = 5; i > 0; i= i - 1) begin
                        if(userInput[i] == 0) begin
                            count0 = count0 + 1;
                            if(userInput[i - 1] == 0) begin
                                count00 = count00 + 1;
                            end else begin
                                count01 = count01 + 1;
                            end
                        end else begin             
                            if(userInput[i - 1] == 0) begin
                                count10 = count10 + 1;
                            end else begin
                                count11 = count11 + 1;
                            end
                        end                 
                    end
                    
                    if(userInput[0] == 0) begin
                        count0 = count0 + 1;
                    end
                    
                    count1 = 6 - count0;
                    ///////////////////////////////////////////////////
                end else if(counter == 0) begin
                    counter = 1;
                end else if(counter == 1)
                    counter = 2;

            end


                        
            2: begin
            //display
            gbuf[3:0] = 4'b0001;
            gbuf[15:4] = 12'b111111111111;
            
            if(Sel1) begin
                state = 4;
                gbuf[3:0] = 4'b0011;
                gbuf[15:4] = 12'b111111111111;
                
            end else if(Sel2) begin
                state = 3;
                gbuf[3:0] = 4'b0010;
                gbuf[15:4] = 12'b111111111111;
                
            end else if(reInput) begin
                state = 1;
                gbuf[3:0] = 4'b000;   
                gbuf[15:4] = 12'b111111111111;
                
            end else begin
                case(sw)
                     8'b00000001:
                        begin
                            if(count0 < seq_count0) begin
                                //display 설정 up
                                gbuf[15:12] <= 4'b1010;
                                gbuf[11:8] <= 4'b1001;
                                
                            end else if (count0 == seq_count0) begin
                                //display 설정 sE
                                gbuf[15:12] <= 4'b1101;
                                gbuf[11:8] <= 4'b0100;
                                
                            end else begin
                                // display 설정 dn
                                gbuf[15:12] <= 4'b1100;
                                gbuf[11:8] <= 4'b1011;
                                
                            end
                        end
                    8'b00000010:
                        begin
                            if(count1 < seq_count1) begin
                                //display 설정 up
                                gbuf[15:12] <= 4'b1010;
                                gbuf[11:8] <= 4'b1001;
                                
                            end else if (count1 == seq_count1) begin
                                //display 설정 sE
                                gbuf[15:12] <= 4'b1101;
                                gbuf[11:8] <= 4'b0100;
                                
                            end else begin
                                // display 설정 dn
                                gbuf[15:12] <= 4'b1100;
                                gbuf[11:8] <= 4'b1011;
                                
                            end
                        end
                    endcase
                end        
                                     
            end



            3: begin
                //display
                gbuf[3:0] = 4'b0010;
                gbuf[15:4] = 12'b111111111111;
                
                if(Sel1) begin
                    state = 2;
                    gbuf[3:0] = 4'b0001;
                    gbuf[15:4] = 12'b111111111111;
        
                end else if(Sel2) begin
                    state = 4;
                    gbuf[3:0] = 4'b0011;
                    gbuf[15:4] = 12'b111111111111;
                
                end else if(reInput) begin
                    state = 1;
                    gbuf[3:0] = 4'b0000;   
                    gbuf[15:4] = 12'b111111111111;

                end else begin
                    case(sw)
                    8'b00000001:
                        begin
                            if(count00 < seq_count00) begin
                                //display 설정 up
                                gbuf[15:12] <= 4'b1010;
                                gbuf[11:8] <= 4'b1001;
                                
                            end else if (count00 == seq_count00) begin
                                //display 설정 sE
                                gbuf[15:12] <= 4'b1101;
                                gbuf[11:8] <= 4'b0100;
                                
                            end else begin
                                // display 설정 dn
                                gbuf[15:12] <= 4'b1100;
                                gbuf[11:8] <= 4'b1011;
                                
                            end
                        end
                    8'b00000010:
                        begin
                            if(count01 < seq_count01) begin
                                //display 설정 up
                                gbuf[15:12] <= 4'b1010;
                                gbuf[11:8] <= 4'b1001;
                                
                            end else if (count01 == seq_count01) begin
                                //display 설정 sE
                                gbuf[15:12] <= 4'b1101;
                                gbuf[11:8] <= 4'b0100;
                                
                            end else begin
                                // display 설정 dn
                                gbuf[15:12] <= 4'b1100;
                                gbuf[11:8] <= 4'b1011;
                                
                            end
                        end
                    8'b00000100:
                        begin
                            if(count10 < seq_count10) begin
                                //display 설정 up
                                gbuf[15:12] <= 4'b1010;
                                gbuf[11:8] <= 4'b1001;
                                
                            end else if (count10 == seq_count10) begin
                                //display 설정 sE
                                gbuf[15:12] <= 4'b1101;
                                gbuf[11:8] <= 4'b0100;
                                
                            end else begin
                                // display 설정 dn
                                gbuf[15:12] <= 4'b1100;
                                gbuf[11:8] <= 4'b1011;
                                
                            end
                        end
                    8'b00001000:
                        begin
                            if(count11 < seq_count11) begin
                                //display 설정 up
                                gbuf[15:12] <= 4'b1010;
                                gbuf[11:8] <= 4'b1001;
                                
                            end else if (count11 == seq_count11) begin
                                //display 설정 sE
                                gbuf[15:12] <= 4'b1101;
                                gbuf[11:8] <= 4'b0100;
                                
                            end else begin
                                // display 설정 dn
                                gbuf[15:12] <= 4'b1100;
                                gbuf[11:8] <= 4'b1011;
                                
                            end
                        end
                    endcase
                end
            end



            4: begin
                //display
                gbuf[3:0] = 4'b0011;
                gbuf[15:4] = 12'b111111111111;
                
                if(Sel1) begin
                    state = 3;
                    gbuf[3:0] = 4'b0010;
                    gbuf[15:4] = 12'b111111111111;
                    
                end else if(Sel2) begin
                    state = 2;
                    gbuf[3:0] = 4'b0001;
                    gbuf[15:4] = 12'b111111111111;

                end else if(reInput) begin
                    state = 1;
                    gbuf[3:0] = 4'b0000;  
                    gbuf[15:4] = 12'b111111111111; 
                end else begin
                    if(userInput < targetNumber) begin
                        //display 설정 up
                        gbuf[15:12] <= 4'b1010;
                        gbuf[11:8] <= 4'b1001;
                    // targetNumber = userInput일 수 없으므로 sE 출력 부분은 제거함    
                        
                    end else begin
                        //display 설정 dn
                        gbuf[15:12] <= 4'b1100;
                        gbuf[11:8] <= 4'b1011;
                    end                 
                end
            end


            5: begin
                state = 0;
            end
        endcase
    end
endmodule


module led_renderer (
    input [15:0] graphics,
    input clk,
    output reg [3:0] segSel,
    output reg [7:0] seg
);
  integer counter;
  wire [7:0] res0, res1, res2, res3;

  initial begin
    counter <= 0;
    segSel <= 14;
    seg <= 8'b11111111;
  end

  bcd_to_7seg pos0 (
      .bcd(graphics[3:0]),
      .seg(res0)
  );
  bcd_to_7seg pos1 (
      .bcd(graphics[7:4]),
      .seg(res1)
  );
  bcd_to_7seg pos2 (
      .bcd(graphics[11:8]),
      .seg(res2)
  );
  bcd_to_7seg pos3 (
      .bcd(graphics[15:12]),
      .seg(res3)
  );

  always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 100000) begin
      counter <= 0;
      case (segSel)
        14: begin
          segSel <= 13;
          seg <= res1;
        end
        13: begin
          segSel <= 11;
          seg <= res2;
        end
        11: begin
          segSel <= 7;
          seg <= res3;
        end
        7: begin
          segSel <= 14;
          seg <= res0;
        end
      endcase
    end
  end
endmodule


module bcd_to_7seg (
    input [3:0] bcd,
    output reg [7:0] seg
);

  always @(*) begin
    case (bcd)
      4'b0000: seg = 8'b11111001;  // 1
      4'b0001: seg = 8'b10100100;  // 2
      4'b0010: seg = 8'b10110000;  // 3
      4'b0011: seg = 8'b10011001;  // 4
      4'b0100: seg = 8'b10010010;  // 5, S
      4'b0101: seg = 8'b10000010;  // 6
      4'b0110: seg = 8'b11111000;  // 7
      4'b0111: seg = 8'b10000000;  // 8
      4'b1000: seg = 8'b11000000;  // 0
      4'b1001: seg = 8'b11000001;  // U
      4'b1010: seg = 8'b10001100;  // P
      4'b1011: seg = 8'b10100001;  // d
      4'b1100: seg = 8'b10101011;  // n
      4'b1101: seg = 8'b10000110;  // E
      4'b1110: seg = 8'b11000110;  // C
      4'b1111: seg = 8'b11111111;
    endcase
  end
endmodule


