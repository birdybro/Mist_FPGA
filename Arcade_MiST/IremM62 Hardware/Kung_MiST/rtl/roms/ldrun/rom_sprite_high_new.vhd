library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity rom_sprite_high_new is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(4 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of rom_sprite_high_new is
	type rom is array(0 to  31) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"01",X"01",X"01",X"01",X"00",X"00",X"00",X"00",X"01",X"01",X"01",X"01",X"00",X"00",X"00",X"00",
		X"01",X"01",X"01",X"01",X"00",X"00",X"00",X"00",X"01",X"01",X"01",X"01",X"00",X"00",X"00",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;
