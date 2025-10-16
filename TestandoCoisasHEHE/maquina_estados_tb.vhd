library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end entity;

architecture a_maquina_estados_tb of maquina_estados_tb is
    component maquina_estados is 
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            estado: out std_logic
        );   
    end component; 

    signal clk_s      : std_logic := '0';
    signal rst_s      : std_logic := '0';
    signal data_out_s : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin 
    uut : maquina_estados port map(
        clk => clk_s,
        rst => rst_s,
        estado=> data_out_s
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

    rst_process : process
    begin 
        rst_s <= '1';
        wait for 15 ns;
        rst_s <= '0'; 
        wait for 100 ns; 
        wait;
    end process;
end architecture;