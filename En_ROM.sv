module En_ROM
(
		input [15:0] read_address,
		input Clk,beida,frame_clk,
		input enemy_left,
		input [1:0]en_move,
        output[23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [7:0] mem1 [0:6000];
logic [7:0] mem2 [0:6000];
logic [7:0] mem3 [0:6000];
logic [7:0] mem4 [0:6000];
initial
begin
	 $readmemb("sprite_bytes/e_1.txt", mem1);
	 $readmemb("sprite_bytes/e_2.txt", mem2);
	 $readmemb("sprite_bytes/e_3.txt", mem3);
	 $readmemb("sprite_bytes/e_beida.txt", mem4);
//	 $readmemb("sprite_bytes/beida_1.txt", mem4); 
end

logic [1:0] index_buffer,index;
always_ff @ (posedge Clk) begin
	index<= index_buffer;
	end
always_comb
begin		
	
	if(beida===1'b1)
		index_buffer=mem4[read_address];
	else 
	begin
		case(en_move)
		2'b01:index_buffer=mem2[read_address];
		2'b10:index_buffer=mem3[read_address];
		default: index_buffer= mem1[read_address];
		endcase
	end
end

always_comb
	begin
    unique case (index)
        2'b0: data_Out=24'hffccff;
        2'b1: data_Out=24'h000000;
//        2'b10: data_Out=24'hb6b6b6;
        2'b11: data_Out=24'h0000ff;
		default : data_Out = 24'h000000; //by default, black
		endcase
    end
endmodule


//module En_ROM
//(
//		input [15:0] read_address,
//		input Clk,beida,frame_clk,
//		input enemy_left,
//		input [1:0]en_move,
//		output logic [7:0] data_Out
//);
//
//// mem has width of 3 bits and a total of 400 addresses
//logic [7:0] mem1 [0:6000];
//logic [7:0] mem2 [0:6000];
//logic [7:0] mem3 [0:6000];
//logic [7:0] mem4 [0:6000];
////logic [7:0] mem5 [0:10000];
////logic [7:0] mem6 [0:10000];
//initial
//begin
//	 $readmemh("sprite_bytes/e_1.txt", mem1);
//	 $readmemh("sprite_bytes/e_2.txt", mem2);
//	 $readmemh("sprite_bytes/e_3.txt", mem3);
//	 $readmemh("sprite_bytes/beida_1.txt", mem4); 
//end
//
//logic [7:0] data_out_buffer;
//always_ff @ (posedge Clk) begin
//	data_Out<= data_out_buffer;
//	end
//always_comb
//begin		
//	
//	if(beida===1'b1)
//		data_out_buffer=mem4[read_address];
//	else 
//	begin
//		case(en_move)
////		2'b00:data_out_buffer=mem1[read_address];
//		2'b01:data_out_buffer=mem2[read_address];
//		2'b10:data_out_buffer=mem3[read_address];
//		default: data_out_buffer= mem1[read_address];
//		endcase
//	end
//end
//
//endmodule
