`timescale 1ns / 1ps
module shift(clk,rst_n,msg);
input clk,rst_n;
// ��Ҫ��ʾ�ġ�HELLO���ַ��͡�12345��һһ��Ӧ
output reg [0:31] msg;  // �洢�ַ���Ϣ
parameter array = 32'h12345000; // "HELLO"ֻ��ǰ��λ��������λ����Ϊ��0��

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) msg <= array;    // ��ʼ���ַ���Ϣ
    else 
    begin
    // ��λ
        msg[0:27] <= msg[4:31];
        msg[28:31] <= msg[0:3];
    end
end


endmodule
