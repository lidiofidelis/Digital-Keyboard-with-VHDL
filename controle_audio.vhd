library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_audio is
	port(
		ENDERECOS_I2C	 : in std_logic_vector(3 downto 0);
		DADOS_I2C		 : out std_logic_vector(15 downto 0);
		INCREMENTO_AUDIO: out std_logic_vector(4 downto 0);
		TAXA_AMOSTRAGEM : out std_logic_vector(16 downto 0);
		oitava			 :	in std_logic_vector(2 downto 0);
		volume			 :	in std_logic_vector(6 downto 0);
		clk				 : in std_logic
	);end controle_audio;
	
architecture behavior of controle_audio is
	signal aux_i2c	: integer range 0 to 15;
	signal aux_incremento : integer range 0 to 16;
begin

	aux_i2c <= to_integer(unsigned(ENDERECOS_I2C));
	TAXA_AMOSTRAGEM <= std_logic_vector(to_unsigned(96000,17));
	
	with oitava select
		INCREMENTO_AUDIO	<= "00001"	when	"001",
									"00010"	when	"010",
									"00100"	when	"011",
									"01000"	when  "100",
									"10000"	when	"101",
									"00000"	when others;



	process(clk)
		begin
			case aux_i2c is
				when 0 =>
					DADOS_I2C <= "0001001000011110"; -- taxa de amostragem 96000
				when 1 =>
					DADOS_I2C <= "0000111000000010";	-- amplitude 16 bits
				when 2 =>
					DADOS_I2C <= "000001000"&volume; -- canal esquerdo
				when 3 =>
					DADOS_I2C <= "000001100"&volume; -- canal direito
				when others =>
					DADOS_I2C <= "0000000000000000";
			end case;
		end process; 

			
			
end behavior;