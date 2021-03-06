library ieee;
use ieee.std_logic_1164.all;


entity display_shiftting is

	port
	(
		button	       : in	 std_logic;
		new_note	       : in  std_logic_vector(29 down to 0);
		current_note	 : out std_logic_vector(29 down to 0);
		past_note	    : out std_logic_vector(29 down to 0)
	);

end entity;

architecture rtl of display_shiftting is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);

	-- Register to hold the current state
	signal state : state_type;

begin

	process (button)
	begin

			state <= s0;
			
			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when s0=>
					if button = '0' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
						past_note <= current_note;
						state <= s2;
					end if;
				when s2=>
						current_note <= new_note;
						state <= s0;
					end if;
			end case;

		end if;
	end process;-- Quartus Prime VHDL Template
-- Four-State Mealy State Machine

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.


