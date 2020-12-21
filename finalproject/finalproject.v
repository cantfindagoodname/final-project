module finalproject(clk,rst,keypad_row,keypad_col,dot_row,dot_col,seven_seg);
	input clk,rst;
	output reg [3:0] keypad_row;
	input [3:0] keypad_col;
	output reg [7:0] dot_row,dot_col;
	output reg [6:0] seven_seg;

	reg [31:0] cnt_div,cnt_dot;
	reg [7:0] dot_col_buf[0:7];
	reg [3:0] keypad_buf;
	reg [2:0] row_count;
	reg clk_div,clk_dot;
	
	integer it, it2;
	reg [31:0] delayCount[15:0];
	
	reg [15:0] moleUp;
	
	integer rnd_int;
	reg [31:0] cnt_spawn;
	
	reg [7:0] cnt_rnd;
	
	
	// clock divider
	always@(posedge clk)
	begin
		if (~rst) begin
			cnt_div <= 32'b0;
			cnt_dot <= 32'b0;
			clk_div <= 1'b0;
			clk_dot <= 1'b0;
			
			cnt_spawn <= 32'b0;

			for(it=0;it<16;it=it+1)begin
				delayCount[it] <= 16'b0;
				moleUp[it] <= 16'b0;
			end
			
		end
		else begin
		
			if(cnt_div == 32'd250000)begin
				cnt_div <= 32'd0;
				clk_div <= ~clk_div;
			end
			else begin
				cnt_div <= cnt_div + 32'd1;
			end
			
			if(cnt_dot == 32'd5000)begin
				cnt_dot <= 32'd0;
				clk_dot <= ~clk_dot;
			end
			else begin
				cnt_dot <= cnt_dot + 32'd1;
			end
			
			if(cnt_rnd == 8'b11111111) begin
				cnt_rnd <= 8'd0;
			end
			else begin
				cnt_rnd <= cnt_rnd  + 8'd1;
			end
			
			if(cnt_spawn == 32'd12500000) begin
				cnt_spawn <= 32'd0;
				
				rnd_int = cnt_rnd[6:2];
				rnd_int = (rnd_int * rnd_int) % 16;
				moleUp[rnd_int] <= 1;

			end
			else begin
				cnt_spawn <= cnt_spawn + 32'd1;
			end
			
			for(it=0;it<16;it=it+1) begin
				if(moleUp[it]) begin
					if(delayCount[it] == 32'd25000000) begin
						delayCount[it] <= 32'd0;
						moleUp[it] <= 1'd0;
					end
					else begin
						delayCount[it] <= delayCount[it] + 32'd1;
					end
				end
				else begin
					delayCount[it] <= 32'd0;
				end
			end		
		end
	end
	
	// scan row
	always@ (posedge clk_dot or negedge rst)
	begin
		if (~rst)
		begin
			dot_row <= 8'd0;
			dot_col <= 8'd0;
			row_count <= 3'd0;
		end
		else
		begin
		    row_count <= row_count + 1;
		    dot_col <= dot_col_buf[row_count];
		    case (row_count)
				3'd0: dot_row <= 8'b01111111;
				3'd1: dot_row <= 8'b10111111;
				3'd2: dot_row <= 8'b11011111;
				3'd3: dot_row <= 8'b11101111;
				3'd4: dot_row <= 8'b11110111;
				3'd5: dot_row <= 8'b11111011;
				3'd6: dot_row <= 8'b11111101;
				3'd7: dot_row <= 8'b11111110;
			endcase
		end
	end
	
	
	// keypad buffer
	always@(posedge clk_div or negedge rst)
	begin
		if (~rst)
		begin
			dot_col_buf[0] <= 8'd0;
			dot_col_buf[1] <= 8'd0;
			dot_col_buf[2] <= 8'd0;
			dot_col_buf[3] <= 8'd0;
			dot_col_buf[4] <= 8'd0;
			dot_col_buf[5] <= 8'd0;
			dot_col_buf[6] <= 8'd0;
			dot_col_buf[7] <= 8'd0;
		end
		else

		for(it=0;it<16;it=it+1)begin
			if(moleUp[it])begin
				case(it)
					0:begin
						dot_col_buf[0]<=8'b11000000|dot_col_buf[0];
						dot_col_buf[1]<=8'b11000000|dot_col_buf[1];
					end
					1:begin
						dot_col_buf[0]<=8'b00110000|dot_col_buf[0];
						dot_col_buf[1]<=8'b00110000|dot_col_buf[1];
					end
					2:begin
						dot_col_buf[0]<=8'b00001100|dot_col_buf[0];
						dot_col_buf[1]<=8'b00001100|dot_col_buf[1];
					end
					3:begin
						dot_col_buf[0]<=8'b00000011|dot_col_buf[0];
						dot_col_buf[1]<=8'b00000011|dot_col_buf[1];
					end
					4:begin
						dot_col_buf[2]<=8'b11000000|dot_col_buf[2];
						dot_col_buf[3]<=8'b11000000|dot_col_buf[3];
					end
					5:begin
						dot_col_buf[2]<=8'b00110000|dot_col_buf[2];
						dot_col_buf[3]<=8'b00110000|dot_col_buf[3];
					end
					6:begin
						dot_col_buf[2]<=8'b00001100|dot_col_buf[2];
						dot_col_buf[3]<=8'b00001100|dot_col_buf[3];
					end
					7:begin
						dot_col_buf[2]<=8'b00000011|dot_col_buf[2];
						dot_col_buf[3]<=8'b00000011|dot_col_buf[3];
					end
					8:begin
						dot_col_buf[4]<=8'b11000000|dot_col_buf[4];
						dot_col_buf[5]<=8'b11000000|dot_col_buf[5];
					end
					9:begin
						dot_col_buf[4]<=8'b00110000|dot_col_buf[4];
						dot_col_buf[5]<=8'b00110000|dot_col_buf[5];
					end
					10:begin
						dot_col_buf[4]<=8'b00001100|dot_col_buf[4];
						dot_col_buf[5]<=8'b00001100|dot_col_buf[5];
					end
					11:begin
						dot_col_buf[4]<=8'b00000011|dot_col_buf[4];
						dot_col_buf[5]<=8'b00000011|dot_col_buf[5];
					end
					12:begin
						dot_col_buf[6]<=8'b11000000|dot_col_buf[6];
						dot_col_buf[7]<=8'b11000000|dot_col_buf[7];
					end
					13:begin
						dot_col_buf[6]<=8'b00110000|dot_col_buf[6];
						dot_col_buf[7]<=8'b00110000|dot_col_buf[7];
					end
					14:begin
						dot_col_buf[6]<=8'b00001100|dot_col_buf[6];
						dot_col_buf[7]<=8'b00001100|dot_col_buf[7];
					end
					15:begin
						dot_col_buf[6]<=8'b00000011|dot_col_buf[6];
						dot_col_buf[7]<=8'b00000011|dot_col_buf[7];
					end
				endcase
			end
			else begin
				case(it)
					0:begin
						dot_col_buf[0]<=8'b00111111&dot_col_buf[0];
						dot_col_buf[1]<=8'b00111111&dot_col_buf[1];
					end
					1:begin
						dot_col_buf[0]<=8'b11001111&dot_col_buf[0];
						dot_col_buf[1]<=8'b11001111&dot_col_buf[1];
					end
					2:begin
						dot_col_buf[0]<=8'b11110011&dot_col_buf[0];
						dot_col_buf[1]<=8'b11110011&dot_col_buf[1];
					end
					3:begin
						dot_col_buf[0]<=8'b11111100&dot_col_buf[0];
						dot_col_buf[1]<=8'b11111100&dot_col_buf[1];
					end
					4:begin
						dot_col_buf[2]<=8'b00111111&dot_col_buf[2];
						dot_col_buf[3]<=8'b00111111&dot_col_buf[3];
					end
					5:begin
						dot_col_buf[2]<=8'b11001111&dot_col_buf[2];
						dot_col_buf[3]<=8'b11001111&dot_col_buf[3];
					end
					6:begin
						dot_col_buf[2]<=8'b11110011&dot_col_buf[2];
						dot_col_buf[3]<=8'b11110011&dot_col_buf[3];
					end
					7:begin
						dot_col_buf[2]<=8'b11111100&dot_col_buf[2];
						dot_col_buf[3]<=8'b11111100&dot_col_buf[3];
					end
					8:begin
						dot_col_buf[4]<=8'b00111111&dot_col_buf[4];
						dot_col_buf[5]<=8'b00111111&dot_col_buf[5];
					end
					9:begin
						dot_col_buf[4]<=8'b11001111&dot_col_buf[4];
						dot_col_buf[5]<=8'b11001111&dot_col_buf[5];
					end
					10:begin
						dot_col_buf[4]<=8'b11110011&dot_col_buf[4];
						dot_col_buf[5]<=8'b11110011&dot_col_buf[5];
					end
					11:begin
						dot_col_buf[4]<=8'b11111100&dot_col_buf[4];
						dot_col_buf[5]<=8'b11111100&dot_col_buf[5];
					end
					12:begin
						dot_col_buf[6]<=8'b00111111&dot_col_buf[6];
						dot_col_buf[7]<=8'b00111111&dot_col_buf[7];
					end
					13:begin
						dot_col_buf[6]<=8'b11001111&dot_col_buf[6];
						dot_col_buf[7]<=8'b11001111&dot_col_buf[7];
					end
					14:begin
						dot_col_buf[6]<=8'b11110011&dot_col_buf[6];
						dot_col_buf[7]<=8'b11110011&dot_col_buf[7];
					end
					15:begin
						dot_col_buf[6]<=8'b11111100&dot_col_buf[6];
						dot_col_buf[7]<=8'b11111100&dot_col_buf[7];
					end
				endcase
			end
		end
		
		begin
			case({keypad_row, keypad_col})
				8'b01110111:begin
					keypad_buf <= 4'hf;
				end
				8'b01111011:begin
					keypad_buf <= 4'he;
				end
				8'b01111101:begin
					keypad_buf <= 4'hd;
				end
				8'b01111110:begin
					keypad_buf <= 4'hc;
				end
				8'b10110111:begin
					keypad_buf <= 4'hb;
				end
				8'b10111011:begin
					keypad_buf <= 4'h3;
				end
				8'b10111101:begin
					keypad_buf <= 4'h6;
				end
				8'b10111110:begin
					keypad_buf <= 4'h9;
				end
				8'b11010111:begin
					keypad_buf <= 4'ha;
				end
				8'b11011011:begin
					keypad_buf <= 4'h2;
				end
				8'b11011101:begin
					keypad_buf <= 4'h5;
				end
				8'b11011110:begin
					keypad_buf <= 4'h8;
				end
				8'b11100111:begin
					keypad_buf <= 4'h0;
				end
				8'b11101011:begin
					keypad_buf <= 4'h1;
				end
				8'b11101101:begin
					keypad_buf <= 4'h4;
				end
				8'b11101110:begin
					keypad_buf <= 4'h7;
				end
				default:
					keypad_buf<=keypad_buf;
			endcase
		end
		
	end
	

	// seven segment display
	always@(*)
	begin
		case(keypad_buf)
		4'h0:seven_seg = 7'b1000000;
		4'h1:seven_seg = 7'b1111001;
		4'h2:seven_seg = 7'b0100100;
		4'h3:seven_seg = 7'b0110000;
		4'h4:seven_seg = 7'b0011001;
		4'h5:seven_seg = 7'b0010010;
		4'h6:seven_seg = 7'b0000010;
		4'h7:seven_seg = 7'b1111000;
		4'h8:seven_seg = 7'b0000000;
		4'h9:seven_seg = 7'b0010000;
		4'ha:seven_seg = 7'b0001000;
		4'hb:seven_seg = 7'b0000011;
		4'hc:seven_seg = 7'b1000110;
		4'hd:seven_seg = 7'b0100001;
		4'he:seven_seg = 7'b0000110;
		4'hf:seven_seg = 7'b0001110;
		endcase
	end

endmodule
