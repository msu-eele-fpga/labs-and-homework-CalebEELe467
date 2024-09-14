library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;


entity debouncer is 
	generic (
		  clk_period	: time := 20 ns;
		  debounce_time	: time 
	);
	port(
		  clk		: in 	std_ulogic;
		  rst		: in 	std_ulogic;
		  input		: in 	std_ulogic;
		  debounced	: out	std_ulogic
	  );
end entity debouncer;


architecture debouncer_arch of debouncer is
	type state_type is (pressed, not_pressed);
	signal current_state : state_type;
	signal next_state    : state_type;
	signal amount	: integer := 0;

begin
	state_memory: process(clk, rst)
	 begin
		if (rst = '1') then
			current_state <= not_pressed;
		elsif(rising_edge(clk)) then
			current_state <= next_state;
		end if;
		end process state_memory;

	next_state_process : process( current_state, input)
		begin	
		case current_state is
			when not_pressed =>
				if (input = '1') then
					next_state <= pressed;
				else
					next_state <= not_pressed;
				end if;
			when pressed =>
				if (amount < ((debounce_time / clk_period) -1)) then
					amount <= amount +1;
					next_state <= pressed;
				else 
					amount <= 0;
					next_state <= not_pressed;
				end if;
			end case;
		end process next_state_process;
	output_logic : process(current_state)
	begin
		case current_state is
			when pressed =>
				debounced <= '1';
			when not_pressed =>
				debounced <= '0';
		end case;
	end process output_logic;
end architecture debouncer_arch;

		
	