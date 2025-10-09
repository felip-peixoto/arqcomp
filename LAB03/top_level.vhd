library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        clk              : in  std_logic;
        rst              : in  std_logic;
        constante_in     : in  unsigned(15 downto 0);
        selec_op_ula     : in  unsigned(1 downto 0);
        addr_reg_leitura : in  unsigned(2 downto 0);
        addr_reg_escrita : in  unsigned(2 downto 0);
        banco_wr_en      : in  std_logic;
        acc_wr_en        : in  std_logic;
        sel_mux_banco_in : in  std_logic;
        sel_mux_ula_B    : in  std_logic;
        carry_out        : out std_logic;
        overflow_out     : out std_logic;
        zero_out         : out std_logic;
        sinal_out        : out std_logic
    );
end entity;

architecture a_top_level of top_level is

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
    end component;

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

    component reg16bits is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal acc_out, ula_out, banco_out, banco_in, ula_in_B : unsigned(15 downto 0);

begin

    ACUMULADOR: reg16bits port map (
        clk      => clk,
        rst      => rst,
        wr_en    => acc_wr_en,
        data_in  => ula_out,
        data_out => acc_out
    );

    BANCO: banco_reg port map (
        clk      => clk,
        rst      => rst,
        wr_en    => banco_wr_en,
        addr_r   => addr_reg_leitura,
        addr_w   => addr_reg_escrita,
        data_in  => banco_in,
        data_out => banco_out
    );

    banco_in <= constante_in when sel_mux_banco_in = '0' else
                acc_out      when sel_mux_banco_in = '1' else
                (others => '0');

    ula_in_B <= banco_out    when sel_mux_ula_B = '0' else
                constante_in when sel_mux_ula_B = '1' else
                (others => '0');

    ULA_inst: ula port map (
        entr_A      => acc_out,
        entr_B      => ula_in_B,
        selec_op    => selec_op_ula,
        carry       => carry_out,
        overflow    => overflow_out,
        zero        => zero_out,
        sinal       => sinal_out,
        saida       => ula_out
    );

end architecture;