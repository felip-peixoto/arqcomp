library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_reg16bits of reg16bits is
    -- CORREÇÃO AQUI: Inicializando o sinal interno
    signal registro : unsigned(15 downto 0) := (others => '0');
begin
    process (clk, rst) -- A lista de sensibilidade só precisa de clk e rst
    begin
        if rst = '1' then
            registro <= (others => '0');
        elsif rising_edge(clk) then
            if wr_en = '1' then
                registro <= data_in;
            end if;
        end if;
    end process;

    data_out <= registro;
end architecture;