library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is 
    port {
        entr_A : in unsigned(15 downto 0);
        entr_B : in unsigned(15 downto 0);
        selec_op : in unsigned(1 downto 0); --Escolher entre 4 operações (2 Bits)
        carry    : out std_logic;
        saida    : out unsigned(15 downto 0)
    };

end entity;

architecture arq of ula is
    signal op_soma : unsigned(15 downto 0);
    signal op_sub  : unsigned(15 downto 0);
    signal op_and  : unsigned(15 downto 0);
    signal op_or   : unsigned(15 downto 0);

    signal soma_carry : unsigned(16 downto 0); --Utilizaremos para encontrar o carry
begin 

    op_soma = entr_A +   entr_B;
    op_sub  = entr_A -   entr_B;
    op_and  = entr_A and entr_B;
    op_or   = entr_A or  entr_B;
 
    saida <= op_soma when selec_op = "00" else 
             op_sub  when selec_op = "01" else
             op_and  when selec_op = "10" else
             op_or   when selec_op = "11" else
             "0000000000000000";
    
    soma_extendida <= ('0' & entr_A) + ('0' & entr_B);

    carry <= soma_extendida(16) when selec_op = "00" else '0';

    
             

end architecture arq;
