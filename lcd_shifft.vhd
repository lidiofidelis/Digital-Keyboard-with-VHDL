LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lcd_shifft IS
  PORT(
      clk       : IN  std_logic;  --system clock
		note		 : IN	std_logic;
END lcd_shifft;

ARCHITECTURE behavior OF lcd_shifft IS
  signal		past_note      : std_logic_vector(29 downto 0);
  signal		current_note   : std_logic_vector(29 downto 0);
  signal		new_note       : std_logic_vector(29 downto 0);
  signal    steady_note		: std_logic_vector(3 downto 0);
  
 
  type state_type_2 is (s0, s1, s2, s3, s4);
  signal state_2 : state_type_2; 
  
BEGIN 

	
	process (clk, steady_note)
	begin

			case state_2 is
			
				when s0=>
						past_note 		<= "100010000010001000001000100000";
						current_note   <= "100010000010001000001000100000";
						state_2 <= s1;
				when s1=>
					if (steady_note /= "0000") then
						state_2 <= s2;
					else
						state_2 <= s1;
					end if;
				when s2=>
						past_note <= current_note;
						state_2 <= s3;
				when s3=>
						current_note <= new_note;
						state_2 <= s4;
				when s4=>
					if (steady_note /= "0000") then
						state_2 <= s4;
					else
						state_2 <= s1;
					end if;
			end case;
	end process;
END arcHITECTURE;
