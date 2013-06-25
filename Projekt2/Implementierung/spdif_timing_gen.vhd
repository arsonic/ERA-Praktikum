library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spdif_timing_gen is
    PORT (
        CLK, RESET:     IN std_logic;

        X, Y, Z:        OUT std_logic;
        SHIFTCLK:       OUT std_logic;
        LOAD_L, LOAD_R: OUT std_logic;
        START:          OUT std_logic;
        P:              OUT std_logic
    );
end spdif_timing_gen;

architecture v1 of spdif_timing_gen is
    
    signal SUBFRAME_CLK_C: unsigned(6 downto 0);
    signal SUBFRAMES_C: unsigned(1 downto 0);
    signal FRAMES_C: unsigned(7 downto 0);

    PROCESS (CLK)
    BEGIN

    if rising_edge(CLK) then

    end if;

    END PROCESS

end v1;
