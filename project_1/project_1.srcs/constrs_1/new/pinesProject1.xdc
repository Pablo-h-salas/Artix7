
# clock
set_property PACKAGE_PIN L17 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
# vector leds
set_property PACKAGE_PIN A17 [get_ports {led[4]}]       
set_property IOSTANDARD LVCMOS18 [get_ports {led[4]}]
set_property PACKAGE_PIN C16 [get_ports {led[3]}]       
set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]

set_property PACKAGE_PIN C17 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property PACKAGE_PIN B16 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
set_property PACKAGE_PIN B17 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]