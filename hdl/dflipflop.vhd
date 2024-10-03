
library IEEE;
use IEEE.std_logic_1164.all;

entity dflipflop is 
port (
	input : in std_ulogic;
	output: out std_ulogic;
	clk   : in std_ulogic
);
end entity dflipflop;

architecture dflipflop_arch of dflipflop is

begin
	process(clk)
	begin
		if rising_edge(clk) then
			output <= input;
		end if;
	end process;
end architecture dflipflop_arch;
