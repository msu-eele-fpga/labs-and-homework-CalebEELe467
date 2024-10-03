library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity one_pulse_tb is
end entity one_pulse_tb;

architecture testbench of one_pulse_tb is

  component one_pulse is
    port
    (
      clk   : in std_ulogic;
      rst   : in std_ulogic;
      input : in std_ulogic;
      pulse : out std_ulogic
    );
  end component one_pulse;

  signal clk_tb   : std_ulogic := '0';
  signal rst_tb   : std_ulogic := '0';
  signal input_tb : std_ulogic := '0';
  signal pulse_tb : std_ulogic := '0';

begin
  duv : one_pulse
  port map
  (
    clk   => clk_tb,
    rst   => rst_tb,
    input => input_tb,
    pulse => pulse_tb
  );

  clk_tb <= not clk_tb after CLK_PERIOD / 2;
  process is
    variable pulse_expected : std_ulogic := '0';
  begin
    -- Testing Reset Functionality 
    print("========================================================");
    print("Testing reset condition");
    print("========================================================");
    rst_tb <= '1';
    pulse_expected := '0';
    assert_eq(pulse_tb, pulse_expected, "Error While Held In Reset");
    wait_for_clock_edges(clk_tb, 5);
    -- Check input during reset condition
    print("    Testing Reset while input = High");
    wait_for_clock_edge(clk_tb);
    rst_tb   <= '1';
    input_tb <= '1';
    pulse_expected := '0';
    assert_eq(pulse_tb, pulse_expected, "Error While reset and input = High");
    wait_for_clock_edges(clk_tb, 5);
    print("=======================================================");
    print("Testing Output Timing");
    print("=======================================================");
    input_tb <= '0';
    rst_tb   <= '0';
    wait_for_clock_edge(clk_tb);
    print("    Testing Pulse Output Timing");
    input_tb <= '1';
    pulse_expected := '1';
    wait_for_clock_edge(clk_tb);
    wait for CLK_PERIOD / 2;
    assert_eq(pulse_tb, pulse_expected, "Error with one pulse timing");
    wait_for_clock_edge(clk_tb);
    print("    Testing after pulse");
    wait for CLK_PERIOD / 2;
    pulse_expected := '0';
    assert_eq(pulse_tb, pulse_expected, "Error when going low after pulse");
    wait_for_clock_edges(clk_tb, 5);
    std.env.finish;

  end process;

end architecture testbench;