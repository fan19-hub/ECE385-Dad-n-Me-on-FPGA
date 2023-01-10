module Flash_Audio_Interface(  
    input logic Clk, Reset, data_over, Audio_Reset,
	 
	 input logic play,loop,  //play the audio continuously when it is 1, halt it when it is 0
	 //loop determine whether the audio with be looped or only played once on play is 1
                  
    // flash interface
    input logic [22:0]  Start_Addr,// Address to start an audio
	 input logic [22:0]  End_Addr,// Address to end an audio
    input logic [7:0]  FL_DQ,// Data received from Memory
    output logic        FL_OE_N, FL_RST_N, FL_WE_N, FL_CE_N,
    output logic [22:0] FL_ADDR,
    // audio to put into audio interface
    output logic [15:0] Audio_Data );
	 
logic data_over_flag,new_data_over_flag,state_data_over;

enum logic [3:0] {HOLD, WAIT, FEED_IN, END} current_state, next_state;  //the state machine

logic [22:0] NEW_ADDR;

logic [5:0] counter, inner_counter;

always_ff @( posedge  Clk) begin
    if (~play || ~Reset || Audio_Reset)begin
        current_state<=HOLD;
		  FL_ADDR <= Start_Addr;
		  counter <= 6'd0;
    end
    if (play && Reset) begin
        current_state <= next_state;
		  data_over_flag <= new_data_over_flag;
		  state_data_over <= data_over;
	     Audio_Data[10:3] <= FL_DQ;
	     FL_ADDR <= NEW_ADDR; 
		  counter <= inner_counter;
    end
end 	 

always_comb begin
    FL_RST_N= 1;
    FL_WE_N = 1;
    FL_CE_N = 0;
    FL_OE_N = 0;
end

always_comb begin
    if (data_over==1 && data_over_flag==0)
	     new_data_over_flag=1;
	 else
	     new_data_over_flag=0;
end


always_comb begin
    unique case(current_state)
	     HOLD:begin
		      if (data_over_flag && play)
				    next_state=WAIT;
				else
				    next_state=HOLD;
		  end
		  WAIT:begin
		      if (data_over_flag && counter == 6'd22)
					 next_state=FEED_IN;
				else
				    next_state=WAIT;	
        end
		  FEED_IN:begin
		      if (data_over_flag)begin
				    if (FL_ADDR==End_Addr) begin
					     next_state=END;
						  end
					 else begin
					     next_state=WAIT;
						  end
				end
				else begin
				    next_state=FEED_IN;
				end
		  end
	     END:begin
		      if (loop)
				    next_state=HOLD;
				else
				    next_state=END;
		  end
    endcase
end

always_comb begin
    NEW_ADDR=FL_ADDR;
	 inner_counter=counter;
    case(current_state)
	     HOLD:begin
		      NEW_ADDR=Start_Addr;
		  end
		  WAIT: begin
		      if (data_over_flag)begin
				    inner_counter=counter+6'd1;
				end
		  end
		  FEED_IN:begin
		      if (data_over_flag)begin
				    inner_counter=0;
				    NEW_ADDR=FL_ADDR+23'd1;
				end
		  end
		  END: begin
		      if (loop)
				    NEW_ADDR=Start_Addr;
				else 
				    NEW_ADDR=End_Addr;
		  end
	
    endcase

end

 endmodule