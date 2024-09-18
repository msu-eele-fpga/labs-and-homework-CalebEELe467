library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity async_conditioner is
  port (
    clk   : in std_ulogic;
    rst   : in std_ulogic;
    async : in std_ulogic;
    sync  : out std_ulogic
  );
end entity async_conditioner;

architecture async_conditioner_arch of async_conditioner is
  signal sync_to_debouncer      : std_ulogic;
  signal debouncer_to_one_pulse : std_ulogic;

  component synchronizer is
    port (
      clk   : in std_ulogic;
      async : in std_ulogic;
      sync  : out std_ulogic
    );
  end component synchronizer;

  component debouncer is
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
  end component debouncer;

  component one_pulse is
    port (
      clk   : in std_ulogic;
      rst   : in std_ulogic;
      input : in std_ulogic;
      pulse : out std_ulogic
    );
  end component one_pulse;
begin
  syncronizer_comp : synchronizer
  port map
  (
    clk   => clk,
    async => async,
    sync  => sync_to_debouncer
  );

  debounce : debouncer
  generic map
  (
    clk_period    => 20 ns,
    debounce_time => 100 ns
  )
  port map
  (
    clk       => clk,
    rst       => rst,
    input     => sync_to_debouncer,
    debounced => debouncer_to_one_pulse
  );

  pulser : one_pulse
  port map(
    clk   => clk,
    rst   => rst,
    input => debouncer_to_one_pulse,
    pulse => sync

  );
end architecture async_conditioner_arch;