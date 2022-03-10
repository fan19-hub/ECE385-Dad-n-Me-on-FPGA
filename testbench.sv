module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
				// This is the amount of time represented by #1

timeprecision 1ns;

logic        CLOCK_50=1'b0;
logic [3:0]  KEY;          //bit 0 is set up as Reset
logic [6:0]  HEX0, HEX1,HEX2,HEX3,HEX4;
logic [7:0]  VGA_R,        //VGA Red
             VGA_G,        //VGA Green
             VGA_B;        //VGA Blue						
logic        VGA_CLK,      //VGA Clock
             VGA_SYNC_N,   //VGA Sync signal
             VGA_BLANK_N,  //VGA Blank signal
             VGA_VS,       //VGA virtical sync signal
             VGA_HS;       //VGA horizontal sync signa
wire  [15:0] OTG_DATA;     //CY7C67200 Data bus 16 Bit
logic [1:0]  OTG_ADDR;     //CY7C67200 Address 2 Bits
logic        OTG_CS_N,     //CY7C67200 Chip Select
             OTG_RD_N,     //CY7C67200 Write
             OTG_WR_N,     //CY7C67200 Read
             OTG_RST_N,    //CY7C67200 Reset
             OTG_INT;      //CY7C67200 Interrupt
logic [12:0] DRAM_ADDR;    //SDRAM Address 13 Bits
wire  [31:0] DRAM_DQ;      //SDRAM Data 32 Bits
logic [1:0]  DRAM_BA;      //SDRAM Bank Address 2 Bits
logic [3:0]  DRAM_DQM;     //SDRAM Data Mast 4 Bits
logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
             DRAM_CAS_N,   //SDRAM Column Address Stro
             DRAM_CKE,     //SDRAM Clock Enable
             DRAM_WE_N,    //SDRAM Write Enable
             DRAM_CS_N,    //SDRAM Chip Select
             DRAM_CLK;      //SDRAM Clock
logic        AUD_ADCDAT,
             AUD_ADCLRCK,
             AUD_BCLK,
             AUD_DACDAT,
             AUD_DACLRCK,
             AUD_XCK,
             I2C_SCLK,
             I2C_SDAT;

logic [22:0] FL_ADDR; // Flash Address
logic [7:0]  FL_DQ;   // Data
logic        FL_OE_N, FL_RST_N, FL_WE_N, FL_CE_N;
logic        CE, UB, LB, OE, WE;
logic [19:0] ADDR;
wire  [15:0] Data;
logic [17:0] SW;

lab8 test(.*);

logic[7:0] show_me_color_index;
assign show_me_color_index=test.me_color_index;

always #1 CLOCK_50 = ~CLOCK_50;
initial begin
KEY=4'b0000;
#2 KEY=4'b0001;
end

endmodule