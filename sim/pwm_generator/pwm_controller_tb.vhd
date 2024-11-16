
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity pwm_controller_tb is
end entity pwm_controller_tb;

architecture testbench of pwm_controller_tb is

  component pwm_controller is

    generic (
      CLK_PERIOD   : time    := 20 ns;
      W_PERIOD     : integer := 30; -- 30.24
      W_DUTY_CYCLE : integer := 19 -- 19.18
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
  end component pwm_controller;

  signal clk_tb        : std_logic                     := '0';
  signal rst_tb        : std_logic                     := '0';
  signal period_tb     : unsigned(29 downto 0)         := "000010000000000000000000000000";
  signal duty_cycle_tb : std_logic_vector(18 downto 0) := "0110000000000000000";
  signal output_tb     : std_logic                     := '0';
begin
  dut : component pwm_controller
    port map(
      clk        => clk_tb,
      rst        => rst_tb,
      period     => period_tb,
      duty_cycle => duty_cycle_tb,
      output     => output_tb
    );

    clk_tb <= not clk_tb after CLK_PERIOD / 2;

    testing : process is
    begin
      wait_for_clock_edges(clk_tb, 210000);
      rst_tb <= '1';
      wait_for_clock_edges(clk_tb, 1000);
      period_tb(29 downto 24) <= to_unsigned(5, 6);
      period_tb(23 downto 0)  <= to_unsigned(0, 24);
      rst_tb                  <= '0';

      wait_for_clock_edges(clk_tb, 500000);
      duty_cycle_tb <= "0001000000000000000";
      wait_for_clock_edges(clk_tb, 1000000);
      std.env.finish;
    end process;
  end architecture;
