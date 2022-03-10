module key_control( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [7:0]   keycode,keycode_2,
               output logic  left,attack,thump,next,ok);
	 logic[1:0] left_in,left_in_1,attack_in,thump_in,attack_in_1,thump_in_1;				
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 enum logic [10:0] {RIGHT,LEFT,ATTACK,ATTACK_1,ATTACK_2,ATTACK_3,ATTACK_4,ATTACK_5,THUMP} curr_state, next_state;
   logic[15:0] key;
	logic left_pre;
	assign key={keycode_2,keycode};
	always_ff @ (posedge Clk)  
   begin
        if (Reset)
		  begin
            curr_state<=RIGHT;
				
        end
		  else 
		  begin
            curr_state<=next_state;

			end
   end

	always_ff @ (posedge frame_clk)
	begin
		if (Reset) 
		begin
			left_in_1<=2'b0;
			left_pre<=1'b0;
			end
		else 
			left_in_1 <= left_in;
			left_pre<=left;
	end
	
    // Update registers
   always_comb
    begin
		
	   next_state=curr_state;
	 	left_in=left_in_1;
			attack_in=2'b0;
			thump_in=2'b0;
			thump=1'b0;
			left=1'b0;
			next=1'b0;
			ok=1'b0;
	case (key)
		16'h04: // A is pressed left
		begin
			left_in=2'b1;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h28: // A is pressed left
		begin
			ok=1'b1;
		end
		16'h07: // D is pressed right
		begin
			left_in=2'b0;
			attack_in=2'b0;
			thump_in=2'b0;
		end

		16'h0d:
		begin
			attack_in=2'b1;
			thump_in=2'b0;
		end
		16'h2c:
		begin
			next=1'b1;
		end
		16'h0e:
		begin
			thump_in=2'b1;
			attack_in=2'b0;
		end
		16'h041a: // AW is pressed left
		begin
			left_in=2'b1;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h1a04: // AW is pressed left
		begin
			left_in=2'b1;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h0416: // AS is pressed left
		begin
			left_in=2'b1;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h1604: // AS is pressed left
		begin
			left_in=2'b1;
			attack_in=2'b0;
			thump_in=2'b0;
		end

		16'h0716: // SD is pressed right
		begin
			left_in=2'b0;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h1607: // SD is pressed downright
		begin
			left_in=2'b0;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h071a: // DW is pressed upright
		begin
			left_in=2'b0;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h1a07: // DW is pressed upright
		begin
			left_in=2'b0;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		
		16'h0704: // AD is pressed left
		begin
			left_in=2'b1;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		16'h0407: // DA is pressed right
		begin
			left_in=2'b0;
			attack_in=2'b0;
			thump_in=2'b0;
		end
		default : ;
	endcase
	 	unique case (curr_state)
		RIGHT: 
		begin
		if(attack_in==2'b1)
			next_state=ATTACK;
		else if(thump_in==2'b1)
			next_state=THUMP;
		else if (left_in==2'b1)

			next_state=LEFT;
		end
		LEFT: 
		begin
		if(attack_in==2'b1)
			next_state=ATTACK;
		else if(thump_in==2'b1)
			next_state=THUMP;
		else if(left_in==2'b0)
			next_state=RIGHT;
			end
		ATTACK:
		 
		next_state=ATTACK_1;
		ATTACK_1:
		next_state=ATTACK_2;
		ATTACK_2:
		next_state=ATTACK_3;
		ATTACK_3:
		next_state=ATTACK_4;
		ATTACK_4:
		next_state=ATTACK_5;
		ATTACK_5:
		begin
		next_state=RIGHT;
		if(left_pre)
			next_state=LEFT;
		end
		THUMP:
		begin
		next_state=RIGHT;
		if(left_pre)
			next_state=LEFT;
		end
		
		
	endcase
	 

	case (curr_state) 
		RIGHT:
		begin
			left=1'b0;
			attack=1'b0;
			
		end
		LEFT:
		begin
			left=1'b1;
			attack=1'b0;
			
		end
		ATTACK:
		begin
		   attack=1'b1;
			left=left_pre;
			end
		ATTACK_1:
		begin
		   attack=1'b1;
			left=left_pre;
			
			end
		ATTACK_2:
		begin
		   attack=1'b1;
			left=left_pre;
			
			end
		ATTACK_3:
		begin
		   attack=1'b1;
			left=left_pre;
			
			end
		ATTACK_4:
		begin
		   attack=1'b1;
			left=left_pre;
			
			end
		ATTACK_5:
		begin
		   attack=1'b1;
			left=left_pre;
			
			end
		THUMP:
		begin
		   thump=1'b1;
			attack=1'b0;
			left=left_pre;
			end
	endcase
	 end

	
endmodule 