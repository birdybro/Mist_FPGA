library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity TRIPLEDRAWPOKER_1H is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(10 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of TRIPLEDRAWPOKER_1H is
	type rom is array(0 to  2047) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FE",X"FC",X"F8",X"F0",X"E0",X"C0",X"80",X"00",
		X"00",X"80",X"C0",X"E0",X"F0",X"F8",X"FC",X"FE",X"0F",X"07",X"03",X"03",X"03",X"07",X"0F",X"1F",
		X"1F",X"0F",X"07",X"03",X"03",X"03",X"07",X"0F",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"9F",X"8F",X"87",X"83",X"91",X"98",
		X"FF",X"FF",X"9F",X"8F",X"87",X"83",X"81",X"80",X"FF",X"FF",X"E3",X"E1",X"E0",X"F0",X"F8",X"F8",
		X"80",X"88",X"8C",X"8E",X"8F",X"8F",X"8F",X"FF",X"78",X"38",X"18",X"00",X"00",X"81",X"C3",X"FF",
		X"FF",X"FF",X"9F",X"8F",X"87",X"83",X"81",X"80",X"FF",X"FF",X"E3",X"E1",X"E0",X"F0",X"F8",X"F8",
		X"80",X"88",X"8C",X"8E",X"8F",X"8F",X"8F",X"FF",X"78",X"38",X"18",X"00",X"00",X"81",X"C3",X"FF",
		X"FF",X"FF",X"E7",X"C7",X"87",X"8F",X"8F",X"8E",X"FF",X"FF",X"F3",X"F1",X"F0",X"F8",X"F8",X"38",
		X"C0",X"9F",X"1F",X"01",X"01",X"01",X"1F",X"1F",X"03",X"F9",X"F8",X"80",X"80",X"80",X"F8",X"F8",
		X"FF",X"FF",X"E7",X"C7",X"87",X"8F",X"8F",X"8E",X"FF",X"FF",X"F3",X"F1",X"F0",X"F8",X"F8",X"38",
		X"00",X"1F",X"1F",X"19",X"19",X"19",X"18",X"18",X"00",X"F8",X"F8",X"98",X"98",X"98",X"18",X"18",
		X"FF",X"F1",X"F0",X"F0",X"F0",X"F0",X"F1",X"F1",X"FF",X"FF",X"FF",X"7F",X"3F",X"1F",X"0F",X"87",
		X"91",X"91",X"80",X"80",X"80",X"91",X"91",X"FF",X"C3",X"E1",X"00",X"00",X"00",X"FF",X"FF",X"FF",
		X"FF",X"F1",X"F0",X"F0",X"F0",X"F0",X"F1",X"F1",X"FF",X"FF",X"FF",X"7F",X"3F",X"1F",X"0F",X"87",
		X"91",X"91",X"80",X"80",X"80",X"91",X"91",X"FF",X"C3",X"E1",X"00",X"00",X"00",X"FF",X"FF",X"FF",
		X"FF",X"FF",X"E7",X"C6",X"86",X"86",X"8E",X"8E",X"FF",X"FF",X"00",X"00",X"00",X"38",X"38",X"38",
		X"00",X"1F",X"1F",X"18",X"18",X"18",X"18",X"00",X"38",X"38",X"38",X"38",X"38",X"78",X"FF",X"FF",
		X"FF",X"FF",X"E7",X"C6",X"86",X"86",X"8E",X"8E",X"FF",X"FF",X"00",X"00",X"00",X"38",X"38",X"38",
		X"00",X"F8",X"F8",X"00",X"00",X"00",X"00",X"00",X"38",X"38",X"38",X"38",X"38",X"78",X"FF",X"FF",
		X"FF",X"FF",X"E0",X"C0",X"80",X"84",X"8E",X"8E",X"FF",X"FF",X"03",X"01",X"00",X"10",X"38",X"38",
		X"F8",X"F8",X"18",X"18",X"38",X"F0",X"E1",X"03",X"38",X"38",X"38",X"38",X"30",X"71",X"F3",X"FF",
		X"FF",X"FF",X"E0",X"C0",X"80",X"84",X"8E",X"8E",X"FF",X"FF",X"03",X"01",X"00",X"10",X"38",X"38",
		X"1F",X"1F",X"18",X"18",X"1C",X"0F",X"87",X"C0",X"38",X"38",X"38",X"38",X"30",X"71",X"F3",X"FF",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"9F",X"87",X"81",X"FF",X"FF",X"E0",X"E0",X"E0",X"F8",X"F8",X"F8",
		X"80",X"E0",X"F8",X"FE",X"FF",X"FF",X"FF",X"FF",X"78",X"18",X"00",X"00",X"80",X"E0",X"FF",X"FF",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"9F",X"87",X"81",X"FF",X"FF",X"E0",X"E0",X"E0",X"F8",X"F8",X"F8",
		X"80",X"E0",X"F8",X"FE",X"FF",X"FF",X"FF",X"FF",X"78",X"18",X"00",X"00",X"80",X"E0",X"FF",X"FF",
		X"FF",X"FF",X"E1",X"C0",X"80",X"84",X"8E",X"8E",X"FF",X"FF",X"C3",X"01",X"00",X"10",X"38",X"38",
		X"8E",X"8E",X"8E",X"84",X"80",X"C0",X"E1",X"FF",X"38",X"38",X"38",X"10",X"00",X"01",X"C3",X"FF",
		X"FF",X"FF",X"E1",X"C0",X"80",X"84",X"8E",X"8E",X"FF",X"FF",X"C3",X"01",X"00",X"10",X"38",X"38",
		X"8E",X"8E",X"8E",X"84",X"80",X"C0",X"E1",X"FF",X"38",X"38",X"38",X"10",X"00",X"01",X"C3",X"FF",
		X"FF",X"FF",X"E7",X"C7",X"86",X"8E",X"8E",X"8E",X"FF",X"FF",X"83",X"01",X"00",X"10",X"38",X"38",
		X"8E",X"8E",X"8E",X"87",X"80",X"C0",X"E0",X"FF",X"38",X"38",X"38",X"10",X"00",X"01",X"03",X"FF",
		X"FF",X"FF",X"E7",X"C7",X"86",X"8E",X"8E",X"8E",X"FF",X"FF",X"83",X"01",X"00",X"10",X"38",X"38",
		X"8E",X"8E",X"8E",X"87",X"80",X"C0",X"E0",X"FF",X"38",X"38",X"38",X"10",X"00",X"01",X"03",X"FF",
		X"FF",X"C0",X"C0",X"C0",X"FF",X"FF",X"E0",X"C0",X"FF",X"00",X"00",X"00",X"FF",X"FF",X"01",X"00",
		X"C0",X"C7",X"C7",X"C7",X"C0",X"C0",X"E0",X"FF",X"00",X"F8",X"F8",X"F8",X"00",X"00",X"01",X"FF",
		X"FF",X"C0",X"C0",X"C0",X"FF",X"FF",X"E0",X"C0",X"FF",X"00",X"00",X"00",X"FF",X"FF",X"01",X"00",
		X"C0",X"C7",X"C7",X"C7",X"C0",X"C0",X"E0",X"FF",X"00",X"F8",X"F8",X"F8",X"00",X"00",X"01",X"FF",
		X"FF",X"F3",X"E3",X"C3",X"C7",X"C7",X"C7",X"C7",X"FF",X"FF",X"FF",X"F8",X"F8",X"F8",X"F8",X"F8",
		X"C3",X"C0",X"E0",X"F0",X"FF",X"FF",X"FF",X"FF",X"F8",X"00",X"00",X"00",X"F8",X"F8",X"FF",X"FF",
		X"FF",X"F3",X"E3",X"C3",X"C7",X"C7",X"C7",X"C7",X"FF",X"FF",X"FF",X"F8",X"F8",X"F8",X"F8",X"F8",
		X"C3",X"C0",X"E0",X"F0",X"FF",X"FF",X"FF",X"FF",X"F8",X"00",X"00",X"00",X"F8",X"F8",X"FF",X"FF",
		X"FF",X"FF",X"C0",X"80",X"80",X"87",X"8F",X"8F",X"FF",X"FF",X"01",X"00",X"00",X"F0",X"F8",X"18",
		X"8E",X"84",X"80",X"80",X"C0",X"E1",X"C3",X"C7",X"18",X"30",X"00",X"00",X"01",X"FF",X"FF",X"FF",
		X"FF",X"FF",X"C0",X"80",X"80",X"87",X"8F",X"8F",X"FF",X"FF",X"01",X"00",X"00",X"F0",X"F8",X"18",
		X"8E",X"84",X"80",X"80",X"C0",X"E1",X"C3",X"C7",X"18",X"30",X"00",X"00",X"01",X"FF",X"FF",X"FF",
		X"FF",X"9F",X"80",X"80",X"80",X"9C",X"FE",X"FC",X"FF",X"FC",X"00",X"00",X"00",X"3C",X"1F",X"0F",
		X"F8",X"90",X"81",X"83",X"87",X"8F",X"9F",X"FF",X"04",X"C0",X"E0",X"F0",X"F8",X"FC",X"FF",X"FF",
		X"FF",X"9F",X"80",X"80",X"80",X"9C",X"FE",X"FC",X"FF",X"FC",X"00",X"00",X"00",X"3C",X"1F",X"0F",
		X"F8",X"90",X"81",X"83",X"87",X"8F",X"9F",X"FF",X"04",X"C0",X"E0",X"F0",X"F8",X"FC",X"FF",X"FF",
		X"9F",X"83",X"80",X"80",X"98",X"F8",X"F9",X"F9",X"FF",X"FF",X"FF",X"3F",X"0F",X"03",X"C0",X"E0",
		X"F9",X"F9",X"F8",X"98",X"80",X"80",X"83",X"9F",X"E0",X"C0",X"03",X"0F",X"3F",X"FF",X"FF",X"FF",
		X"9F",X"83",X"80",X"80",X"98",X"F8",X"F9",X"F9",X"FF",X"FF",X"FF",X"3F",X"0F",X"03",X"C0",X"E0",
		X"F9",X"F9",X"F8",X"98",X"80",X"80",X"83",X"9F",X"E0",X"C0",X"03",X"0F",X"3F",X"FF",X"FF",X"FF",
		X"F0",X"E0",X"C0",X"C0",X"C0",X"60",X"38",X"00",X"FF",X"7F",X"3F",X"1F",X"0F",X"07",X"03",X"01",
		X"00",X"38",X"60",X"C0",X"C0",X"C0",X"E0",X"F0",X"01",X"03",X"07",X"0F",X"1F",X"3F",X"7F",X"FF",
		X"F8",X"F0",X"E0",X"E0",X"60",X"30",X"38",X"00",X"FF",X"7F",X"3F",X"3F",X"4F",X"87",X"03",X"01",
		X"00",X"38",X"30",X"60",X"E0",X"E0",X"F0",X"F8",X"01",X"03",X"87",X"4F",X"3F",X"3F",X"7F",X"FF",
		X"FE",X"FC",X"F8",X"F0",X"E0",X"C0",X"80",X"00",X"FF",X"7F",X"3F",X"1F",X"0F",X"07",X"03",X"01",
		X"00",X"80",X"C0",X"E0",X"F0",X"F8",X"FC",X"FE",X"01",X"03",X"07",X"0F",X"1F",X"3F",X"7F",X"FF",
		X"67",X"BD",X"DB",X"66",X"66",X"DB",X"BD",X"66",X"66",X"BD",X"DB",X"66",X"66",X"DB",X"BD",X"67",
		X"E6",X"BD",X"DB",X"66",X"66",X"DB",X"BD",X"66",X"66",X"BD",X"DB",X"66",X"66",X"DB",X"BD",X"E6",
		X"66",X"BD",X"DB",X"66",X"66",X"DB",X"BD",X"66",X"66",X"BD",X"DB",X"66",X"00",X"7E",X"7A",X"7A",
		X"42",X"7A",X"5A",X"7E",X"7E",X"4E",X"66",X"6A",X"6A",X"66",X"4E",X"7E",X"5E",X"7E",X"7E",X"42",
		X"7E",X"5E",X"7E",X"00",X"66",X"DB",X"BD",X"66",X"FF",X"E0",X"E0",X"FE",X"FE",X"FE",X"E0",X"E0",
		X"FF",X"07",X"07",X"7F",X"7F",X"7F",X"07",X"07",X"FF",X"F0",X"E0",X"E7",X"E7",X"E7",X"E0",X"F0",
		X"FF",X"0F",X"07",X"E7",X"E7",X"E7",X"07",X"0F",X"FF",X"E0",X"E0",X"E7",X"E7",X"E7",X"E7",X"FF",
		X"FF",X"07",X"07",X"FF",X"FF",X"FF",X"FF",X"FF",X"E0",X"E0",X"E7",X"E7",X"E3",X"F0",X"F8",X"FF",
		X"07",X"07",X"E7",X"E7",X"C7",X"0F",X"1F",X"FF",X"FF",X"F0",X"E0",X"E7",X"E7",X"E7",X"E3",X"F3",
		X"FF",X"0F",X"07",X"E7",X"E7",X"E7",X"C7",X"CF",X"FF",X"E0",X"E0",X"FE",X"FE",X"FE",X"E0",X"E0",
		X"FF",X"0F",X"07",X"67",X"67",X"67",X"07",X"0F",X"FF",X"E0",X"E0",X"FF",X"FC",X"F8",X"E0",X"E0",
		X"FF",X"07",X"07",X"1F",X"3F",X"FF",X"07",X"07",X"FF",X"F0",X"E0",X"E7",X"E7",X"E7",X"E3",X"F3",
		X"FF",X"0F",X"07",X"E7",X"E7",X"E7",X"C7",X"CF",X"FF",X"E0",X"E0",X"E6",X"E6",X"E6",X"E7",X"E7",
		X"FF",X"07",X"07",X"67",X"67",X"67",X"E7",X"E7",X"FF",X"E0",X"E0",X"E7",X"E7",X"E7",X"E7",X"FF",
		X"FF",X"07",X"07",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"E3",X"E3",X"E6",X"E6",X"E6",X"E0",X"F0",
		X"FF",X"0F",X"07",X"67",X"67",X"67",X"C7",X"CF",X"FF",X"FF",X"FF",X"E0",X"E0",X"FF",X"FF",X"FF",
		X"FF",X"E7",X"E7",X"07",X"07",X"E7",X"E7",X"FF",X"E0",X"E0",X"FE",X"FE",X"FE",X"E0",X"E0",X"FF",
		X"0F",X"07",X"67",X"67",X"67",X"07",X"0F",X"FF",X"E0",X"E0",X"FF",X"FC",X"F8",X"E0",X"E0",X"FF",
		X"07",X"07",X"1F",X"3F",X"FF",X"07",X"07",X"FF",X"FF",X"E0",X"E0",X"E7",X"E7",X"E3",X"F0",X"F8",
		X"FF",X"07",X"07",X"E7",X"E7",X"C7",X"0F",X"1F",X"FF",X"E0",X"E0",X"E6",X"E6",X"E6",X"E0",X"F1",
		X"FF",X"07",X"07",X"67",X"67",X"67",X"07",X"8F",X"FF",X"FF",X"FF",X"E0",X"E0",X"FF",X"FF",X"FF",
		X"FF",X"E7",X"E7",X"07",X"07",X"E7",X"E7",X"FF",X"FF",X"E0",X"E0",X"E7",X"E7",X"E7",X"E7",X"E7",
		X"FF",X"07",X"07",X"FF",X"FF",X"FF",X"FF",X"FF",X"F0",X"E0",X"E7",X"E7",X"E7",X"E3",X"F3",X"FF",
		X"0F",X"07",X"E7",X"E7",X"E7",X"C7",X"CF",X"FF",X"FF",X"FF",X"F0",X"E0",X"E7",X"E7",X"E7",X"E4",
		X"FF",X"FF",X"0F",X"07",X"E7",X"E7",X"E7",X"E7",X"E0",X"F0",X"FF",X"E0",X"E0",X"FE",X"FE",X"FE",
		X"C7",X"CF",X"FF",X"0F",X"07",X"67",X"67",X"67",X"E0",X"E0",X"FF",X"E0",X"E0",X"FF",X"FF",X"FE",
		X"07",X"0F",X"FF",X"07",X"07",X"8F",X"1F",X"3F",X"FF",X"FF",X"E0",X"E0",X"FF",X"E0",X"E0",X"E6",
		X"1F",X"8F",X"07",X"07",X"FF",X"07",X"07",X"67",X"E6",X"E6",X"E0",X"F1",X"FF",X"E0",X"E0",X"E7",
		X"67",X"67",X"07",X"8F",X"FF",X"07",X"07",X"FF",X"E7",X"E7",X"E7",X"FF",X"E0",X"E0",X"E6",X"E6",
		X"FF",X"FF",X"FF",X"FF",X"07",X"07",X"67",X"67",X"E6",X"E7",X"E7",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"67",X"E7",X"E7",X"FF",X"FF",X"FF",X"FF",X"FF",X"E0",X"E0",X"FC",X"F9",X"F1",X"E3",X"E7",X"FF",
		X"07",X"07",X"3F",X"1F",X"8F",X"C7",X"E7",X"FF",X"E0",X"E0",X"FC",X"F8",X"F0",X"E2",X"E7",X"FF",
		X"07",X"07",X"E7",X"E7",X"E7",X"07",X"0F",X"FF",X"FF",X"E0",X"E0",X"E6",X"E6",X"E6",X"E7",X"E7",
		X"FF",X"07",X"07",X"67",X"67",X"67",X"E7",X"E7",X"FF",X"E0",X"E0",X"E7",X"E7",X"E3",X"F0",X"F8",
		X"FF",X"07",X"07",X"E7",X"E7",X"C7",X"0F",X"1F",X"FF",X"C3",X"99",X"BD",X"BD",X"BD",X"99",X"C3",
		X"FF",X"FF",X"FF",X"BB",X"81",X"BF",X"FF",X"FF",X"FF",X"9B",X"89",X"AD",X"AD",X"AD",X"A1",X"B3",
		X"FF",X"DD",X"9D",X"B5",X"B5",X"B5",X"81",X"C9",X"FF",X"CF",X"C7",X"D3",X"D9",X"DD",X"81",X"DF",
		X"FF",X"D1",X"95",X"B5",X"B5",X"B5",X"85",X"CF",X"FF",X"C3",X"91",X"B5",X"B5",X"B5",X"85",X"CF",
		X"FF",X"FD",X"BD",X"9D",X"CD",X"E5",X"F1",X"F9",X"FF",X"CB",X"81",X"B5",X"B5",X"B5",X"81",X"CB",
		X"FF",X"F3",X"A1",X"AD",X"AD",X"AD",X"89",X"C3",X"FF",X"87",X"D3",X"D9",X"DD",X"D9",X"D3",X"87",
		X"FF",X"81",X"B5",X"B5",X"B5",X"B5",X"81",X"CB",X"FF",X"C3",X"99",X"BD",X"BD",X"BD",X"99",X"DB",
		X"FF",X"81",X"BD",X"BD",X"BD",X"BD",X"99",X"C3",X"FF",X"81",X"B5",X"B5",X"B5",X"B5",X"BD",X"BD",
		X"FF",X"81",X"F5",X"F5",X"F5",X"F5",X"FD",X"FD",X"FF",X"C3",X"99",X"BD",X"BD",X"AD",X"A9",X"8B",
		X"FF",X"81",X"F7",X"F7",X"F7",X"F7",X"F7",X"81",X"FF",X"FF",X"FF",X"BD",X"81",X"BD",X"FF",X"FF",
		X"FF",X"CF",X"9F",X"BF",X"BF",X"BF",X"9F",X"C1",X"FF",X"81",X"9F",X"CF",X"E7",X"D3",X"99",X"BD",
		X"FF",X"81",X"BF",X"BF",X"BF",X"BF",X"BF",X"BF",X"FF",X"81",X"F3",X"E7",X"CF",X"E7",X"F3",X"81",
		X"FF",X"81",X"F9",X"F3",X"E7",X"CF",X"9F",X"81",X"FF",X"C3",X"99",X"BD",X"BD",X"BD",X"99",X"C3",
		X"FF",X"81",X"ED",X"ED",X"ED",X"ED",X"E1",X"F3",X"FF",X"C3",X"99",X"BD",X"AD",X"CD",X"99",X"A3",
		X"FF",X"81",X"ED",X"ED",X"ED",X"8D",X"A1",X"B3",X"FF",X"DB",X"91",X"B5",X"A5",X"AD",X"89",X"DB",
		X"FF",X"FD",X"FD",X"FD",X"81",X"FD",X"FD",X"FD",X"FF",X"C1",X"9F",X"BF",X"BF",X"BF",X"9F",X"C1",
		X"FF",X"F1",X"C7",X"9F",X"BF",X"9F",X"C7",X"F1",X"FF",X"C1",X"9F",X"CF",X"E7",X"CF",X"9F",X"C1",
		X"FF",X"BD",X"99",X"CB",X"E7",X"D3",X"99",X"BD",X"FF",X"F9",X"F3",X"E7",X"8F",X"E7",X"F3",X"F9",
		X"FF",X"BD",X"9D",X"8D",X"A5",X"B1",X"B9",X"BD",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C3",X"BD",X"7E",X"7E",X"7E",X"7E",X"BD",X"C3",
		X"C0",X"9F",X"1F",X"19",X"19",X"19",X"1F",X"0E",X"03",X"F9",X"F8",X"98",X"98",X"98",X"F8",X"70",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"1F",X"1F",X"19",X"19",X"19",X"18",X"18",
		X"00",X"F8",X"F8",X"98",X"98",X"98",X"18",X"18",X"00",X"00",X"00",X"1F",X"1F",X"00",X"80",X"C0",
		X"00",X"18",X"18",X"F8",X"F8",X"18",X"19",X"03",X"C0",X"9F",X"1F",X"18",X"18",X"1C",X"0F",X"07",
		X"03",X"F9",X"F8",X"18",X"18",X"38",X"F0",X"E0",X"00",X"1F",X"1F",X"01",X"01",X"01",X"1F",X"1F",
		X"00",X"F0",X"F8",X"98",X"98",X"98",X"F8",X"F0",X"00",X"1F",X"1F",X"18",X"18",X"18",X"98",X"C0",
		X"00",X"F8",X"F8",X"00",X"00",X"00",X"01",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;
