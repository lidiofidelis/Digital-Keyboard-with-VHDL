-- Quartus Prime VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity debounce is

	port(
		clk		 		 : in	std_logic;
		nota	 	       : in	std_logic_vector(3 downto 0);
		steady_nota		 : out	std_logic_vector(3 downto 0)
	);

end entity;

architecture rtl of debounce is

	-- Build an enumerated type for the state machine
	type state_type is (press, is_pressed, still_pressed);

	-- Register to hold the current state
	signal state   : state_type;

	begin

	-- Logic to advance to the next state
	process (clk)
	begin
			state <= press;
			if (rising_edge(clk)) then
				case state is
					when press =>
						if nota /= "0000" then
							state <= is_pressed;
						else
							state <= press;
						end if;
					when is_pressed =>
						if(clk_count < (2500000)) THEN    --wait 50 ms
							clk_count := clk_count + 1;
							if nota /= "0000" then
								state <= still_pressed;
							end if;
						else
							state <= press;
						end if;
					when still_pressed =>
						steady_note <= "0000";
				end case;
		end if;
	end process;

end rtl;
