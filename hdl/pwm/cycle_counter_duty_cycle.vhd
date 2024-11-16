library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity cycle_counter_duty_cycle is
  generic (
    clk_period : time -- Has to be units of nanoseconds
  );

  port (
    clk         : in std_ulogic;
    enable      : in boolean;
    base_period : in unsigned(18 downto 0); -- unsigned fixed point XXXX.XXXX units of sec 
    done        : out boolean
  );
end entity cycle_counter_duty_cycle;

architecture cycle_counter_ms_arch of cycle_counter_ms is

  constant counts_per_ms       : integer := 1 ms / clk_period; -- Set to 1 ms / clk_period
  constant counts_per_ms_fract : integer := counts_per_ms / 131072; -- 2^17
  signal base_counter_limit    : integer;
  signal COUNTER_LIMIT         : integer;
  signal count                 : integer := 0;
begin

  process (clk, base_period)
  begin
    COUNTER_LIMIT <= ((to_integer(base_period(18)) * counts_per_ms) + ((to_integer(base_period(17 downto 0)) * counts_per_ms_fract)));

  end process;

  process (clk)
  begin
    if (rising_edge(clk)) then
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
  end process;
end architecture cycle_counter_duty_cycle;
