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
        0   => "00000000000000000", -- nop
        1   => "11110001100011000", -- jump para 24
        2   => "00000000001111111", -- nunca roda
        20  => "00001111110001110", -- nop
        21  => "00000001110001111", -- mop
        22  => "00000101010101011", -- nop
        23  => "11111010000010100", -- jump para 20
        24  => "00001111111111111", -- nop
        25  => "11110000000010100", -- jump para 20
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