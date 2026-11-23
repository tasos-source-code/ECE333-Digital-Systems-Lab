create_clock -period 10.000 -name clk [get_ports clk]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}]
# On-board Buttons
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {rst}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {new_game}]

#HDMI Signals
set_property -dict { PACKAGE_PIN T14 IOSTANDARD TMDS_33} [get_ports {hdmi_clk_n}]
set_property -dict { PACKAGE_PIN R14 IOSTANDARD TMDS_33} [get_ports {hdmi_clk_p}]
set_property -dict { PACKAGE_PIN T15 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[0]}]
set_property -dict { PACKAGE_PIN R17 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[1]}]
set_property -dict { PACKAGE_PIN P16 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_n[2]}]
set_property -dict { PACKAGE_PIN R15 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[0]}]
set_property -dict { PACKAGE_PIN R16 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[1]}]
set_property -dict { PACKAGE_PIN N15 IOSTANDARD TMDS_33} [get_ports {hdmi_tx_p[2]}]

set_property -dict { PACKAGE_PIN V2 IOSTANDARD LVCMOS33 } [get_ports { intencity[0]}];
set_property -dict { PACKAGE_PIN U2 IOSTANDARD LVCMOS33 } [get_ports { intencity[1]}];
set_property -dict { PACKAGE_PIN U1 IOSTANDARD LVCMOS33 } [get_ports { intencity[2]}];
set_property -dict { PACKAGE_PIN T2 IOSTANDARD LVCMOS33 } [get_ports { intencity[3]}];
set_property -dict { PACKAGE_PIN T1 IOSTANDARD LVCMOS33 } [get_ports { intencity[4]}];
set_property -dict { PACKAGE_PIN R2 IOSTANDARD LVCMOS33 } [get_ports { intencity[5]}];
set_property -dict { PACKAGE_PIN R1 IOSTANDARD LVCMOS33 } [get_ports { intencity[6]}];
set_property -dict { PACKAGE_PIN P2 IOSTANDARD LVCMOS33 } [get_ports { intencity[7]}];

#paddle_speed
set_property -dict { PACKAGE_PIN M1 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[0]}];
set_property -dict { PACKAGE_PIN L1 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[1]}];
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[2]}];
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports { paddle_speed[3]}];
#puck speed
set_property -dict { PACKAGE_PIN P1 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[0]}];
set_property -dict { PACKAGE_PIN N2 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[1]}];
set_property -dict { PACKAGE_PIN N1 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[2]}];
set_property -dict { PACKAGE_PIN M2 IOSTANDARD LVCMOS33 } [get_ports { puck_speed[3]}];

#movement
set_property -dict { PACKAGE_PIN H2 IOSTANDARD LVCMOS33 } [get_ports { up }];
set_property -dict { PACKAGE_PIN J1 IOSTANDARD LVCMOS33 } [get_ports { down }];


#new_frame LED
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {new_frame_LED}];

# Set Bank 0 voltage
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]