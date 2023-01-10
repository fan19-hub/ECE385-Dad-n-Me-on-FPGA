module LB_ROM
(
		input [15:0] read_address,
		input Clk,
		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem1 [0:10000];
initial
begin
	 $readmemh("sprite_bytes/move.txt", mem1);	 
end

logic [23:0] data_out_buffer;
always_ff @ (posedge Clk) begin
	data_Out<= data_out_buffer;
end
always_comb begin
	data_out_buffer= mem1[read_address];
end

endmodule
