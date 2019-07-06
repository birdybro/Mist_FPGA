//============================================================================
//  Arcade: Pleiads
//
//-------------------------------------------------------------------------------
// DE2-35 Top level for Phoenix by Dar (darfpga@aol.fr) (April 2016)
// http://darfpga.blogspot.fr
//
//
//-------------------------------------------------------------------------------

module Pleiads_MiST
(
	output        LED,						
	output  [5:0] VGA_R,
	output  [5:0] VGA_G,
	output  [5:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,
	output        AUDIO_L,
	output        AUDIO_R,	
	input         SPI_SCK,
	output        SPI_DO,
	input         SPI_DI,
	input         SPI_SS2,
	input         SPI_SS3,
	input         CONF_DATA0,
	input         CLOCK_27
);

`include "rtl\build_id.v" 

localparam CONF_STR = {
	"Pleiads;;",
	"O2,Rotate Controls,Off,On;",
	"O34,Scanlines,Off,25%,50%,75%;",
	"T6,Reset;",
	"V,v1.20.",`BUILD_DATE
};

assign LED = 1;
assign AUDIO_R = AUDIO_L;

wire clk_sys, clk_mist;
wire pll_locked;
pll pll(
	.inclk0(CLOCK_27),
	.areset(0),
	.c0(clk_mist),//22
	.c1(clk_sys)//11
	);

wire [31:0] status;
wire  [1:0] buttons;
wire  [1:0] switches;
wire  [7:0] joystick_0;
wire  [7:0] joystick_1;
wire        scandoublerD;
wire        ypbpr;
reg	[11:0] audio;
wire 			hb1, hb2, vb;
wire        blankn = ~(hb1 | hb2 | vb);
wire 			hs, vs;
wire  [1:0] r,g,b;

phoenix phoenix(
	.clk(clk_sys),
	.reset(status[0] | status[6] | buttons[1]),
	.dip_switch(8'b00001111),
	.btn_coin(btn_coin),
	.btn_player_start({btn_two_players,btn_one_player}),
	.btn_left(m_left),
	.btn_right(m_right),
	.btn_barrier(m_bomb),
	.btn_fire(m_fire),
	.video_r(r),
	.video_g(g),
	.video_b(b),
	.video_hs(hs),
	.video_vs(vs),
	.video_vblank(vb), 
	.video_hblank_bg(hb1), 
	.video_hblank_fg(hb2),
	.audio_select("000"),
	.audio(audio)
	);
	
mist_video #(.COLOR_DEPTH(3)) mist_video(
	.clk_sys(clk_mist),
	.SPI_SCK(SPI_SCK),
	.SPI_SS3(SPI_SS3),
	.SPI_DI(SPI_DI),
	.R(blankn ? {r,r,r} : "000"),
	.G(blankn ? {g,g,g} : "000"),
	.B(blankn ? {b,b,b} : "000"),
	.HSync(hs),
	.VSync(vs),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_VS(VGA_VS),
	.VGA_HS(VGA_HS),
	.rotate({1'b1,status[2]}),
	.scandoubler_disable(scandoublerD),
	.scanlines(scandoublerD ? 2'b00 : status[4:3]),
	.ypbpr(ypbpr)
	);
	
user_io #(
	.STRLEN(($size(CONF_STR)>>3)))
user_io(
	.clk_sys        (clk_mist       ),
	.conf_str       (CONF_STR       ),
	.SPI_CLK        (SPI_SCK        ),
	.SPI_SS_IO      (CONF_DATA0     ),
	.SPI_MISO       (SPI_DO         ),
	.SPI_MOSI       (SPI_DI         ),
	.buttons        (buttons        ),
	.switches       (switches       ),
	.scandoubler_disable (scandoublerD	  ),
	.ypbpr          (ypbpr          ),
	.key_strobe     (key_strobe     ),
	.key_pressed    (key_pressed    ),
	.key_code       (key_code       ),
	.joystick_0     (joystick_0     ),
	.joystick_1     (joystick_1     ),
	.status         (status         )
	);


dac #(
	.C_bits(15))
dac(
	.clk_i(clk_mist),
	.res_n_i(1),
	.dac_i({audio, 4'b0000}),
	.dac_o(AUDIO_L)
	);
//											Rotated														Normal
//wire m_up     = ~status[2] ? btn_left | joystick_0[1] | joystick_1[1] : btn_up | joystick_0[3] | joystick_1[3];
//wire m_down   = ~status[2] ? btn_right | joystick_0[0] | joystick_1[0] : btn_down | joystick_0[2] | joystick_1[2];
wire m_left   = ~status[2] ? btn_down | joystick_0[2] | joystick_1[2] : btn_left | joystick_0[1] | joystick_1[1];
wire m_right  = ~status[2] ? btn_up | joystick_0[3] | joystick_1[3] : btn_right | joystick_0[0] | joystick_1[0];
wire m_fire   = btn_fire1 | joystick_0[4] | joystick_1[4];
wire m_bomb   = btn_fire2 | joystick_0[5] | joystick_1[5];

reg btn_one_player = 0;
reg btn_two_players = 0;
reg btn_left = 0;
reg btn_right = 0;
reg btn_down = 0;
reg btn_up = 0;
reg btn_fire1 = 0;
reg btn_fire2 = 0;
reg btn_coin  = 0;
wire       key_pressed;
wire [7:0] key_code;
wire       key_strobe;


always @(posedge clk_mist) begin
if(key_strobe) begin
		case(key_code)
			'h75: btn_up          <= key_pressed; // up
			'h72: btn_down        <= key_pressed; // down
			'h6B: btn_left        <= key_pressed; // left
			'h74: btn_right       <= key_pressed; // right
			'h76: btn_coin        <= key_pressed; // ESC
			'h05: btn_one_player  <= key_pressed; // F1
			'h06: btn_two_players <= key_pressed; // F2
			'h29: btn_fire1       <= key_pressed; // Space
			'h11: btn_fire2 		 <= key_pressed; // Alt
		endcase
	end
end


endmodule 