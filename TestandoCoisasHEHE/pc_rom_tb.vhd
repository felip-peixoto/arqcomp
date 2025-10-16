library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_rom_tb is
end entity;

architecture a_pc_rom_tb of pc_rom_tb is 
    component pc_rom is
       port( 
          clk      : in std_logic;
          rst      : in std_logic;
          wr_en    : in std_logic;
          data_out : out unsigned(6 downto 0);
          dado     : out unsigned(16 downto 0)
       );
    end component;

    signal clk_s      : std_logic := '0';
    signal rst_s      : std_logic := '0';
    signal wr_en_s    : std_logic := '0';
    signal data_out_s : unsigned(6 downto 0);
    signal dado_s     : unsigned(16 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
begin
    uut : pc_rom port map (
        clk      => clk_s,
        rst      => rst_s,
        wr_en    => wr_en_s,
        data_out => data_out_s,
        dado     => dado_s
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

    
    stimulus_process : process
    begin
        rst_s   <= '1';
        wr_en_s <= '1';
        wait for 15 ns; 

        rst_s <= '0';

        wait for 200 ns;

        wait;
    end process;

end architecture;