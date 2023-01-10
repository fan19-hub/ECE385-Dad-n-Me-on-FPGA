//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]   keycode,keycode_2,
					input [10:0]  Screen_X_Min,
					input [7:0]   state,
					input left,level,
               output logic  is_ball,
					output logic [10:0]  roll,
					output logic [15:0]  relative_address,					// Whether current pixel belongs to ball or background
					output logic [10:0]  Ball_X_Pos,Ball_Y_Pos,
					output logic me_dead,r
//					output logic [6:0]   me_blood
					);
			    // logic 	  [10:0] Screen_X_Min = 11'd0;       // Leftmost point on the X axis
    parameter [10:0] Map_width = 11'd1000;
	 parameter [10:0] Screen_X_Center = 11'd320;  // Center position on the X axis
    logic     [10:0] Screen_X_Max;     // Rightmost point on the X axis
    parameter [10:0] Screen_Y_Center = 11'd240;  // Center position on the Y axis
	 parameter [10:0] Screen_Y_Min = 11'd170;       // Topmost point on the Y axis
    parameter [10:0] Screen_Y_Max = 11'd479;     // Bottommost point on the Y axis
    parameter [10:0] Ball_X_Step = 11'd5;      // Step size on the X axis
    parameter [10:0] Ball_Y_Step = 11'd5;      // Step size on the Y axis
    parameter [10:0] Ball_X_Size = 11'd40;        // Ball size
	 parameter [10:0] Ball_Y_Size = 11'd50;        // Ball size
	 parameter [10:0] Attack_Width = 11'd100;
	 parameter [10:0] Attack_Height = 11'd100;

    parameter [10:0] zero = 11'd0;
    logic [10:0] Ball_X_Motion, Ball_Y_Motion;
    logic [10:0] Ball_X_Pos_in,  Ball_Y_Pos_in ;
	logic [6:0] me_blood_in,me_blood;
	logic[8:0] counter,inner_counter;
	assign r=(Ball_X_Motion!=11'b0);

		  
		  
	assign Screen_X_Max = Screen_X_Min + 11'd639;
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
            Ball_X_Pos <= 11'd100;
            Ball_Y_Pos <= 11'd230;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
        end
    end

   logic[15:0] key;
	assign key={keycode_2,keycode};
	logic en;
	
	
	
	always_ff @ (posedge frame_clk)
		begin
		roll =Ball_X_Motion;
		if(Ball_X_Pos_in<11'd320 || Ball_X_Pos_in>(Map_width-11'd320))
			roll =11'b0;
	
		end
//   always_comb begin : Update_Pos
//			Ball_X_Pos_in = Ball_X_Pos;
//			Ball_Y_Pos_in = Ball_Y_Pos;
//			Ball_X_Motion=11'd0;
//			Ball_Y_Motion=11'd0;
//        
//        // Update position and motion only at rising edge of frame clock
//        if (frame_clk_rising_edge)
//        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_X_Size <= Screen_Y_Min 

				
always_ff @ (posedge frame_clk)
		begin	
				
				if( Ball_Y_Pos + Ball_Y_Size >= Screen_Y_Max&&((keycode===8'h16)||(keycode_2===8'h16)))  // Ball is at the bottom edge, BOUNCE!
				begin
                Ball_Y_Motion = 11'd0;  // 2's complement.  
					 Ball_X_Motion = 11'd0;
				end
            else if ( Ball_Y_Pos <= Screen_Y_Min + Ball_Y_Size &&((keycode===8'h1a)||(keycode_2===8'h1a)))  // Ball is at the top edge, BOUNCE!
				begin
                Ball_Y_Motion = 11'd0;
					 Ball_X_Motion = 11'd0;
				end
            
            else if( Ball_X_Pos + Ball_X_Size >= Screen_X_Max&&((keycode===8'h07)||(keycode_2===8'h07)))  // Ball is at the right edge, BOUNCE!
				begin
            	Ball_X_Motion = 11'd0; 
					 Ball_Y_Motion = 11'd0;
				end
            else if ( Ball_X_Pos <= Screen_X_Min +  Ball_X_Size&&((keycode===8'h04)||(keycode_2===8'h04))) // Ball is at the left edge, BOUNCE!
				begin
                Ball_X_Motion = 11'd0;
					 Ball_Y_Motion = 11'd0;
				end
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_X_Size will not be -4, but rather a large positive number.
				else if( level&& (Ball_Y_Pos + Ball_Y_Size) == 11'd320 &&((keycode===8'h1a)||(keycode_2===8'h1a)) && Ball_X_Pos<=(11'd558+Ball_X_Size))  // Ball is at the bottom edge, BOUNCE!
				begin
                Ball_Y_Motion = 11'd0;  // 2's complement.  
				end
				else
				begin
             case (key)
					16'h04: // A is pressed left
					begin
								 Ball_X_Motion = (~(Ball_X_Step)+1'b1);
								 Ball_Y_Motion = zero;
					end
					16'h07: // D is pressed right
					begin
								 Ball_X_Motion = Ball_X_Step;
								 Ball_Y_Motion = zero;
					end
					16'h1a: // W is pressed up
					begin
								 Ball_Y_Motion = (~(Ball_Y_Step) + 1'b1);
								 Ball_X_Motion = zero;
					end
					16'h16: // S is pressed down
					begin
								 Ball_Y_Motion = Ball_Y_Step;
								 Ball_X_Motion = zero;
					end
					
					
					16'h041a: // AW is pressed left
					begin
								 Ball_X_Motion = (~(Ball_X_Step)+1'b1);
								 Ball_Y_Motion = (~(Ball_Y_Step) + 1'b1);
					end
					16'h1a04: // AW is pressed right
					begin
								 Ball_X_Motion = (~(Ball_X_Step)+1'b1);
								 Ball_Y_Motion = (~(Ball_Y_Step) + 1'b1);
					end
					16'h0416: // AS is pressed up
					begin
								 Ball_Y_Motion = Ball_Y_Step;
								 Ball_X_Motion = (~(Ball_X_Step)+1'b1);
					end
					16'h1604: // AS is pressed down
					begin
								 Ball_Y_Motion = Ball_Y_Step;
								 Ball_X_Motion = (~(Ball_X_Step)+1'b1);
					end
	
					16'h0716: // SD is pressed left
					begin
								 Ball_X_Motion = Ball_X_Step;
								 Ball_Y_Motion = Ball_Y_Step;
					end
					16'h1607: // SD is pressed right
					begin
								 Ball_X_Motion = Ball_X_Step;
								 Ball_Y_Motion = Ball_Y_Step;
					end
					16'h071a: // DW is pressed up
					begin
								 Ball_Y_Motion = (~(Ball_Y_Step) + 1'b1);
								 Ball_X_Motion = Ball_X_Step;
					end
					16'h1a07: // DW is pressed down
					begin
								 Ball_Y_Motion = (~(Ball_Y_Step) + 1'b1);
								 Ball_X_Motion = Ball_X_Step;
					end
					
					16'h0704: // AD is pressed left
					begin
								 Ball_X_Motion = Ball_X_Step;
								 Ball_Y_Motion = zero;
					end
					16'h0407: // DA is pressed right
					begin
								 Ball_X_Motion = (~(Ball_X_Step)+1'b1);
								 Ball_Y_Motion = zero;
					end
					16'h1a16: // SW is pressed up
					begin
								 Ball_Y_Motion = (~(Ball_Y_Step) + 1'b1);
								 Ball_X_Motion = zero;
					end
					16'h161a: // SW is pressed down
					begin
								 Ball_Y_Motion = Ball_Y_Step;
								 Ball_X_Motion = zero;
					end
						
					
					default: 
					begin
								 Ball_Y_Motion = zero;
								 Ball_X_Motion = zero;
					end
				endcase
				end

            // Update the ball's position with its motion
				Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
				Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;

        end 
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY;
	 int Width_left;
	 int Width_right;
	 int Width_half_height;
    assign DistX = DrawX+Screen_X_Min - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    //60*93
    always_comb begin
		  Width_left=Ball_X_Size;
		  Width_right=Ball_X_Size;
		  Width_half_height=Ball_Y_Size;
		  
		  if(state>=8'h05)
			  begin
			  Width_left=Ball_X_Size;
			  Width_right=Attack_Width-Width_left;
			  Width_half_height=Attack_Height/11'd2;
			  
			  if(left)
				  begin
				  Width_right=Ball_X_Size;
				  Width_left=Attack_Width-Width_right;
				  Width_half_height=Attack_Height/11'd2;
				  end
			  
			  end
		  
		  if (DistX<Width_right && DistX+Width_left>0 &&  DistY*DistY < Width_half_height*Width_half_height) 
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        
		  
		  
		  relative_address=16'hffff;
        if(is_ball)
			  begin
			  relative_address=(DrawX+Screen_X_Min +Ball_X_Size- Ball_X_Pos)+ (DistY+Width_half_height)*(Width_left+Width_right);
			  if(left)
					relative_address=(Ball_X_Size-DrawX-Screen_X_Min + Ball_X_Pos)+ (DistY+Width_half_height)*(Width_left+Width_right);
			  end
	end
	

endmodule

