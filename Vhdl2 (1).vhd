library ieee;
use ieee.std_logic_1164.all;

entity debounce is

	port(
		clk		 : in	std_logic;
		input	 : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic_vector(1 downto 0)
	);

end entity;

architecture rtl of debounce is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);

	-- Register to hold the current state
	signal state   : state_type;

begin

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				when s0=>
					if input = '0' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					IF(clk_count < (2500000)) THEN    --wait 50 ms
						clk_count := clk_count + 1;
						if(input = '0') then
							state <= s2 ;
					else
						state <= s0;
					end if;
				when s2=>
						state <= s0;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s2 =>
				output <= '0';
				others <= '1';
		end case;
	end process;

end rtl;

