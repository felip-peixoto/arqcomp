library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity;

architecture a_top_level_tb of top_level_tb is

    -- 1. Declaração do componente
    component top_level is
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
    end component;

    -- 2. Sinais de controle e dados
    signal clk_s              : std_logic := '0';
    signal rst_s              : std_logic := '1'; -- Já começa em reset
    signal constante_in_s     : unsigned(15 downto 0) := (others => '0');
    signal selec_op_ula_s     : unsigned(1 downto 0) := "00";
    signal addr_reg_leitura_s : unsigned(2 downto 0) := "000";
    signal addr_reg_escrita_s : unsigned(2 downto 0) := "000";
    signal banco_wr_en_s      : std_logic := '0';
    signal acc_wr_en_s        : std_logic := '0';
    signal sel_mux_banco_in_s : std_logic := '0';
    signal sel_mux_ula_B_s    : std_logic := '0';

    -- Sinais de saída não precisam de inicialização
    signal carry_out_s        : std_logic;
    signal overflow_out_s     : std_logic;
    signal zero_out_s         : std_logic;
    signal sinal_out_s        : std_logic;

    constant CLK_PERIOD : time := 10 ns;

    -- Códigos de operação da ULA
    constant ULA_ADD : unsigned(1 downto 0) := "00";
    constant ULA_SUB : unsigned(1 downto 0) := "01";
    constant ULA_AND : unsigned(1 downto 0) := "10";
    constant ULA_OR  : unsigned(1 downto 0) := "11";

begin

    -- 3. Instanciação do UUT
    uut : top_level port map (
        clk              => clk_s,
        rst              => rst_s,
        constante_in     => constante_in_s,
        selec_op_ula     => selec_op_ula_s,
        addr_reg_leitura => addr_reg_leitura_s,
        addr_reg_escrita => addr_reg_escrita_s,
        banco_wr_en      => banco_wr_en_s,
        acc_wr_en        => acc_wr_en_s,
        sel_mux_banco_in => sel_mux_banco_in_s,
        sel_mux_ula_B    => sel_mux_ula_B_s,
        carry_out        => carry_out_s,
        overflow_out     => overflow_out_s,
        zero_out         => zero_out_s,
        sinal_out        => sinal_out_s
    );

    -- 4. Processo de Clock
    clk_process : process begin
        clk_s <= '0'; wait for CLK_PERIOD / 2;
        clk_s <= '1'; wait for CLK_PERIOD / 2;
    end process;

    -- 5. Processo de Estímulos (simulando um programa)
    stimulus_process : process
    begin
        
        rst_s <= '1';
        wait for CLK_PERIOD * 2;
        rst_s <= '0';
        banco_wr_en_s <= '0'; acc_wr_en_s <= '0';
        wait for CLK_PERIOD;
        
        -- SIMULANDO: LD R1, #25 (Carrega 25 em R1)
        
        constante_in_s     <= to_unsigned(25, 16);
        addr_reg_escrita_s <= "001";
        sel_mux_banco_in_s <= '0';
        banco_wr_en_s      <= '1';
        wait for CLK_PERIOD;
        banco_wr_en_s      <= '0';

        constante_in_s     <= to_unsigned(0, 16);
        sel_mux_ula_B_s    <= '1';
        selec_op_ula_s     <= ULA_SUB;
        acc_wr_en_s        <= '1';
        wait for CLK_PERIOD;
        acc_wr_en_s        <= '0';

       
        addr_reg_leitura_s <= "001";
        sel_mux_ula_B_s    <= '0';
        selec_op_ula_s     <= ULA_ADD;
        acc_wr_en_s        <= '1';
        wait for CLK_PERIOD;
        acc_wr_en_s        <= '0';

        
        addr_reg_escrita_s <= "010";
        sel_mux_banco_in_s <= '1';
        banco_wr_en_s      <= '1';
        wait for CLK_PERIOD;
        banco_wr_en_s      <= '0';
        
        addr_reg_leitura_s <= "001"; 
        sel_mux_ula_B_s    <= '0';     
        selec_op_ula_s     <= ULA_ADD; 
        acc_wr_en_s        <= '1'; 
        wait for CLK_PERIOD;
        acc_wr_en_s        <= '0'; 
        wait;
    end process;

end architecture;