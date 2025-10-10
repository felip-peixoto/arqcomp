library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        data_out : out std_logic
    );
end entity;

architecture a_maquina_estados of maquina_estados is
    signal estado : std_logic := '0';
begin
    process (clk, rst) 
    begin
        if rst = '1' then
            estado <= '0'; 
        elsif rising_edge(clk) then 
            estado <= not(estado);
        end if;
    end process;
    data_out <= estado;
end architecture;