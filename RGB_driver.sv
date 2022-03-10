module RGB_driver (input  [7:0]  rgb_index,
                  output logic [23:0]  rgb_out);
always_comb
	begin
    unique case (rgb_index)
		8'h00 : rgb_out = 24'hdab0d8;
		8'h01 : rgb_out = 24'hcb99cc;
		8'h02 : rgb_out = 24'hffffff;
		8'h03 : rgb_out = 24'h000000;
		8'h04 : rgb_out = 24'h96d3f2;
		8'h05 : rgb_out = 24'h14a2ea;
		8'h06 : rgb_out = 24'ha10000;
		8'h07 : rgb_out = 24'h7c7b4f;
		8'h08 : rgb_out = 24'h65aa67;
		8'h09 : rgb_out = 24'h500a3e;
		8'h0a : rgb_out = 24'h5d5d5d;
		8'h0b : rgb_out = 24'h579252;
		8'h0c : rgb_out = 24'h64623b;
		8'h0d : rgb_out = 24'h6800f7;
		8'h0e : rgb_out = 24'h999999;
		8'h0f : rgb_out = 24'h323232;
		8'h10 : rgb_out = 24'h585f72;
		8'h11 : rgb_out = 24'h9ca200;
		8'h12 : rgb_out = 24'h686903;
		8'h13 : rgb_out = 24'hffff2a;
		8'h14 : rgb_out = 24'hffa82a;
		8'h15 : rgb_out = 24'h9140fe;
		8'h16 : rgb_out = 24'ha863fc;
		8'h17 : rgb_out = 24'hffccff;
		8'h18 : rgb_out = 24'hcbc9cd;
		8'h19 : rgb_out = 24'h9a7162;
		8'h1a : rgb_out = 24'hf8ca9f;
		8'h1b : rgb_out = 24'hf0966d;
		8'h1c : rgb_out = 24'hec4266;
		8'hff : rgb_out = 24'h0000ff; //marked as the Transparent pixels

		default : rgb_out = 24'h000000; //by default, black
		endcase
    end
endmodule