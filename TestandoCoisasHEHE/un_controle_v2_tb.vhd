library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle_v2_tb is
end entity;

architecture a_un_controle_v2_tb of un_controle_v2_tb is

    -- 1. Declaração do componente (agora sem a porta wr_en)
    component un_controle is
        port(
            clk         : in  std_logic;
            rst         : in  std_logic;
            data_out_pc : out unsigned(6 downto 0);
            dado_rom    : out unsigned(16 downto 0);
            estado_out  : out std_logic
        );
    end component;

    -- 2. Sinais para conectar (o sinal wr_en_s foi removido)
    signal clk_s         : std_logic := '0';
    signal rst_s         : std_logic;
    signal data_out_pc_s : unsigned(6 downto 0);
    signal dado_rom_s    : unsigned(16 downto 0);
    signal estado_out_s  : std_logic;

    -- 3. Constante para o período do clock
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 4. Instanciação da UUT (agora sem a conexão wr_en)
    uut: un_controle port map(
        clk         => clk_s,
        rst         => rst_s,
        data_out_pc => data_out_pc_s,
        dado_rom    => dado_rom_s,
        estado_out  => estado_out_s
    );

    -- 5. Processo para gerar o clock contínuo
    clk_process: process
    begin
        loop
            clk_s <= '0';
            wait for CLK_PERIOD / 2;
            clk_s <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- 6. Processo de estímulo (agora sem a atribuição para wr_en_s)
    stimulus_process: process
    begin
        -- Início do teste: Ativar o reset.
        rst_s   <= '1';
        wait for 15 ns;

        -- Liberar o reset para o processador começar a executar.
        rst_s <= '0';

        -- Deixar a simulação rodar.
        wait for 400 ns;

        -- Fim do roteiro.
        wait;
    end process;

end architecture;