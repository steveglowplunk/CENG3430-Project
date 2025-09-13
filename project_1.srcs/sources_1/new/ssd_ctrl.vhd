----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2024 02:45:46 PM
-- Design Name: 
-- Module Name: ssd_ctrl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd_ctrl is
  Port (
  clk : in std_logic;
  data_in: in std_logic_vector(7 downto 0);
  sel :buffer std_logic := '0';
  ssd :out std_logic_vector(6 downto 0)
  );
end ssd_ctrl;

architecture Behavioral of ssd_ctrl is


    component clock_divider is
        generic (N : integer);
        port (
        clk : in std_logic;
        clk_out : out std_logic
        );
    end component;

  SIGNAL digit : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL clk100Hz : STD_LOGIC;

begin
  PROCESS (digit) BEGIN
    CASE digit IS
      WHEN "0000" => ssd <= "1111110"; -- 0x0
      WHEN "0001" => ssd <= "0110000"; -- 0x1
      WHEN "0010" => ssd <= "1101101"; -- 0x2
      WHEN "0011" => ssd <= "1111001"; -- 0x3
      WHEN "0100" => ssd <= "0110011"; -- 0x4
      WHEN "0101" => ssd <= "1011011"; -- 0x5
      WHEN "0110" => ssd <= "1011111"; -- 0x6
      WHEN "0111" => ssd <= "1110000"; -- 0x7
      WHEN "1000" => ssd <= "1111111"; -- 0x8
      WHEN "1001" => ssd <= "1111011"; -- 0x9
      WHEN "1010" => ssd <= "1110111"; -- 0xA
      WHEN "1011" => ssd <= "0011111"; -- 0xb (lowercase)
      WHEN "1100" => ssd <= "1001110"; -- 0xC
      WHEN "1101" => ssd <= "0111101"; -- 0xd (lowercase)
      WHEN "1110" => ssd <= "1001111"; -- 0xE
      WHEN "1111" => ssd <= "1000111"; -- 0xF
      WHEN OTHERS => ssd <= "00000000";
    END CASE;
  END PROCESS;
  
  comp_clk100Hz: clock_divider generic map(N => 500000) port map(clk => clk, clk_out => clk100Hz);
  
  process (clk100HZ) begin
    if (rising_edge(clk100Hz)) then
        if (sel = '0') then
            digit <= data_in(7 downto 4);
            sel <= '1';
         elsif (sel = '1') then
            digit <= data_in(3 downto 0);
            sel <= '0';
         else
            digit <= digit;
         end if;
     end if;
    end process;
    
    -- master of ssd
   

end Behavioral;
