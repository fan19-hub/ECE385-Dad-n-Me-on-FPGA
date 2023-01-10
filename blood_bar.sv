module blood_bar (
    input Clk,
    input frame_clk,
    input[6:0] blood,
    input [9:0] DrawX, DrawY, 
    output logic is_blood_bar,
    output logic [7:0] blood_bar_rgb_index
);



//[2-64][74-82]
logic [7:0] mem1 [0:10000];
logic [7:0] data_out_buffer;
logic white;
always_ff @ (posedge Clk) begin
	 blood_bar_rgb_index<=data_out_buffer;
	 if(white)
		  blood_bar_rgb_index<=8'h2;
		end

logic[15:0] relative_addr;
always_ff @ (posedge Clk) begin
	relative_addr=DrawX+ DrawY*10'd68;
end


always_comb begin
    is_blood_bar=(DrawX<10'd68 && DrawY<10'd86);
    white=1'b0;
    if(DrawX>blood && DrawX<10'd64 && DrawY>10'd74 && DrawY<10'd82)
        white=1'b1;
    data_out_buffer=mem1[relative_addr];


end


initial
begin
	 $readmemh("sprite_bytes/blood_bar.txt", mem1);
end
    
endmodule