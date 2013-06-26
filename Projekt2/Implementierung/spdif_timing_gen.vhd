library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spdif_timing_gen is
    port (
        CLK, RESET:     in std_logic;

        X, Y, Z:        out std_logic;
        SHIFTCLK:       out std_logic;
        LOAD_L, LOAD_R: out std_logic;
        START:          out std_logic;
        P:              out std_logic
    );
end spdif_timing_gen;

architecture v1 of spdif_timing_gen is

    signal SUBFRAME_CLK_C: unsigned(6 downto 0);
    signal SUBFRAMES_C: std_logic;
    signal FRAMES_C: unsigned(7 downto 0);

begin



    process (CLK, RESET)
    begin
    if RESET = '1' then 
        X   <= '0';
        Y   <= '0';
        Z   <= '1';
        SHIFTCLK <= '0';
        LOAD_L <= '0';
        LOAD_R <= '0';
        START <= '0';
        P <= '0';
    
        SUBFRAME_CLK_C <= (others => '0');
        SUBFRAMES_C <= '0';
        FRAMES_C <= (others => '0');
    elsif rising_edge(CLK) then
            --increase counters
            if SUBFRAME_CLK_C < 63 then
                SUBFRAME_CLK_C <= SUBFRAME_CLK_C + 1;
            else 
                SUBFRAME_CLK_C <= (others => '0');
            end if;

            --subframes_counter
            if SUBFRAME_CLK_C = 63 then
                SUBFRAMES_C <= not SUBFRAMES_C;

                --frames_counter
                if SUBFRAMES_C = '1' then
                    if FRAMES_C < 191 then
                        FRAMES_C <= FRAMES_C + 1;
                    else
                        FRAMES_C <= (others => '0');
                    end if;
                end if;

            end if;



        X   <= '0';
        Y   <= '0';
        Z   <= '0';
        SHIFTCLK <= '0';
        LOAD_L <= '0';
        LOAD_R <= '0';
        START <= '0';
        P <= '0';
        
        if    SUBFRAME_CLK_C < 7 or SUBFRAME_CLK_C = 63 then
            --preamble:
            --FRAMES_C = 0 and 
            -- FRAMES_C = 0 in the course of 2 SUBFRAMES_C -> we have to set it only for the first one
            if FRAMES_C = 0 and SUBFRAMES_C = '0' then
                Z <= '1';
            elsif SUBFRAMES_C = '0' then
                X <= '1';
            --we have to change the value when SUBFRAMES_C changes (exactly at the moment when SUBFRAME_CLK_C = 63)
            else
                Y <= '1';
            end if;

        elsif SUBFRAME_CLK_C < 23 then
            --audio data shifting:
            SHIFTCLK <= '1';

        elsif SUBFRAME_CLK_C < 55  then
            --audio data
            if SUBFRAMES_C = '0' then
                LOAD_L <= '1';
            else
                LOAD_R <= '1';
            end if;
        
        elsif SUBFRAME_CLK_C < 61 then
            --start
            START <= '1';

        elsif SUBFRAME_CLK_C < 63 then
            --parity
            P <= '1';

        end if;

    end if;
    end process;

    

end v1;
