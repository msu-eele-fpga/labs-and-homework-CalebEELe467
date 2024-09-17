library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity one_pulse is
	port ( 
		clk	: in	std_ulogic;
		rst	: in 	std_ulogic;
		input	: in 	std_ulogic;
		pulse	: out	std_ulogic
		);
end entity one_pulse;




architecture one_pulse_arch of one_pulse is
	begin
		
