library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity;

architecture v1 of testbench is
	signal clk	: std_logic;
	signal reset: std_logic;

	--data parts 
	signal test_subframe: std_logic;
	signal test_frame: std_logic;
	signal test_block: std_logic;

	--subframe parts
	signal test_preamble: std_logic;
	signal test_shiftclk: std_logic;
	signal test_audio_data: std_logic;
	signal test_start: std_logic;
	signal test_p: std_logic;

	--timing generator output signals
	signal X, Y, Z, SHIFTCLK, LOAD_L, LOAD_R, START, P : std_logic;

	--clk signal period
	constant clk_period : time := 1 ms;

	component spdif_timing_gen is
		port (
        	CLK, RESET:     in  std_logic;
	
        	X, Y, Z:        out std_logic;
        	SHIFTCLK:       out std_logic;
        	LOAD_L, LOAD_R: out std_logic;
        	START:          out std_logic;
        	P:              out std_logic
    	);
    end component;
begin

	--instantiate timing generator
	STG: spdif_timing_gen port map (clk, reset, X, Y, Z, SHIFTCLK, LOAD_L, LOAD_R, START, P);

	--initialize reset sequence
	reset <= '1', '0' after clk_period*2;

	--clk
	process
	begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
	end process;

	--TEST SIGNALS
	--Test signals indicate the time spans, when the timing generator should output a specific kind of signal

	--test_subframe: indicates each generated subframe
	--64: length of a subframe in clocks 
	process
	begin
		test_subframe <= '0';
		wait for clk_period*64;
		test_subframe <= '1';
		wait for clk_period*64;
	end process;

	--test_frame: indicates each generated frame
	process
	begin
		test_frame <= '0';
		wait for clk_period*64*2;
		test_frame <= '1';
		wait for clk_period*64*2;
	end process;

	--test_block: indicates each generated block
	process
	begin
		test_block <= '0';
		wait for clk_period*64*2*192;
		test_block <= '1';
		wait for clk_period*64*2*192;
	end process;

	--The following signals indicate when the appropriate signals inside each test_subframe should be generated

	--test_preamble (X/Y/Z)
	process
	begin
		test_preamble <= '1';
		wait for clk_period*8;
		test_preamble <= '0';
		wait for clk_period*56;
	end process;

	--test_shiftclk (SHIFTCLK)
	process
	begin
		test_shiftclk <= '0';
		wait for clk_period*8;
		test_shiftclk <= '1';
		wait for clk_period*16;
		test_shiftclk <= '0';
		wait for clk_period*40;
	end process;

	--test_audio_data (LOAD_L/LOAD_R)
	process
	begin
		test_audio_data <= '0';
		wait for clk_period*24;
		test_audio_data <= '1';
		wait for clk_period*32;
		test_audio_data <= '0';
		wait for clk_period*8;
	end process;

	--test_start (START)
	process
	begin
		test_start <= '0';
		wait for clk_period*56;
		test_start <= '1';
		wait for clk_period*6;
		test_start <= '0';
		wait for clk_period*2;
	end process;

	--test_p (P)
	process
	begin
		test_p <= '0';
		wait for clk_period*62;
		test_p <= '1';
		wait for clk_period*2;
	end process;

end v1 ;