
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package utilities is
  TYPE IMG_ARRAY IS ARRAY (0 to 599) OF bit_vector(0 to 839);
  TYPE IMG_ARRAY_KEYPAD IS ARRAY (0 to 127) OF bit_vector(0 to 127);
end package;
