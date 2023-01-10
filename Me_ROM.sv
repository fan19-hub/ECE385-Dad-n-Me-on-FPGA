
module Me_ROM
(
		input [7:0] state,
		input [15:0] relative_address,
		input Clk,frame_clk, Reset,
		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [2:0] mem1 [0:10000];
logic [2:0] mem2 [0:10000];
logic [2:0] mem_a0 [0:12000];
logic [2:0] mem_a1 [0:12000];
logic [2:0] mem_a2 [0:12000];
logic [7:0] index;
initial
begin
	 $readmemb("sprite_bytes/1.txt", mem1);
	 $readmemb("sprite_bytes/2.txt", mem2);
	 $readmemb("sprite_bytes/a_0.txt", mem_a0);
	 $readmemb("sprite_bytes/a_1.txt", mem_a1);
	 $readmemb("sprite_bytes/a_2.txt", mem_a2);
end
logic [7:0] index_buffer;
always_ff @ (posedge Clk) begin
	index<= index_buffer;
end
always_comb
begin		
	index_buffer=mem1[relative_address];
		if(state===8'h02)
		  index_buffer=mem2[relative_address];
		if(state===8'h06 || state===8'h08)
		  index_buffer=mem_a0[relative_address];
		if(state===8'h07 || state===8'h05)
		  index_buffer=mem_a1[relative_address];
		if(state===8'h09)
		  index_buffer=mem_a2[relative_address];
end

always_comb
	begin
    unique case (index)
       3'h0: data_Out=24'ha664ff;
        3'h1: data_Out=24'h9140ff;
        3'h2: data_Out=24'hffffff;
        3'h3: data_Out=24'h666666;
        3'h4: data_Out=24'h000000;
        3'h7: data_Out=24'h0000ff;
		default : data_Out = 24'h000000; //by default, black
		endcase
    end



endmodule

//module Me_ROM
//(
//		input [7:0] state,
//		input [15:0] relative_address,
//		input Clk,frame_clk, Reset,
//		output logic [7:0] data_Out
//);
//
//// mem has width of 3 bits and a total of 400 addresses
//logic [7:0] mem1 [0:10000];
//logic [7:0] mem2 [0:10000];
//
//logic [7:0] mem_a0 [0:12000];
//logic [7:0] mem_a1 [0:12000];
//logic [7:0] mem_a2 [0:12000];
//
//initial
//begin
//	 $readmemh("sprite_bytes/1.txt", mem1);
//	 $readmemh("sprite_bytes/2.txt", mem2);
//// 	 $readmemh("sprite_bytes/enemy.txt", mem3);
//	 $readmemh("sprite_bytes/a_0.txt", mem_a0);
//	 $readmemh("sprite_bytes/a_1.txt", mem_a1);
//	 $readmemh("sprite_bytes/a_2.txt", mem_a2);
//end
//logic [7:0] data_out_buffer;
//always_ff @ (posedge Clk) begin
//	data_Out<= data_out_buffer;
////	Width<=Width_in;
////	Height<=Height_in;
//end
//always_comb
//begin		
//	data_out_buffer=mem1[relative_address];
//		if(state===8'h02)
//		  data_out_buffer=mem2[relative_address];
//		if(state===8'h06 || state===8'h08)
//		  data_out_buffer=mem_a0[relative_address];
//		if(state===8'h07 || state===8'h05)
//		  data_out_buffer=mem_a1[relative_address];
//		if(state===8'h09)
//		  data_out_buffer=mem_a2[relative_address];
//
//
//end
//
//endmodule
////
////module Me_ROM
////(
////		input [7:0] state,
////		input [15:0] relative_address,
////		input Clk,frame_clk, Reset,
////		output logic [23:0] data_Out
////);
////
////// mem has width of 3 bits and a total of 400 addresses
////logic [2:0] mem1 [0:10000];
////logic [2:0] mem2 [0:10000];
////logic [2:0] mem_a0 [0:12000];
////logic [2:0] mem_a1 [0:12000];
////logic [2:0] mem_a2 [0:12000];
////
////initial
////begin
////	 $readmemb("sprite_bytes/1.txt", mem1);
////	 $readmemb("sprite_bytes/2.txt", mem2);
////	 $readmemb("sprite_bytes/a_0.txt", mem_a0);
////	 $readmemb("sprite_bytes/a_1.txt", mem_a1);
////	 $readmemb("sprite_bytes/a_2.txt", mem_a2);
////end
////logic [7:0] index_buffer;
////always_ff @ (posedge Clk) begin
////	index<= index_buffer;
//////	Width<=Width_in;
//////	Height<=Height_in;
////end
////always_comb
////begin		
////	index_buffer=mem1[relative_address];
////		if(state===8'h02)
////		  index_buffer=mem2[relative_address];
////		if(state===8'h06 || state===8'h08)
////		  index_buffer=mem_a0[relative_address];
////		if(state===8'h07 || state===8'h05)
////		  index_buffer=mem_a1[relative_address];
////		if(state===8'h09)
////		  index_buffer=mem_a2[relative_address];
////end
////
////always_comb
////	begin
////    unique case (index)
////       3'h0: data_Out=24'ha664ff;
////        3'h1: data_Out=24'h9140ff;
////        3'h2: data_Out=24'hffffff;
////        3'h3: data_Out=24'h666666;
////        3'h4: data_Out=24'h000000;
////        3'h7: data_Out=24'h0000ff;
////		default : data_Out = 24'h000000; //by default, black
////		endcase
////    end
////
////
////
////endmodule