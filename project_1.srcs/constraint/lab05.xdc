set_property PACKAGE_PIN Y21 [get_ports {blue[0]}]; # "VGA-B0"
set_property PACKAGE_PIN Y20 [get_ports {blue[1]}]; # "VGA-B1"
set_property PACKAGE_PIN AB20 [get_ports {blue[2]}]; # "VGA-B2"
set_property PACKAGE_PIN AB19 [get_ports {blue[3]}]; # "VGA-B3"
set_property PACKAGE_PIN AB22 [get_ports {green[0]}]; # "VGA-G0"
set_property PACKAGE_PIN AA22 [get_ports {green[1]}]; # "VGA-G1"
set_property PACKAGE_PIN AB21 [get_ports {green[2]}]; # "VGA-G2"
set_property PACKAGE_PIN AA21 [get_ports {green[3]}]; # "VGA-G3"
set_property PACKAGE_PIN V20 [get_ports {red[0]}]; # "VGA-R0"
set_property PACKAGE_PIN U20 [get_ports {red[1]}]; # "VGA-R1"
set_property PACKAGE_PIN V19 [get_ports {red[2]}]; # "VGA-R2"
set_property PACKAGE_PIN V18 [get_ports {red[3]}]; # "VGA-R3"
set_property PACKAGE_PIN AA19 [get_ports {hsync}]; # "VGA-HS"
set_property PACKAGE_PIN Y19 [get_ports {vsync}]; # 
# All VGA pins are connected by bank 33, so specified 3.3V together.
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];
set_property PACKAGE_PIN Y9 [get_ports {clk}]; 
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];

set_property PACKAGE_PIN T18 [get_ports BTN_up]; #BTNU
set_property PACKAGE_PIN R16 [get_ports BTN_down]; #BTND
set_property PACKAGE_PIN N15 [get_ports BTN_left]; #BTNL
set_property PACKAGE_PIN R18 [get_ports BTN_right]; #BTNR
set_property PACKAGE_PIN P16 [get_ports BTN_center]; #BTNC
#set_property PACKAGE_PIN D13 [get_ports BTN_PB1]; #PB1
#set_property PACKAGE_PIN C10 [get_ports BTN_PB2]; #PB2

#set_property IOSTANDARD LVCMOS25 [get_ports BTN_up];
#set_property IOSTANDARD LVCMOS25 [get_ports BTN_down];
#set_property IOSTANDARD LVCMOS25 [get_ports BTN_left];
#set_property IOSTANDARD LVCMOS25 [get_ports BTN_right];
#set_property IOSTANDARD LVCMOS25 [get_ports BTN_center];
#set_property IOSTANDARD LVCMOS25 [get_ports BTN_PB1];
#set_property IOSTANDARD LVCMOS25 [get_ports BTN_PB2];

# ----------------------------------------------------------------------------

# JC Pmod - Bank 13

# ----------------------------------------------------------------------------

set_property PACKAGE_PIN AB6 [get_ports {mosi}];  # "JC1_N"

set_property PACKAGE_PIN AB7 [get_ports {cs_n}];  # "JC1_P"

set_property PACKAGE_PIN AA4 [get_ports {sclk}];  # "JC2_N"

set_property PACKAGE_PIN Y4  [get_ports {miso}];  # "JC2_P"

set_property IOSTANDARD LVCMOS33 [get_ports cs_n];

set_property IOSTANDARD LVCMOS33 [get_ports miso];

set_property IOSTANDARD LVCMOS33 [get_ports mosi];

set_property IOSTANDARD LVCMOS33 [get_ports sclk];

# ----------------------------------------------------------------------------

# JA, JB Pmod - Bank 13

# ----------------------------------------------------------------------------
set_property PACKAGE_PIN V10 [get_ports {ssd[0]}];
set_property PACKAGE_PIN W11 [get_ports {ssd[1]}];
set_property PACKAGE_PIN W12 [get_ports {ssd[2]}];
set_property PACKAGE_PIN AA9 [get_ports {ssd[3]}];
set_property PACKAGE_PIN Y10 [get_ports {ssd[4]}];
set_property PACKAGE_PIN AA11 [get_ports {ssd[5]}];
set_property PACKAGE_PIN Y11 [get_ports {ssd[6]}];
set_property IOSTANDARD LVCMOS33 [get_ports ssd];

# Digit Select
set_property PACKAGE_PIN W8 [get_ports {sel}];
set_property IOSTANDARD LVCMOS33 [get_ports sel];

##RGB LED
set_property PACKAGE_PIN R6 [get_ports R_LED];
set_property PACKAGE_PIN T6 [get_ports B_LED];
set_property PACKAGE_PIN T4 [get_ports G_LED];
set_property IOSTANDARD LVCMOS33 [get_ports R_LED];
set_property IOSTANDARD LVCMOS33 [get_ports G_LED];
set_property IOSTANDARD LVCMOS33 [get_ports B_LED];

#wire
set_property PACKAGE_PIN V7 [get_ports {wire[0]}]; # r
set_property PACKAGE_PIN W7 [get_ports {wire[1]}]; # g
set_property PACKAGE_PIN V5 [get_ports {wire[2]}]; # b
set_property PACKAGE_PIN V4 [get_ports {wire[3]}]; # yellow
set_property IOSTANDARD LVCMOS33 [get_ports wire];
set_property PACKAGE_PIN U14 [get_ports test_LED];
set_property IOSTANDARD LVCMOS33 [get_ports test_LED];

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T22 [get_ports {LD[0]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {LD[1]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {LD[2]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {LD[3]}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {LD[4]}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {LD[5]}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {LD[6]}];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"

## ----------------------------------------------------------------------------
## User DIP Switches - Bank 35
## ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN F22 [get_ports {SW[0]}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {SW[1]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {SW[2]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {SW[3]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {SW[4]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {SW[5]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {SW[6]}];  # "SW6"
#set_property PACKAGE_PIN M15 [get_ports {SW7}];  # "SW7"

# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
#
# Note that these IOSTANDARD constraints are applied to all IOs currently
# assigned within an I/O bank.  If these IOSTANDARD constraints are 
# evaluated prior to other PACKAGE_PIN constraints being applied, then 
# the IOSTANDARD specified will likely not be applied properly to those 
# pins.  Therefore, bank wide IOSTANDARD constraints should be placed 
# within the XDC file in a location that is evaluated AFTER all 
# PACKAGE_PIN constraints within the target bank have been evaluated.
#
# Un-comment one or more of the following IOSTANDARD constraints according to
# the bank pin assignments that are required within a design.
# ---------------------------------------------------------------------------- 

# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];