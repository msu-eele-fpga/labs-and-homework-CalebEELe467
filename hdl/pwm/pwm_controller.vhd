library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pwm_controller is
  generic (
    CLK_PERIOD   : time    := 20 ns;
    W_PERIOD     : integer := 30;
    W_DUTY_CYCLE : integer := 19
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    -- PWM repetition period in milliseconds;
    -- datatype (W.F) is individually assigned
    period : in unsigned(W_PERIOD - 1 downto 0);
    -- PWM duty cycle between [0 1]; out-of-range values are hard limited
    -- datatype (W.F) is individually assigned;
    duty_cycle : in std_logic_vector(W_DUTY_CYCLE - 1 downto 0);
    output     : out std_logic
  );
end entity pwm_controller;

architecture pwm_controller_arch of pwm_controller is
  constant counts_per_ms        : integer               := 1 ms / clk_period; -- Set to 1 sec / clk_period
  constant precision_duty_cycle : integer               := 262144;
  constant devisior             : unsigned(27 downto 0) := to_unsigned(87960930, 28);
  signal duty_cycle_time        : unsigned(48 downto 0); -- W.F format = 49.42

  signal PERIOD_LIMIT_whole     : integer;
  signal PERIOD_LIMIT_FRACT     : integer;
  signal PERIOD_LIMIT_TOTAL     : integer;
  signal DUTY_CYCLE_LIMIT_WHOLE : integer;
  signal DUTY_CYCLE_LIMIT_FRACT : integer;
  signal DUTY_CYCLE_LIMIT_TOT   : integer;
  signal count                  : integer := 0;
begin

  process (clk, period, duty_cycle)
  begin
    PERIOD_LIMIT_whole     <= (to_integer(period(29 downto 24)) * counts_per_ms);
    PERIOD_LIMIT_FRACT     <= (to_integer(period(23 downto 0)) / 336);
    PERIOD_LIMIT_TOTAL     <= PERIOD_LIMIT_FRACT + PERIOD_LIMIT_whole;
    duty_cycle_time        <= unsigned(duty_cycle) * period;
    DUTY_CYCLE_LIMIT_WHOLE <= (to_integer(duty_cycle_time(48 downto 42))) * counts_per_ms;
    DUTY_CYCLE_LIMIT_FRACT <= to_integer(duty_cycle_time(41 downto 0) / devisior);
    DUTY_CYCLE_LIMIT_TOT   <= DUTY_CYCLE_LIMIT_WHOLE + DUTY_CYCLE_LIMIT_FRACT;
  end process;

  process (clk, rst)
  begin
    if rst = '1' then
      count  <= 0;
      output <= '0';
    elsif (rising_edge(clk)) then
      count <= count + 1;
      if (duty_cycle(18) = '1') then
        output       <= '1';
      elsif (count <= DUTY_CYCLE_LIMIT_TOT) then
        output       <= '1';
      else
        output <= '0';
      end if;
      if (count = PERIOD_LIMIT_TOTAL) then
        count <= 0;
      else
      end if;
    end if;
  end process;
end architecture;