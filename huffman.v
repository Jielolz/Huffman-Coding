module huffman(clk, reset, gray_data, gray_valid, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg code_valid;
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;
reg out_en;
reg pattern_3;
reg compare_all;
reg [2:0] compare_cnt;

reg hcode1;
reg [1:0] hcode2;
reg [2:0] hcode3; 
reg [3:0] hcode4; 
reg [4:0] hcode5; 
reg [4:0] hcode6;

reg mask1;
reg [1:0] mask2;
reg [7:0] mask3;
reg [7:0] mask4;
reg [7:0] mask5;
reg [7:0] mask6;

reg re_order_en;
reg [2:0] state, next_state;

reg [7:0] com_after_1, com_after_2, com_after_3, com_after_4, com_after_5;

reg [2:0] tree_mem;
reg [2:0] tree_mem_back;

reg [7:0] com [0:5];
reg [2:0] symbol [0:5];

reg [17:0] symbol_mem;
reg [7:0] com1, com2, com3, com4, com5, com6;

reg [2:0] sort_i, sort_j;
reg en_sort;

parameter A1 = 3'd1;
parameter A2 = 3'd2;
parameter A3 = 3'd3;
parameter A4 = 3'd4;
parameter A5 = 3'd5;
parameter A6 = 3'd6;
parameter idle = 3'd0;
parameter huffman_state = 3'd1;
parameter sort_state = 3'd2;
parameter compare = 3'd3;
parameter initialization = 3'd4;
parameter huffman_code = 3'd5;
parameter out_state = 3'd6;
integer i;

always @(posedge clk or posedge reset) begin
	if(reset) 
		state <= idle;
	else 
		state <= next_state;
end

always @(*) begin
	case(state)
		idle: begin
			if(gray_valid)
				next_state = huffman_state;
			else 
				next_state = idle;
		end
		huffman_state: begin
			if(!gray_valid)
				next_state = sort_state;
			else 
				next_state = huffman_state;
		end
		sort_state: begin
			if(en_sort)
				next_state = compare;
			else
				next_state = sort_state;
		end
		compare: begin
			if(compare_all)
				next_state = initialization;
			else 
				next_state = compare;
		end
		initialization: begin
			if(re_order_en)
				next_state = huffman_code;
			else 
				next_state = initialization; 
		end
		huffman_code: begin
			if(out_en)
				next_state = out_state;
			else 
				next_state = huffman_code;		
		end
	endcase
end

always @(posedge clk or posedge reset) begin
	if(reset) begin
		HC1 <= 8'd0; HC2 <= 8'd0; HC3 <= 8'd0; HC4 <= 8'd0; HC5 <= 8'd0; HC6 <= 8'd0;
		M1 <= 8'd0;M2 <= 8'd0;M3 <= 8'd0;M4 <= 8'd0;M5 <= 8'd0;M6 <= 8'd0;
	end
	else begin
		case(symbol_mem[17:15])
			A1: begin HC1 <= hcode1; M1 <= mask1; end
			A2: begin HC2 <= hcode1; M2 <= mask1; end
			A3: begin HC3 <= hcode1; M3 <= mask1; end
			A4: begin HC4 <= hcode1; M4 <= mask1; end
			A5: begin HC5 <= hcode1; M5 <= mask1; end
			A6: begin HC6 <= hcode1; M6 <= mask1; end
			default: begin
				HC1 <= 8'd0; HC2 <= 8'd0; HC3 <= 8'd0; HC4 <= 8'd0; HC5 <= 8'd0; HC6 <= 8'd0;
				M1 <= 8'd0;M2 <= 8'd0;M3 <= 8'd0;M4 <= 8'd0;M5 <= 8'd0;M6 <= 8'd0;
			end
		endcase
		case(symbol_mem[14:12])
			A1: begin HC1 <= hcode2; M1 <= mask2; end
			A2: begin HC2 <= hcode2; M2 <= mask2; end
			A3: begin HC3 <= hcode2; M3 <= mask2; end
			A4: begin HC4 <= hcode2; M4 <= mask2; end
			A5: begin HC5 <= hcode2; M5 <= mask2; end
			A6: begin HC6 <= hcode2; M6 <= mask2; end
			default: begin
				HC1 <= 8'd0; HC2 <= 8'd0; HC3 <= 8'd0; HC4 <= 8'd0; HC5 <= 8'd0; HC6 <= 8'd0;
				M1 <= 8'd0;M2 <= 8'd0;M3 <= 8'd0;M4 <= 8'd0;M5 <= 8'd0;M6 <= 8'd0;
			end
		endcase
		case(symbol_mem[11:9])
			A1: begin HC1 <= hcode3; M1 <= mask3; end
			A2: begin HC2 <= hcode3; M2 <= mask3; end
			A3: begin HC3 <= hcode3; M3 <= mask3; end
			A4: begin HC4 <= hcode3; M4 <= mask3; end
			A5: begin HC5 <= hcode3; M5 <= mask3; end
			A6: begin HC6 <= hcode3; M6 <= mask3; end
			default: begin
				HC1 <= 8'd0; HC2 <= 8'd0; HC3 <= 8'd0; HC4 <= 8'd0; HC5 <= 8'd0; HC6 <= 8'd0;
				M1 <= 8'd0;M2 <= 8'd0;M3 <= 8'd0;M4 <= 8'd0;M5 <= 8'd0;M6 <= 8'd0;
			end
		endcase
		case(symbol_mem[8:6])
			A1: begin HC1 <= hcode4; M1 <= mask4; end
			A2: begin HC2 <= hcode4; M2 <= mask4; end
			A3: begin HC3 <= hcode4; M3 <= mask4; end
			A4: begin HC4 <= hcode4; M4 <= mask4; end
			A5: begin HC5 <= hcode4; M5 <= mask4; end
			A6: begin HC6 <= hcode4; M6 <= mask4; end
			default: begin
				HC1 <= 8'd0; HC2 <= 8'd0; HC3 <= 8'd0; HC4 <= 8'd0; HC5 <= 8'd0; HC6 <= 8'd0;
				M1 <= 8'd0;M2 <= 8'd0;M3 <= 8'd0;M4 <= 8'd0;M5 <= 8'd0;M6 <= 8'd0;
			end
		endcase
		case(symbol_mem[5:3])
			A1: begin HC1 <= hcode5; M1 <= mask5; end
			A2: begin HC2 <= hcode5; M2 <= mask5; end
			A3: begin HC3 <= hcode5; M3 <= mask5; end
			A4: begin HC4 <= hcode5; M4 <= mask5; end
			A5: begin HC5 <= hcode5; M5 <= mask5; end
			A6: begin HC6 <= hcode5; M6 <= mask5; end
			default: begin
				HC1 <= 8'd0; HC2 <= 8'd0; HC3 <= 8'd0; HC4 <= 8'd0; HC5 <= 8'd0; HC6 <= 8'd0;
				M1 <= 8'd0;M2 <= 8'd0;M3 <= 8'd0;M4 <= 8'd0;M5 <= 8'd0;M6 <= 8'd0;
			end
		endcase
		case(symbol_mem[2:0])
			A1: begin HC1 <= hcode6; M1 <= mask6; end
			A2: begin HC2 <= hcode6; M2 <= mask6; end
			A3: begin HC3 <= hcode6; M3 <= mask6; end
			A4: begin HC4 <= hcode6; M4 <= mask6; end
			A5: begin HC5 <= hcode6; M5 <= mask6; end
			A6: begin HC6 <= hcode6; M6 <= mask6; end
			default: begin
				HC1 <= 8'd0; HC2 <= 8'd0; HC3 <= 8'd0; HC4 <= 8'd0; HC5 <= 8'd0; HC6 <= 8'd0;
				M1 <= 8'd0;M2 <= 8'd0;M3 <= 8'd0;M4 <= 8'd0;M5 <= 8'd0;M6 <= 8'd0;
			end
		endcase
	end
end

always @(posedge clk or posedge reset) begin
	if(reset) begin
		CNT1 <= 8'd0; CNT2 <= 8'd0; CNT3 <= 8'd0; CNT4 <= 8'd0; CNT5 <= 8'd0; CNT6 <= 8'd0;
	end
	else begin
		if(gray_valid) begin
			case(gray_data)
				8'd1: begin
					CNT1 <= CNT1 + 8'd1;
				end
				8'd2: begin
					CNT2 <= CNT2 + 8'd1;
				end
				8'd3: begin
					CNT3 <= CNT3 + 8'd1;
				end
				8'd4: begin
					CNT4 <= CNT4 + 8'd1;
				end
				8'd5: begin
					CNT5 <= CNT5 + 8'd1;
				end
				8'd6: begin
					CNT6 <= CNT6 + 8'd1;
				end
				default : begin
					CNT1 <= CNT1; CNT2 <= CNT2; CNT3 <= CNT3; CNT4 <= CNT4; CNT5 <= CNT5; CNT6 <= CNT6;
				end
			endcase
		end
		else begin
			CNT1 <= CNT1; CNT2 <= CNT2; CNT3 <= CNT3; CNT4 <= CNT4; CNT5 <= CNT5; CNT6 <= CNT6;
		end
	end
end

always @(posedge clk or posedge reset) begin
	if(reset) begin
		com6 <= 8'd0; com5 <= 8'd0; com4 <= 8'd0; com3 <= 8'd0; com2 <= 8'd0; com1 <= 8'd0;
		symbol_mem <= 18'd0;
	end
	else begin
		com6 <= com[0]; com5 <= com[1]; com4 <= com[2]; com3 <= com[3]; com2 <= com[4]; com1 <= com[5];
		symbol_mem <= {symbol[5],symbol[4],symbol[3],symbol[2],symbol[1],symbol[0]};
	end
end

always @(posedge clk or posedge reset) begin
	if(reset) begin
		code_valid <= 1'b0;
		hcode1 <= 1'b0; hcode2 <= 2'd0; hcode3 <= 3'd0; hcode4 <= 4'd0; hcode5 <= 5'd0; hcode6 <= 5'd0;
		mask1 <= 1'b0; mask2 <= 2'd0; mask3 <= 8'd0; mask4 <= 8'd0; mask5 <= 8'd0; mask6 <= 8'd0;
		CNT_valid <= 1'b0;
		out_en <= 1'b0;
		compare_all <= 1'b0;
		compare_cnt <= 3'd0;
		tree_mem <= 3'd0;
		tree_mem_back <= 3'd0;
		pattern_3 <= 1'b0;
		re_order_en <= 1'b0;
		com_after_1 <= 8'd0;com_after_2 <= 8'd0;com_after_3 <= 8'd0;com_after_4 <= 8'd0;com_after_5 <= 8'd0;
		for(i=0;i<6;i=i+1) begin
			com[i] <= 8'd0;
			symbol[i] <= 3'd0;
		end

		en_sort <= 1'd0;
		sort_i <= 3'd0; sort_j <= 3'd0;
	end
	else begin
		case(state)
			huffman_state: begin
				if(!gray_valid)
					CNT_valid <= 1'b1;
				else 
					CNT_valid <= 1'b0;
			end
			sort_state: begin
				CNT_valid <= 1'b0;
				if(CNT_valid) begin
					com[0] <= CNT1; com[1] <= CNT2; com[2] <= CNT3; com[3] <= CNT4; com[4] <= CNT5; com[5] <= CNT6;
					symbol[0] <= A1; symbol[1] <= A2; symbol[2] <= A3; symbol[3] <= A4; symbol[4] <= A5; symbol[5] <= A6;
				end
				else begin
					if(sort_j == 3'd6) begin
						sort_i <= sort_i + 3'd1;
						sort_j <= 3'd0;
					end
					else begin
						sort_j <= sort_j + 3'd1;
						sort_i <= sort_i;
					end

					if(com[sort_j] >= com[sort_j + 1]) begin
						symbol[sort_j] <= symbol[sort_j + 1];
						symbol[sort_j + 1] <= symbol[sort_j];
		
						com[sort_j] <= com[sort_j + 1];
						com[sort_j + 1] <= com[sort_j];
					end
					else begin
						symbol[sort_j] <= symbol[sort_j];
						com[sort_j] <= com[sort_j];
					end
		
					if(sort_i == 3'd6)
						en_sort <= 1'd1;
					else
						en_sort <= 1'd0;
				end
			end
			compare: begin
				if(compare_cnt == 3'd0) begin
					compare_cnt <= compare_cnt + 3'd1;
					com_after_1 <= com6 + com5;
				end
				else if(compare_cnt == 3'd1) begin
					compare_cnt <= compare_cnt + 3'd1;
					if(com_after_1 > com3 && com_after_1 > com4) begin
	 					pattern_3 <= 1'd1;
						com_after_2 <= com3 + com4;
					end
					else begin
						pattern_3 <= 1'd0;
						com_after_2 <= com_after_1 + com4;
					end
				end
				else if(compare_cnt == 3'd2) begin
					compare_cnt <= compare_cnt + 3'd1;
					if(com_after_1 > com3 && com_after_1 > com4) begin
	 					pattern_3 <= 1'd1;
						com_after_3 <= com_after_1 + com_after_2;
					end
					else begin
						pattern_3 <= 1'd0;
						com_after_3 <= com_after_2 + com3;
					end
				end
				else if(compare_cnt == 3'd3) begin
					compare_cnt <= compare_cnt + 3'd1;
					com_after_4 <= com_after_3 + com2;
				end
				else if(compare_cnt == 3'd4) begin
					compare_cnt <= compare_cnt + 3'd1;
					
					compare_all <= 1'b1;
					if(com_after_4 >= com1)
						com_after_5 <= com_after_4;
					else 
						com_after_5 <= com1;
				end
				else 
					compare_cnt <= compare_cnt;
			end
			initialization: begin
				if(tree_mem == 3'd0)
					tree_mem <= tree_mem + 1'b1;
				else if(tree_mem == 3'd1)
					tree_mem <= tree_mem + 1'b1;
				else if(tree_mem == 3'd2)
					tree_mem <= tree_mem + 1'b1;
				else if(tree_mem == 3'd3)
					tree_mem <= tree_mem + 1'b1;
				else if(tree_mem == 3'd4) begin
					re_order_en <= 1'b1;
					compare_all <= 1'b0;
					tree_mem <= tree_mem + 1'b1;
				end
				else 
					tree_mem <= tree_mem;
			end
			huffman_code: begin
				if(tree_mem_back == 3'd0) begin
					tree_mem_back <= tree_mem_back + 3'd1;
					mask1 <= 1'b1;
					if(com1 >= com_after_4)
						hcode1 <= 1'b0;
					else 
						hcode1 <= 1'b1;

				end
				else if(tree_mem_back == 3'd1) begin
					tree_mem_back <= tree_mem_back + 3'd1;
					mask2 <= 2'd3;
					if(com2 >= com_after_3)
						hcode2 <= {~hcode1,1'b0};
					else 
						hcode2 <= {~hcode1,1'b1};

				end
				else if(tree_mem_back == 3'd2) begin
					if(pattern_3) begin
						tree_mem_back <= tree_mem_back + 3'd1;
						mask3 <= 8'd15;
						if(com_after_2 >= com_after_1) begin
							if(com3 >= com4) begin
								hcode3 <= {hcode2[1],~hcode2[0],2'b00};
								hcode4 <= {hcode2[1],~hcode2[0],2'b01};
							end
							else begin
								hcode3 <= {hcode2[1],~hcode2[0],2'b01};
								hcode4 <= {hcode2[1],~hcode2[0],2'b00};
							end
							if(com5 >= com6) begin
								hcode5 <= {hcode2[1],~hcode2[0],2'b10};
								hcode6 <= {hcode2[1],~hcode2[0],2'b11};
							end
							else begin
								hcode5 <= {hcode2[1],~hcode2[0],2'b11};
								hcode6 <= {hcode2[1],~hcode2[0],2'b10};
							end
						end
						else begin 
							hcode3 <= {hcode2[1],~hcode2[0],1'b1};
						end
					end
					else begin
						tree_mem_back <= tree_mem_back + 3'd1;
						mask3 <= 8'd7;
						if(com3 >= com_after_2) 
							hcode3 <= {hcode2[1],~hcode2[0],1'b0};
						else 
							hcode3 <= {hcode2[1],~hcode2[0],1'b1};
					end
				end
				else if(tree_mem_back == 3'd3) begin
					if(pattern_3) begin
						tree_mem_back <= tree_mem_back + 3'd1;
						mask4 <= 8'd15;
					end
					else begin
						tree_mem_back <= tree_mem_back + 3'd1;
						mask4 <= 8'd15;
						if(com4 >= com_after_1)
							hcode4 <= {hcode3[2],hcode3[1],~hcode3[0],1'b0};
						else 
							hcode4 <= {hcode3[2],hcode3[1],~hcode3[0],1'b1};
					end
				end
				else if(tree_mem_back == 3'd4) begin
					if(pattern_3) begin
						tree_mem_back <= tree_mem_back + 3'd1;
						mask5 <= 8'd15;
						mask6 <= 8'd15;
						out_en <= 1'b1;
					end
					else begin
						tree_mem_back <= tree_mem_back + 3'd1;
						mask5 <= 8'd31;
						mask6 <= 8'd31;
						if(com5 >= com6) begin
							hcode5 <= {hcode4[3],hcode4[2],hcode4[1],~hcode4[0],1'b0};
							hcode6 <= {hcode4[3],hcode4[2],hcode4[1],~hcode4[0],1'b1};
						end
						else begin
							hcode5 <= {hcode4[3],hcode4[2],hcode4[1],~hcode4[0],1'b1};
							hcode6 <= {hcode4[3],hcode4[2],hcode4[1],~hcode4[0],1'b0};
						end
						out_en <= 1'b1;
					end
				end
				else begin
					hcode1 <= hcode1;
					hcode2 <= hcode2;
					hcode3 <= hcode3;
					hcode4 <= hcode4;
					hcode5 <= hcode5;
					hcode6 <= hcode6;
				end
			end
			out_state: begin
				code_valid <= 1'b1;
			end
		endcase
	end
end

endmodule