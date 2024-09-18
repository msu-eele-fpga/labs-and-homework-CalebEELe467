library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture async_conditioner_tb_arch of async_conditioner_tb is

  component async_conditioner is
    port (
      clk   : in std_logic;
      rst   : in std_logic;
      async : in std_ulogic;
      sync  : out std_ulogic

    );
  end component async_conditioner;

  signal clk_tb   : std_ulogic := '0';
  signal rst_tb   : std_ulogic := '0';
  signal async_tb : std_ulogic := '0';
  signal sync_tb  : std_ulogic := '0';

begin
  duv : async_conditioner
  port map
  (
    clk   => clk_tb,
    rst   => rst_tb,
    async => async_tb,
    sync  => sync_tb
  );

  clk_tb <= not clk_tb after CLK_PERIOD / 2;
  testing : process is
    variable sync_expected : std_ulogic := '0';
    variable debounce_time : time       := 100 ns;

  begin
    print("=============================================");
    print("Testing Reset Functionality");
    print("=============================================");
    rst_tb <= '1';
    sync_expected := '0';
    assert_eq(sync_tb, sync_expected, "Error when in reset Condition");
    wait_for_clock_edges(clk_tb, 5);
    print("    Test Reset when input = 1");
    async_tb <= '1';
    wait_for_clock_edge(clk_tb);
    wait for CLK_PERIOD / 2;
    assert_eq(sync_tb, sync_expected, "Error when in reset and input = 1");

    print("============================================");
    print("Synchronous and Asynchonous input Functionality");
    print("============================================");
    print("    Testing synchronus input");

    async_tb <= '0';
    wait_for_clock_edge(clk_tb);
    rst_tb <= '0';
    wait_for_clock_edge(clk_tb);
    async_tb <= '1';
    wait_for_clock_edge(clk_tb);
    wait for CLK_PERIOD / 2;
    sync_expected := '1';
    assert_eq(sync_tb, sync_expected, "Error not pulsing at correct time");
    print("    Testing with asynchronus input");
    async_tb <= '0';
    wait_for_clock_edges(clk_tb, debounce_time / CLK_PERIOD);
    wait_for_clock_edges(clk_tb, 5); -- Wait for synchronizer and debouncer
    wait for CLK_PERIOD / 4;
    async_tb <= '1';
    wait_for_clock_edge(clk_tb);
    async_tb <= '0';
    wait_for_clock_edges(clk_tb, 10);
    print("============================================");
    print("Test for bouncing");
    print("============================================");
    print("We Bouncing Boi");
    -- Wait for another debounce period
    wait_for_clock_edges(clk_tb, debounce_time / CLK_PERIOD);
    wait_for_clock_edges(clk_tb, 5); -- Wait for synchronizer and debouncer
    wait for CLK_PERIOD / 4;
    async_tb <= '1';
    wait for CLK_PERIOD / 2;
    async_tb <= '0';
    wait_for_clock_edge(clk_tb);
    async_tb <= '1';
    wait_for_clock_edge(clk_tb);
    async_tb <= '0';
    wait_for_clock_edges(clk_tb, 3);
    wait for CLK_PERIOD / 2;
    sync_expected := '1';
    assert_eq(sync_tb, sync_expected, "Error not handling bouncing correctly");
    std.env.finish;
  end process;

end architecture async_conditioner_tb_arch;