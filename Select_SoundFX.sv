module SoundFX_Selector(
    input logic Clk,
    input logic [17:0] InputSelect,
	 output logic loop,play,Audio_Reset,
	 output logic [22:0]  Start_Addr,// Address to start an audio
	 output logic [22:0]  End_Addr// Address to end an audio 
);
logic [17:0] SoundSelect;
always_ff @( posedge  Clk) begin
    SoundSelect<=InputSelect;
end

always_comb begin
    if (SoundSelect != InputSelect)  //make sure one audio is end before the other begins
	     Audio_Reset=1;
	 else
	     Audio_Reset=0;
end

always_comb begin
    loop=0;
	 play=0;
	 Start_Addr=23'd0;
	 End_Addr=23'd0;
case(SoundSelect)
	 18'd1: begin   //camp_bomb
	     loop=0;
		  play=1;
		  Start_Addr=23'd0;
		  End_Addr=23'd439483;
	 end

	 
	 
	 
	 default: begin
	     loop=0;
		  play=0;
		  Start_Addr=23'd0;
	     End_Addr=23'd0;
	 end
endcase
end
endmodule