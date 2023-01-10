module  Background( input    Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
				    input    left,
					 input [10:0]   roll,offset,
                input [9:0]   DrawX, DrawY,       // Current pixel coordinates
			       output logic [19:0]  relative_address,
                output logic [10:0]  Screen_X_Min
                    );
    logic [10:0] Screen_X_Min_update;
	 parameter[10:0] Map_width=11'd1000;
	 parameter[10:0] Screen_width=11'd640;
    always_ff @(posedge Clk ) begin
        if(Reset)
            Screen_X_Min<=11'd10;
        else
            Screen_X_Min<=Screen_X_Min_update;
    end
    always_ff @(posedge frame_clk ) begin
        Screen_X_Min_update=Screen_X_Min+roll;
		  if(Screen_X_Min_update<11'd5)
                Screen_X_Min_update=11'd5;
		  else if(Screen_X_Min_update>(Map_width-Screen_width))
				    Screen_X_Min_update=Map_width-Screen_width;
	 end
 assign relative_address=(Screen_X_Min+DrawX)+(DrawY+offset)*Map_width;
        
endmodule