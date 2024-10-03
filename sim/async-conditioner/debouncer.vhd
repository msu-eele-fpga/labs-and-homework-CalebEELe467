library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity debouncer is
  generic (
    clk_period    : time := 20 ns;
    debounce_time : time
  );
  port (
    clk       : in std_ulogic;
    rst       : in std_ulogic;
    input     : in std_ulogic;
    debounced : out std_ulogic
  );
end entity debouncer;
architecture debouncer_arch of debouncer is
  type state_type is (out_high, out_low, idle);
  signal current_state : state_type := out_low;
  signal next_state    : state_type;

  signal counter_enable : boolean := false;
  signal counter_done   : boolean := false;
  signal counted        : boolean := false;

  component timed_counter is
    generic (
      clk_period : time;
      count_time : time
    );
    port (
      clk    : in std_ulogic;
      enable : in boolean;
      done   : out boolean
    );
  end component timed_counter;

begin
  timed_counter_1_second : timed_counter
  generic map(
    clk_period => 20 ns,
    count_time => debounce_time
  )
  port map(
    clk    => clk,
    enable => counter_enable,
    done   => counter_done
  );

  state_memory : process (clk, rst)
  begin
    if (rst = '1') then
      current_state <= idle;
    elsif (rising_edge(clk)) then
      current_state <= next_state;
    end if;
  end process state_memory;

  next_state_process : process (current_state, input, clk, rst, counter_done)
  begin
    if (rst = '1') then
      next_state <= idle;
    else
      case current_state is
        when idle =>
          if input = '1' then
            next_state     <= out_high;
            counter_enable <= true;
            counted        <= false;
          else
            next_state <= idle;
          end if;
        when out_high =>
          if counter_done = true then
            counter_enable <= false;
            counted        <= true;
            if input = '0' then
              next_state <= out_low;
            else
              next_state <= out_high;
            end if;
          elsif counted = true and input = '0' then
            next_state <= out_low;
          end if;
        when out_low =>
          if counter_done = true then
            next_state     <= idle;
            counter_enable <= false;
          else
            next_state     <= out_low;
            counter_enable <= true;
          end if;
      end case;
    end if;
  end process next_state_process;

  output_logic : process (current_state)
  begin
    case current_state is
      when idle =>
        debounced <= '0';
      when out_high =>
        debounced <= '1';
      when out_low =>
        debounced <= '0';
    end case;
  end process output_logic;
end architecture debouncer_arch;
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

	next_state_process : process( current_state, input, clk, rst)
		begin	 
		if (rst = '1') then
			amount <= 0;
		next_state <= not_pressed;
		else
		case current_state is
			when not_pressed =>
				if ((input = '1') and (amount = 0)) then
					next_state <= pressed;
				elsif ( amount > 0) then
					next_state <= not_pressed;
					if (rising_edge(clk)) then
						amount <= amount - 1;
					end if;
				else 
					next_state <= not_pressed;
				end if;
			when pressed =>
				if (amount < ((debounce_time / clk_period)- 1)) then
					next_state <= pressed;
					if (rising_edge(clk)) then
						amount <= amount + 1;
					end if;
				elsif ( input = '1') then	
					next_state <= pressed;
				else
					next_state <= not_pressed;
				end if;
			end case;
		end if;
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

		
	

