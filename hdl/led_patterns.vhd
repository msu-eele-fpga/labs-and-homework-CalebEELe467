library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns is
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
end entity;
architecture led_patterns_arch of led_patterns is

  -- Signals:
  signal button_pressed          : std_ulogic := '0';
  signal start_counter           : std_ulogic := '0';
  signal base_period_time        : time;
  signal adjustable_counter_time : time := 100 ns;
  signal half_base_rate_period   : time;

  signal before_decimal : integer := 0;
  signal after_decimal  : integer := 0;

  signal output_integer : integer range 0 to 127 := 0;
  signal led_7          : std_ulogic             := '0';
  signal start_output   : std_ulogic             := '0';

  signal hold_state_led : std_ulogic_vector(3 downto 0) := "0000";

  signal switch_int : integer := 0;

  signal base_period_counter_enable : boolean := false;
  signal one_second_period_enable   : boolean := false;
  signal global_enable              : boolean := false;

  signal base_period_done       : boolean := false;
  signal one_second_done        : boolean := false;
  signal half_base_rate_done    : boolean := false;
  signal quarter_base_rate_done : boolean := false;
  signal double_base_rate_done  : boolean := false;
  signal triple_base_rate_done  : boolean := false;
  signal eighth_base_rate_done  : boolean := false;
  signal global_done            : boolean := false;

  -- State types

  type state_type is (idle, hold, state0, state1, state2, state3, state4);
  signal current_state   : state_type;
  signal next_state      : state_type;
  signal post_hold_state : state_type;

  -- Components:

  component async_conditioner is
    port (
      clk   : in std_ulogic;
      rst   : in std_ulogic;
      async : in std_ulogic;
      sync  : out std_ulogic
    );
  end component async_conditioner;

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

  component cycle_counter is
    generic (
      clk_period : time
    );
    port (
      clk         : in std_ulogic;
      enable      : in boolean;
      base_period : in unsigned(7 downto 0); -- unsigned fixed point XXXX.XXXX units of sec 
      divider     : in integer; -- shifts base period right aka counter less
      multiplier  : in integer; -- shifts base period left  aka count longer
      done        : out boolean
    );
  end component cycle_counter;

begin
  switch_int <= TO_INTEGER(unsigned(switches));

  Conditioner : async_conditioner
  port map
  (
    clk   => clk,
    rst   => rst,
    async => push_button,
    sync  => button_pressed

  );

  -- 1 Second Counter---------------------------------------
  timed_counter_1_second : timed_counter
  generic map(
    clk_period => 20 ns,
    count_time => 1 sec -- Set to 1 sec after testing
  )
  port map(
    clk    => clk,
    enable => one_second_period_enable,
    done   => one_second_done
  );

  -- Base Period Counter ---------------------------------------
  cycle_counter_base_period : cycle_counter
  generic map(
    clk_period => 20 ns
  )
  port map(
    clk         => clk,
    enable      => base_period_counter_enable,
    base_period => base_period,
    divider     => 0,
    multiplier  => 0,
    done        => base_period_done
  );
  -- 1/2 baseRate -----------------------------------
  half_base_rate_counter : cycle_counter
  generic map(
    clk_period => 20 ns
  )
  port map(
    clk         => clk,
    enable      => global_enable,
    base_period => base_period,
    divider     => 0,
    multiplier  => 2,
    done        => half_base_rate_done
  );
  ------------------------------------------------------------
  -- 1/4 baseRate -----------------------------------
  quarter_base_rate_counter : cycle_counter
  generic map(
    clk_period => 20 ns
  )
  port map(
    clk         => clk,
    enable      => global_enable,
    base_period => base_period,
    divider     => 0,
    multiplier  => 4,
    done        => quarter_base_rate_done
  );
  ------------------------------------------------------------
  -- 2 * baseRate -----------------------------------
  double_base_rate_counter : cycle_counter
  generic map(
    clk_period => 20 ns
  )
  port map(
    clk         => clk,
    enable      => global_enable,
    base_period => base_period,
    divider     => 2,
    multiplier  => 0,
    done        => double_base_rate_done
  );
  ------------------------------------------------------------
  -- 3 * baseRate -----------------------------------
  triple_base_rate_counter : cycle_counter
  generic map(
    clk_period => 20 ns
  )
  port map(
    clk         => clk,
    enable      => global_enable,
    base_period => base_period,
    divider     => 3,
    multiplier  => 0,
    done        => triple_base_rate_done
  );
  ------------------------------------------------------------
  -- 1/8 baseRate -----------------------------------
  eighth_base_rate_counter : cycle_counter
  generic map(
    clk_period => 20 ns
  )
  port map(
    clk         => clk,
    enable      => global_enable,
    base_period => base_period,
    divider     => 0,
    multiplier  => 8,
    done        => eighth_base_rate_done
  );
  ------------------------------------------------------------

  -- Process for output
  State_memory : process (clk, rst, hps_led_control)
  begin
    if (rst = '1') then
      current_state <= idle;
    elsif (rising_edge(clk)) then
      current_state <= next_state;
    end if;
  end process State_memory;

  next_state_logic : process (current_state, button_pressed, one_second_done, switches, switch_int, post_hold_state, clk)
  begin
    if rst = '1' then
      next_state <= idle;
    elsif button_pressed = '1' then
      next_state                 <= hold;
      hold_state_led(3 downto 0) <= switches;
      case(switch_int) is
        when 0 =>
        post_hold_state <= state0;

        when 1 =>
        post_hold_state <= state1;

        when 2 =>
        post_hold_state <= state2;

        when 3 =>
        post_hold_state <= state3;

        when 4 =>
        post_hold_state <= state4;

        when others =>
        post_hold_state <= idle;
      end case;
    elsif one_second_done = true then
      next_state <= post_hold_state;
    else
      next_state      <= next_state;
      post_hold_state <= post_hold_state;
      hold_state_led  <= hold_state_led;
    end if;
  end process next_state_logic;

  timer_setup : process (current_state, clk)
  begin
    case current_state is
      when idle =>
        base_period_counter_enable <= false;
        one_second_period_enable   <= false;
      when hold =>
        base_period_counter_enable <= false;
        one_second_period_enable   <= true;
      when state0 =>
        base_period_counter_enable <= true;
        one_second_period_enable   <= false;
        global_enable              <= true;
        global_done                <= half_base_rate_done;
      when state1 =>
        base_period_counter_enable <= true;
        one_second_period_enable   <= false;
        global_enable              <= true;
        global_done                <= quarter_base_rate_done;
      when state2 =>
        base_period_counter_enable <= true;
        one_second_period_enable   <= false;
        global_enable              <= true;
        global_done                <= double_base_rate_done;
      when state3 =>
        base_period_counter_enable <= true;
        one_second_period_enable   <= false;
        global_enable              <= true;
        global_done                <= eighth_base_rate_done;
      when state4 =>
        base_period_counter_enable <= true;
        one_second_period_enable   <= false;
        global_done                <= triple_base_rate_done;
    end case;
  end process timer_setup;

  timer_based_output : process (global_done, one_second_done, base_period_done, current_state, clk
    )
  begin
    if (hps_led_control = true) then
      led <= led_reg;
    else
      if (current_state = idle) then
        led(7 downto 0) <= "00000000";
      elsif (current_state = hold) then
        led(3 downto 0) <= hold_state_led;
        led(7 downto 4) <= "0000";
        case post_hold_state is
          when state0 =>
            output_integer <= 64;
          when state1 =>
            output_integer <= 3;
          when state2 =>
            output_integer <= 0;
          when state3 =>
            output_integer <= 127;
          when state4 =>
            output_integer <= 85;
          when others =>
            output_integer <= 0;
        end case;
      else
        if base_period_done = true and rising_edge(clk) then
          led_7  <= not led_7;
          led(7) <= led_7;
        else
          -- Do nothing
        end if;
        if global_done = true and rising_edge(clk) then
          case current_state is
            when state0 =>
              if (output_integer > 1) then
                output_integer <= output_integer / 2;
              else
                output_integer <= 64;
              end if;
            when state1 =>
              if (output_integer < 64) then
                output_integer <= output_integer * 2;
              elsif output_integer = 96 then
                output_integer <= 65;
              else
                output_integer <= 3;
              end if;
            when state2 =>
              if (output_integer < 127) then
                output_integer <= output_integer + 1;
              else
                output_integer <= 0;
              end if;
            when state3 =>
              if (output_integer > 0) then
                output_integer <= output_integer - 1;
              else
                output_integer <= 64;
              end if;
            when state4 =>
              if output_integer = 85 then
                output_integer <= 42;
              else
                output_integer <= 85;
              end if;
            when others =>
              output_integer <= 0;
          end case;
        else
          -- Do Nothing
        end if;
        led(6 downto 0) <= std_ulogic_vector(to_unsigned(output_integer, 7));
      end if;
    end if;
  end process timer_based_output;
end architecture led_patterns_arch;