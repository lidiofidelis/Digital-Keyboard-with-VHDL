--------------------------------------------------------------------------------
--
--   FileName:         lcd_example.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 6/13/2012 Scott Larson
--     Initial Public Release
--
--   Prints "123456789" on a HD44780 compatible 8-bit interface character LCD 
--   module using the lcd_controller.vhd component.
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lcd_example IS
  PORT(
      clk, on_off       : IN  std_logic;  --system clock
      rw, rs, e 			: OUT std_logic;  --read/write, setup/data, and enable for lcd
		nota		 			: IN  std_logic_vector(3 DOWNTO 0);
		oitava	 			: in  std_logic_vector(2 downto 0);
		volume	 			: in  std_logic_vector(6 downto 0);
      lcd_data  			: OUT std_logic_vector(7 DOWNTO 0)); --data signals for lcd
END lcd_example;

ARCHITECTURE behavior OF lcd_example IS
  SIGNAL    lcd_enable                           : std_logic;
  SIGNAL    lcd_bus                              : std_logic_vector(9 DOWNTO 0);
  SIGNAL    lcd_busy                             : std_logic;
  SIGNAL    vol_1,vol_0,on_off_1 ,on_off_0       : std_logic_vector(9 downto 0);
  signal		past_note                            : std_logic_vector(29 downto 0);
  signal		current_note                         : std_logic_vector(29 downto 0);
  signal		new_note                             : std_logic_vector(29 downto 0);
  signal    steady_note								    : std_logic;
  
  type state_type_1 is (press, is_pressed, still_pressed);
  signal state_1   : state_type_1;
  
  type state_type_2 is (s0, s1, s2, s3, s4);
  signal state_2 : state_type_2;

  COMPONENT lcd_controller IS
    PORT(
       clk        : IN  STD_LOGIC; --system clock
       reset_n    : IN  STD_LOGIC; --active low reinitializes lcd
       lcd_enable : IN  STD_LOGIC; --latches data into lcd controller
       lcd_bus    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0); --data and control signals
       busy       : OUT STD_LOGIC; --lcd controller busy/idle feedback
       rw, rs, e  : OUT STD_LOGIC; --read/write, setup/data, and enable for lcd
       lcd_data   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
  END COMPONENT;
BEGIN

  --instantiate the lcd controller
  dut: lcd_controller
    PORT MAP(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
             busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
 
 
  
  PROCESS(clk)
     VARIABLE char  :  INTEGER RANGE 0 TO 25 := 0;
  BEGIN
  
	
    IF(clk'EVENT AND clk = '1') THEN
	 
      IF(lcd_busy = '0' and lcd_enable = '0') THEN
        lcd_enable <= '1';
        IF(char < 25) THEN
          char := char + 1;
			 else 
			char := 0;
        END IF;
        CASE char IS
          WHEN 1  => lcd_bus <= "1001010110";---------------------------V
          WHEN 2  => lcd_bus <= "1001001111";---------------------------O
          WHEN 3  => lcd_bus <= "1001001100";---------------------------L
          WHEN 4  => lcd_bus <= "1001010101";---------------------------U
          WHEN 5  => lcd_bus <= "1001001101";---------------------------M
          WHEN 6  => lcd_bus <= "1001000101";---------------------------E
          WHEN 7  => lcd_bus <= "1000111010";-------------------------' '			 
          WHEN 8  => lcd_bus <= vol_1(9 DOWNTO 0);------------VOL 1ºDIGIT 
          WHEN 9  => lcd_bus <= vol_0(9 DOWNTO 0);------------VOL 2ºDIGIT
			 WHEN 10 => lcd_bus <= "1000110000";---------------------------0
			 when 11 => lcd_bus <= "1000100101";---------------------------%
			 when 12 => lcd_bus <= "1000100000";-------------------------' '
			 when 13 => lcd_bus <= "1001001111";---------------------------o
			 when 14 => lcd_bus <= on_off_1(9 DOWNTO 0);-----------------n/f
			 when 15 => lcd_bus <= on_off_0(9 DOWNTO 0);------------' ' ou f
			 when 16 => lcd_bus <= "0011000000";------------------pula linha
			 when 17 => lcd_bus <= past_note(29 downto 20);
			 when 18 => lcd_bus <= past_note(19 downto 10);
			 when 19 => lcd_bus <= past_note(9 downto 0);------------ oitava
			 when 20 => lcd_bus <= "1000100000";-------------------------' '
			 when 21 => lcd_bus <= current_note(29 downto 20);
			 when 22 => lcd_bus <= current_note(19 downto 10);
			 when 23 => lcd_bus <= current_note(9 downto 0);--------- oitava 
			 
			 
          WHEN OTHERS => lcd_bus <= "0000000010";
        END CASE;
    ELSE
        lcd_enable <= '0';
      END IF;
    END IF;
	 
  END PROCESS;
 
 
  proCESS(clk)
	begin
		case volume is
			when "0101111" => --0%
				vol_1 <= "1000100000";
				vol_0 <= "1000100000";		
			when "0110111" =>--10%
				vol_1 <= "1000100000";
				vol_0 <= "1000110001";			
			when "0111111" =>--20%
				vol_1 <= "1000100000";
				vol_0 <= "1000110010";
			when "1000111" =>--30%
				vol_1 <= "1000100000";
				vol_0 <= "1000110011";
			when "1001111" =>--40%
				vol_1 <= "1000100000";
				vol_0 <= "1000110100";
			when "1010111" =>--50%
				vol_1 <= "1000100000";
				vol_0 <= "1000110101";
			when "1011111" =>--60%
				vol_1 <= "1000100000";
				vol_0 <= "1000110110";
			when "1100111" =>--70%
				vol_1 <= "1000100000";
				vol_0 <= "1000110111";
			when "1101111" =>--80%
				vol_1 <= "1000100000";
				vol_0 <= "1000111000";
			when "1110111" =>--90%
				vol_1 <= "1000100000";
				vol_0 <= "1000111001";
			when "1111111" =>--100%
				vol_1 <= "1000110001";
				vol_0 <= "1000110000";
			when others => 
		end case;
	end process;
	


	process (nota)
	
		VARIABLE    cLK_count                              :  INTEGER RANGE 0 TO 2500000 := 0;
		variable		v_past_note                            : std_logic_vector(29 downto 0);
		variable		v_current_note                         : std_logic_vector(29 downto 0); 
		
		begin
		
		

				case state_2 is
				
					when s0=>
							v_past_note 		:= "100011101010001110101000111010";
							v_current_note    := "100011101010001110101000111010";
							state_2 <= s1;
					when s1=>
						 
						if (not(nota = "0000")) then
							state_2 <= s2;
						else
							state_2 <= s1;
						end if;
					when s2=>
							v_past_note := v_current_note;
							state_2 <= s3;
					when s3=>
							IF(clk_count < (2500000)) THEN    --wait 50 ms
								clk_count := clk_count + 1;
							ELSIF (nota /= "0000") then
								v_current_note := new_note;
								state_2 <= s4;
						   end if;
					when s4=>
						if (not(nota = "0000")) then
							state_2 <= s4;
						else
							state_2 <= s1;
						end if;
				end case;
			current_note <= v_current_note;
			past_note <= v_past_note;
		end process;


	with nota select
	new_note(29 downto 10) <= 
				"10001000001001000011" when "0001",
				"10010000111000100011" when "0010",
				"10001000001001000100" when "0011",
				"10010001001000100011" when "0100",
				"10001000001001000101" when "0101",
				"10001000001001000110" when "0110",
				"10010001101000100011" when "0111",
				"10001000001001000111" when "1000",
				"10010001111000100011" when "1001",
				"10001000001001000001" when "1010",
				"10010000011000100011" when "1011",
				"10001000001001000010" when "1100",
				"10001000001000100000" when others;
	
	with oitava select
	new_note(9 downto 0) <=
					"1000110011" when "001",
					"1000110100" when "010",
					"1000110101" when "011",
					"1000110110" when "100",
					"1000110111" when "101",
					"1000100000" when others;
	
		

	with on_off select
	on_off_1(9 downto 0) <= 
				"1001000110" when '0',
				"1001001110" when others;
	with on_off select
	on_off_0(9 downto 0) <= 
				"1001000110" when '0',
				"1000100000" when others;			
END behavior;