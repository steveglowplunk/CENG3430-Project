
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.utilities.all;
use work.knob_top_dial_bg_pkg.all;

use work.knob_up_arrow_pkg.all;
use work.knob_down_arrow_pkg.all;
use work.knob_left_arrow_pkg.all;
use work.knob_right_arrow_pkg.all;

use work.knob_bottom_1_pkg.all;
use work.knob_bottom_2_pkg.all;
use work.knob_bottom_3_pkg.all;
use work.knob_bottom_4_pkg.all;

use work.knob_frozen_pkg.all;

use work.correct_pkg.all;
use work.wrong_pkg.all;

use work.click_pkg.all;

use work.keypad_pkg.all;
use work.keypad_at_pkg.all;
use work.keypad_balloon_pkg.all;
use work.keypad_hookn_pkg.all;
use work.keypad_leftc_pkg.all;
use work.keypad_squidknife_pkg.all;
use work.keypad_squigglyn_pkg.all;
use work.keypad_upsidedowny_pkg.all;

use work.defused_pkg.all;
use work.boom_pkg.all;

use work.wires_bg_pkg.all;
use work.wires_blue_pkg.all;
use work.wires_green_pkg.all;
use work.wires_red_pkg.all;
use work.wires_yellow_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_driver is
 Port ( 
     clk : in std_logic;                                
     hsync, vsync : out std_logic;                      
     red, green, blue : out std_logic_vector(3 downto 0);
     BTN_up : IN STD_LOGIC;
     BTN_down : IN STD_LOGIC;
     BTN_left: IN STD_LOGIC;
     BTN_right : IN STD_LOGIC;
     BTN_center: IN STD_LOGIC;
    --  BTN_PB1: IN STD_LOGIC;
    --  BTN_PB2: IN STD_LOGIC
    SW : IN STD_LOGIC_VECTOR(6 downto 0);
    LD : OUT STD_LOGIC_VECTOR(6 downto 0);
    miso            : IN    STD_LOGIC;                     --SPI master in, slave out
    mosi            : OUT    STD_LOGIC;                     --SPI master out, slave in
    sclk            : BUFFER STD_LOGIC;                     --SPI clock
    cs_n            : out    STD_LOGIC ;                   --pmod chip select
    
    sel :buffer std_logic := '0';
    ssd :out std_logic_vector(6 downto 0);
    
    R_LED: out std_logic;
    G_LED: out std_logic ;
    B_LED: out std_logic ;
    
    wire: in std_logic_vector(3 downto 0);
    test_wire: in std_logic;
    test_LED: out std_logic
 );
end vga_driver;

architecture Behavioral of vga_driver is
    signal clk50MHz : std_logic;
    signal clk10Hz : std_logic;
    signal hcount, vcount : integer := 0;
    constant H_TOTAL:integer:=1344-1;
    constant H_SYNC:integer:=48-1;
    constant H_BACK:integer:=240-1;
    constant H_START:integer:=48+240-1;
    constant H_ACTIVE:integer:=1024-1;
    constant H_END:integer:=1344-32-1;
    constant H_FRONT:integer:=32-1;
    constant V_TOTAL:integer:=625-1;
    constant V_SYNC:integer:=3-1;
    constant V_BACK:integer:=12-1;
    constant V_START:integer:=3+12-1;
    constant V_ACTIVE:integer:=600-1;
    constant V_END:integer:=625-10-1;
    constant V_FRONT:integer:=10-1;
    
    
    
--    signal knob_bottom_1_img : IMG_ARRAY := knob_bottom_1;
--    signal knob_bottom_2_img : IMG_ARRAY := knob_bottom_2;
--    signal knob_bottom_3_img : IMG_ARRAY := knob_bottom_3;
--    signal knob_bottom_4_img : IMG_ARRAY := knob_bottom_4;


    -- global section
    signal selected_scene : integer := 0;
    signal selected_indicator_img : IMG_ARRAY := wrong_img;
    signal x_position_buf : std_logic_vector(7 downto 0);
    signal y_position_buf : std_logic_vector(7 downto 0);
    signal all_completed : boolean := false;
    -- end global section
    
    -- knob section
    signal knob_top_dial_bg_img : IMG_ARRAY := knob_top_dial_bg;
    
    signal knob_up_arrow_img : IMG_ARRAY := knob_up_arrow;
    signal knob_down_arrow_img : IMG_ARRAY := knob_down_arrow;
    signal knob_left_arrow_img : IMG_ARRAY := knob_left_arrow;
    signal knob_right_arrow_img : IMG_ARRAY := knob_right_arrow;
    
    signal knob_selected_arrow_img : IMG_ARRAY := knob_up_arrow_img; 
    signal knob_selected_bottom_img : IMG_ARRAY;
    
    signal knob_arrow_sel : integer := 0;
    
    signal knob_rand_num : integer range 0 to 3 := 0;

    signal knob_completed : boolean := false;
    
    signal x_position      :   STD_LOGIC_VECTOR(7 DOWNTO 0);  --joystick x-axis position
    signal y_position      :   STD_LOGIC_VECTOR(7 DOWNTO 0);  --joystick y-axis position
    signal trigger_button  :   STD_LOGIC;                     --trigger button status
    signal center_button   :   STD_LOGIC;
    
    signal refresh_screen : std_logic := '0';
    -- end knob section

    -- timer section
    signal data_in : std_logic_vector(7 downto 0) := "10011001";
    signal clk1Hz : std_logic;
    signal global_countdown : integer := 99;
    -- end timer section
    
    --keypad section
    
    --end keypad section
    
    -- RGB section
    signal led_state : integer := 3; -- default off
    -- end RGB section
    
     --wire section
    signal test_wire_on: std_logic := '1';
    signal wire_hz_counter: integer := 0;
    signal wire_completed: boolean := false;
    signal wire_rand_num : integer range 0 to 5 := 0;

    type wire_rgb_sqeuence_array is array (0 to 5, 0 to 2)of bit_vector(0 to 2);
    signal wire_rgb_sqeuence : wire_rgb_sqeuence_array := (
        ("011", "001", "110"),  -- ryb
        ("110", "011", "001"),  -- bry
        ("001", "110", "011"),  -- ybr
        ("011", "110", "001"),  -- rby
        ("110", "001", "011"),  -- byr
        ("001", "011", "100")   -- yrb
    );
     -- end wire section
     
    -- keypad section
    constant LENGTH : integer := 128;
    signal H_TOP_LEFT : integer := (H_START + H_END)/2 - LENGTH*2 - LENGTH/2 - 10;
    signal V_TOP_LEFT : integer := (V_START + V_END)/2 - LENGTH/2;
    signal H_TOP_LEFT2 : integer := (H_START + H_END)/2 - LENGTH;
    signal V_TOP_LEFT2 : integer := (V_START + V_END)/2 - LENGTH/2;
    signal H_TOP_LEFT3 : integer := (H_START + H_END)/2 + LENGTH/2;
    signal V_TOP_LEFT3 : integer := (V_START + V_END)/2 - LENGTH/2;
    signal H_TOP_LEFT4 : integer := (H_START + H_END)/2 + LENGTH*2 + 10;
    signal V_TOP_LEFT4 : integer := (V_START + V_END)/2 - LENGTH/2;

    type symbol_selected_array is array (0 to 3) of boolean;
    signal symbol_selected : symbol_selected_array := (false, false, false, false);

    -- signal keyboard_1st_img : IMG_ARRAY_KEYPAD := keypad_leftc_img;
    -- signal keyboard_2nd_img : IMG_ARRAY_KEYPAD := keypad_squidknife_img;
    -- signal keyboard_3rd_img : IMG_ARRAY_KEYPAD := keypad_squigglyn_img;
    -- signal keyboard_4th_img : IMG_ARRAY_KEYPAD := keypad_upsidedowny_img;

    type keyboard_all_img is array (0 to 6) of IMG_ARRAY_KEYPAD;
    constant keyboard_all_img_arr : keyboard_all_img := (
        keypad_at_img,
        keypad_balloon_img,
        keypad_hookn_img,
        keypad_leftc_img,
        keypad_squidknife_img,
        keypad_squigglyn_img,
        keypad_upsidedowny_img
    );

    type keyboard_display_type is array (0 to 3) of IMG_ARRAY_KEYPAD;
    signal keyboard_display_img : keyboard_display_type := (
        keypad_at_img,
        keypad_balloon_img,
        keypad_hookn_img,
        keypad_leftc_img
    );

    signal keyboard_rand_num : integer range 0 to 34 := 0;

    type keyboard_combination_type is array (0 to 34) of bit_vector(0 to 6);
    constant keyboard_combination : keyboard_combination_type := (
        "1111000",
        "1110100",
        "1110010",
        "1110001",
        "1101100",
        "1101010",
        "1101001",
        "1100110",
        "1100101",
        "1100011",
        "1011100",
        "1011010",
        "1011001",
        "1010110",
        "1010101",
        "1010011",
        "1001110",
        "1001101",
        "1001011",
        "1000111",
        "0111100",
        "0111010",
        "0111001",
        "0110110",
        "0110101",
        "0110011",
        "0101110",
        "0101101",
        "0101011",
        "0100111",
        "0011110",
        "0011101",
        "0011011",
        "0010111",
        "0001111"
    );

    signal keyboard_output_light_mode : integer := 0;

    signal keyboard_completed : boolean := false;
    -- end keypad section

    component clock_divider is
        generic (N : integer);
        port (
        clk : in std_logic;
        clk_out : out std_logic
        );
    end component;

    component pmod_joystick is 
        GENERIC(
            clk_freq        : INTEGER := 50); --system clock frequency in MHz
        PORT(
            clk             : IN     STD_LOGIC;                     --system clock
            reset_n         : IN     STD_LOGIC;                     --active low reset
            miso            : IN     STD_LOGIC;                     --SPI master in, slave out
            mosi            : OUT    STD_LOGIC;                     --SPI master out, slave in
            sclk            : BUFFER STD_LOGIC;                     --SPI clock
            cs_n            : out    STD_LOGIC;                     --pmod chip select
            x_position      : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0);  --joystick x-axis position
            y_position      : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0);  --joystick y-axis position
            trigger_button  : OUT    STD_LOGIC;                     --trigger button status
            center_button   : OUT    STD_LOGIC);  
    end component;
    
  component  pmod_keypad IS
      GENERIC(
        clk_freq    : INTEGER := 50_000_000;  --system clock frequency in Hz
        stable_time : INTEGER := 10);         --time pressed key must remain stable in ms
      PORT(
        clk     :  IN     STD_LOGIC;                           --system clock
        reset_n :  IN     STD_LOGIC;                           --asynchornous active-low reset
        rows    :  IN     STD_LOGIC_VECTOR(1 TO 4);            --row connections to keypad
        columns :  BUFFER STD_LOGIC_VECTOR(1 TO 4) := "1111";  --column connections to keypad
        keys    :  OUT    STD_LOGIC_VECTOR(0 TO 15));          --resultant key presses
   end component;
    
     component ssd_ctrl
    Port (
      clk : in std_logic;
      data_in: in std_logic_vector(7 downto 0);
      sel :buffer std_logic := '0';
      ssd :out std_logic_vector(6 downto 0)
    );
    end component;

begin
comp_clk50MHz : clock_divider generic map(N => 1) port map(clk => clk, clk_out => clk50MHz);
comp_clk10Hz : clock_divider generic map(N => 5000000) port map(clk => clk, clk_out => clk10Hz); 

x_position_buf <= x_position;
y_position_buf <= y_position;

mushroom :  pmod_joystick 
    generic map(clk_freq => 100) 
    port map(
        clk => clk,
        reset_n => '1',
        miso => miso,
        mosi => mosi,
        sclk => sclk,
        cs_n => cs_n,
        x_position => x_position,
        y_position => y_position,
        trigger_button => trigger_button,
        center_button => center_button
    );

hcount_proc: process(clk50MHz)
begin
if( rising_edge(clk50MHz) )
then
    if(hcount = H_TOTAL) then
     hcount <= 0;
    else
     hcount <= hcount + 1;
    end if;
end if;
end process hcount_proc;

vcount_proc: process(clk50MHz)
begin
if (rising_edge(clk50MHz)) then
	if (hcount = H_TOTAL) then
		if (vcount = V_TOTAL) then
			vcount <= 0;
		else
			vcount <= vcount + 1;
		end if;
	end if;
end if;
end process vcount_proc;

hsync_gen_proc : process (hcount) begin
	if (hcount < H_SYNC) then
		hsync <= '0';
	else
		hsync <= '1';
	end if;
end process hsync_gen_proc;

vsync_gen_proc : process (vcount)
begin
	if (vcount < V_SYNC) then
		vsync <= '0';
	else
		vsync <= '1';
	end if;
end process vsync_gen_proc;

rand_num_and_scene_sel: process (clk10Hz)
    variable rand_val : integer;
    variable rand_val2 : integer;
    variable rand_val3 : integer;
    variable i : integer;
begin
    if (rising_edge(clk10Hz)) then
        if (trigger_button = '1' and refresh_screen = '0') then
            refresh_screen <= '1';
        elsif (trigger_button = '1' and refresh_screen = '1') then
            refresh_screen <= '0';
        end if;

        if (BTN_center = '1' and selected_scene = 0) then
            -- initialize random number
            rand_val := vcount mod 4;
            knob_rand_num <= rand_val;
            rand_val2 := vcount mod 35;
            keyboard_rand_num <= rand_val2;
            rand_val3 := vcount mod 6;
            wire_rand_num <= rand_val3;

            -- Map keyboard_combination(rand_val2) onto keyboard_display_img, from 0 to 3
            -- to select random symobols for keypad scene
            i := 0;
            for j in 0 to 6 loop
                if keyboard_combination(rand_val2)(j) = '1' then
                    keyboard_display_img(i) <= keyboard_all_img_arr(j);
                    i := i + 1;
                end if;
            end loop;
            
            case (rand_val) is
                when 0 => knob_selected_bottom_img <= knob_bottom_1;
                when 1 => knob_selected_bottom_img <= knob_bottom_2;
                when 2 => knob_selected_bottom_img <= knob_bottom_3;
                when 3 => knob_selected_bottom_img <= knob_bottom_4;
                when others => knob_selected_bottom_img <= knob_bottom_1;
            end case;
            
            selected_scene <= 1;
        elsif (BTN_up = '1' and selected_scene - 1 >= 0) then
            selected_scene <= selected_scene - 1;
        elsif (BTN_down = '1' and selected_scene + 1 <= 3) then
            selected_scene <= selected_scene + 1;
        end if;

        if (all_completed = true) then
            selected_scene <= 4;
        end if;

        if (all_completed = false and global_countdown = 0) then
            selected_scene <= 5;
        end if;
    end if;
end process;

data_output_proc : process (hcount, vcount)
variable vcount_shifted : integer;
variable hcount_shifted : integer;
variable vcount_shifted2 : integer;
variable hcount_shifted2 : integer;
variable vcount_shifted3 : integer;
variable hcount_shifted3 : integer;
variable vcount_shifted4 : integer;
variable hcount_shifted4 : integer;
variable vcount_shifted5 : integer;
variable hcount_shifted5 : integer;
begin
	if ((hcount >= H_START and hcount < H_END) and
	 (vcount >= V_START and vcount < V_END)) then
		-- Display Area (draw the square here)
--		if ((hcount >= H_TOP_LEFT and hcount < H_TOP_LEFT + LENGTH) and (vcount >= V_TOP_LEFT and vcount < V_TOP_LEFT + LENGTH)) then
--            red <= "1111";
--            green <= "0000";
--            blue <= "1111";
--        if (ROM(vcount+7)(hcount+720) = '0') then
        vcount_shifted := vcount - 15;
        hcount_shifted := hcount + 620;
        vcount_shifted2 := vcount_shifted;
        hcount_shifted2 := hcount_shifted;
        
        -- click to continue scene
        if (selected_scene = 0) then
            if (
                (click_bg(vcount_shifted)(hcount_shifted) = '0')
            ) then
                red <= "0000";
                green <= "0000";
                blue <= "0000";
            else
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;
        
        -- knob scene
        if (selected_scene = 1) then
            if (
                (knob_selected_bottom_img(vcount_shifted)(hcount_shifted) = '0') or
                (knob_top_dial_bg_img(vcount_shifted)(hcount_shifted) = '0') or 
                (knob_selected_arrow_img(vcount_shifted)(hcount_shifted) = '0') or
                (selected_indicator_img(vcount_shifted)(hcount_shifted) = '0') or
                (refresh_screen = '1' and knob_frozen_img(vcount_shifted)(hcount_shifted) = '0')
            ) then
                if (knob_completed = true and selected_indicator_img(vcount_shifted)(hcount_shifted) = '0') then
                    -- Display selected_indicator_img as green
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                elsif (knob_completed = false and selected_indicator_img(vcount_shifted)(hcount_shifted) = '0') then
                    -- Display selected_indicator_img as red
                    red <= "1111";
                    green <= "0000";
                    blue <= "0000";
                else
                    red <= "0000";
                    green <= "0000";
                    blue <= "0000";
                end if;
            else
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;
        
        -- keypad scene
        if (selected_scene = 2) then
            hcount_shifted := hcount - H_TOP_LEFT;
            vcount_shifted := vcount - V_TOP_LEFT;
            hcount_shifted2 := hcount - H_TOP_LEFT2;
            vcount_shifted2 := vcount - V_TOP_LEFT2;
            hcount_shifted3 := hcount - H_TOP_LEFT3;
            vcount_shifted3 := vcount - V_TOP_LEFT3;
            hcount_shifted4 := hcount - H_TOP_LEFT4;
            vcount_shifted4 := vcount - V_TOP_LEFT4;

            vcount_shifted5 := vcount - 15;
            hcount_shifted5 := hcount + 620;
            if (
                (hcount_shifted >= 0 and hcount_shifted < keyboard_display_img(0)'length and
                vcount_shifted >= 0 and vcount_shifted < keyboard_display_img(0)(hcount_shifted)'length and
                (keyboard_display_img(0)(vcount_shifted)(hcount_shifted) = '0')) or
                (hcount_shifted2 >= 0 and hcount_shifted2 < keyboard_display_img(1)'length and
                vcount_shifted2 >= 0 and vcount_shifted2 < keyboard_display_img(1)(hcount_shifted2)'length and
                (keyboard_display_img(1)(vcount_shifted2)(hcount_shifted2) = '0')) or
                (hcount_shifted3 >= 0 and hcount_shifted3 < keyboard_display_img(2)'length and
                vcount_shifted3 >= 0 and vcount_shifted3 < keyboard_display_img(2)(hcount_shifted3)'length and
                (keyboard_display_img(2)(vcount_shifted3)(hcount_shifted3) = '0')) or
                (hcount_shifted4 >= 0 and hcount_shifted4 < keyboard_display_img(3)'length and
                vcount_shifted4 >= 0 and vcount_shifted4 < keyboard_display_img(3)(hcount_shifted4)'length and
                (keyboard_display_img(3)(vcount_shifted4)(hcount_shifted4) = '0')) or
                (selected_indicator_img(vcount_shifted5)(hcount_shifted5) = '0')
            ) then
                if (keyboard_completed = true and selected_indicator_img(vcount_shifted5)(hcount_shifted5) = '0') then
                    -- Display selected_indicator_img as green
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                elsif (keyboard_completed = false and selected_indicator_img(vcount_shifted5)(hcount_shifted5) = '0') then
                    -- Display selected_indicator_img as red
                    red <= "1111";
                    green <= "0000";
                    blue <= "0000";
                elsif (symbol_selected(0) = true and keyboard_display_img(0)(vcount_shifted)(hcount_shifted) = '0') then
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                elsif (symbol_selected(1) = true and keyboard_display_img(1)(vcount_shifted2)(hcount_shifted2) = '0') then
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                elsif (symbol_selected(2) = true and keyboard_display_img(2)(vcount_shifted3)(hcount_shifted3) = '0') then
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                elsif (symbol_selected(3) = true and keyboard_display_img(3)(vcount_shifted4)(hcount_shifted4) = '0') then
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                else
                    red <= "0000";
                    green <= "0000";
                    blue <= "0000";
                end if;
            else
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;

        -- wire scene
        if (selected_scene = 3) then
            if (
                (wires_bg_img(vcount_shifted)(hcount_shifted) = '0') or
                (wires_blue_img(vcount_shifted)(hcount_shifted) = '0') or
                (wires_green_img(vcount_shifted)(hcount_shifted) = '0') or
                (wires_red_img(vcount_shifted)(hcount_shifted) = '0') or
                (wires_yellow_img(vcount_shifted)(hcount_shifted) = '0') or 
                (selected_indicator_img(vcount_shifted)(hcount_shifted) = '0')
            ) then
                if (wire_completed = true and selected_indicator_img(vcount_shifted)(hcount_shifted) = '0') then
                    -- Display selected_indicator_img as green
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                elsif (wire_completed = false and selected_indicator_img(vcount_shifted)(hcount_shifted) = '0') then
                    -- Display selected_indicator_img as red
                    red <= "1111";
                    green <= "0000";
                    blue <= "0000";
                elsif (wires_blue_img(vcount_shifted)(hcount_shifted) = '0') then
                    if (wire(2) = '0') then
                        red <= "0000";
                        green <= "0000";
                        blue <= "1111";
                    else
                        red <= "0000";
                        green <= "0000";
                        blue <= "0000";
                    end if;
                elsif (wires_green_img(vcount_shifted)(hcount_shifted) = '0') then
                    if (wire(1) = '0') then
                        red <= "0000";
                        green <= "1111";
                        blue <= "0000";
                    else
                        red <= "0000";
                        green <= "0000";
                        blue <= "0000";
                    end if;
                elsif (wires_red_img(vcount_shifted)(hcount_shifted) = '0') then
                    if (wire(0) = '0') then
                        red <= "1111";
                        green <= "0000";
                        blue <= "0000";
                    else
                        red <= "0000";
                        green <= "0000";
                        blue <= "0000";
                    end if;
                elsif (wires_yellow_img(vcount_shifted)(hcount_shifted) = '0') then
                    if (wire(3) = '0') then
                        red <= "1111";
                        green <= "1111";
                        blue <= "0000";
                    else
                        red <= "0000";
                        green <= "0000";
                        blue <= "0000";
                    end if;
                else
                    red <= "0000";
                    green <= "0000";
                    blue <= "0000";
                end if;
            else
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;
        
        -- defused scene
        if (selected_scene = 4) then
            if (
                (defused_img(vcount_shifted)(hcount_shifted) = '0')
            ) then
                red <= "0000";
                green <= "0000";
                blue <= "0000";
            else
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;

        -- boom scene
        if (selected_scene = 5) then
            if (
                (boom_img(vcount_shifted)(hcount_shifted) = '0')
            ) then
                red <= "0000";
                green <= "0000";
                blue <= "0000";
            else
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;
	else
		-- Blanking Area
		red <= "0000";
		green <= "0000";
		blue <= "0000";
	end if;
end process data_output_proc;

knob_choose_arrow_img: PROCESS (knob_arrow_sel)
BEGIN
    case (knob_arrow_sel) is
        when 0 => knob_selected_arrow_img <= knob_up_arrow_img;
        when 1 => knob_selected_arrow_img <= knob_right_arrow_img;
        when 2 => knob_selected_arrow_img <= knob_down_arrow_img;
        when 3 => knob_selected_arrow_img <= knob_left_arrow_img;
        when others => knob_selected_arrow_img <= knob_up_arrow_img;
    end case;
END PROCESS;

knob_movement: process(x_position_buf, y_position_buf)
    variable x_pos_int : integer;
    variable y_pos_int : integer;
begin
    -- Convert x_position and y_position to signed integer
    x_pos_int := to_integer(unsigned(x_position_buf));
    y_pos_int := to_integer(unsigned(y_position_buf));
   
    -- if refresh_screen is 0, then allow update the knob_arrow_sel
    -- else (refresh_screen is 1), freeze screen to allow easier knob button press
    if (refresh_screen = '0') then

    -- Determine the direction of the knob
         if (x_pos_int <= 200 and (y_pos_int <=200 and  y_pos_int >=100 ) ) then
                knob_arrow_sel <= 0;
        elsif( x_pos_int > 200  and (y_pos_int <=200 and  y_pos_int >=100 ))then
                knob_arrow_sel <= 2;
        elsif( y_pos_int <100 ) then
                knob_arrow_sel <= 1;
        elsif( y_pos_int >200)then
                knob_arrow_sel <= 3; --left
        end if;
    end if;
  
end process knob_movement;

knob_confirm: process(clk10Hz)
begin
    if (center_button = '1' and selected_scene = 1) then
        if (knob_arrow_sel = knob_rand_num) then
            knob_completed <= true;
            -- selected_indicator_img <= correct_img;
        else
            knob_completed <= false;
            -- selected_indicator_img <= wrong_img;
        end if;
    end if;
end process knob_confirm;

check_completed: all_completed <= knob_completed and keyboard_completed and wire_completed;
-- selected_scene <= 3 when all_completed = true else selected_scene;
-- selected_scene <= 4 when (all_completed = false and global_countdown = 0) else selected_scene;

set_completed_indicator: process (selected_scene, knob_completed, keyboard_completed, wire_completed)
begin
    if (selected_scene = 1) then
        if (knob_completed = true) then
            selected_indicator_img <= correct_img;
        else
            selected_indicator_img <= wrong_img;
        end if;
    end if;
    if (selected_scene = 2) then
        if (keyboard_completed = true) then
            selected_indicator_img <= correct_img;
        else
            selected_indicator_img <= wrong_img;
        end if;
    end if;
    if (selected_scene = 3) then
        if (wire_completed = true) then
            selected_indicator_img <= correct_img;
        else
            selected_indicator_img <= wrong_img;
        end if;
    end if;
end process;

ssd_control: ssd_ctrl port map( clk => clk, data_in => data_in , sel => sel, ssd => ssd); 

comp_clk1Hz : clock_divider generic map(N => 50000000) port map(clk => clk, clk_out => clk1Hz);


ssd_input: process(clk1Hz)
 variable count_down : integer  := 99;
begin
    if (rising_edge(clk1Hz)) then
        if (all_completed /= true) then
            if(count_down /= 0) then
                count_down := count_down -1;
                global_countdown <= count_down;
            end if;
            data_in(7 downto 4) <= std_logic_vector(TO_UNSIGNED( count_down/10 , 4));
            data_in(3 downto 0) <= std_logic_vector(TO_UNSIGNED(count_down mod 10, 4));
        end if;
    end if;
end process;

--rgb_confirm: process(clk10Hz)
--begin
--   if(rising_edge(clk10Hz))then
--    if(BTN_center = '1') then
--        led_state<=0;
--    end if;
--   end if;
--end process;

rgb_sequence: process(clk10Hz)
    -- variable hz_counter: integer := 0;
begin
    if (rising_edge(clk10Hz) and selected_scene = 3) then
        if (BTN_center = '1') then
            led_state <= 0;
        end if;
     
        if (wire_hz_counter = 9) then
            if ( led_state = 0 ) then
                R_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 0)(0));
                G_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 0)(1));
                B_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 0)(2));
                led_state <= 1;
            elsif ( led_state = 1 ) then
                R_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 1)(0));
                G_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 1)(1));
                B_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 1)(2));
                led_state <= 2;
            elsif ( led_state = 2 ) then
                R_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 2)(0));
                G_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 2)(1));
                B_LED <= to_stdulogic(wire_rgb_sqeuence(wire_rand_num, 2)(2));
                led_state <= 3;  -- to off
            else
                -- turn off light
                R_LED <= '1';
                G_LED <='1';
                B_LED <='1';
            end if;
            wire_hz_counter <= 0;
        else
            wire_hz_counter <= wire_hz_counter + 1;
        end if;
    end if;
end process;

-- keypad_debug_light_output: PROCESS (clk1Hz)
-- BEGIN
--     if (rising_edge(clk1Hz)) then
--         if (keyboard_output_light_mode = 0) then
--             LD <= to_stdlogicvector(keyboard_combination(keyboard_rand_num));
--             keyboard_output_light_mode <= 1;
--         elsif (keyboard_output_light_mode = 1) then
--             LD <= SW;
--             keyboard_output_light_mode <= 0;
--         end if;
--     end if;
-- END PROCESS;

--wire_debug_light_output: LD(3 downto 0) <= not wire;
output_switch_to_led: LD <= SW;

keypad_switch_control: process(SW)
begin
    if (SW = to_stdlogicvector(keyboard_combination(keyboard_rand_num))) then
        -- symbol_selected(0) <= true;
        -- symbol_selected(1) <= true;
        -- symbol_selected(2) <= true;
        -- symbol_selected(3) <= true;
        symbol_selected <= (true, true, true, true);
        keyboard_completed <= true;
    end if;
end process;

wire_check_completed: process (wire)
begin
    -- wires: 1 is open, 0 is closed circuit
    if (wire = "0100" and wire_rand_num = 0) then -- ryb
        wire_completed <= true;
    elsif (wire = "1010" and wire_rand_num = 1) then -- bry
        wire_completed <= true;
    elsif (wire = "1101" and wire_rand_num = 2) then -- ybr
        wire_completed <= true;
    elsif (wire = "0001" and wire_rand_num = 3) then -- rby
        wire_completed <= true;
    elsif (wire = "0011" and wire_rand_num = 4) then -- byr
        wire_completed <= true;
    elsif (wire = "1001" and wire_rand_num = 5) then -- yrb
        wire_completed <= true;
    else
        wire_completed <= false;
    end if;
end process;

-- LD <= to_stdlogicvector(keyboard_combination(keyboard_rand_num));


end Behavioral;
