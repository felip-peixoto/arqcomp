library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle_tb is
end entity;

architecture a_un_controle_tb of un_controle_tb is

    component un_controle is
        port(
            clk         : in  std_logic;
            rst         : in  std_logic;
            data_out_pc : out unsigned(6 downto 0);
            dado_rom    : out unsigned(16 downto 0);
            estado_out  : out std_logic
        );
    end component;

    signal clk_s         : std_logic := '0';
    signal rst_s         : std_logic;
    signal data_out_pc_s : unsigned(6 downto 0);
    signal dado_rom_s    : unsigned(16 downto 0);
    signal estado_out_s  : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: un_controle port map(
        clk         => clk_s,
        rst         => rst_s,
        data_out_pc => data_out_pc_s,
        dado_rom    => dado_rom_s,
        estado_out  => estado_out_s
    );

    clk_process: process
    begin
        loop
            clk_s <= '0';
            wait for CLK_PERIOD / 2;
            clk_s <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stimulus_process: process
    begin
        rst_s <= '1';
        wait for 15 ns;
        rst_s <= '0';
        wait for 400 ns;
        wait;
    end process;

end architecture;
