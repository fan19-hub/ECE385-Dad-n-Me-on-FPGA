
module ISDU (  input logic frame_clk,Clk,Reset,left,attack,thump,
					input [7:0]   keycode,keycode_2,
				   output logic [7:0]  state,
					output logic [10:0] me_state_out,
					output fly
				);
   logic[15:0] key;
	assign me_state_out=State;
	assign key={keycode_2,keycode};
	enum logic [10:0] { 
						start1_1,//0
						start1_2,//1
						start2_1,//2
						start2_2,//3
						start3_1,//4
						start3_2,//5
						attack_11_1,//6
						attack_11_2,//7
						attack_12_1,//8
						attack_12_2,//9
                  attack_12_3,//a
						attack_21_1,//b
						attack_21_2,//c
						attack_22_1,//d
                  attack_22_2,//e
						attack_23_1,//f
						attack_23_2,//10
                  attack_23_3//11
						}  State, Next_state;   // Internal state logic	
	
	//counter
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

	//update state
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= start1_1;
		else 
			State <= Next_state;
	end
	
	//update 
	always_ff @ (posedge frame_clk)
	begin 
		set_zero=1'b0;
        state=8'h01;
		  fly=1'b0;
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
            else if(counter==6'd30)
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
				begin
				if(attack==1'b1)
					 Next_state=attack_11_1;
				else if(counter==6'd30)
					 Next_state=start3_1;
				end
			start3_1:
			   Next_state=start3_2;
			start3_2:
			   Next_state=start1_1;

		  	attack_11_1:
				begin
				Next_state=attack_11_2;
				set_zero=1'b1;
				end
			attack_11_2:
				begin
				if(counter==6'd10)
					Next_state=attack_12_1;
				end
				
			attack_12_1:
				begin
				Next_state=attack_12_2;
				set_zero=1'b1;
				end
			attack_12_2:
				begin
				if(counter==6'd10)
					Next_state=attack_12_3;
				end
			attack_12_3:
			begin
				if(key===16'h0d)
					Next_state=attack_21_1;
				else
					Next_state=start1_1;
			end
			
			//state=7
			attack_21_1:
				Next_state=attack_21_2;
			attack_21_2:
				begin
				if(counter==6'd10)
					Next_state=attack_22_1;
				end
			attack_22_1:
				
				Next_state=attack_22_2;
			attack_22_2:
			begin
			if(counter==6'd10)
				Next_state=attack_23_1;
			end
			attack_23_1:
				Next_state=attack_23_2;
			attack_23_2: 
				begin
				if(counter==6'd20)
					Next_state=attack_23_3;
				end
			attack_23_3: 
			begin
			if(key===16'h0d)
				Next_state=attack_11_1;
		   else
				Next_state=start1_1;
			end
			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)

			start1_1 :
					begin
					state=8'h01;
               set_zero=1'b1;
					end
			start1_2 : 
					state=8'h01;

			start2_1:
					begin
					state=8'h02;
               set_zero=1'b1;
					end
			start2_2 : 
					state=8'h02;

			start3_1 : 
					begin
					state=8'h03;
               set_zero=1'b1;
					end
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
			begin
					state=8'h08;
			end
			attack_23_1:
			begin
					state=8'h09;
					set_zero=1'b1;
//					fly=1'b1;
			end	
			attack_23_2:
			begin
					state=8'h09;
					fly=1'b1;
			end
			attack_23_3:
			begin
				   state=8'h09;
//					fly=1'b1;
			end
			default : ;

		endcase
	end 


endmodule
			
				