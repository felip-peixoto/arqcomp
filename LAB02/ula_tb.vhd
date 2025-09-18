library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- A entidade do testbench é sempre vazia.
entity ula_tb is
end entity ula_tb;

architecture a_ula_tb of ula_tb is

    -- 1. Declarar o componente que vamos testar (sua ULA)
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

    -- 2. Criar sinais para conectar às portas do componente
    signal s_entr_A   : unsigned(15 downto 0) := (others => '0');
    signal s_entr_B   : unsigned(15 downto 0) := (others => '0');
    signal s_selec_op : unsigned(1 downto 0) := "00";
    signal s_carry    : std_logic;
    signal s_overflow : std_logic;
    signal s_zero     : std_logic;
    signal s_sinal    : std_logic;
    signal s_saida    : unsigned(15 downto 0);

    -- Constante para o tempo de cada teste
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
        -- ==========================================================
        -- === TESTES BÁSICOS (JÁ REALIZADOS) ===
        -- ==========================================================
        s_selec_op <= "00";
        s_entr_A <= to_unsigned(5, 16);
        s_entr_B <= to_unsigned(10, 16);
        wait for periodo;

        s_entr_A <= x"FFFF";
        s_entr_B <= x"0001";
        wait for periodo;
        
        s_entr_A <= x"7000";
        s_entr_B <= x"7000";
        wait for periodo;
        
        s_selec_op <= "01";
        s_entr_A <= to_unsigned(100, 16);
        s_entr_B <= to_unsigned(40, 16);
        wait for periodo;
        
        s_entr_A <= to_unsigned(50, 16);
        s_entr_B <= to_unsigned(50, 16);
        wait for periodo;
        
        s_entr_A <= to_unsigned(10, 16);
        s_entr_B <= to_unsigned(20, 16);
        wait for periodo;
        
        s_entr_A <= x"7000";
        s_entr_B <= x"9000";
        wait for periodo;

        s_selec_op <= "10";
        s_entr_A <= to_unsigned(123, 16);
        s_entr_B <= to_unsigned(45, 16);
        wait for periodo;
        
        s_selec_op <= "11";
        wait for periodo;

        -- ==========================================================
        -- === TESTES CRITERIOSOS (NEGATIVOS E CASOS DE CONTORNO) ===
        -- ==========================================================
        
        -- Teste 10: Maior positivo (7FFF) + 1. DEVE causar overflow.
        -- Expectativa: 7FFF + 1 = 8000 (menor negativo). Positivo + Positivo -> Negativo = Overflow.
        s_selec_op <= "00";
        s_entr_A <= x"7FFF";
        s_entr_B <= x"0001";
        wait for periodo;

        -- Teste 11: Menor negativo (8000) - 1. DEVE causar overflow.
        -- Expectativa: 8000 - 1 = 7FFF (maior positivo). Negativo - Positivo -> Positivo = Overflow.
        s_selec_op <= "01";
        s_entr_A <= x"8000";
        s_entr_B <= x"0001";
        wait for periodo;

        -- Teste 12: Um número mais seu negativo. DEVE resultar em zero.
        -- Vamos testar 100 + (-100). -100 em 16 bits C2 é 65436.
        s_selec_op <= "00";
        s_entr_A <= to_unsigned(100, 16);
        s_entr_B <= to_unsigned(65436, 16); -- 65436 é -100 em complemento de 2
        wait for periodo;

        -- Teste 13: Zero menos um número. DEVE resultar no negativo do número.
        -- Vamos testar 0 - 50. O resultado deve ser -50 (65486 ou FFC EH).
        s_selec_op <= "01";
        s_entr_A <= to_unsigned(0, 16);
        s_entr_B <= to_unsigned(50, 16);
        wait for periodo;

        -- Teste 14: -1 + Menor Negativo
        -- Expectativa: FFFF + 8000 = 17FFF. O resultado em 16 bits é 7FFF.
        -- Negativo + Negativo -> Positivo = Overflow.
        s_selec_op <= "00";
        s_entr_A <= x"FFFF"; -- -1
        s_entr_B <= x"8000"; -- -32768
        wait for periodo;

        -- Fim da simulação
        wait;
    end process stimulus_process;

end architecture a_ula_tb;