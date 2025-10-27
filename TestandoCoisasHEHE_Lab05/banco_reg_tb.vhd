library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg_tb is
end entity;

architecture a_banco_reg_tb of banco_reg_tb is
    component banco_reg is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            addr_r   : in unsigned(2 downto 0);
            addr_w   : in unsigned(2 downto 0);
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    -- Sinais do Testbench (template do Lab 3)
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, rst : std_logic;
    
    -- ===================================================================
    -- CORREÇÃO 1: Inicializar todos os sinais de entrada do UUT
    -- ===================================================================
    signal wr_en_s  : std_logic := '0';
    signal addr_r_s : unsigned(2 downto 0) := (others => '0');
    signal addr_w_s : unsigned(2 downto 0) := (others => '0');
    signal data_in_s  : unsigned(15 downto 0) := (others => '0');
    signal data_out_s : unsigned(15 downto 0);
    -- ===================================================================

begin
    -- Instância
    uut: banco_reg port map (
        clk=>clk, rst=>rst, wr_en=>wr_en_s, addr_r=>addr_r_s, 
        addr_w=>addr_w_s, data_in=>data_in_s, data_out=>data_out_s
    );

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

    -- ===================================================================
    -- CORREÇÃO 2: Processo de teste síncrono (sem race condition)
    -- ===================================================================
    test_vectors: process
    begin
        -- Espera o reset terminar (o rst='0' acontece em 200ns)
        wait until rst = '0';
        
        -- Sincroniza com a primeira borda de SUBIDA após o reset
        wait until rising_edge(clk); -- t = 250ns
        
        -- 1. Escreve 50 no R3
        wr_en_s <= '1';
        addr_w_s <= "011"; -- R3
        data_in_s <= "0000000000110010"; -- 50
        
        -- Espera a próxima borda de subida (aqui é que a escrita acontece)
        wait until rising_edge(clk); -- t = 350ns
        
        -- 2. Escreve 120 no R5
        -- (wr_en_s continua '1')
        addr_w_s <= "101"; -- R5
        data_in_s <= "0000000001111000"; -- 120

        -- Espera a próxima borda de subida (aqui é que a escrita acontece)
        wait until rising_edge(clk); -- t = 450ns
        
        -- 3. Desliga escrita. Lê R3
        wr_en_s <= '0';
        addr_r_s <= "011"; -- R3
        
        -- Espera um pouco para ver o MUX de leitura funcionar
        -- (A leitura é combinacional, deve ser imediata)
        wait for period_time/4; -- t = 475ns
        -- (No GTKWave: data_out_s DEVE ser 50 agora)
        
        -- 4. Lê R5
        addr_r_s <= "101"; -- R5
        wait for period_time/4; -- t = 500ns
        -- (No GTKWave: data_out_s DEVE ser 120 agora)

        -- 5. Lê R0 (deve ser 0, pois foi resetado e nunca escrito)
        addr_r_s <= "000"; -- R0
        wait for period_time; -- t = 600ns
        -- (No GTKWave: data_out_s DEVE ser 0 agora)
        
        finished <= '1';
        wait;
    end process test_vectors;
    -- ===================================================================
    
end architecture;