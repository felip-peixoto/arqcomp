library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is 
    port (
        entr_A      : in unsigned(15 downto 0);
        entr_B      : in unsigned(15 downto 0);
        selec_op    : in unsigned(1 downto 0); --Escolher entre 4 operações (2 Bits)
        carry       : out std_logic;
        overflow    : out std_logic;
        zero        : out std_logic;
        sinal       : out std_logic;
        saida       : out unsigned(15 downto 0)
    );
end entity;

architecture arq of ula is
    signal op_soma    : unsigned(15 downto 0);
    signal op_sub     : unsigned(15 downto 0);
    signal op_and     : unsigned(15 downto 0);
    signal op_or      : unsigned(15 downto 0);

    --Possibilidade de adicionar novas operações no futuro
    --signal op_igual   : unsigned(15 downto 0); 
    --signal op_maior   : unsigned(15 downto 0);

    signal soma_extendida : unsigned(16 downto 0);
    signal sub_extendida  : unsigned(16 downto 0);
    signal carry_soma     : std_logic;
    signal overflow_soma  : std_logic;
    signal carry_sub      : std_logic;
    signal overflow_sub   : std_logic;

    signal saida_interna : unsigned(15 downto 0); --Não é possível utilizar a saída dentro de architecture, então temos que criar um sinal interno

begin 
    soma_extendida <= ('0' & entr_A) + ('0' & entr_B);
    sub_extendida  <= ('0' & entr_A) - ('0' & entr_B);

    op_soma <= soma_extendida(15 downto 0);
    op_sub  <= sub_extendida(15 downto 0);
    op_and <= entr_A and entr_B;
    op_or  <= entr_A or entr_B;

    carry_soma   <= soma_extendida(16);
    carry_sub    <= not sub_extendida(16); -- Quando carry = 1, não houve borrow. Ou seja, se carry_sub = 1, entr_A >= entr_B.

    --Overflow ocorre quando o sinal dos operandos são iguais entre si e o do resultado é diferente.
    overflow_soma <= '1' when (entr_A(15) = entr_B(15)) and (entr_A(15) /= op_soma(15)) else '0';
    overflow_sub  <= '1' when (entr_A(15) /= entr_B(15)) and (entr_B(15) = op_sub(15)) else '0';

    --Possibilidade de adicionar novas operações no futuro
    --op_igual <= "1111111111111111" when entr_A = entr_B else "0000000000000000";
    --op_maior <= "1111111111111111" when entr_A > entr_B else "0000000000000000";

    saida_interna <= op_soma  when selec_op = "00" else 
            op_sub   when selec_op = "01" else
            op_and when selec_op = "10" else
            op_or when selec_op = "11" else
            "0000000000000000";

    carry <= carry_soma when selec_op = "00" else
            carry_sub  when selec_op = "01" else
            '0'; 

    overflow <= overflow_soma when selec_op = "00" else
                overflow_sub  when selec_op = "01" else
                '0';

    sinal <= saida_interna(15);
    zero  <= '1' when saida_interna = 0 else '0';
    saida <= saida_interna;

end architecture;