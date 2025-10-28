library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
    
    -- 1. Componente: O seu processador inteiro
    component processador is
        port( clk, rst: in std_logic );
    end component;

    -- 2. Sinais do Testbench (baseado no template do Lab 3)
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, rst : std_logic;
    
begin
    -- 3. Instância do Processador (Unidade Sob Teste)
    uut: processador port map (
        clk => clk, 
        rst => rst
    );

    -- 4. Processo de Geração de Clock
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

    -- 5. Processo de Geração de Reset
    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- Segura o reset por 2 ciclos
        rst <= '0';
        wait;
    end process reset_global;

    -- 6. Processo de Duração da Simulação
    sim_time_proc: process
    begin
        -- Deixa a simulação rodar por 50 micro-segundos
        -- para dar tempo de ver o loop do programa
        wait for 50 us; 
        finished <= '1';
        wait;
    end process sim_time_proc;
    
end architecture;