library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity teclado is
	port(
		sel_nota		: 	in std_logic_vector(1 downto 0);
		sel_oitava	:	in std_logic_vector(3 downto 0);
		teclas		:	in std_logic_vector(3 downto 0);
		clk			:	in std_logic;
		nota			:	out std_logic_vector(3 downto 0);
		oitava		:	out std_logic_vector(2 downto 0)
	);end teclado;
	
architecture behavior of teclado is
	signal	aux_nota		: integer range 0 to 12;
begin

nota <= std_logic_vector(to_unsigned(aux_nota,4));

	process(clk)
		begin
			case sel_nota is
				when "00" =>
					if (teclas(3)='0') then			--C
						aux_nota <= 1;
					elsif(teclas(2)='0') then		--C#
						aux_nota<=2;
					elsif(teclas(1)='0') then		--D
						aux_nota<=3;
					elsif(teclas(0)='0') then		--D#
						aux_nota<=4;
					else
						aux_nota<=0;
					end if;
					
				when "01" =>
					if (teclas(3)='0') then			--E
						aux_nota <=5;
					elsif(teclas(2)='0') then		--F
						aux_nota<=6;
					elsif(teclas(1)='0') then		--F#
						aux_nota<=7;
					elsif(teclas(0)='0') then		--G
						aux_nota<=8;
					else
						aux_nota<=0;
					end if;
					
				when "11" =>
					if (teclas(3)='0') then			--G#
						aux_nota <=9;
					elsif(teclas(2)='0') then		--A
						aux_nota<=10;
					elsif(teclas(1)='0') then		--A#
						aux_nota<=11;
					elsif(teclas(0)='0') then		--B
						aux_nota<=12;
					else
						aux_nota<=0;
					end if;
					
				when others =>	aux_nota<=0;		--nenhuma nota
			end case;
		end process;
	
	with sel_oitava select
		oitava <=	"001"	when "0000",		--3ª oitava
						"010"	when "1000",		--4ª oitava
						"011"	when "1100",		--5ª oitava
						"100"	when "1110",		--6ª oitava
						"101"	when "1111",		--7ª oitava
						"000"	when others;		--nenhuma oitava
end behavior;