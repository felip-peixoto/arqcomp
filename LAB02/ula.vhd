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
    signal op_igual   : unsigned(15 downto 0);
    signal op_maior   : unsigned(15 downto 0);

    signal soma_extendida : unsigned(16 downto 0);
    signal sub_extendida  : unsigned(16 downto 0);
    signal carry_soma     : std_logic;
    signal overflow_soma  : std_logic;
    signal carry_sub      : std_logic;
    signal overflow_sub   : std_logic;
    signal sinal_saida : unsigned(15 downto 0); -- SINAL INTERNO ADICIONADO AQUII
begin 

    op_soma <= entr_A + entr_B;
    op_sub  <= entr_A - entr_B;

    soma_extendida <= ('0' & entr_A) + ('0' & entr_B);
    sub_extendida  <= ('0' & entr_A) - ('0' & entr_B);
 
    carry_soma    <= soma_extendida(16);
    overflow_soma <= '1' when (entr_A(15) = entr_B(15)) and (entr_A(15) /= op_soma(15)) else '0';


    carry_sub    <= not sub_extendida(16); 
    overflow_sub <= '1' when (entr_A(15) /= entr_B(15)) and (entr_B(15) = op_sub(15)) else '0';


    sinal_saida <= op_soma when selec_op = "00" else 
             op_sub  when selec_op = "01" else
             op_igual  when selec_op = "10" else
             op_maior   when selec_op = "11" else
             "0000000000000000";
    
    
    carry <= carry_soma when selec_op = "00" else
                  carry_sub  when selec_op = "01" else
                  '0'; 

    overflow <= overflow_soma when selec_op = "00" else
                     overflow_sub  when selec_op = "01" else
                     '0';

    sinal <= sinal_saida(15);
    
    zero <= '1' when sinal_saida = to_unsigned(0, 16) else '0';
    --Antes estava apenas comparando a saída, mas foi necessário adicionar
    --o to_unsigned para poder fazer a comparação corretamente(comparação entre
    --integer e unsigned)
    saida <= sinal_saida;

end architecture arq;
