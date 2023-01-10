module enemy ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [10:0]  Screen_X_Min,
					input [10:0]  S_X_Pos, S_Y_Pos,
					input [10:0]  Ball_X_Pos, Ball_Y_Pos,
					input attack,fly,left,
					output logic  is_enemy,enemy_left,beida,is_en_blood_bar,en_dead,
					output logic[15:0]  relative_address,					// Whether current pixel belongs to ball or background
               output logic[1:0] en_move,
					output logic[3:0] curr_state1
				  );
    parameter [10:0] Screen_X_Center = 11'd320;  // Center position on the X axis
    parameter [10:0] Screen_Y_Center = 11'd240;  // Center position on the Y axis
    logic [10:0] Map_width=11'd1000;
	 logic [10:0] Map_X_Min=11'd0000;
	 logic [10:0] Screen_X_Max;  // Rightmost point on the X axis
    parameter [10:0] Screen_Y_Min = 11'd170;       // Topmost point on the Y axis
    parameter [10:0] Screen_Y_Max = 11'd479;     // Bottommost point on the Y axis 479
    parameter [10:0] En_X_Step = 11'd2;      // Step size on the X axis
    parameter [10:0] En_Y_Step = 11'd2;      // Step size on the Y axis
    parameter [10:0] En_X_Size = 11'd30;        // Ball size
    parameter [10:0] En_Y_Size = 11'd46;        // Ball size
    parameter [10:0] zero=11'd0;
	 logic beida_t,enemy_left_in,set_zero;
	 logic[9:0] inner_counter,counter;
    logic [10:0] En_X_Pos, En_Y_Pos, En_Y_Motion;
    logic [10:0] En_X_Pos_in, En_X_Motion, En_X_Motion_in, En_Y_Pos_in, En_Y_Motion_in;
	 logic back;

//	 assign en_blood=7'd32;
	 
	 int DX, DY;
    assign DX = Ball_X_Pos-En_X_Pos;
    assign DY = Ball_Y_Pos-En_Y_Pos;
	 assign Screen_X_Max = Screen_X_Min+11'd639;
	 assign beida_t=(attack && (DX*DX)<((32+50)*(32+50)) && (DY*DY)<((47+50)*(47+50)));
	 assign curr_state1=curr_state;
	 assign en_dead=1'b0;
	 enum logic [3:0] {NORMAL_11,NORMAL_12,NORMAL_21,NORMAL_22,NORMAL_31,NORMAL_32,BEIDA,BACK} curr_state, next_state;
	
	always_ff @ (posedge Clk)
	begin 
	if(Reset)
	begin
		curr_state<=NORMAL_11;
		enemy_left<=1'b0;

	end
	else
	begin
	curr_state<=next_state;
	enemy_left<=enemy_left_in;
	end

	

	end 
	
	always_ff @ (posedge frame_clk) 
	begin
	counter<=inner_counter;
	end 
	
	always_ff @ (posedge frame_clk)
	begin
	 beida=1'b0;

	 inner_counter=counter+10'd1;
	 set_zero=1'b0;
	 back=1'b0;
	 next_state=curr_state;
	 enemy_left_in=~(En_X_Motion_in==En_X_Step);
	 en_move=2'b11;
	 case(curr_state)
     NORMAL_11:
                begin
					 set_zero=1'b1;
					 next_state=NORMAL_12;
					 if(beida_t)
					 begin
						next_state=BEIDA;
					 end
                end
	  NORMAL_12:
                begin
					 if(counter==10'd10)
						next_state=NORMAL_21;
					 if(beida_t)
					 begin
						set_zero=1'b1;
						next_state=BEIDA;
					 end
                end
	  NORMAL_21:
                begin
					 set_zero=1'b1;
					 next_state=NORMAL_22;
					 if(beida_t)
					 begin
						next_state=BEIDA;
					 end
                end
	  NORMAL_22:
                begin
					 if(counter==10'd10)
						next_state=NORMAL_31;
					 if(beida_t)
					 begin
						set_zero=1'b1;
						next_state=BEIDA;
					 end
                end
	  NORMAL_31:
                begin
					 set_zero=1'b1;
					 next_state=NORMAL_32;
					 if(beida_t)
					 begin
						
						next_state=BEIDA;
					 end
                end
	  NORMAL_32:
                begin
					 if(counter==10'd10)
						next_state=NORMAL_11;
					 if(beida_t)
					 begin
						set_zero=1'b1;
						next_state=BEIDA;
					 end
                end
	  BEIDA:
                begin
	
					 if(fly)
					 begin
						next_state=BACK;
						set_zero=1'b1;
					 end
					 
					 else if(counter==10'd25)
					 begin
						next_state=NORMAL_11;
						set_zero=1'b1;
					 end
					 
					
                end
		BACK:
					begin
						next_state=NORMAL_11;
					end
					
	endcase
	
	case (curr_state)
	  NORMAL_11:
                en_move=2'b00;
     NORMAL_12:
                en_move=2'b00;
     NORMAL_21:
                en_move=2'b01;
     NORMAL_22:
                en_move=2'b01;
     NORMAL_31:
                en_move=2'b10;
     NORMAL_32:
                en_move=2'b10;
	  BEIDA:
					 beida=1'b1;
	  BACK:
					 begin
					 back=1'b1;
					 beida=1'b1;
					 end
			 
	  
	endcase 
	
end
	 
	 
	
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            En_X_Pos <= S_X_Pos;
            En_Y_Pos <= S_Y_Pos;
            En_X_Motion <= En_X_Step;
            En_Y_Motion <= En_Y_Step;
        end
        else
        begin
            En_X_Pos <= En_X_Pos_in;
            En_Y_Pos <= En_Y_Pos_in;
            En_X_Motion <= En_X_Motion_in;
            En_Y_Motion <= En_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        En_X_Pos_in = En_X_Pos;
        En_Y_Pos_in = En_Y_Pos;
        En_X_Motion_in = En_X_Motion;
        En_Y_Motion_in = En_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. En_Y_Pos - En_X_Size <= Screen_Y_Min 
            // If En_Y_Pos is 0, then En_Y_Pos - En_X_Size will not be -4, but rather a large positive number.

				if( En_Y_Pos + En_Y_Size >= Screen_Y_Max)  // Ball is at the bottom edge, BOUNCE!
				begin
                En_Y_Motion_in = (~(En_Y_Step) + 1'b1);  // 2's complement.  
//					 En_X_Motion_in = 11'd0;
				end
            else if ( En_Y_Pos <= Screen_Y_Min + En_Y_Size)  // Ball is at the top edge, BOUNCE!
				begin
                En_Y_Motion_in = En_Y_Step;
//					 En_X_Motion_in = 11'd0;
				end
            // TODO: Add other boundary detections and handle keypress here.
            else if( En_X_Pos + En_X_Size >= Map_width)  // Ball is at the right edge, BOUNCE!
				begin
                En_X_Motion_in = (~(En_X_Step) + 1'b1); 
//					 En_Y_Motion_in = 11'd0;
				end
            else if ( En_X_Pos <= Map_X_Min +  En_X_Size) // Ball is at the left edge, BOUNCE!
				begin
                En_X_Motion_in = En_X_Step;
//					 En_Y_Motion_in = 11'd0;
				end
					 
            // Update the ball's position with its motion

				if(~beida)
				begin
				En_X_Pos_in = En_X_Pos + En_X_Motion;
				En_Y_Pos_in = En_Y_Pos + En_Y_Motion;
					
				end
				else if(back)
				begin
					if(~left)
					begin
						En_X_Pos_in = En_X_Pos +11'd7;
//						En_Y_Pos_in = En_Y_Pos;
					end
					
					else
					begin
						En_X_Pos_in = En_X_Pos +~(11'd7)+11'd1;
//						En_Y_Pos_in = En_Y_Pos;
					end
				end
        end
		  
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY;
    assign DistX = DrawX+Screen_X_Min - En_X_Pos;
    assign DistY = DrawY - En_Y_Pos;
    //60*93
    always_comb
	 begin
	 is_en_blood_bar=1'b0;
	 if(DistY+60>=0 && DistY+50<=0 && DistX+25<=50 && DistX+25>=0)
			is_en_blood_bar=1'b1 & ~(en_dead);
	  if ( DistX*DistX < 900 &&  DistY*DistY < 2116  ) 
			is_enemy = 1'b1 && (~en_dead);
	  else
			is_enemy = 1'b0;
	  relative_address=16'hffff;
	  if(is_enemy)
		  begin
		  relative_address=(Screen_X_Min+DrawX+En_X_Size-En_X_Pos)+ (DrawY+En_Y_Size- En_Y_Pos)*(En_X_Size*2);
		  if(enemy_left)
		  relative_address=(En_X_Pos+En_X_Size-Screen_X_Min-DrawX)+ (DrawY+En_Y_Size- En_Y_Pos)*(En_X_Size*2);
		  end
	 end

    
    
endmodule
