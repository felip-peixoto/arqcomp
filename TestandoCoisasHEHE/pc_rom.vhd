library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_rom is
   port( 

   );
end entity;


architecture a_pc_rom of pc_rom is
    component rom is
        port( clk      : in std_logic;
             endereco : in unsigned(6 downto 0);
             dado     : out unsigned(16 downto 0) 
       );
    end component;

    component top_level_pc is
       port( clk     : in std_logic;
             rst      : in std_logic;
             wr_en    : in std_logic;
             data_o : out unsigned(6 downto 0)
       );
    end component;



end architecture;