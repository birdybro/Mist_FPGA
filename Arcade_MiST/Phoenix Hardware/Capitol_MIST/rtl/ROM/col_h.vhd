library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity col_h is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(6 downto 0);
	data : out std_logic_vector(3 downto 0)
);
end entity;

architecture prom of col_h is
	type rom is array(0 to  127) of std_logic_vector(3 downto 0);
	signal rom_data: rom := (	
		"0000","0000","0000","0000","0000","0000","0000","0000","0010","0110","0101","0011","0101","0110","0110","0110",
		"0001","0011","0011","0110","0010","0011","0011","0011","0111","0101","0101","0011","0111","0101","0101","0101",
		"0000","0000","0000","0000","0000","0000","0000","0000","0110","0001","0001","0011","0011","0011","0001","0100",
		"0110","0101","0101","0111","0111","0111","0111","0011","0110","0111","0111","0101","0101","0101","0011","0111",
		"0000","0000","0000","0000","0000","0000","0000","0000","0010","0010","0101","0011","0011","0011","0011","0011",
		"0001","0011","0011","0110","0110","0110","0110","0110","0101","0101","0101","0011","0101","0101","0101","0101",
		"0000","0000","0000","0000","0000","0000","0000","0000","0110","0001","0001","0100","0100","0100","0011","0100",
		"0110","0101","0101","0101","0101","0101","0111","0011","0101","0111","0111","0111","0111","0111","0101","0111");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;