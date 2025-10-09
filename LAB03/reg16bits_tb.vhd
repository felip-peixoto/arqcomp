library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end entity;

architecture a_reg16bits_tb of reg16bits_tb is

    -- 1. Declaração do componente a ser testado
    component reg16bits is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- 2. Sinais para conectar ao componente
    signal clk_s      : std_logic := '0';
    signal rst_s      : std_logic;
    signal wr_en_s    : std_logic;
    signal data_in_s  : unsigned(15 downto 0);
    signal data_out_s : unsigned(15 downto 0);

    -- Constante para o período do clock (facilita a manutenção)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 3. Instanciação do componente (Unit Under Test - UUT)
    uut : reg16bits
        port map (
            clk      => clk_s,
            rst      => rst_s,
            wr_en    => wr_en_s,
            data_in  => data_in_s,
            data_out => data_out_s
        );

    -- 4. Processo para gerar o clock
    clk_process : process
    begin
        clk_s <= '0';
        wait for CLK_PERIOD / 2;
        clk_s <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- 5. Processo de estímulos para testar os cenários
    stimulus_process : process
    begin
        -- Cenário 1: Reset inicial
        -- O registrador deve começar em zero.
        report "Cenário 1: Testando o Reset inicial.";
        rst_s <= '1';
        wr_en_s <= '0'; -- Não importa, reset tem prioridade
        data_in_s <= x"AAAA"; -- Valor arbitrário na entrada
        wait for CLK_PERIOD * 2; -- Espera 2 clocks com reset ativo

        -- Cenário 2: Primeira escrita
        -- Após desativar o reset, na primeira borda de subida com wr_en='1', 
        -- o dado deve ser escrito.
        report "Cenário 2: Testando a primeira escrita.";
        rst_s <= '0';
        wr_en_s <= '1';
        data_in_s <= x"1234";
        wait for CLK_PERIOD; -- Espera a próxima borda de subida

        -- Cenário 3: Manter o valor (Hold)
        -- Com wr_en='0', o valor não deve mudar, mesmo com a entrada mudando.
        report "Cenário 3: Testando a retenção de dados (wr_en = '0').";
        wr_en_s <= '0';
        data_in_s <= x"FFFF"; -- Muda a entrada, mas a saída não deve mudar
        wait for CLK_PERIOD * 2; -- Espera 2 clocks para garantir

        -- Cenário 4: Segunda escrita
        -- Habilita a escrita novamente para um novo valor.
        report "Cenário 4: Testando uma segunda escrita.";
        wr_en_s <= '1';
        data_in_s <= x"C0DE";
        wait for CLK_PERIOD;

        -- Cenário 5: Reset assíncrono durante a operação
        -- O reset deve zerar a saída imediatamente.
        report "Cenário 5: Testando o reset assíncrono.";
        rst_s <= '1';
        wait for CLK_PERIOD / 2; -- Meio ciclo para mostrar que é imediato
        rst_s <= '0';
        
        report "Fim da simulação.";
        wait; -- Fim do processo, para a simulação [cite: 148]
    end process;

end architecture;