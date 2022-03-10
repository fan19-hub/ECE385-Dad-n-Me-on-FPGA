module debug(
input CLOCK_50,Reset_h,
input [3:0] KEY,
output Clk
);
logic STOP,STOP_in,STEP,STEP_in;
always_ff @(CLOCK_50)
begin
if(Reset_h)
begin
	STOP<=1'b0;
	STEP<=1'b0;
end
else
begin
	STOP<=STOP_in;
	STEP<=STEP_in;
end
end

always_comb
begin
	STOP_in=STOP;
	STEP_in=STEP;
	if(STEP==1'b1)
	begin
		STOP_in=1'b1;
		STEP_in=1'b0;
	end
	else if(KEY[3] && ~STOP)
		STOP_in=1'b1;
	else if(KEY[2] && STOP)
	begin
		STOP_in=1'b0;
		STEP_in=1'b1;
	end
	else if(KEY[1] && STOP)
		STOP_in=1'b0;
	
end
assign Clk=CLOCK_50 & ~STOP;

endmodule