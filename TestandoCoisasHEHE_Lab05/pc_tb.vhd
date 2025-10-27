library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity;

architecture a_pc_tb of pc_tb is
    component pc is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    -- Sinais do Testbench
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, rst : std_logic;
    
    -- Sinais para conectar ao componente
    signal wr_en_s  : std_logic;
    signal data_in_s  : unsigned(6 downto 0);
    signal data_out_s : unsigned(6 downto 0);

begin
    -- Instância do PC (Unit Under Test)
    uut: pc port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en_s,
        data_in  => data_in_s,
        data_out => data_out_s
    );

    -- Geração de Clock (baseado no Lab 3) [cite: 845-853]
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

    -- Geração de Reset (baseado no Lab 3) [cite: 835-840]
    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- Segura o reset por 2 ciclos
        rst <= '0';
        wait;
    end process reset_global;

    -- Processo de Teste (Casos de Teste)
    test_vectors: process
    begin
        -- 1. Espera o reset terminar
        wait until rst = '0';
        wait for period_time/4; -- Alinha com o meio do ciclo
        
        -- 2. Teste: Tenta escrever com wr_en='0'
        wr_en_s <= '0';
        data_in_s <= "0000101"; -- Valor 5
        wait for period_time; -- Espera um ciclo (subida E descida)
        -- (No GTKWave, data_out_s deve continuar "0000000")

        -- 3. Teste: Tenta escrever com wr_en='1'
        wr_en_s <= '1';
        data_in_s <= "0001110"; -- Valor 14
        
        -- *** O TESTE DO FALLING EDGE ESTÁ AQUI ***
        -- Espera ATÉ A BORDA DE SUBIDA (meio ciclo)
        wait for period_time/2; 
        -- (No GTKWave, data_out_s AINDA deve ser "0000000")
        
        -- Espera ATÉ A BORDA DE DESCIDA (meio ciclo)
        wait for period_time/2; 
        -- (No GTKWave, data_out_s AGORA deve mudar para "0001110")

        -- 4. Teste: Trava o valor (wr_en='0')
        wr_en_s <= '0';
        data_in_s <= "1111111"; -- Valor 127
        wait for period_time;
        -- (No GTKWave, data_out_s deve continuar "0001110")

        -- Fim da simulação
        finished <= '1';
        wait;
    end process test_vectors;

    -- Processo de tempo total (baseado no Lab 3) [cite: 841-844]
    sim_time_proc: process
    begin
        wait for 10 us; -- Tempo total da simulação
        finished <= '1';
        wait;
    end process sim_time_proc;
    
end architecture;