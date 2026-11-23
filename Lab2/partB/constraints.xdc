## This file is a general .xdc for the Spartan-7 Boolean Board

## Global configuration voltage
set_property CFGBVS VCCO           [current_design]
set_property CONFIG_VOLTAGE 3.3    [current_design]

### Clock Signal
set_property -dict { PACKAGE_PIN F14 IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports { clk }];

#baud select
set_property -dict { PACKAGE_PIN L1 IOSTANDARD LVCMOS33 } [get_ports { baud_select[0]}];
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports { baud_select[1]}];
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports { baud_select[2]}];
#INPUT SIGNALS
set_property -dict { PACKAGE_PIN N1 IOSTANDARD LVCMOS33 } [get_ports { Tx_EN }];
set_property -dict { PACKAGE_PIN J5 IOSTANDARD LVCMOS33 } [get_ports { Tx_WR }];
set_property -dict { PACKAGE_PIN J2 IOSTANDARD LVCMOS33 } [get_ports { reset }];
#DATA
set_property -dict { PACKAGE_PIN V2 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[0]}];
set_property -dict { PACKAGE_PIN U2 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[1]}];
set_property -dict { PACKAGE_PIN U1 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[2]}];
set_property -dict { PACKAGE_PIN T2 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[3]}];
set_property -dict { PACKAGE_PIN T1 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[4]}];
set_property -dict { PACKAGE_PIN R2 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[5]}];
set_property -dict { PACKAGE_PIN R1 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[6]}];
set_property -dict { PACKAGE_PIN P2 IOSTANDARD LVCMOS33 } [get_ports { Tx_DATA[7]}];
#outputs
set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports { TxD }];
#set_property -dict { PACKAGE_PIN B4 IOSTANDARD LVCMOS33 } [get_ports { TxD }];

set_property -dict { PACKAGE_PIN A4 IOSTANDARD LVCMOS33 } [get_ports { Tx_BUSY }];
