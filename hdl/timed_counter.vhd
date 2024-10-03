library ieee;
use ieee.std_logic_1164.all;



entity timed_counter is
generic(
	clk_period : time;
	count_time : time
);

port (
	clk	: in 	std_ulogic;
	enable	: in 	boolean;
	done	: out 	boolean
	);
end entity timed_counter;



architecture timed_counter_arch of timed_counter is
	constant COUNTER_LIMIT : integer := (count_time / clk_period);
	signal count : integer := 0;


	begin
	process (clk, enable)
	begin
		if (rising_edge(clk ))then
			if(enable) then
			  count <= count + 1;
				if(count = COUNTER_LIMIT) then
				  done <= true;
				  count <= 0;
				else
					done <= false;
				end if;
			else 
				count <= 0;
				done  <= false;	
			end if;
		end if;
	end process;
	end architecture timed_counter_arch;
