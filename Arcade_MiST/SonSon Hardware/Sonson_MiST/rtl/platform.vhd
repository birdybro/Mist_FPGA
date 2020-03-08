library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pace_pkg.all;
use work.video_controller_pkg.all;
use work.sprite_pkg.all;
use work.platform_pkg.all;

entity platform is
  port
  (
    -- clocking and reset
    clkrst_i        	: in from_CLKRST_t;
	 vma					: out std_logic;
    -- controller inputs
    inputs_p1			: in std_logic_vector(7 downto 0);
    inputs_p2			: in std_logic_vector(7 downto 0);
    inputs_sys			: in std_logic_vector(7 downto 0);
    inputs_dip1		: in std_logic_vector(7 downto 0);
    inputs_dip2		: in std_logic_vector(7 downto 0);
    
    bitmap_i        : in from_BITMAP_CTL_a(1 to PACE_VIDEO_NUM_BITMAPS);
    bitmap_o        : out to_BITMAP_CTL_a(1 to PACE_VIDEO_NUM_BITMAPS);
    
    tilemap_i       : in from_TILEMAP_CTL_a(1 to PACE_VIDEO_NUM_TILEMAPS);
    tilemap_o       : out to_TILEMAP_CTL_a(1 to PACE_VIDEO_NUM_TILEMAPS);

    sprite_reg_o    : out to_SPRITE_REG_t;
    sprite_i        : in from_SPRITE_CTL_t;
    sprite_o        : out to_SPRITE_CTL_t;
	 spr0_hit				: in std_logic;

    -- various graphics information
    graphics_i      : in from_GRAPHICS_t;
    graphics_o      : out to_GRAPHICS_t;
	 
	 snd_i      : in from_SOUND_t;
    snd_o      : out to_SOUND_t;
    platform_i      : in from_PLATFORM_IO_t;
    platform_o      : out to_PLATFORM_IO_t;
	 
	 cpu_rom_addr		: out std_logic_vector(15 downto 0);
	 cpu_rom_do			: in std_logic_vector(7 downto 0);
	 tile_rom_addr		: out std_logic_vector(12 downto 0);
	 tile_rom_do		: in std_logic_vector(15 downto 0)
  );

end platform;

architecture SYN of platform is

	alias clk_20M					    : std_logic is clkrst_i.clk(0);
  alias rst_20M             : std_logic is clkrst_i.rst(0);
	alias clk_video				    : std_logic is clkrst_i.clk(1);
	signal cpu_reset			    : std_logic;
  
  -- uP signals  
  signal clk_2M_en			    : std_logic;
	signal cpu_clk_en         : std_logic;
	signal cpu_r_wn				    : std_logic;
	signal cpu_a				      : std_logic_vector(15 downto 0);
	signal cpu_d_i			      : std_logic_vector(7 downto 0);
	signal cpu_d_o			      : std_logic_vector(7 downto 0);
	signal cpu_irq				    : std_logic;

  -- ROM signals        
	signal rom_cs				      : std_logic;
	
  -- RAM signals        
	signal wram_cs				    : std_logic;
  signal wram_wr            : std_logic;
  signal wram_d_o      	    : std_logic_vector(7 downto 0);
  signal vram_cs				    : std_logic;
  signal vram_d_o           : std_logic_vector(7 downto 0);
  signal vram_wr            : std_logic;
  signal cram_cs				    : std_logic;
  signal cram_d_o           : std_logic_vector(7 downto 0);
  signal cram_wr            : std_logic;
  signal sprite_cs          : std_logic;
  
  -- I/O signals
  signal scroll_cs          : std_logic;
  signal in0_cs             : std_logic;
  signal in1_cs             : std_logic;
  signal in2_cs             : std_logic;
  signal dsw1_cs            : std_logic;
  signal dsw2_cs            : std_logic;
  
  signal rom4_d_o   : std_logic_vector(7 downto 0);
  signal rom8_d_o   : std_logic_vector(7 downto 0);
  signal romC_d_o   : std_logic_vector(7 downto 0);
  signal rom_d_o    : std_logic_vector(7 downto 0);
  
  signal cpu_rn_w            : std_logic;
  
  COMPONENT mc6809i
	GENERIC ( ILLEGAL_INSTRUCTIONS : STRING := "GHOST" );
	PORT
	(
		D		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		DOut		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		ADDR		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		RnW		:	 OUT STD_LOGIC;
		E		:	 IN STD_LOGIC;
		Q		:	 IN STD_LOGIC;
		BS		:	 OUT STD_LOGIC;
		BA		:	 OUT STD_LOGIC;
		nIRQ		:	 IN STD_LOGIC;
		nFIRQ		:	 IN STD_LOGIC;
		nNMI		:	 IN STD_LOGIC;
		AVMA		:	 OUT STD_LOGIC;
		BUSY		:	 OUT STD_LOGIC;
		LIC		:	 OUT STD_LOGIC;
		nHALT		:	 IN STD_LOGIC;
		nRESET		:	 IN STD_LOGIC;
		nDMABREQ		:	 IN STD_LOGIC;
		RegData		:	 OUT STD_LOGIC_VECTOR(111 DOWNTO 0)
	);
END COMPONENT;

begin
	
	wram_cs 		<=	'1' when STD_MATCH(cpu_a,  "0000------------") else '0';-- RAM $0000-$0FFF
	vram_cs 		<=	'1' when STD_MATCH(cpu_a,  "000100----------") else '0';-- video ram $1000-$13FF 
   cram_cs 		<=	'1' when STD_MATCH(cpu_a,  "000101----------") else '0';-- colour ram $1400-$17FF
	sprite_cs 	<=	'1' when STD_MATCH(cpu_a,    X"20"&"001-----") else
						'1' when STD_MATCH(cpu_a,    X"20"&"01------") else
						'0';-- sprite 'ram' $2020-$207F
  -- I/O
	scroll_cs 	<= '1' when STD_MATCH(cpu_a, X"3000") else '0';
	in0_cs 		<= '1' when STD_MATCH(cpu_a, X"3002") else '0';
	in1_cs 		<= '1' when STD_MATCH(cpu_a, X"3003") else '0';
	in2_cs 		<= '1' when STD_MATCH(cpu_a, X"3004") else '0';
	dsw1_cs 		<= '1' when STD_MATCH(cpu_a, X"3005") else '0';
	dsw2_cs 		<= '1' when STD_MATCH(cpu_a, X"3006") else '0';
	rom_cs  		<= '1' when (cpu_a > X"3FFF") else '0';

  -- memory block write enables
  wram_wr <= wram_cs and clk_2M_en and not cpu_r_wn;
  vram_wr <= vram_cs and clk_2M_en and not cpu_r_wn;
  cram_wr <= cram_cs and clk_2M_en and not cpu_r_wn;

	-- memory read mux
	cpu_d_i <=  wram_d_o when wram_cs = '1' else
					vram_d_o when vram_cs = '1' else
					cram_d_o when cram_cs = '1' else
					inputs_p1 when in0_cs = '1' else
					inputs_p2 when in1_cs = '1' else
					inputs_sys when in2_cs = '1' else
					inputs_dip1 when dsw1_cs = '1' else
					inputs_dip2 when dsw2_cs = '1' else
					-- flip off, service off, coin A, 1C1C
--              (X"80" or X"40" or X"10" or X"0F") when dsw1_cs = '1' else
              -- freeze off, easy, 20K/80K/100K, 3 lives
--              (X"80" or X"60" or X"08" or X"03") when dsw2_cs = '1' else
				  rom_d_o when rom_cs = '1' else
--				  cpu_rom_do when rom_cs = '1' else
							(others => 'Z');
	
	
  -- system timing
  process (clk_20M, rst_20M)
    variable count : integer range 0 to 10-1;
  begin
    if rst_20M = '1' then
      count := 0;
    elsif rising_edge(clk_20M) then
      clk_2M_en <= '0'; -- default
      case count is
        when 0 =>
          clk_2M_en <= '1';
        when others =>
          null;
      end case;
      if count = count'high then
        count := 0;
      else
        count := count + 1;
      end if;
    end if;
  end process;

	-- cpu09 core uses negative clock edge
	--cpu_clk_en <= not (clk_2M_en and not platform_pause);
	cpu_clk_en <= clk_2M_en;

	-- add game reset later
	cpu_reset <= rst_20M;
	
--	cpu_inst : entity work.cpu09
 --   generic map
 --   (
 --     CLK_POL   => '1'
 --   )
--		port map
--		(	
--			clk				=> clk_20M,
 --     clk_en    => cpu_clk_en,
--			rst				=> cpu_reset,
--			rw				=> cpu_r_wn,
	--		vma				=> vma,
      --ba        => open,
      --bs        => open,
	--		addr		  => cpu_a,
--		  data_in		=> cpu_d_i,
--		  data_out	=> cpu_d_o,
--			halt			=> '0',
--			hold			=> '0',
--			irq				=> cpu_irq,
--			firq			=> '0',
---			nmi				=> '0'
--		);
		
--changed for test		
	cpu_inst : mc6809i
	port map
    (
    D				=> cpu_d_i,
    DOut			=> cpu_d_o,
    ADDR	  		=> cpu_a,
    RnW			=> cpu_r_wn,
    E   			=> cpu_clk_en,
    Q				=> clk_20M,
    BS     		=> open,
    BA     		=> open,
    nIRQ			=> not cpu_irq,
    nFIRQ		=> '1',
    nNMI			=> '1',
    AVMA  		=> open,
    BUSY  		=> open,
	 LIC  		=> open,
    nHALT		=> '1',	 
    nRESET		=> not cpu_reset,
    nDMABREQ  	=> '1',
    RegData		=> open
    );

		
		
--WRAm_cs
	wram_inst : entity work.spram
    generic map
	(
		widthad_a	=> 12,
		width_a		=> 8
	)
		port map
	(
		address		=> cpu_a(11 downto 0),
		clock			=> clk_20M,
		data			=> cpu_d_o,
		wren			=> wram_wr,
		q				=> wram_d_o
	);	

	-- irq vblank interrupt
	process (clk_20M, rst_20M)
    variable vblank_r : std_logic_vector(3 downto 0);
    alias vblank_prev : std_logic is vblank_r(vblank_r'left);
    alias vblank_um   : std_logic is vblank_r(vblank_r'left-1);
	begin
		if rst_20M = '1' then
			vblank_r := (others => '0');
      cpu_irq <= '0';
		elsif rising_edge(clk_20M) then
			if vblank_um = '1' and vblank_prev = '0' then
				cpu_irq <= '1';
      elsif vblank_um = '0' then
        cpu_irq <= '0';
			end if;
      -- numeta the vblank
      vblank_r := vblank_r(vblank_r'left-1 downto 0) & graphics_i.vblank;
		end if;
	end process;

  -- scroll register
  process (clk_20M, rst_20M)
  begin
    if rst_20M = '1' then
      graphics_o.bit8(0) <= (others => '0');
    elsif rising_edge(clk_20M) then
      if scroll_cs and clk_2M_en and not cpu_r_wn then
        graphics_o.bit8(0) <= cpu_d_o;
      end if;
    end if;
  end process;

  
    rom_4000_inst : entity work.sprom
     generic map
      (
        init_file		=> "./roms/ss_01e.hex",
       widthad_a		=> 14
     )
      port map
      (
        clock			=> clk_20M,
        address		=> cpu_a(13 downto 0),
        q					=> rom4_d_o
      );
    
   rom_8000_inst : entity work.sprom
      generic map
      (
        init_file		=> "./roms/ss_02e.hex",
        widthad_a		=> 14
      )
      port map
      (
        clock			=> clk_20M,
        address		=> cpu_a(13 downto 0),
        q					=> rom8_d_o
      );
      
    rom_C000_inst : entity work.sprom
      generic map
      (
        init_file		=> "./roms/ss_03e.hex",
        widthad_a		=> 14
      )
      port map
      (
       clock			=> clk_20M,
        address		=> cpu_a(13 downto 0),
       q					=> romC_d_o
      );
		
    rom_d_o <=  rom4_d_o when STD_MATCH(cpu_a, "01--------------") else
                rom8_d_o when STD_MATCH(cpu_a, "10--------------") else
                romC_d_o;
                  
--cpu_rom_addr <= cpu_a(15 downto 0);
--rom_d_o <= cpu_rom_do;

  -- wren_a *MUST* be GND for CYCLONEII_SAFE_WRITE=VERIFIED_SAFE
  vram_inst : entity work.dpram
    generic map
    (
      init_file		=> "./roms/vram.hex",
      widthad_a		=> 10
    )
    port map
    (
      clock_b			=> clk_20M,
      address_b		=> cpu_a(9 downto 0),
      wren_b			=> vram_wr,
      data_b			=> cpu_d_o,
      q_b					=> vram_d_o,

      clock_a			=> clk_video,
      address_a		=> tilemap_i(1).map_a(9 downto 0),
      wren_a			=> '0',
      data_a			=> (others => 'X'),
      q_a					=> tilemap_o(1).map_d(7 downto 0)
    );
  tilemap_o(1).map_d(tilemap_o(1).map_d'left downto 8) <= (others => 'Z');
  
  -- wren_a *MUST* be GND for CYCLONEII_SAFE_WRITE=VERIFIED_SAFE
  cram_inst : entity work.dpram
    generic map
    (
      init_file		=> "./roms/cram.hex",
      widthad_a		=> 10
    )
    port map
    (
      clock_b			=> clk_20M,
      address_b		=> cpu_a(9 downto 0),
      wren_b			=> cram_wr,
      data_b			=> cpu_d_o,
      q_b					=> cram_d_o,

      clock_a			=> clk_video,
      address_a		=> tilemap_i(1).attr_a(9 downto 0),
      wren_a			=> '0',
      data_a			=> (others => 'X'),
      q_a					=> tilemap_o(1).attr_d(7 downto 0)
    );
  tilemap_o(1).attr_d(tilemap_o(1).attr_d'left downto 8) <= (others => 'Z');

   --tile rom (bit 0)
  ss_7_b6_inst : entity work.sprom
    generic map
    (
     init_file		=> "./roms/ss_7_b6.hex",
      widthad_a		=> 13
    )
    port map
    (
      clock			=> clk_video,
      address		=> tilemap_i(1).tile_a(12 downto 0),
      q					=> tilemap_o(1).tile_d(7 downto 0)
   );
		
  -- tile rom (bit 1)---will not fit in FPGA Block Ram
 -- ss_8_b5_inst : entity work.sprom
  --  generic map
  --  (
  --   init_file		=> "./roms/ss_8_b5.hex",
  --    widthad_a		=> 13
  --  )
  --  port map
  --  (
  --    clock			=> clk_video,
  --    address		=> tilemap_i(1).tile_a(12 downto 0),
   --  q					=> tilemap_o(1).tile_d(15 downto 8)
   -- );

--tile_rom_addr <= tilemap_i(1).tile_a(12 downto 0);
--tilemap_o(1).tile_d(15 downto 0) <= tile_rom_do(15 downto 0);

  BLK_SPRITES : block---will not fit in FPGA Block Ram
    signal bit0_1       : std_logic_vector(7 downto 0);   -- offset 0
    signal bit0_2       : std_logic_vector(7 downto 0);   -- offset 0
    signal bit0_3       : std_logic_vector(7 downto 0);   -- offset 16
    signal bit0_4       : std_logic_vector(7 downto 0);   -- offset 16
    signal bit1_1       : std_logic_vector(7 downto 0);
    signal bit1_2       : std_logic_vector(7 downto 0);
    signal bit1_3       : std_logic_vector(7 downto 0);
    signal bit1_4       : std_logic_vector(7 downto 0);
    signal bit2_1       : std_logic_vector(7 downto 0);
    signal bit2_2       : std_logic_vector(7 downto 0);
    signal bit2_3       : std_logic_vector(7 downto 0);
    signal bit2_4       : std_logic_vector(7 downto 0);
    
    signal sprite_a_00  : std_logic_vector(12 downto 0);
    signal sprite_a_16  : std_logic_vector(12 downto 0);
    
  begin

    -- registers
    sprite_reg_o.clk <= clk_20M;
    sprite_reg_o.clk_ena <= clk_2M_en;
    sprite_reg_o.a <= cpu_a(sprite_reg_o.a'range);
    sprite_reg_o.d <= cpu_d_o;
    sprite_reg_o.wr <= sprite_cs and clk_2M_en and not cpu_r_wn;

    -- - sprite data consists of:
    --   16 consecutive bytes for the 1st half
    --   then the next 16 bytes for the 2nd half
    -- - because we need to fetch an entire row at once
    --   use dual-port memory to access both halves of each row

    -- generate address for each port
   -- sprite_a_00 <= sprite_i.a(12 downto 5) & '0' & sprite_i.a(3 downto 0);
  --  sprite_a_16 <= sprite_i.a(12 downto 5) & '1' & sprite_i.a(3 downto 0);
    
    -- sprite rom (bit 0, part 1/2)
   -- ss_9_m5_inst : entity work.dprom_2r
  --    generic map
  --    (
  --      init_file		=> "./roms/ss_9_m5.hex",
  --      widthad_a		=> 13,
  --      widthad_b		=> 13
 --     )
  --    port map
  --    (
  --      clock			  => clk_video,
  --      address_a   => sprite_a_00,
  --      q_a 			  => bit0_1,
  --      address_b   => sprite_a_16,
  --      q_b         => bit0_3
 --     );
      
    -- sprite rom (bit 0, part 2/2)
  --  ss_10_m6_inst : entity work.dprom_2r
  --    generic map
  --    (
  --      init_file		=> "./roms/ss_10_m6.hex",
  --      widthad_a		=> 13,
  --      widthad_b		=> 13
  --    )
 --     port map
 --     (
 --       clock			  => clk_video,
 --       address_a   => sprite_a_00,
 ---       q_a 			  => bit0_2,
 --       address_b   => sprite_a_16,
 --       q_b         => bit0_4
 --     );
      
--    sprite_o.d(15 downto 0) <=  (bit0_1 & bit0_3) when sprite_i.a(13) = '0' else
--                                (bit0_2 & bit0_4);
                              
    -- sprite rom (bit 1, part 1/2)
 --   ss_11_m3_inst : entity work.dprom_2r
 --     generic map
 --     (
 --       init_file		=> "./roms/ss_11_m3.hex",
 --       widthad_a		=> 13,
 --       widthad_b		=> 13
 --     )
 --     port map
 --     (
 --      clock			  => clk_video,
 --      address_a   => sprite_a_00,
 --      q_a 			  => bit1_1,
 --      address_b   => sprite_a_16,
 --      q_b         => bit1_3
--      );
      
    -- sprite rom (bit 0, part 2/2)
 --   ss_12_m4_inst : entity work.dprom_2r
 --     generic map
 --     (
 --       init_file		=> "./roms/ss_12_m4.hex",
 --       widthad_a		=> 13,
 --       widthad_b		=> 13
 --     )
 --     port map
 --     (
 --       clock			  => clk_video,
--        address_a   => sprite_a_00,
 --       q_a 			  => bit1_2,
 --       address_b   => sprite_a_16,
---        q_b         => bit1_4
 ---     );
      
 --   sprite_o.d(31 downto 16) <= (bit1_1 & bit1_3) when sprite_i.a(13) = '0' else
--                                (bit1_2 & bit1_4);
                              
    -- sprite rom (bit 2, part 1/2)
  --  ss_13_m1_inst : entity work.dprom_2r
 --     generic map
 --     (
 --       init_file		=> "./roms/ss_13_m1.hex",
 --       widthad_a		=> 13,
 --       widthad_b		=> 13
 --     )
 --     port map
 --     (
 --       clock			  => clk_video,
 --       address_a   => sprite_a_00,
 --       q_a 			  => bit2_1,
 --       address_b   => sprite_a_16,
 --       q_b         => bit2_3
 --     );
      
    -- sprite rom (bit 2, part 2/2)
--    ss_14_m2_inst : entity work.dprom_2r
--      generic map
--      (
--        init_file		=> "./roms/ss_14_m2.hex",
 --       widthad_a		=> 13,
--        widthad_b		=> 13
 --     )
 --     port map
 --     (
 --       clock			  => clk_video,
 --       address_a   => sprite_a_00,
 --       q_a 			  => bit2_2,
 --       address_b   => sprite_a_16,
 --       q_b         => bit2_4
 --     );
     
 --   sprite_o.d(47 downto 32) <= (bit2_1 & bit2_3) when sprite_i.a(13) = '0' else
 --                               (bit2_2 & bit2_4);

  end block BLK_SPRITES;
  
  -- unused outputs

  graphics_o.bit16(0) <= (others => '0');

end SYN;
