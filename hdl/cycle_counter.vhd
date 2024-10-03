library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity cycle_counter is
  generic (
    clk_period : time -- Has to be units of nanoseconds
  );

  port (
    clk         : in std_ulogic;
    enable      : in boolean;
    base_period : in unsigned(7 downto 0); -- unsigned fixed point XXXX.XXXX units of sec 
    divider     : in integer; -- shifts base period right aka counter less
    multiplier  : in integer; -- shifts base period left  aka count longer
    done        : out boolean
  );
end entity cycle_counter;

architecture cycle_counter_arch of cycle_counter is

  constant counts_per_second           : integer := 1 sec / clk_period; -- Set to 1 sec / clk_period
  constant counts_per_second_sixteenth : integer := counts_per_second / 16;
  signal base_counter_limit            : integer;
  signal COUNTER_LIMIT                 : integer;
  signal count                         : integer := 0;
begin

  process (clk, base_period)
  begin
    base_counter_limit <= ((to_integer(base_period(7 downto 4)) * counts_per_second) + ((to_integer(base_period(3 downto 0)) * counts_per_second_sixteenth)));
    if divider > 0 then
      COUNTER_LIMIT <= base_counter_limit / divider;
    elsif multiplier > 0 then
      COUNTER_LIMIT <= base_counter_limit * multiplier;
    else
      COUNTER_LIMIT <= base_counter_limit;
    end if;
  end process;
  process (clk, enable)
  begin
    if (rising_edge(clk)) then
      if (enable) then
        count <= count + 1;
        if (count = COUNTER_LIMIT) then
          done  <= true;
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
end architecture cycle_counter_arch;
