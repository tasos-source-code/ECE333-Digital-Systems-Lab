## This file is a general .xdc for the Spartan-7 Boolean Board

## Global configuration voltage
set_property CFGBVS VCCO           [current_design]
set_property CONFIG_VOLTAGE 3.3    [current_design]

set_property -dict { PACKAGE_PIN F14 IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports { clk }];

### 7-Segment Display
set_property -dict { PACKAGE_PIN D7 IOSTANDARD LVCMOS33 } [get_ports { a }];
set_property -dict { PACKAGE_PIN C5 IOSTANDARD LVCMOS33 } [get_ports { b }];
set_property -dict { PACKAGE_PIN A5 IOSTANDARD LVCMOS33 } [get_ports { c }];
set_property -dict { PACKAGE_PIN B7 IOSTANDARD LVCMOS33 } [get_ports { d }];
set_property -dict { PACKAGE_PIN A7 IOSTANDARD LVCMOS33 } [get_ports { e }];
set_property -dict { PACKAGE_PIN D6 IOSTANDARD LVCMOS33 } [get_ports { f }];
set_property -dict { PACKAGE_PIN B5 IOSTANDARD LVCMOS33 } [get_ports { g }];
set_property -dict { PACKAGE_PIN A6 IOSTANDARD LVCMOS33 } [get_ports { dp }];
set_property -dict { PACKAGE_PIN D5 IOSTANDARD LVCMOS33 } [get_ports { an0 }];
set_property -dict { PACKAGE_PIN C4 IOSTANDARD LVCMOS33 } [get_ports { an1 }];
set_property -dict { PACKAGE_PIN C7 IOSTANDARD LVCMOS33 } [get_ports { an2 }];
set_property -dict { PACKAGE_PIN A8 IOSTANDARD LVCMOS33 } [get_ports { an3 }];

### Button(s)
set_property -dict { PACKAGE_PIN J2 IOSTANDARD LVCMOS33 } [get_ports { reset }];
#baud select
set_property -dict { PACKAGE_PIN L1 IOSTANDARD LVCMOS33 } [get_ports { baud_select[0]}];
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports { baud_select[1]}];
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports { baud_select[2]}];
#INPUT SIGNALS
set_property -dict { PACKAGE_PIN N1 IOSTANDARD LVCMOS33 } [get_ports { enable }];
set_property -dict { PACKAGE_PIN J5 IOSTANDARD LVCMOS33 } [get_ports { Tx_WR }];


set_property -dict { PACKAGE_PIN A3 IOSTANDARD LVCMOS33 } [get_ports { ERROR }];
