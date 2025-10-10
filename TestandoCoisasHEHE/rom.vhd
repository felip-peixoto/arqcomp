library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(16 downto 0) 
   );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned (16 downto 0);
    constant conteudo_rom : mem := (
        0   => "00001111000011111",
        1   => "10101010101010101",
        2   => "11111111111111111",
        37  => "11111111111000000",
        99  => "00000000000111111",
        127 => "11110000000000000",
        others => (others => '0')
    );

begin 
    process(clk)
    begin 
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;