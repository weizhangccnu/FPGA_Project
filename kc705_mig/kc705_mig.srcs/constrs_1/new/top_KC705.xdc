# KC705 configuration
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

# 200MHz onboard diff clock
create_clock -period 5.000 -name system_clock [get_ports SYS_CLK_P]

#-------------------------------------------------------------< System Clock Interface
# PadFunction: IO_L12P_T1_MRCC_33
set_property IOSTANDARD DIFF_SSTL15 [get_ports SYS_CLK_P]
set_property PACKAGE_PIN AD12 [get_ports SYS_CLK_P]
# PadFunction: IO_L12N_T1_MRCC_33
set_property IOSTANDARD DIFF_SSTL15 [get_ports SYS_CLK_N]
set_property PACKAGE_PIN AD11 [get_ports SYS_CLK_N]
#-------------------------------------------------------------> System Clock Interface
#-------------------------------------------------------------< SGMII clcok for GTP/GTH/GTX
#set_property IOSTANDARD LVCMOS25 [get_ports SGMIICLK_Q0_P]
set_property PACKAGE_PIN G8 [get_ports SGMIICLK_Q0_P]
#set_property IOSTANDARD LVCMOS25 [get_ports SGMIICLK_Q0_N]
set_property PACKAGE_PIN G7 [get_ports SGMIICLK_Q0_N]
#-------------------------------------------------------------> SGMII clcok
#-------------------------------------------------------------< System reset Interface
# Bank: 33 - GPIO_SW_7 (CPU_RESET)
set_property VCCAUX_IO DONTCARE [get_ports SYS_RST]
set_property SLEW SLOW [get_ports SYS_RST]
set_property IOSTANDARD LVCMOS15 [get_ports SYS_RST]
set_property LOC AB7 [get_ports SYS_RST]
#-------------------------------------------------------------> System reset Interface
#-------------------------------------------------------------< LED Interface
# Bank: 33 - GPIO_LED_0_LS
set_property DRIVE 12 [get_ports {LED8Bit[0]}]
set_property SLEW SLOW [get_ports {LED8Bit[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED8Bit[0]}]
set_property LOC AB8 [get_ports {LED8Bit[0]}]

# Bank: 33 - GPIO_LED_1_LS
set_property DRIVE 12 [get_ports {LED8Bit[1]}]
set_property SLEW SLOW [get_ports {LED8Bit[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED8Bit[1]}]
set_property LOC AA8 [get_ports {LED8Bit[1]}]

# Bank: 33 - GPIO_LED_2_LS
set_property DRIVE 12 [get_ports {LED8Bit[2]}]
set_property SLEW SLOW [get_ports {LED8Bit[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED8Bit[2]}]
set_property LOC AC9 [get_ports {LED8Bit[2]}]

# Bank: 33 - GPIO_LED_3_LS
set_property DRIVE 12 [get_ports {LED8Bit[3]}]
set_property SLEW SLOW [get_ports {LED8Bit[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED8Bit[3]}]
set_property LOC AB9 [get_ports {LED8Bit[3]}]

# Bank: - GPIO_LED_4_LS
set_property DRIVE 12 [get_ports {LED8Bit[4]}]
set_property SLEW SLOW [get_ports {LED8Bit[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8Bit[4]}]
set_property LOC AE26 [get_ports {LED8Bit[4]}]

# Bank: - GPIO_LED_5_LS
set_property DRIVE 12 [get_ports {LED8Bit[5]}]
set_property SLEW SLOW [get_ports {LED8Bit[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8Bit[5]}]
set_property LOC G19 [get_ports {LED8Bit[5]}]

# Bank: - GPIO_LED_6_LS
set_property DRIVE 12 [get_ports {LED8Bit[6]}]
set_property SLEW SLOW [get_ports {LED8Bit[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8Bit[6]}]
set_property LOC E18 [get_ports {LED8Bit[6]}]

# Bank: - GPIO_LED_7_LS
set_property DRIVE 12 [get_ports {LED8Bit[7]}]
set_property SLEW SLOW [get_ports {LED8Bit[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8Bit[7]}]
set_property LOC F16 [get_ports {LED8Bit[7]}]
#-------------------------------------------------------------> LED Interface
