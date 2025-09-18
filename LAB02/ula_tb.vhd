library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity ula_tb;

architecture tb of ula_tb is
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

    constant PERIODO : time := 20 ns;

begin
    UUT: ula port map (
        entr_A      => s_entr_A,
        entr_B      => s_entr_B,
        selec_op    => s_selec_op,
        carry       => s_carry,
        overflow    => s_overflow,
        zero        => s_zero,
        sinal       => s_sinal,
        saida       => s_saida
    );

    stimulus_proc: process
    begin
        --SOMA
        s_selec_op <= "00";

        -- Saida = 000F, Z = 0, SINAL = 0, CARRY = 0, OVERFLOW = 0
        s_entr_A <= to_unsigned(10, 16);
        s_entr_B <= to_unsigned(5, 16);
        wait for PERIODO;

        -- SAIDA = 0, Z = 1, SINAL = 0, CARRY = 1, OVERFLOW = 0
        s_entr_A <= x"FFFF";
        s_entr_B <= x"0001";
        wait for PERIODO;

        -- SAIDA = 8000, Z = 0, SINAL = 1, CARRY = 0, OVERFLOW = 1
        s_entr_A <= x"7FFF";
        s_entr_B <= x"0001";
        wait for PERIODO;

        --SUBTRACAO
        s_selec_op <= "01";

        -- SAIDA = 0, Z = 1, SINAL = 0, CARRY = 1, OVERFLOW = 0
        s_entr_A <= to_unsigned(50, 16);
        s_entr_B <= to_unsigned(50, 16);
        wait for PERIODO;

        -- SAIDA = FFF6, Z = 0, SINAL = 1, CARRY = 0, OVERFLOW = 0
        s_entr_A <= to_unsigned(10, 16);
        s_entr_B <= to_unsigned(20, 16);
        wait for PERIODO;
        
        -- SAIDA = 7FFF, Z = 0, SINAL = 0, CARRY = 1, OVERFLOW = 1
        s_entr_A <= x"8000"; -- Menor negativo (-32768)
        s_entr_B <= x"0001";
        wait for PERIODO;

        --AND
        s_selec_op <= "10";

        -- SAIDA = 0F00, Z = 0, SINAL = 0
        s_entr_A <= x"FFFF";
        s_entr_B <= x"0F00";
        wait for PERIODO;

        -- SAIDA = 0000, Z = 1, SINAL = 0
        s_entr_A <= x"F0F0";
        s_entr_B <= x"0F0F";
        wait for PERIODO;

        --OR
        s_selec_op <= "11";

        -- SAIDA = FFFF, Z = 0, SINAL = 1
        s_entr_A <= x"F0F0";
        s_entr_B <= x"0F0F";
        wait for PERIODO;

        -- SAIDA = ABCD, Z = 0, SINAL = 1
        s_entr_A <= x"ABCD";
        s_entr_B <= x"0000";
        wait for PERIODO;

        report "Simulacao concluida com !";
        wait;
    end process stimulus_proc;

end architecture tb;