library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_com_ula is
    port (
        clk              : in  std_logic;
        rst              : in  std_logic;
        constante_in     : in  unsigned(15 downto 0); -- Para instruções LD e com imediatos
        op_ula     : in  unsigned(1 downto 0); 
        addr_reg_leitura : in  unsigned(2 downto 0); -- Endereço de leitura do banco
        addr_reg_escrita : in  unsigned(2 downto 0); -- Endereço de escrita no banco
        banco_wr_en      : in  std_logic;             -- Habilita escrita no banco (para LD, MOV)
        acc_wr_en        : in  std_logic;             -- Habilita escrita no acumulador (para ops da ULA)
        sel_mux_banco_in : in  std_logic;             -- MUX da entrada do banco: '0'->constante, '1'->acumulador
        sel_mux_ula_B    : in  std_logic;             -- MUX da entrada B da ULA: '0'->banco, '1'->constante

        -- Saídas de Flags da ULA
        carry_out        : out std_logic;
        overflow_out     : out std_logic;
        zero_out         : out std_logic;
        sinal_out        : out std_logic
    );
end entity;