library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados_tb is
end entity;

architecture a_maq_estados_tb of maq_estados_tb is
    component maq_estados is
       port( 
          clk,rst: in std_logic;
          estado: out unsigned(1 downto 0)
       );
    end component;

    -- Sinais do Testbench (template do Lab 3)
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, rst : std_logic;
    
    -- Sinais para conectar ao componente
    signal estado_s : unsigned(1 downto 0);

begin
    -- Instância
    uut: maq_estados port map (clk=>clk, rst=>rst, estado=>estado_s);

    -- Geração de Clock (baseado no Lab 3)
    clk_proc: process
    begin
        while finished = '0' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    -- Geração de Reset (baseado no Lab 3)
    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- Segura o reset por 2 ciclos
        rst <= '0';
        wait;
    end process reset_global;

    -- Processo de tempo total (baseado no Lab 3)
    sim_time_proc: process
    begin
        wait for 10 us; -- Tempo total da simulação
        finished <= '1';
        wait;
    end process sim_time_proc;
    
end architecture;