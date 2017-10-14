`timescale 1ns / 1ps
module pwm(clk,rst_n,sw_freq,sw_duty,clkout);
    input clk;  //����ʱ���ź� 100MH
    input rst_n;//��λ
    input [2:0] sw_freq;//�л�Ƶ�ʿ��ƿ���
    input [1:0] sw_duty;//�л�ռ�ձ�
    output reg clkout;//���β�����ź�
    
    reg [7:0] div;   
    always @(*)
    begin
        case(sw_freq)
            3'b001:div = 8'd8;  // 1/8��Ƶ
            3'b010:div = 8'd16; // 1/16��Ƶ
            3'b011:div = 8'd32; // 1/32��Ƶ
            3'b100:div = 8'd64; // 1/64��Ƶ
            3'b101:div = 8'd128;// 1/128��Ƶ
            default: div = 8'd4;// 1/4��Ƶ
        endcase
    end
    
    reg [6:0] pulse;    // �������ֵ N*q = div*q
    always @(*)
    begin
        case(sw_duty)
            3'b01:pulse = div * 3/4;
            3'b10:pulse = div * 1/4;
            3'b11:pulse = div * 1/8;
            default: pulse = div * 1/2;
        endcase
    end
    
    reg [6:0] count;
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            count <= 0; clkout <= 0;
        end
        else
        begin
            if(count == div -1)
                count <= 0;
            else 
                count <= count + 1;
        end
    end
    
    always @(*)
    begin
        if(count < pulse)
            clkout <= 1;
        else
            clkout <= 0;
    end
    
endmodule
