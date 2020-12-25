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
	wire clk_div, clk_dot, clk_spn; // assign dot matrix column, scan dot matrix row, turn on dot matrix, respectively
	
	clk_divide div(.clk(clk), .rst(rst), .div_clk(clk_div), .frequency(32'd250000));
	clk_divide dot(.clk(clk), .rst(rst), .div_clk(clk_dot), .frequency(32'd5000));
	clk_divide spn(.clk(clk), .rst(rst), .div_clk(clk_spn), .frequency(32'd25000000));
	
	/***********************************************************/
	// lfsr ( pseudo-random sequence generator )
	
	reg [7:0] rnd_seq;
	reg [7:0] rnd_num;

	always @(rnd_seq) begin
		rnd_num = (rnd_seq[6:3] * rnd_seq[4:1]);
		rnd_num[3:0] = {rnd_seq[7], rnd_num[3], rnd_num[5], rnd_seq[0]};
	end

	always @(posedge clk_spn or negedge rst) begin		
	if (~rst)
		rnd_seq <= 8'd1; 
	else
		rnd_seq <= {rnd_seq[6:0], rnd_seq[7] ^ rnd_seq[5] ^ rnd_seq[4] ^ rnd_seq[3]};
	end
	
	/**********************************************************/
	
	/**********************************************************/
	// scan row
	integer it;
	
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
	/**********************************************************/
	
	/**********************************************************/
	// assign column
	
	reg [15:0] signal;
	reg [31:0] count [15:0];
		
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
		begin
			case(rnd_num[5:2])
				4'hf:begin
					signal[0]<=1'b1;
					dot_col_buf[0]<=8'b11000000|dot_col_buf[0];
					dot_col_buf[1]<=8'b11000000|dot_col_buf[1];
				end
				4'he:begin
					signal[1]<=1'b1;
					dot_col_buf[0]<=8'b00110000|dot_col_buf[0];
					dot_col_buf[1]<=8'b00110000|dot_col_buf[1];
				end
				4'hd:begin
					signal[2]<=1'b1;
					dot_col_buf[0]<=8'b00001100|dot_col_buf[0];
					dot_col_buf[1]<=8'b00001100|dot_col_buf[1];
				end
				4'hc:begin
					signal[3]<=1'b1;
					dot_col_buf[0]<=8'b00000011|dot_col_buf[0];
					dot_col_buf[1]<=8'b00000011|dot_col_buf[1];
				end
				4'hb:begin
					signal[4]<=1'b1;
					dot_col_buf[2]<=8'b11000000|dot_col_buf[2];
					dot_col_buf[3]<=8'b11000000|dot_col_buf[3];
				end
				4'h3:begin
					signal[5]<=1'b1;
					dot_col_buf[2]<=8'b00110000|dot_col_buf[2];
					dot_col_buf[3]<=8'b00110000|dot_col_buf[3];
				end
				4'h6:begin
					signal[6]<=1'b1;
					dot_col_buf[2]<=8'b00001100|dot_col_buf[2];
					dot_col_buf[3]<=8'b00001100|dot_col_buf[3];
				end
				4'h9:begin
					signal[7]<=1'b1;
					dot_col_buf[2]<=8'b00000011|dot_col_buf[2];
					dot_col_buf[3]<=8'b00000011|dot_col_buf[3];
				end
				4'ha:begin
					signal[8]<=1'b1;
					dot_col_buf[4]<=8'b11000000|dot_col_buf[4];
					dot_col_buf[5]<=8'b11000000|dot_col_buf[5];
				end
				4'h2:begin
					signal[9]<=1'b1;
					dot_col_buf[4]<=8'b00110000|dot_col_buf[4];
					dot_col_buf[5]<=8'b00110000|dot_col_buf[5];
				end
				4'h5:begin
					signal[10]<=1'b1;
					dot_col_buf[4]<=8'b00001100|dot_col_buf[4];
					dot_col_buf[5]<=8'b00001100|dot_col_buf[5];
				end
				4'h8:begin
					signal[11]<=1'b1;
					dot_col_buf[4]<=8'b00000011|dot_col_buf[4];
					dot_col_buf[5]<=8'b00000011|dot_col_buf[5];
				end
				4'h0:begin
					signal[12]<=1'b1;
					dot_col_buf[6]<=8'b11000000|dot_col_buf[6];
					dot_col_buf[7]<=8'b11000000|dot_col_buf[7];
				end
				4'h1:begin
					signal[13]<=1'b1;
					dot_col_buf[6]<=8'b00110000|dot_col_buf[6];
					dot_col_buf[7]<=8'b00110000|dot_col_buf[7];
				end
				4'h4:begin
					signal[14]<=1'b1;
					dot_col_buf[6]<=8'b00001100|dot_col_buf[6];
					dot_col_buf[7]<=8'b00001100|dot_col_buf[7];
				end
				4'h7:begin
					signal[15]<=1'b1;
					dot_col_buf[6]<=8'b00000011|dot_col_buf[6];
					dot_col_buf[7]<=8'b00000011|dot_col_buf[7];
				end
			endcase
			for(it=0;it<16;it=it+1) begin
				if(signal[it]==1'b1) begin
				   // clock divider for stay time
					if(count[it]==32'd500) begin
						count[it]<=32'd0;
						case(it)
							0:begin
								signal[0]<=1'b0;
								dot_col_buf[0]<=8'b00111111&dot_col_buf[0];
								dot_col_buf[1]<=8'b00111111&dot_col_buf[1];
							end
							1:begin
								signal[1]<=1'b0;
								dot_col_buf[0]<=8'b11001111&dot_col_buf[0];
								dot_col_buf[1]<=8'b11001111&dot_col_buf[1];
							end
							2:begin
								signal[2]<=1'b0;
								dot_col_buf[0]<=8'b11110011&dot_col_buf[0];
								dot_col_buf[1]<=8'b11110011&dot_col_buf[1];
							end
							3:begin
								signal[3]<=1'b0;
								dot_col_buf[0]<=8'b11111100&dot_col_buf[0];
								dot_col_buf[1]<=8'b11111100&dot_col_buf[1];
							end
							4:begin
								signal[4]<=1'b0;
								dot_col_buf[2]<=8'b00111111&dot_col_buf[2];
								dot_col_buf[3]<=8'b00111111&dot_col_buf[3];
							end
							5:begin
								signal[5]<=1'b0;
								dot_col_buf[2]<=8'b11001111&dot_col_buf[2];
								dot_col_buf[3]<=8'b11001111&dot_col_buf[3];
							end
							6:begin
								signal[6]<=1'b0;
								dot_col_buf[2]<=8'b11110011&dot_col_buf[2];
								dot_col_buf[3]<=8'b11110011&dot_col_buf[3];
							end
							7:begin
								signal[7]<=1'b0;
								dot_col_buf[2]<=8'b11111100&dot_col_buf[2];
								dot_col_buf[3]<=8'b11111100&dot_col_buf[3];
							end
							8:begin
								signal[8]<=1'b0;
								dot_col_buf[4]<=8'b00111111&dot_col_buf[4];
								dot_col_buf[5]<=8'b00111111&dot_col_buf[5];
							end
							9:begin
								signal[9]<=1'b0;
								dot_col_buf[4]<=8'b11001111&dot_col_buf[4];
								dot_col_buf[5]<=8'b11001111&dot_col_buf[5];
							end
							10:begin
								signal[10]<=1'b0;
								dot_col_buf[4]<=8'b11110011&dot_col_buf[4];
								dot_col_buf[5]<=8'b11110011&dot_col_buf[5];
							end
							11:begin
								signal[11]<=1'b0;
								dot_col_buf[4]<=8'b11111100&dot_col_buf[4];
								dot_col_buf[5]<=8'b11111100&dot_col_buf[5];
							end
							12:begin
								signal[12]<=1'b0;
								dot_col_buf[6]<=8'b00111111&dot_col_buf[6];
								dot_col_buf[7]<=8'b00111111&dot_col_buf[7];
							end
							13:begin
								signal[13]<=1'b0;
								dot_col_buf[6]<=8'b11001111&dot_col_buf[6];
								dot_col_buf[7]<=8'b11001111&dot_col_buf[7];
							end
							14:begin
								signal[14]<=1'b0;
								dot_col_buf[6]<=8'b11110011&dot_col_buf[6];
								dot_col_buf[7]<=8'b11110011&dot_col_buf[7];
							end
							15:begin
								signal[15]<=1'b0;
								dot_col_buf[6]<=8'b11111100&dot_col_buf[6];
								dot_col_buf[7]<=8'b11111100&dot_col_buf[7];
							end
						endcase
					end	
					else begin
						count[it] <= count[it] + 32'd1;
					end
				end
				else begin end
			end
		end
	end
	/**********************************************************/
	// bcd display
	
	always@(*)
	begin
		case(rnd_num[5:2])
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

module clk_divide(clk, rst, div_clk, frequency);
input clk, rst;
input [31:0] frequency;
output div_clk;

reg div_clk;
reg [31:0] count;

always@(posedge clk)
begin
	if(!rst)
	begin
		count <= 32'd0;
		div_clk <= 1'b0;
	end
	else
	begin
		if(count==frequency)
		begin
			count <= 32'd0;
			div_clk <= ~div_clk;
		end
		else
		begin
			count <= count + 32'd1;
		end
	end
end
endmodule

	