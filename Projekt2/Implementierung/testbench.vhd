library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity;

-- ghdl -a spdif_timing_gen.vhd
-- ghdl -a testbench.vhd
-- ghdl -e testbench.vhd
-- ghdl -r testbench --wave=testbench.ghw --stop-time=15sec

architecture v1 of testbench is
	signal clk	: std_logic;
	signal reset: std_logic;

	--	 	    PARTS 
	signal subframe: std_logic;
	signal frame: std_logic;
	signal block_signal: std_logic;

	--		SUBFRAME PARTS 
	signal preamble: std_logic;
	signal shift_clock: std_logic;
	signal audio_data: std_logic;
	signal start_signal: std_logic;
	signal p_bit: std_logic;

	signal X, Y, Z, SHIFTCLK, LOAD_L, LOAD_R, START, P : std_logic;

	constant clk_preiod : time := 1 ms; -- approx 1/(5.6*10^6) - 5.6 MHz

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
	reset <= '1', '0' after clk_preiod/4;

	--clk
	process
	begin
		clk <= '1';
		wait for clk_preiod/2;
		clk <= '0';
		wait for clk_preiod/2;
	end process;

	--subframe
	process
	begin
		subframe <= '0';
		wait for clk_preiod*64;
		subframe <= '1';
		wait for clk_preiod*64;
	end process;

	--frame
	process
	begin
		frame <= '0';
		wait for clk_preiod*64*2;
		frame <= '1';
		wait for clk_preiod*64*2;
	end process;

	--block_signal
	process
	begin
		block_signal <= '0';
		wait for clk_preiod*64*2*192;
		block_signal <= '1';
		wait for clk_preiod*64*2*192;
	end process;

	--preamble
	process
	begin
		preamble <= '1';
		wait for clk_preiod*8;
		preamble <= '0';
		wait for clk_preiod*56;
	end process;

	--shift_clock
	process
	begin
		shift_clock <= '0';
		wait for clk_preiod*8;
		shift_clock <= '1';
		wait for clk_preiod*16;
		shift_clock <= '0';
		wait for clk_preiod*40;
	end process;

	--audio_data
	process
	begin
		audio_data <= '0';
		wait for clk_preiod*24;
		audio_data <= '1';
		wait for clk_preiod*32;
		audio_data <= '0';
		wait for clk_preiod*8;
	end process;

	--p_bit
	process
	begin
		start_signal <= '0';
		wait for clk_preiod*56;
		start_signal <= '1';
		wait for clk_preiod*6;
		start_signal <= '0';
		wait for clk_preiod*2;
	end process;

	--p_bit
	process
	begin
		p_bit <= '0';
		wait for clk_preiod*62;
		p_bit <= '1';
		wait for clk_preiod*2;
	end process;

end v1 ; -- v1