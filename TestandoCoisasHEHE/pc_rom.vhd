library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_rom is
   port( 
      clk      : in std_logic;
      rst      : in std_logic;
      wr_en    : in std_logic;
      data_out : out unsigned(6 downto 0);
      dado     : out unsigned(16 downto 0)
   );
end entity;


architecture a_pc_rom of pc_rom is
   component rom is
      port(
         clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(16 downto 0) 
      );
   end component;

   component top_level_pc is
      port( 
         clk     : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_o : out unsigned(6 downto 0)
      );
   end component;

   signal data_out_s : unsigned(6 downto 0);
begin 
   uut_rom : rom port map (
      clk      => clk,
      endereco => data_out_s,
      dado     => dado
   );

   uut_pc : top_level_pc port map (
      clk     => clk,
      rst      => rst,
      wr_en    => wr_en,
      data_o => data_out_s
   );

   data_out <= data_out_s;

end architecture;