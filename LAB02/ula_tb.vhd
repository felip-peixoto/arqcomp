library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- A entidade do testbench é sempre vazia.
entity ula_tb is
end entity ula_tb;

architecture a_ula_tb of ula_tb is

    component ula is
        port (
            entr_A      : in unsigned(15 downto 0);
            entr_B      : in unsigned(15 downto 0);
            selec_op    : in unsigned(1 downto 0);
            carry       : out std_logic;
            overflow    : out std_logic;
            zero        : out std_logic;
            sinal       : out std_logic;
            saida       : out unsigned(15 downto 0)
        );
    end component ula;

    signal s_entr_A   : unsigned(15 downto 0) := (others => '0');
    signal s_entr_B   : unsigned(15 downto 0) := (others => '0');
    signal s_selec_op : unsigned(1 downto 0) := "00";
    signal s_carry    : std_logic;
    signal s_overflow : std_logic;
    signal s_zero     : std_logic;
    signal s_sinal    : std_logic;
    signal s_saida    : unsigned(15 downto 0);

    constant periodo : time := 20 ns;

begin

    -- 3. Instanciar o componente (Unit Under Test - UUT)
    uut: ula port map (
        entr_A      => s_entr_A,
        entr_B      => s_entr_B,
        selec_op    => s_selec_op,
        carry       => s_carry,
        overflow    => s_overflow,
        zero        => s_zero,
        sinal       => s_sinal,
        saida       => s_saida
    );

    -- 4. Processo que gera os estímulos para testar a ULA
    stimulus_process: process
    begin
        -- === TESTES DE SOMA (selec_op = "00") ===
        s_selec_op <= "00";
        
        -- Teste 1: Soma simples (5 + 10 = 15)
        s_entr_A <= to_unsigned(5, 16);
        s_entr_B <= to_unsigned(10, 16);
        wait for periodo;

        -- Teste 2: Teste de Carry (FFFF + 1 = 0, com carry)
        s_entr_A <= x"FFFF";
        s_entr_B <= x"0001";
        wait for periodo;
        
        -- Teste 3: Teste de Overflow (7000 + 7000, tratando como números com sinal)
        s_entr_A <= x"7000";
        s_entr_B <= x"7000";
        wait for periodo;
        
        -- === TESTES DE SUBTRAÇÃO (selec_op = "01") ===
        s_selec_op <= "01";
        
        -- Teste 4: Subtração simples (100 - 40 = 60)
        s_entr_A <= to_unsigned(100, 16);
        s_entr_B <= to_unsigned(40, 16);
        wait for periodo;
        
        -- Teste 5: Teste do flag Zero (50 - 50 = 0)
        s_entr_A <= to_unsigned(50, 16);
        s_entr_B <= to_unsigned(50, 16);
        wait for periodo;
        
        -- Teste 6: Teste de Carry/Borrow (10 - 20 = FFF6, com borrow)
        s_entr_A <= to_unsigned(10, 16);
        s_entr_B <= to_unsigned(20, 16);
        wait for periodo;
        
        -- Teste 7: Teste de Overflow (7000 - 9000, tratando como números com sinal)
        s_entr_A <= x"7000";
        s_entr_B <= x"9000";
        wait for periodo;

        -- === TESTES DE OPERAÇÕES NÃO IMPLEMENTADAS ===
        -- Estes testes verificarão o que acontece quando uma operação indefinida é selecionada.
        -- É esperado que a saída fique "UUUU..." (não inicializada).
        
        -- Teste 8: Operação "10"
        s_selec_op <= "10";
        s_entr_A <= to_unsigned(123, 16);
        s_entr_B <= to_unsigned(45, 16);
        wait for periodo;
        
        -- Teste 9: Operação "11"
        s_selec_op <= "11";
        wait for periodo;

        -- Fim da simulação
        wait;
    end process stimulus_process;

end architecture a_ula_tb;