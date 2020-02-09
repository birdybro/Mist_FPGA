library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity cclimber_big_sprite_tile_bit0 is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(10 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of cclimber_big_sprite_tile_bit0 is
	type rom is array(0 to  2047) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"01",X"01",X"07",X"0F",X"7F",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"00",X"01",X"03",X"02",X"06",X"0C",X"08",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"07",X"18",X"10",X"10",X"10",X"10",X"1F",X"1F",X"FF",
		X"03",X"00",X"00",X"00",X"10",X"18",X"1F",X"0F",X"FF",X"18",X"10",X"30",X"20",X"60",X"FF",X"FF",
		X"00",X"00",X"01",X"01",X"01",X"07",X"0F",X"1F",X"00",X"00",X"81",X"FF",X"80",X"E0",X"F0",X"F8",
		X"00",X"00",X"01",X"01",X"01",X"07",X"0F",X"1F",X"00",X"01",X"8F",X"FF",X"80",X"E0",X"F0",X"F8",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"07",X"0F",X"0F",X"00",X"00",X"00",X"00",
		X"00",X"1F",X"3F",X"7F",X"00",X"00",X"00",X"00",X"00",X"E0",X"FF",X"FF",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"3F",X"7F",X"F0",X"F7",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FB",X"7D",X"3F",X"1F",X"0F",X"07",X"03",X"01",
		X"03",X"00",X"7F",X"7F",X"7F",X"60",X"30",X"00",X"E0",X"70",X"FF",X"FF",X"FF",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"01",X"01",X"01",X"00",X"00",X"00",X"03",X"FF",X"FF",X"F0",X"FB",X"7D",X"3E",X"0F",X"E3",
		X"03",X"00",X"FF",X"FF",X"FF",X"C0",X"60",X"00",X"E0",X"70",X"FF",X"FF",X"FF",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"80",X"80",X"80",X"E0",X"F0",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"FF",X"8F",X"08",X"08",X"08",X"08",X"08",X"F8",X"FF",X"FF",X"1F",X"0F",X"07",X"03",X"03",
		X"08",X"08",X"08",X"08",X"08",X"FF",X"FF",X"FF",X"07",X"0F",X"1F",X"3F",X"7F",X"FF",X"FE",X"FC",
		X"FF",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"F0",X"80",X"80",X"C0",X"40",X"41",X"FF",X"FE",
		X"00",X"07",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"F8",X"FC",X"FE",X"00",X"00",X"00",X"00",
		X"00",X"E0",X"F0",X"F0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"80",X"F1",X"FF",X"01",X"07",X"0F",X"1F",X"00",X"00",X"80",X"80",X"80",X"E0",X"F0",X"F8",
		X"00",X"00",X"81",X"FF",X"01",X"07",X"0F",X"1F",X"00",X"00",X"80",X"80",X"80",X"E0",X"F0",X"F8",
		X"00",X"00",X"00",X"00",X"FF",X"FF",X"1F",X"FF",X"00",X"00",X"00",X"00",X"FE",X"FC",X"C0",X"C0",
		X"FC",X"E0",X"E0",X"E0",X"E0",X"F0",X"FC",X"FC",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"7E",X"FF",X"FF",X"FF",X"FF",X"3C",X"0E",X"0F",X"00",X"FE",X"FE",X"BC",X"0C",X"00",X"20",X"E0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"30",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"E0",X"FF",X"7F",X"9F",X"FF",X"FC",X"FC",X"FE",X"00",X"80",X"FE",X"FC",X"C0",X"00",X"00",X"00",
		X"FF",X"FF",X"FF",X"FF",X"3C",X"0E",X"0F",X"00",X"FE",X"FE",X"DC",X"8C",X"00",X"20",X"E0",X"30",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"F0",X"F8",X"FF",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"C0",
		X"FE",X"F8",X"E0",X"C0",X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"06",X"1E",X"FE",
		X"01",X"03",X"02",X"06",X"FC",X"F8",X"00",X"00",X"FE",X"9E",X"06",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"70",X"7C",X"7C",X"7C",X"78",X"E0",X"80",
		X"01",X"03",X"02",X"06",X"FC",X"F8",X"00",X"00",X"80",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"00",X"00",X"00",X"00",X"07",X"0F",X"0F",X"E7",X"37",
		X"7F",X"7F",X"7F",X"60",X"30",X"00",X"00",X"00",X"FF",X"FF",X"F7",X"03",X"01",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"03",X"00",X"7F",X"00",X"00",X"03",X"07",X"07",X"E7",X"77",X"FF",
		X"7F",X"7F",X"60",X"30",X"00",X"00",X"00",X"00",X"FF",X"F7",X"07",X"07",X"0F",X"0F",X"0F",X"0F",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1F",X"17",X"13",X"3B",X"36",X"64",X"40",X"00",
		X"00",X"0E",X"3E",X"3E",X"1E",X"0E",X"07",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",
		X"01",X"03",X"02",X"06",X"FC",X"F8",X"00",X"00",X"80",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"60",X"78",X"7F",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",
		X"7F",X"7B",X"62",X"06",X"FC",X"F8",X"00",X"00",X"80",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",
		X"01",X"07",X"0F",X"1F",X"FE",X"FE",X"0E",X"00",X"80",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",
		X"01",X"03",X"02",X"06",X"FC",X"F8",X"00",X"00",X"80",X"E0",X"70",X"78",X"7C",X"7C",X"70",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"C0",X"F0",X"FC",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7E",
		X"FF",X"FF",X"FF",X"FA",X"FB",X"ED",X"6C",X"34",X"DE",X"F0",X"FC",X"80",X"10",X"F0",X"18",X"00",
		X"18",X"18",X"08",X"08",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"80",X"E0",X"F8",X"FE",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"FE",X"FE",
		X"FF",X"FF",X"EE",X"F7",X"FB",X"DC",X"EE",X"EE",X"DC",X"8C",X"00",X"10",X"F0",X"18",X"00",X"00",
		X"E6",X"74",X"70",X"60",X"40",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"03",X"07",X"0F",X"1F",X"1F",X"07",X"3F",X"FF",X"FF",X"FF",X"CF",X"87",X"03",
		X"3F",X"3F",X"7E",X"7E",X"7E",X"FE",X"FF",X"F9",X"03",X"07",X"3F",X"3F",X"7F",X"FF",X"FF",X"FF",
		X"F9",X"F9",X"F9",X"78",X"7C",X"7C",X"3E",X"3E",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"7F",X"7F",
		X"1F",X"1F",X"0F",X"07",X"03",X"00",X"00",X"00",X"3F",X"9F",X"EF",X"FF",X"FF",X"FF",X"3F",X"07",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"03",X"01",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"3F",X"7F",X"FF",X"FD",X"FA",X"F5",X"FA",X"F5",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FA",X"F5",X"FA",X"FD",X"FF",X"7F",X"3F",X"15",
		X"00",X"1F",X"3F",X"7D",X"7A",X"7D",X"7A",X"7D",X"0A",X"E7",X"F3",X"FF",X"FB",X"7F",X"FB",X"7F",
		X"7A",X"7D",X"7A",X"7D",X"7A",X"7D",X"3F",X"1F",X"AB",X"7F",X"FB",X"7F",X"FB",X"FF",X"FB",X"F7",
		X"0A",X"05",X"02",X"01",X"00",X"00",X"00",X"00",X"AA",X"55",X"AA",X"55",X"00",X"00",X"00",X"00",
		X"F3",X"F3",X"15",X"2A",X"F5",X"FB",X"FD",X"FF",X"CF",X"CF",X"55",X"AA",X"F5",X"BB",X"D7",X"BE",
		X"7F",X"6F",X"77",X"6B",X"D5",X"EA",X"3C",X"3C",X"F7",X"BE",X"F7",X"BB",X"55",X"AA",X"F3",X"F3",
		X"F3",X"F3",X"00",X"0A",X"D5",X"CA",X"D5",X"CA",X"CF",X"CF",X"00",X"AA",X"55",X"AB",X"57",X"AB",
		X"15",X"0A",X"D5",X"CA",X"D5",X"CA",X"15",X"0A",X"57",X"AB",X"55",X"AA",X"55",X"AF",X"5D",X"BA",
		X"D5",X"CA",X"D5",X"CA",X"15",X"00",X"F3",X"F3",X"7D",X"BA",X"5D",X"AF",X"55",X"00",X"CF",X"CF",
		X"E0",X"FC",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"C0",X"E0",X"F0",X"F8",X"F8",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FC",X"FC",X"FE",X"FE",X"FE",X"FF",X"FF",X"FF",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FE",X"FE",X"FE",X"FC",X"FC",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FC",X"E0",X"F8",X"F8",X"F0",X"E0",X"C0",X"00",X"00",X"00",
		X"C0",X"C0",X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"C7",X"E7",X"F7",X"F7",X"FF",X"F7",X"FF",X"57",X"FC",X"FE",X"BF",X"DF",X"AF",X"DF",X"BF",X"FF",
		X"FF",X"F7",X"FF",X"F7",X"FF",X"F7",X"EF",X"55",X"FE",X"FD",X"BE",X"DF",X"BF",X"DF",X"AF",X"55",
		X"AA",X"D5",X"EA",X"D5",X"EA",X"D5",X"EA",X"D5",X"AA",X"F7",X"FF",X"F7",X"FF",X"F7",X"FF",X"F7",
		X"EA",X"D5",X"EA",X"D5",X"EA",X"D5",X"FE",X"FF",X"FF",X"F7",X"FF",X"F7",X"FF",X"F7",X"FF",X"F7",
		X"AA",X"55",X"AA",X"55",X"00",X"00",X"00",X"00",X"AA",X"55",X"AA",X"55",X"00",X"00",X"00",X"00",
		X"3C",X"3C",X"55",X"AA",X"5D",X"EE",X"FD",X"AF",X"F3",X"F3",X"55",X"AA",X"5F",X"BB",X"57",X"BB",
		X"5F",X"AE",X"FD",X"EE",X"55",X"AA",X"CF",X"CF",X"DF",X"FB",X"DF",X"FB",X"55",X"AA",X"3C",X"3C",
		X"3C",X"3C",X"00",X"AA",X"F7",X"FB",X"DF",X"AB",X"F3",X"F3",X"00",X"AA",X"F5",X"BB",X"57",X"BB",
		X"5F",X"FB",X"F7",X"AA",X"55",X"BB",X"F5",X"BB",X"F7",X"FB",X"7F",X"AA",X"55",X"BB",X"FF",X"BF",
		X"75",X"BB",X"F5",X"BF",X"55",X"00",X"3C",X"3C",X"FF",X"BF",X"F5",X"BB",X"55",X"00",X"F3",X"F3",
		X"00",X"00",X"94",X"D1",X"B5",X"94",X"00",X"00",X"00",X"00",X"A2",X"20",X"3A",X"AA",X"00",X"00",
		X"94",X"D1",X"B5",X"94",X"08",X"08",X"08",X"0E",X"A2",X"20",X"3A",X"AA",X"4B",X"A2",X"C9",X"6B",
		X"14",X"D1",X"B5",X"94",X"56",X"54",X"52",X"76",X"A2",X"20",X"3A",X"AA",X"42",X"A4",X"E4",X"A2",
		X"94",X"D1",X"B5",X"94",X"A8",X"AA",X"AC",X"EA",X"A2",X"20",X"3A",X"AA",X"25",X"25",X"25",X"B5",
		X"0F",X"17",X"2F",X"DE",X"AE",X"DE",X"FC",X"DC",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FC",X"F8",X"F8",X"F0",X"F0",X"F0",X"F0",X"50",X"AA",X"54",X"A8",X"50",X"00",X"00",X"00",X"00",
		X"07",X"07",X"87",X"4F",X"AF",X"5F",X"BF",X"5F",X"F0",X"F1",X"F2",X"FD",X"FA",X"7D",X"FE",X"7D",
		X"BE",X"7F",X"BF",X"7F",X"FE",X"7D",X"FA",X"55",X"BE",X"7F",X"FE",X"FF",X"BF",X"5F",X"AF",X"55",
		X"AA",X"F5",X"EA",X"F5",X"FB",X"F5",X"FB",X"FF",X"AA",X"FD",X"FF",X"FD",X"FF",X"FD",X"FF",X"FD",
		X"FB",X"FF",X"BF",X"FF",X"BF",X"DF",X"BF",X"DF",X"FF",X"FD",X"BF",X"FD",X"BF",X"7D",X"BF",X"7D",
		X"AA",X"55",X"AA",X"55",X"00",X"00",X"00",X"00",X"AA",X"55",X"AA",X"55",X"00",X"00",X"00",X"00",
		X"CF",X"CF",X"55",X"AA",X"55",X"AA",X"57",X"EE",X"3C",X"3C",X"55",X"AA",X"57",X"AE",X"7F",X"EF",
		X"F7",X"BE",X"F7",X"EB",X"55",X"AA",X"3C",X"3C",X"77",X"EE",X"F7",X"EB",X"55",X"AA",X"F3",X"F3",
		X"CF",X"CF",X"00",X"AA",X"F7",X"BA",X"5D",X"BA",X"3C",X"3C",X"00",X"AA",X"F7",X"BE",X"77",X"EB",
		X"FD",X"BB",X"5F",X"AA",X"55",X"BE",X"F7",X"BB",X"D5",X"AB",X"F5",X"AA",X"55",X"FF",X"75",X"EB",
		X"FF",X"BB",X"F7",X"BE",X"55",X"00",X"CF",X"CF",X"7D",X"EB",X"75",X"FF",X"55",X"00",X"3C",X"3C",
		X"00",X"00",X"81",X"97",X"D5",X"DD",X"00",X"00",X"00",X"00",X"30",X"A5",X"15",X"B7",X"00",X"00",
		X"81",X"97",X"D5",X"DD",X"05",X"56",X"54",X"74",X"30",X"A5",X"15",X"B7",X"20",X"50",X"60",X"30",
		X"01",X"97",X"D5",X"DD",X"42",X"A2",X"A2",X"4B",X"30",X"A5",X"15",X"B7",X"EC",X"4A",X"4A",X"4C",
		X"81",X"97",X"D5",X"DD",X"57",X"D2",X"D2",X"52",X"30",X"A5",X"15",X"B7",X"76",X"65",X"65",X"76",
		X"A0",X"FF",X"EF",X"5F",X"AF",X"5F",X"AF",X"5F",X"00",X"F8",X"FC",X"7E",X"BE",X"5E",X"BE",X"7E",
		X"EF",X"5F",X"AF",X"5F",X"AF",X"5F",X"EF",X"FF",X"FC",X"F8",X"F8",X"7C",X"BC",X"7E",X"BE",X"5E",
		X"FF",X"7F",X"FF",X"57",X"AF",X"5F",X"AF",X"5F",X"FF",X"FF",X"EF",X"FF",X"EF",X"D7",X"AF",X"D7",
		X"BF",X"7F",X"BE",X"7F",X"FF",X"7F",X"FF",X"55",X"AB",X"57",X"AB",X"55",X"EA",X"F5",X"EA",X"55",
		X"AA",X"FF",X"FF",X"F7",X"EB",X"F7",X"EB",X"F7",X"AA",X"5F",X"BF",X"DF",X"FE",X"DF",X"FE",X"DF",
		X"FF",X"F7",X"EB",X"F7",X"EB",X"F7",X"FF",X"FF",X"BF",X"DF",X"FE",X"DF",X"FE",X"DF",X"BF",X"5F",
		X"AA",X"55",X"AA",X"55",X"00",X"00",X"00",X"00",X"AA",X"55",X"AA",X"55",X"00",X"00",X"00",X"00",
		X"F3",X"F3",X"55",X"AA",X"55",X"BE",X"F7",X"BA",X"CF",X"CF",X"54",X"A8",X"57",X"AB",X"77",X"EF",
		X"5F",X"AB",X"F7",X"BE",X"55",X"AA",X"CF",X"CF",X"76",X"EE",X"7E",X"BE",X"57",X"AB",X"3C",X"3C",
		X"F3",X"F3",X"00",X"AA",X"75",X"EA",X"55",X"EA",X"CF",X"CF",X"00",X"A8",X"53",X"AB",X"53",X"AB",
		X"55",X"AA",X"D5",X"AA",X"55",X"FA",X"DD",X"AA",X"50",X"A8",X"53",X"AB",X"53",X"AB",X"50",X"A8",
		X"DD",X"FA",X"FD",X"BE",X"55",X"00",X"F3",X"F3",X"53",X"AB",X"53",X"AB",X"50",X"00",X"CF",X"CF");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;