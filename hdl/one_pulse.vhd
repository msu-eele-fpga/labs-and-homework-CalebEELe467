library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity one_pulse is
  port
  (
    clk   : in std_ulogic;
    rst   : in std_ulogic;
    input : in std_ulogic;
    pulse : out std_ulogic := '0'
  );
end entity one_pulse;
architecture one_pulse_arch of one_pulse is

  type state_type is (before, during, post);
  signal current_state : state_type;
  signal next_state    : state_type;

begin

  state_memory : process (clk, rst)
  begin
    if (rst = '1') then
      current_state <= before;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process state_memory;

  next_state_logic : process (current_state, input)
  begin
    case current_state is
      when before =>
		if input = '1' then
        next_state <= during;
		else
        next_state <= before;
		end if;
      when during =>
        next_state <= post;
      when post =>
			if input = '0' then
        next_state <= before;
		  else
          next_state <= post;
			 end if;
      when others =>
        next_state <= before;
    end case;
  end process next_state_logic;

  output_logic : process (current_state)
  begin
    if current_state = during then
      pulse <= '1';
    else
      pulse <= '0';
    end if;
  end process output_logic;
end architecture one_pulse_arch;