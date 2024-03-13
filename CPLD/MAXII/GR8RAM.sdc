create_clock -period 40 [get_ports C25M]
create_clock -period 978 [get_ports PHI0]
set_clock_groups -asynchronous -group C25M -group PHI0