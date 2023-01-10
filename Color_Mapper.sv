//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
// module  color_mapper ( input              is_ball,is_enemy,            // Whether current pixel belongs to ball 
//                                                              //   or background (computed in ball.sv)
//                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
//							  input        [23:0] me_rgb,en_rgb,bg_rgb,
//                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
//                     );
module  color_mapper ( input              is_ball,is_enemy,is_enemy3,is_blood_bar,is_en_blood_bar,show_success, show_fail,          // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input        [23:0] success_rgb,fail_rgb,en_rgb,me_rgb,en_rgb3,
							  input        [7:0] bg_rgb_index,blood_bar_rgb_index,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output
							  output logic [7:0] color_index
                     );
    
    logic [23:0] color;

    // Output colors to VGA

	 
    RGB_driver rgb(.rgb_index(color_index),.rgb_out(color));
    // Assign color based on is_ball signal
    always_comb
    begin
	      VGA_R = color[23:16];
			VGA_G = color[15:8];
			VGA_B = color[7:0];
			color_index=bg_rgb_index;
			
		  if(show_success)
		  begin
				VGA_R=success_rgb[23:16];
				VGA_G=success_rgb[15:8];
				VGA_B=success_rgb[7:0];
		  end
		  if(show_fail)
		  begin
				VGA_R=fail_rgb[23:16];
				VGA_G=fail_rgb[15:8];
				VGA_B=fail_rgb[7:0];
		  end
        if (is_ball == 1'b1 && me_rgb!=24'hff) 
        begin
				VGA_R=me_rgb[23:16];
				VGA_G=me_rgb[15:8];
				VGA_B=me_rgb[7:0];
        end
		  else if(is_blood_bar)
		  begin
				color_index=blood_bar_rgb_index;
		  end
		  else if(is_enemy3 == 1'b1 && en_rgb3!=24'hff)
		  begin

				VGA_R=en_rgb3[23:16];
				VGA_G=en_rgb3[15:8];
				VGA_B=en_rgb3[7:0];
		  end
        else if(is_enemy == 1'b1 && en_rgb!=24'hff)
		  begin

				VGA_R=en_rgb[23:16];
				VGA_G=en_rgb[15:8];
				VGA_B=en_rgb[7:0];
		  end
		  else if(is_en_blood_bar)
		  begin
				color_index=8'h06;
		  end
 
end
    
    
endmodule
