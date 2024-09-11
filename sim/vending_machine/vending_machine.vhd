library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity vending_machine is
port (
	clk	: in	std_ulogic;
	rst	: in 	std_ulogic;
	nickel	: in 	std_ulogic;
	dime	: in 	std_ulogic;
	dispense: out 	std_ulogic;
	amount	: out	natural range 0 to 15
);
end entity vending_machine;


architecture vending_machine_arch of vending_machine is


	type state_type is (c0, c5, c10, c15);
	signal state : state_type;

begin

	state_machine : process(clk,rst)	
	begin
		if(rst = '1') then
		  state <= c0;
		elsif rising_edge(clk) then
		  case state is
			when c0 =>
			  if(dime = '1') then
				state <= c10;
				amount <= 10;
				dispense <= '0';
			  elsif(nickel = '1') then
				state <= c5;
				amount <= 5;
				dispense <= '0';
			  else 
				state <= c0;
				amount <= 0;
				dispense <= '0';
			  end if;
			when c5 =>
			  if(dime = '1') then
				state <= c15;
				amount <= 15;
				dispense <= '1';
			  elsif(nickel = '1') then
				state <= c10;
				amount <= 10;
				dispense <= '0';
			  else
				state <= c5;
				amount <= 5;
				dispense <= '0';
			  end if;
			when c10 => 
			  if(dime = '1') then
				state <= c15;
				amount <= 15;
				dispense <= '1';
			  elsif(nickel = '1') then
				state <= c15;
				amount <= 15;
				dispense <= '1';
			  else 
				state <= c10;
				amount <= 10;
				dispense <= '0';
			  end if;
			when c15 => 
				state <= c0;
				amount <= 0;
				dispense <= '0';
			when others => 
				state <= c0;
				dispense <= 'U';
				amount <= 0;
			end case;
		end if;
	end process state_machine;
end architecture vending_machine_arch;



	