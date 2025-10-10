library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_pc_tb is 
end entity;

architecture a_top_level_pc_tb of top_level_pc_tb is
    component top_level_pc is
        port(
        clk     : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_o : out unsigned(6 downto 0)
    );
    end component;

    signal clk_s     : std_logic := '0';
    signal rst_s     : std_logic := '1';
    signal wr_en_s   : std_logic := '1';

    signal data_o_s  : unsigned(6 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    pc_completo : top_level_pc port map (
        clk     => clk_s,
        rst      => rst_s,
        wr_en    => wr_en_s,
        data_o => data_o_s
    );

    clk_process : process
    begin
        loop
            clk_s <= '0';
            wait for CLK_PERIOD / 2;
            clk_s <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    teste_pc : process
    begin
        wait for 15 ns;
        rst_s <= '0';

        wait for 100 ns;

        wait;
    end process;

end architecture;