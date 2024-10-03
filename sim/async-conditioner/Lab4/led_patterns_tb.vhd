library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity led_patterns_tb is
end entity led_patterns_tb;

architecture led_patterns_tb_arch of led_patterns_tb is

  component led_patterns is
    generic (
      system_clock_period : time := 20 ns
    );
    port (
      clk             : in std_ulogic;
      rst             : in std_ulogic;
      push_button     : in std_ulogic;
      switches        : in std_ulogic_vector(3 downto 0);
      hps_led_control : in boolean;
      base_period     : in unsigned(7 downto 0); -- Fixed point representation of time in seconds XXXX.XXXX
      led_reg         : in std_ulogic_vector(7 downto 0);
      led             : out std_ulogic_vector(7 downto 0)
    );
  end component;

  -- Signals
  signal clk_tb             : std_ulogic                    := '0';
  signal rst_tb             : std_ulogic                    := '0';
  signal push_button_tb     : std_ulogic                    := '0';
  signal switches_tb        : std_ulogic_vector(3 downto 0) := "0010";
  signal hps_led_control_tb : boolean                       := false;
  signal base_period_tb     : unsigned(7 downto 0)          := "00000001";
  signal led_reg_tb         : std_ulogic_vector(7 downto 0) := "00000000";
  signal led_tb             : std_ulogic_vector(7 downto 0) := "00000000";
begin

  dut : component led_patterns
    generic map(system_clock_period => 20 ns)
    port map(
      clk             => clk_tb,
      rst             => rst_tb,
      push_button     => push_button_tb,
      switches        => switches_tb,
      hps_led_control => hps_led_control_tb,
      base_period     => base_period_tb,
      led_reg         => led_reg_tb,
      led             => led_tb
    );

    clk_tb <= not clk_tb after CLK_PERIOD / 2;

    process is
    begin
      wait_for_clock_edges(clk_tb, 200);
      push_button_tb <= '1';
      wait_for_clock_edges(clk_tb, 10);
      push_button_tb <= '0';
      wait_for_clock_edges(clk_tb, 100);
	rst_tb <= '1';
      switches_tb <= "0000";
      wait_for_clock_edges(clk_tb, 5);
	rst_tb <= '0';
      wait_for_clock_edges(clk_tb, 10);
      push_button_tb <= '0';
      wait_for_clock_edges(clk_tb, 100);
      switches_tb <= "0010";
      wait_for_clock_edges(clk_tb, 5);
      push_button_tb <= '1';
      wait_for_clock_edges(clk_tb, 10);
      push_button_tb <= '0';
      wait_for_clock_edges(clk_tb, 100);
      switches_tb <= "0011";
      wait_for_clock_edges(clk_tb, 5);
      push_button_tb <= '1';
      wait_for_clock_edges(clk_tb, 10);
      push_button_tb <= '0';
      wait_for_clock_edges(clk_tb, 100);
      switches_tb <= "0100";
      wait_for_clock_edges(clk_tb, 5);
      push_button_tb <= '1';
      wait_for_clock_edges(clk_tb, 10);
      push_button_tb <= '0';
      wait_for_clock_edges(clk_tb, 100);

      std.env.finish;

    end process;

  end architecture;