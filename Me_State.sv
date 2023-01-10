module Me_State (  input logic frame_clk,Clk,Reset,left,attack,thump,
					input [7:0]   keycode,keycode_2,
				   output logic [7:0]   state,
					output logic [10:0] me_state_out
				);
    logic[15:0] key;
	assign key={keycode_2,keycode};
	enum logic [10:0] { 
						start1_1,
						start1_2,
						start2_1,
						start2_2,
						start3_1,
						start3_2,
						attack_11_1,
						attack_11_2,
						attack_12_1,
						attack_12_2,
                        attack_12_3,
						attack_21_1,
						attack_21_2,
						attack_22_1,
                        attack_22_2,
						attack_23_1,
						attack_23_2,
                        attack_23_3
						}  State, Next_state;   // Internal state logic	
	assign me_state_out=State;
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= start1;
		else 
			State <= Next_state;
	end
	
	logic set_zero;
	logic[5:0] counter,inner_counter;
   always_ff @ (posedge frame_clk) 
	begin
	counter<=inner_counter;
	if(set_zero)
		counter<=6'b0;
	end 
	always_comb
	begin
		inner_counter=counter+1;
	end

	always_ff @ (posedge frame_clk)
	begin 
		set_zero=1'b0;
        state=8'h01;
		Next_state = State;
		unique case (State)
			start1_1:
            begin
            if(attack==1'b1)
                Next_state=attack_11_1;
            else
                Next_state=start1_2;
            end
            start1_2:
			begin
            if(attack==1'b1)
                Next_state=attack_11_1;
            else if(counter==6'd10)
                Next_state=start2_1;
			end

			start2_1:
            begin
			if(attack==1'b1)
			    Next_state=attack_11_1;
			else
			   Next_state=start2_2;
            end
			start2_2:
			if(attack==1'b1)
			    Next_state=attack_11_1;
			else if(counter==6'd10)
			    Next_state=start3_1;

			start3_1:
			   Next_state=start3_2;
			start3_2:
			   Next_state=start3_3;

		  	attack_11_1:
				begin
				Next_state=attack_11_2;
				set_zero=1'b1;
				end
			attack_11_2:
				begin
				if(counter==6'd15)
					Next_state=attack_11_3;
				end
				
			attack_12_1:
				begin
				Next_state=attack_12_2;
				set_zero=1'b1;
				end
			attack_12_2:
				begin
				if(counter==6'd15)
					Next_state=attack_12_3;
				end
			attack_12_3:
			begin
				if(key===16'h0d)
					Next_state=attack_21_1;
				else
					Next_state=start1;
			end
			
			//state=7
			attack_21_1:
				Next_state=attack_21_2;
			attack_21_2:
				begin
				if(counter==6'd100)
					Next_state=attack_22_1;
				end
			attack_22_1:
				
				Next_state=attack_22_1;
            attack_22_2:
				begin
				if(counter==6'd100)
					Next_state=attack_23_1;
				end
			attack_23_1:
				Next_state=attack_23_2;
			attack_23_2: 
				begin
				if(counter==6'd100)
					Next_state=start1;
				end
            attack_23_3: 
				begin
				if(key===16'h0d)
					Next_state=attack_11_1;
                else
					Next_state=start1;
				end
			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)

			start1_1 : 
					state=8'h01;
                    set_zero=1'b1;
			start1_2 : 
					state=8'h01;
					

			start2_1:
					state=8'h02;
                    set_zero=1'b1;
			start2_2 : 
					state=8'h02;

			start3_1 : 
					state=8'h03;
                    set_zero=1'b1;
			start3_2 : 
					state=8'h03;
			attack_11_1:
			begin
					state=8'h05;
					set_zero=1'b1;
			end
			attack_11_2:
					state=8'h05;

			attack_12_1:
			begin
					state=8'h06;
					set_zero=1'b1;
			end
			attack_12_2:
					state=8'h06;
            attack_12_3:
					state=8'h06;

			attack_21_1:
			begin
					state=8'h07;
					set_zero=1'b1;
			end
			attack_21_2:
					state=8'h07;

			attack_22_1:
			begin
					state=8'h08;
					set_zero=1'b1;
			end
            attack_22_2:
					state=8'h08;
			attack_23_1:
			begin
					state=8'h09;
					set_zero=1'b1;
			end	
			attack_23_2:
					state=8'h09;
            attack_23_3:
					state=8'h09;
			default : ;

		endcase
	end 


endmodule
