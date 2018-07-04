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
//reg [7:0] HC1_1, HC2_1, HC3_1, HC4_1, HC5_1, HC6_1;
reg hcode1,hcode1_1;
reg pattern_3;
reg compare_all;
reg [2:0] compare_cnt;
reg [7:0] M1_1, M2_1, M3_1, M4_1, M5_1, M6_1;
reg [1:0] hcode2,hcode2_1;
reg [2:0] hcode3; 
reg [3:0] hcode4; 
reg [4:0] hcode5; 
reg [4:0] hcode6;
reg [7:0] hcode3_1;
reg [7:0] hcode4_1;
reg [7:0] hcode5_1;
reg [7:0] hcode6_1;
reg re_order_en;
reg [2:0] state, next_state;
reg [7:0] com1, com2, com3, com4, com5, com6;
reg [7:0] com_after_1, com_after_2, com_after_3, com_after_4, com_after_5;
reg [7:0] com [0:5];
reg [7:0] sort;
reg [2:0] tree_mem;
reg [2:0] tree_mem_back;
reg [2:0] symbol [0:5];
reg [2:0] symbol_sort;
reg [17:0] symbol_mem;
parameter A1 = 3'd1;
parameter A2 = 3'd2;
parameter A3 = 3'd3;
parameter A4 = 3'd4;
parameter A5 = 3'd5;
parameter A6 = 3'd6;
parameter idle = 3'd0;
parameter huffman_state = 3'd1;
parameter compare = 3'd2;
parameter initialization = 3'd3;
parameter huffman_code = 3'd4;
parameter out_state = 3'd5;
integer i;
integer j;

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
				next_state = compare;
			else 
				next_state = huffman_state;
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

always @(*) begin
	case(symbol_mem[17:15])
		A1: begin HC1 = hcode1; M1_1 = hcode1_1; end
		A2: begin HC2 = hcode1; M2_1 = hcode1_1; end
		A3: begin HC3 = hcode1; M3_1 = hcode1_1; end
		A4: begin HC4 = hcode1; M4_1 = hcode1_1; end
		A5: begin HC5 = hcode1; M5_1 = hcode1_1; end
		A6: begin HC6 = hcode1; M6_1 = hcode1_1; end
		default: begin
			HC1 = 8'd0; HC2 = 8'd0; HC3 = 8'd0; HC4 = 8'd0; HC5 = 8'd0; HC6 = 8'd0;
			M1_1 = 8'd0;M2_1 = 8'd0;M3_1 = 8'd0;M4_1 = 8'd0;M5_1 = 8'd0;M6_1 = 8'd0;
		end
	endcase
	case(symbol_mem[14:12])
		A1: begin HC1 = hcode2; M1_1 = hcode2_1; end
		A2: begin HC2 = hcode2; M2_1 = hcode2_1; end
		A3: begin HC3 = hcode2; M3_1 = hcode2_1; end
		A4: begin HC4 = hcode2; M4_1 = hcode2_1; end
		A5: begin HC5 = hcode2; M5_1 = hcode2_1; end
		A6: begin HC6 = hcode2; M6_1 = hcode2_1; end
		default: begin
			HC1 = 8'd0; HC2 = 8'd0; HC3 = 8'd0; HC4 = 8'd0; HC5 = 8'd0; HC6 = 8'd0;
			M1_1 = 8'd0;M2_1 = 8'd0;M3_1 = 8'd0;M4_1 = 8'd0;M5_1 = 8'd0;M6_1 = 8'd0;
		end
	endcase
	case(symbol_mem[11:9])
		A1: begin HC1 = hcode3; M1_1 = hcode3_1; end
		A2: begin HC2 = hcode3; M2_1 = hcode3_1; end
		A3: begin HC3 = hcode3; M3_1 = hcode3_1; end
		A4: begin HC4 = hcode3; M4_1 = hcode3_1; end
		A5: begin HC5 = hcode3; M5_1 = hcode3_1; end
		A6: begin HC6 = hcode3; M6_1 = hcode3_1; end
		default: begin
			HC1 = 8'd0; HC2 = 8'd0; HC3 = 8'd0; HC4 = 8'd0; HC5 = 8'd0; HC6 = 8'd0;
			M1_1 = 8'd0;M2_1 = 8'd0;M3_1 = 8'd0;M4_1 = 8'd0;M5_1 = 8'd0;M6_1 = 8'd0;
		end
	endcase
	case(symbol_mem[8:6])
		A1: begin HC1 = hcode4; M1_1 = hcode4_1; end
		A2: begin HC2 = hcode4; M2_1 = hcode4_1; end
		A3: begin HC3 = hcode4; M3_1 = hcode4_1; end
		A4: begin HC4 = hcode4; M4_1 = hcode4_1; end
		A5: begin HC5 = hcode4; M5_1 = hcode4_1; end
		A6: begin HC6 = hcode4; M6_1 = hcode4_1; end
		default: begin
			HC1 = 8'd0; HC2 = 8'd0; HC3 = 8'd0; HC4 = 8'd0; HC5 = 8'd0; HC6 = 8'd0;
			M1_1 = 8'd0;M2_1 = 8'd0;M3_1 = 8'd0;M4_1 = 8'd0;M5_1 = 8'd0;M6_1 = 8'd0;
		end
	endcase
	case(symbol_mem[5:3])
		A1: begin HC1 = hcode5; M1_1 = hcode5_1; end
		A2: begin HC2 = hcode5; M2_1 = hcode5_1; end
		A3: begin HC3 = hcode5; M3_1 = hcode5_1; end
		A4: begin HC4 = hcode5; M4_1 = hcode5_1; end
		A5: begin HC5 = hcode5; M5_1 = hcode5_1; end
		A6: begin HC6 = hcode5; M6_1 = hcode5_1; end
		default: begin
			HC1 = 8'd0; HC2 = 8'd0; HC3 = 8'd0; HC4 = 8'd0; HC5 = 8'd0; HC6 = 8'd0;
			M1_1 = 8'd0;M2_1 = 8'd0;M3_1 = 8'd0;M4_1 = 8'd0;M5_1 = 8'd0;M6_1 = 8'd0;
		end
	endcase
	case(symbol_mem[2:0])
		A1: begin HC1 = hcode6; M1_1 = hcode6_1; end
		A2: begin HC2 = hcode6; M2_1 = hcode6_1; end
		A3: begin HC3 = hcode6; M3_1 = hcode6_1; end
		A4: begin HC4 = hcode6; M4_1 = hcode6_1; end
		A5: begin HC5 = hcode6; M5_1 = hcode6_1; end
		A6: begin HC6 = hcode6; M6_1 = hcode6_1; end
		default: begin
			HC1 = 8'd0; HC2 = 8'd0; HC3 = 8'd0; HC4 = 8'd0; HC5 = 8'd0; HC6 = 8'd0;
			M1_1 = 8'd0;M2_1 = 8'd0;M3_1 = 8'd0;M4_1 = 8'd0;M5_1 = 8'd0;M6_1 = 8'd0;
		end
	endcase
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

always @(*) begin
	com[0] = CNT1; com[1] = CNT2; com[2] = CNT3; com[3] = CNT4; com[4] = CNT5; com[5] = CNT6;
	symbol[0] = A1; symbol[1] = A2; symbol[2] = A3; symbol[3] = A4; symbol[4] = A5; symbol[5] = A6;
	for(i=0;i<5;i=i+1) begin
		for(j=i+1;j<6;j=j+1) begin
			if(com[i] > com[j]) begin
				symbol_sort = symbol[i];
				symbol[i] = symbol[j];
				symbol[j] = symbol_sort;

				sort = com[i];
				com[i] = com[j];
				com[j] = sort;
			end
		end
		com6 = com[0]; com5 = com[1]; com4 = com[2]; com3 = com[3]; com2 = com[4]; com1 = com[5];
		symbol_mem = {symbol[5],symbol[4],symbol[3],symbol[2],symbol[1],symbol[0]};
	end
end

always @(posedge clk or posedge reset) begin
	if(reset) begin
		code_valid <= 1'b0;
		M1 <= 8'd0; M2 <= 8'd0; M3 <= 8'd0; M4 <= 8'd0; M5 <= 8'd0; M6 <= 8'd0;
		hcode1 <= 1'b0; hcode2 <= 2'd0; hcode3 <= 3'd0; hcode4 <= 4'd0; hcode5 <= 5'd0; hcode6 <= 5'd0;
		hcode1_1 <= 1'b0; hcode2_1 <= 2'd0; hcode3_1 <= 8'd0; hcode4_1 <= 8'd0; hcode5_1 <= 8'd0; hcode6_1 <= 8'd0;
		CNT_valid <= 1'b0;
		out_en <= 1'b0;
		compare_all <= 1'b0;
		compare_cnt <= 3'd0;
		tree_mem <= 3'd0;
		tree_mem_back <= 3'd0;
		pattern_3 <= 1'b0;
		re_order_en <= 1'b0;
		com_after_1 <= 8'd0;com_after_2 <= 8'd0;com_after_3 <= 8'd0;com_after_4 <= 8'd0;com_after_5 <= 8'd0;
	end
	else begin
		case(state)
			huffman_state: begin
				if(!gray_valid)
					CNT_valid <= 1'b1;
				else 
					CNT_valid <= 1'b0;
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
				  CNT_valid <= 1'b0;
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
					hcode1_1 <= 1'b1;
					if(com1 >= com_after_4)
						hcode1 <= 1'b0;
					else 
						hcode1 <= 1'b1;

				end
				else if(tree_mem_back == 3'd1) begin
					tree_mem_back <= tree_mem_back + 3'd1;
					hcode2_1 <= 2'd3;
					if(com2 >= com_after_3)
						hcode2 <= {~hcode1,1'b0};
					else 
						hcode2 <= {~hcode1,1'b1};

				end
				else if(tree_mem_back == 3'd2) begin
					if(pattern_3) begin
						tree_mem_back <= tree_mem_back + 3'd1;
						hcode3_1 <= 8'd15;
						if(com_after_2 >= com_after_1) begin
							if(com3 >= com4) begin
								hcode3 <= {hcode2[1],~hcode2[0],1'b0,1'b0};
								hcode4 <= {hcode2[1],~hcode2[0],1'b0,1'b1};
							end
							else begin
								hcode3 <= {hcode2[1],~hcode2[0],1'b0,1'b1};
								hcode4 <= {hcode2[1],~hcode2[0],1'b0,1'b0};
							end
							if(com5 >= com6) begin
								hcode5 <= {hcode2[1],~hcode2[0],1'b1,1'b0};
								hcode6 <= {hcode2[1],~hcode2[0],1'b1,1'b1};
							end
							else begin
								hcode5 <= {hcode2[1],~hcode2[0],1'b1,1'b1};
								hcode6 <= {hcode2[1],~hcode2[0],1'b1,1'b0};
							end
						end
						else begin 
							hcode3 <= {hcode2[1],~hcode2[0],1'b1};
						end
					end
					else begin
						tree_mem_back <= tree_mem_back + 3'd1;
						hcode3_1 <= 8'd7;
						if(com3 >= com_after_2) 
							hcode3 <= {hcode2[1],~hcode2[0],1'b0};
						else 
							hcode3 <= {hcode2[1],~hcode2[0],1'b1};
					end
				end
				else if(tree_mem_back == 3'd3) begin
					if(pattern_3) begin
						tree_mem_back <= tree_mem_back + 3'd1;
						hcode4_1 <= 8'd15;
					end
					else begin
						tree_mem_back <= tree_mem_back + 3'd1;
						hcode4_1 <= 8'd15;
						if(com4 >= com_after_1)
							hcode4 <= {hcode3[2],hcode3[1],~hcode3[0],1'b0};
						else 
							hcode4 <= {hcode3[2],hcode3[1],~hcode3[0],1'b1};
					end
				end
				else if(tree_mem_back == 3'd4) begin
					if(pattern_3) begin
						tree_mem_back <= tree_mem_back + 3'd1;
						hcode5_1 <= 8'd15;
						hcode6_1 <= 8'd15;
						out_en <= 1'b1;
					end
					else begin
						tree_mem_back <= tree_mem_back + 3'd1;
						hcode5_1 <= 8'd31;
						hcode6_1 <= 8'd31;
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
				M1 <= M1_1;
				M2 <= M2_1;
				M3 <= M3_1;
				M4 <= M4_1;
				M5 <= M5_1;
				M6 <= M6_1;
				code_valid <= 1'b1;
			end
		endcase
	end
end

endmodule