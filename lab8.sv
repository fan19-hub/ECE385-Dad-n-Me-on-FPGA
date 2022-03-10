module lab8(input               CLOCK_50,
            input        [3:0]  KEY,          //bit 0 is set up as Reset
            output logic [6:0]  HEX0, HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,
            // VGA Interface 
            output logic [7:0]  VGA_R,        //VGA Red
                                VGA_G,        //VGA Green
                                VGA_B,        //VGA Blue						
            output logic        VGA_CLK,      //VGA Clock
                                VGA_SYNC_N,   //VGA Sync signal
                                VGA_BLANK_N,  //VGA Blank signal
                                VGA_VS,       //VGA virtical sync signal
                                VGA_HS,       //VGA horizontal sync signal
            // CY7C67200 Interface
            inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
            output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
            output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                OTG_RD_N,     //CY7C67200 Write
                                OTG_WR_N,     //CY7C67200 Read
                                OTG_RST_N,    //CY7C67200 Reset
            input               OTG_INT,      //CY7C67200 Interrupt
            // SDRAM Interface for Nios II Software
            output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
            inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
            output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
            output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
            output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                DRAM_CAS_N,   //SDRAM Column Address Strobe
                                DRAM_CKE,     //SDRAM Clock Enable
                                DRAM_WE_N,    //SDRAM Write Enable
                                DRAM_CS_N,    //SDRAM Chip Select
                                DRAM_CLK,      //SDRAM Clock
            input  logic          		AUD_ADCDAT,
	         inout  logic          		AUD_ADCLRCK,
	         inout  logic          		AUD_BCLK,
	         output logic          		AUD_DACDAT,
	         inout  logic          		AUD_DACLRCK,
	         output logic          		AUD_XCK,
            
	         output logic          		I2C_SCLK,
	         inout  logic          		I2C_SDAT,
            // flash
            output logic  [22:0] FL_ADDR, // Flash Address
            input  logic  [7:0]  FL_DQ,   // Data
            output logic         FL_OE_N, FL_RST_N, FL_WE_N, FL_CE_N,
	         output logic         CE, UB, LB, OE, WE,
	         output logic  [19:0] ADDR,
	         inout  wire   [15:0] Data,
            input         [17:0] SW
				);
    logic Reset_h, Clk;
   logic [7:0] keycode_2;
   logic is_ball;
   logic [9:0] DrawX,DrawY;
//	debug(.*);
   assign Clk=CLOCK_50;

   always_ff @ (posedge Clk) begin
      Reset_h <= ~(KEY[0]);        // The push buttons are active low
   end
   
   logic [1:0] hpi_addr;
   logic [15:0] hpi_data_in, hpi_data_out;
   logic hpi_r, hpi_w, hpi_cs, hpi_reset;
   
	//audio
   logic [15:0] WM8731_LDATA, WM8731_RDATA;
   logic WM8731_DATA_OVER, WM8731_DATA_OVER_PREV;
   logic WM8731_READY;
   logic INIT_FINISH;
   logic play,loop;  //play audio or loop audio
   logic [22:0] Start_Addr,End_Addr;
   logic [15:0] Audio_Data;

   logic Audio_Reset;

   logic [31:0] test;
   assign test={WM8731_RDATA, WM8731_LDATA};

Flash_Audio_Interface fetch_music(
    .Clk(CLOCK_50), .Reset(~Reset_h), .data_over(WM8731_DATA_OVER),.Audio_Reset(Audio_Reset),
	 .play(1),.loop(1),
	 .Start_Addr(Start_Addr),.End_Addr(End_Addr),
	 .FL_DQ(FL_DQ),.FL_OE_N(FL_OE_N),.FL_RST_N(FL_RST_N), .FL_WE_N(FL_WE_N), .FL_CE_N(FL_CE_N),
	 .FL_ADDR(FL_ADDR),
	 .Audio_Data(Audio_Data)
);
////audio FX selector

SoundFX_Selector Select_Audio(
    .Clk(CLOCK_50),
	 .InputSelect(1),
	 .loop(1),.play(1),.Audio_Reset(Audio_Reset),
	 .Start_Addr(Start_Addr),.End_Addr(End_Addr)
);


audio_interface wm8731_inst(
	.clk(CLOCK_50), .Reset(Reset_h), .INIT(1'b1),
	.INIT_FINISH(INIT_FINISH),
	.AUD_ADCDAT(AUD_ADCDAT), .AUD_ADCLRCK(AUD_ADCLRCK), .AUD_BCLK(AUD_BCLK),
	.AUD_DACDAT(AUD_DACDAT), .AUD_DACLRCK(AUD_DACLRCK), .AUD_MCLK(AUD_XCK),
	.I2C_SDAT(I2C_SDAT), .I2C_SCLK(I2C_SCLK),
	
	.LDATA(Audio_Data), .RDATA(Audio_Data),
	.data_over(WM8731_DATA_OVER)
);    
    // Interface between NIOS II and EZ-OTG chip
	 logic me_dead;
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode), 
									  .keycode_2_export(keycode_2), 
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );



    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.*,.Reset(Reset_h));
	 
	
    logic [10:0] Screen_X_Min;

    logic [7:0] keycode;
    logic press;
	 logic left,attack,thump;
	 logic [7:0] state;
	 logic [10:0]me_state_out;
    ISDU state_machine(.*,.Reset(Reset_h),.frame_clk(VGA_VS),.Clk(CLOCK_50));
	 logic [23:0] lb_rgb;
	 


	logic r,ok;
	//our main design
 	logic [15:0] me_addr;
   logic [19:0] bg_addr;
	logic [23:0] me_rgb,bg_rgb;
   logic [15:0] Data_from_CPU, Data_from_SRAM, Data_to_CPU, Data_to_SRAM;
   logic [7:0]  bg_rgb_index,me_rgb_index,en_rgb_index,blood_bar_rgb_index;
	logic [10:0] roll,En_X_Motion;
	logic [10:0] Ball_X_Pos,Ball_Y_Pos;

	logic [3:0] curr_state1;
	logic is_blood_bar;
	logic [6:0] me_blood;
	logic beida,beida1,beida2;
	
//	logic is_en_blood_bar,is_en_blood_bar1,is_en_blood_bar2;
//	logic [23:0] en_rgb,en_rgb1,en_rgb2;
//	logic [15:0] en_addr,en_addr1,en_addr2;
//	logic [1:0] en_move,en_move1,en_move2;
//	logic [6:0] en_blood,en_blood1,en_blood2;
//	logic enemy_left1,enemy_left2,enemy_left;
//	logic en_dead,en_dead1,en_dead2;
//	
	
	logic fly;
	logic [7:0] color_index;
	logic next,fail,success;
	logic [10:0] offset;
	logic level_reset;
	logic [23:0] success_rgb,fail_rgb;
	logic show_success, show_fail;
	logic [9:0] counter;
	logic level,pass;
	assign pass=en_dead;
	
	logic[23:0] en_rgb3;


   ball ball_instance(.*,.Reset(Reset_h || level_reset),.frame_clk(VGA_VS),.relative_address(me_addr));
	Little_Boss lb(.*,.Reset(Reset_h),.frame_clk(VGA_VS),.is_enemy(is_enemy3),.relative_address(en_addr3),.main_X_Pos(Ball_X_POS),.main_Y_Pos(Ball_Y_POS));
	enemy en2(.*,.S_X_Pos(11'd100), .S_Y_Pos(11'd200),.Reset(Reset_h),.frame_clk(VGA_VS),.is_enemy(is_enemy2),.enemy_left(enemy_left2),.beida(beida2),.is_en_blood_bar(is_en_blood_bar2),.relative_address(en_addr2),.en_move(en_move2),.en_dead(en_dead2),.curr_state1(curr_state11));
	enemy en1(.*,.S_X_Pos(11'd200), .S_Y_Pos(11'd100),.Reset(Reset_h),.frame_clk(VGA_VS),.is_enemy(is_enemy1),.enemy_left(enemy_left1),.beida(beida1),.is_en_blood_bar(is_en_blood_bar1),.relative_address(en_addr1),.en_move(en_move1),.en_dead(en_dead1),.curr_state1(curr_state12));
	Background bg(.*,.Reset(Reset_h),.frame_clk(VGA_VS),.relative_address(bg_addr));
	key_control key_contro(.*,.Clk(Clk),.frame_clk(VGA_VS),.Reset(Reset_h));
	Me_ROM me_rom(.*,.frame_clk(VGA_VS),.Reset(Reset_h),.relative_address(me_addr),.Clk(Clk),.data_Out(me_rgb));
   En_ROM en_rom(.*,.frame_clk(VGA_VS),.read_address(en_addr),.Clk(Clk),.data_Out(en_rgb)); 
	LB_ROM LB_rom(.*,.read_address(en_addr3),.Clk(Clk),.data_Out(en_rgb3)); 
   blood_bar me_bb(.*,.frame_clk(VGA_VS),.blood(me_blood));
	color_mapper color_instance1(.*);
	level_state ls(.*,.frame_clk(VGA_VS),.Reset(Reset_h));
	RGB_SUCCESS rgb_s(.*);
	RGB_FAIL rgb_f(.*);
     //SRAM
    assign WE = 1'b1;
	 assign CE = 1'b0;
	 assign UB = 1'b0;
	 assign LB = 1'b0;
    assign OE = ~WE;
    assign ADDR = bg_addr;
    assign bg_rgb_index=Data_to_CPU[7:0];


	 // Our SRAM and I/O controller
	 Mem2IO memory_subsystem(
		 .*, .Reset(Reset_h), .ADDR(ADDR),
		 .Data_from_CPU(), .Data_to_CPU(Data_to_CPU),
		 .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
	 );


    // The tri-state buffer serves as the interface between Mem2IO and SRAM
	 tristate #(.N(16)) tr0(
		 .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data));
	 
	 
	 
	 
	 
	logic is_en_blood_bar,is_en_blood_bar1,is_en_blood_bar2;
	logic [23:0] en_rgb;
	logic [15:0] en_addr,en_addr1,en_addr2,en_addr3;
	logic [1:0] en_move,en_move1,en_move2;
	logic [6:0] en_blood,en_blood1,en_blood2;
	logic enemy_left1,enemy_left2,enemy_left,enemy_left3;
	logic en_dead,en_dead1,en_dead2;
	logic is_enemy,is_enemy1,is_enemy2,is_enemy3;
	logic [1:0] en_select;
	 assign is_en_blood_bar=is_en_blood_bar1 || is_en_blood_bar2;
	 assign is_enemy=is_enemy1 || is_enemy2;
	 assign en_select={is_enemy2,is_enemy1};
	 assign en_dead=en_dead1 && en_dead2;
	 always_comb
	 begin
		 case(en_select)
		 2'b01:
		 begin   
			en_addr =     en_addr1;   
			en_move  =    en_move1;   
			en_blood  =   en_blood1;    
			enemy_left = enemy_left1;
			beida=beida1;
		 end
		 2'b10:
		 begin  
			en_addr =  en_addr2;   
			en_move =  en_move2;   
			en_blood=en_blood2;   
			enemy_left = enemy_left2;
			beida=beida2;
		 
		 end
		 2'b11:
		 begin  
			en_addr =  en_addr1;   
			en_move =  en_move1;   
			en_blood=en_blood1;   
			enemy_left = enemy_left1;
			beida=beida1;
		 
		 end
		 default:
		 begin 
			en_addr =     en_addr1;   
			en_move  =    en_move1;   
			en_blood  =   en_blood1;    
			enemy_left = enemy_left1;
			beida=beida1;
		 end
		 endcase
		
	 
	 end
	 
	 
	 
	 
//	 //show the data from sram
	 logic[27:0] show;
	 logic[27:0] show_in;
	 logic[19:0] draw_addr;
	 assign draw_addr=DrawX+DrawY*'d640;
	 always_ff @ (posedge Clk)
	 begin
			if(Reset_h)
				show<=16'dx;
			else
				show<=show_in;
	 end

    
	 always_comb
	 begin
	 show_in=show;
	 if(draw_addr[15:0]===SW[15:0])
	 begin
//		show_in[7:0]=color_index;
		show_in[3:0]={3'b0,en_dead};
		show_in[11:8]=curr_state11;
//		show_in[15:12]=counter[3:0];
//		show_in[19:16]=counter[6:4];
		show_in[23:20]=en_blood[3:0];
		show_in[26:24]=en_blood[6:4];

	 end
	end
	 
//	 always_comb
//	 begin
//	 show_in=show;
//	 if(me_addr[15:0]===SW[15:0])
//		show_in[7:0]=me_rgb_index;
//      show_in[15:8]=8'dx;
//	 end

    // Display on hex display
    HexDriver hex_inst_0 (show[3:0], HEX0);
    HexDriver hex_inst_1 (show[7:4], HEX1);
	 HexDriver hex_inst_2 (show[11:8], HEX2);
	 HexDriver hex_inst_3 (show[15:12], HEX3);
    HexDriver hex_inst_4 (show[19:16], HEX4);
	 HexDriver hex_inst_5 (show[23:20], HEX5);
	 HexDriver hex_inst_6 (show[27:24], HEX6);
	 
	 
	
endmodule
