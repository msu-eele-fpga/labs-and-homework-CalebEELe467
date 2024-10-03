library IEEE;
use IEEE.std_logic_1164.all;
                  
entity synchronizer is
port (
	clk	: in	std_ulogic;
	async	: in 	std_ulogic;
	sync	: out 	std_ulogic
);
end entity synchronizer;


architecture synchronizer_arch of synchronizer is 

	component dflipflop
	  port(
		input : in std_ulogic;
		output: out std_ulogic;
		clk   : in std_ulogic
	);
	end component;

	signal flop1_out : std_ulogic;

begin
	flop1 : dflipflop
		port map ( input 	=> async,
			   output	=> flop1_out,
			   clk		=> clk
			  );
	flop2 : dflipflop
		port map ( input 	=> flop1_out,
			   output	=> sync,
			   clk		=> clk
			  );

end architecture;

	    