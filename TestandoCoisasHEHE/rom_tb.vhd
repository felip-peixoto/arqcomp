library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is 
    component rom is
       port( clk      : in std_logic;
             endereco : in unsigned(6 downto 0);
             dado     : out unsigned(16 downto 0) 
       );
    end component;

    signal clk_s      : std_logic := '0';
    signal endereco_s : unsigned(6 downto 0) := (others => '0');
    signal dado_s     : unsigned(16 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;

begin
    uut : rom port map (
        clk      => clk_s,
        endereco => endereco_s,
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

    stim_process : process
    begin
        for i in 0 to 127 loop
            endereco_s <= to_unsigned(i, 7);
            wait for CLK_PERIOD;
        end loop;
        
        wait;
    end process;

end architecture;