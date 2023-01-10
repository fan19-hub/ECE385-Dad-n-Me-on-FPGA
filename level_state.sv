module level_state (
input logic next,frame_clk,Reset,pass,ok,
output logic[10:0] offset,
output logic level_reset,success,fail,level

);
logic me_dead;
assign me_dead=1'b0;
enum logic [3:0] {LEVEL1,TRAN12,LEVEL2,SUCCESS,FAIL} State, Next_state;
always_ff @ (posedge frame_clk)
	begin
		if (Reset) 
			State <= LEVEL1;
		else 
			State <= Next_state;
	end


always_comb begin
	Next_state =State;
	offset=11'd0;
	success=1'b0;
	fail=1'b0;
	level=1'b0;
	level_reset=1'b0;
    unique case (State)
        LEVEL1:
            begin
            if(next)
              Next_state =  TRAN12;
            end
        TRAN12:
            begin
            Next_state =  LEVEL2;
				level_reset=1'b1;
            end
		  LEVEL2:
            begin
            if(ok)
                Next_state = SUCCESS;
				 else if(me_dead)
				    Next_state = FAIL;
            end
		  SUCCESS:
		  begin
				if(next)
				Next_state =  LEVEL1;
		  end
		  FAIL:
		  begin
				if(next)
				Next_state =  LEVEL1;
		  end
        default:
            Next_state = State;
	endcase
    case(State)
        LEVEL1:
		  begin
            offset=11'd0;
		  end
        TRAN12:
				offset=11'd480;	
        LEVEL2:
		  begin
				offset=11'd480;
				level=1'b1;
		  end
		  SUCCESS:
		  begin
				success=1'b1;
				offset=11'd480;
		  end
		  FAIL:	
		  begin
				fail=1'b1;
				offset=11'd480;
		  end
	endcase




end
endmodule