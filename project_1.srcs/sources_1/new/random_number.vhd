library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity random_number is
    generic (MAX_VALUE : integer);
end entity random_number;

architecture behavioral of random_number is
    signal lfsr : std_logic_vector(MAX_VALUE downto 0);
    signal random_num : integer range 0 to MAX_VALUE;
begin
    process
    begin
        lfsr <= not lfsr(MAX_VALUE) & lfsr(MAX_VALUE downto 1);
        random_num <= to_integer(unsigned(lfsr(MAX_VALUE downto 0)));
        wait for 1 ns;
    end process;
end architecture behavioral;