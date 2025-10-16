library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle_v1_tb is
end entity;

architecture a_un_controle_v1_tb of un_controle_v1_tb is
    -- 1. Declarar o componente que será testado
    component un_controle is
        port(
            clk         : in  std_logic;
            rst         : in  std_logic;
            wr_en       : in  std_logic; -- Porta ainda existe, então precisamos conectá-la
            data_out_pc : out unsigned(6 downto 0);
            dado_rom    : out unsigned(16 downto 0);
            estado_out  : out std_logic
        );
    end component;

    -- 2. Sinais para conectar ao componente
    signal clk_s         : std_logic := '0';
    signal rst_s         : std_logic;
    signal wr_en_s       : std_logic; -- Sinal para a porta não utilizada
    signal data_out_pc_s : unsigned(6 downto 0);
    signal dado_rom_s    : unsigned(16 downto 0);
    signal estado_out_s  : std_logic;

    -- 3. Constante para o período do clock
    constant CLK_PERIOD : time := 10 ns;

begin
    -- 4. Instanciar o componente (UUT)un_controle
    uut: un_controle port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_s, -- Conectamos, mas seu valor não importa
        data_out_pc => data_out_pc_s,
        dado_rom    => dado_rom_s,
        estado_out  => estado_out_s
    );

    -- 5. Processo para gerar o clock
    clk_process: process
    begin
        loop
            clk_s <= '0';
            wait for CLK_PERIOD / 2;
            clk_s <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- 6. Processo para gerar os estímulos (o roteiro do teste)
    stimulus_process: process
    begin
        -- Início do teste: Ativar o reset.
        rst_s   <= '1';
        wr_en_s <= '0'; -- Amarrando a porta não utilizada a um valor conhecido.
        wait for 15 ns; -- Manter o reset por 1.5 ciclos de clock.

        -- Liberar o reset para o processador começar a operar.
        rst_s <= '0';

        -- Deixar a simulação rodar para observar vários ciclos de Fetch/Execute.
        wait for 200 ns;

        -- Fim do roteiro.
        wait;
    end process;

end architecture;