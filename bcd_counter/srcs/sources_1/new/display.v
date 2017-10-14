module  display(CLK_50M, RSTn, BCD, Segout,dp,AN);
	 input CLK_50M;	  //50 MHz clock
	 input RSTn;
	 input [7:0] BCD; // BCD code
	 output reg [6:0] Segout;  //7-segment code output
	 output reg [7:0]AN;  //AN0-AN3 select LED
	 output dp;
	 reg [26:0] Count;     //internal 20-bit counter
	 wire S2, S1, S0;
	 reg [3:0] InDigit;
	  
	 wire [7:0] En;
	  
	 assign dp = 1;	//С���㲻��

// ʱ�ӷ�Ƶ��
	always @(posedge CLK_50M or negedge RSTn)  //50 MHz clock
	begin
		if(~RSTn)  Count <= 0;
		else 	Count <= Count + 1;
	end

// 2-4��������
	assign {S2,S1,S0} = Count[20:18];	//����ˢ������T=20.97 ms��T/4=5.24 ms
	
	assign En[1] = | BCD[7:4];	//�����3λΪ0
	assign En[0] = 1;

	always @( * )  begin
		AN = 8'b11111111;	//4λ������ʾ
		if(En[{S2,S1,S0}]==1)
			AN[{S2,S1,S0}] = 0;  //ĳһλ��ʾ
	end

 
// 4λ4ѡ1����ѡ����
	always @( * )  
	begin
//		AN = 4'b1111;
		case ({S2,S1,S0})
			3'b000: begin
				InDigit= BCD[3:0];  //select BCD0 to display
//				AN = 4'b1110;       //Digit0 display,AN0---F12
				end
			3'b001: begin
				InDigit= BCD[7:4];  //select BCD1 to display
//				AN = 4'b1101;  //Digit1 display,AN1---J12
				end
			default:InDigit= 4'b0000;
	  endcase
	end


	//=====  BCD code => 7 Segment Code (a~g) =======	
	always @(InDigit)
            case (InDigit)  // --- gfedcba ----
                0:  Segout=7'b0000001; //display digital 0(40H)
                1:  Segout=7'b1001111; //display digital 1(79H)
                2:  Segout=7'b0010010; //display digital 2(24H)
                3:  Segout=7'b0000110; //display digital 3(30H)
                4:  Segout=7'b1001100; //display digital 4(19H)
                5:  Segout=7'b0100100; //display digital 5(12H)
                6:  Segout=7'b0100000; //display digital 6(02H)
                7:  Segout=7'b0001111; //display digital 7(78H)
                8:  Segout=7'b0000000; //display digital 8(00H)
                9:  Segout=7'b0000100; //display digital 9(10H)
                'hA: Segout=7'b0001000; //display digital A(08H)
                'hB: Segout=7'b0000011; //display digital b(03H)
                'hC: Segout=7'b0100111; //display digital c(27H)
                'hD: Segout=7'b0100001; //display digital d(21H)
                'hE: Segout=7'b0000110; //display digital E(06H)
                'hF: Segout=7'b0001110; //display digital F(0EH)
                default: Segout=7'b0100011; //display digital o(23H )     
            endcase

	endmodule