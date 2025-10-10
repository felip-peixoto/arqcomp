library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_pc is
    port(
        clk     : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_o : out unsigned(6 downto 0)
    );
end entity;

architecture a_top_level_pc of top_level_pc is 
    component pc is
       port( clk      : in std_logic;
             rst      : in std_logic;
             wr_en    : in std_logic;
             data_in  : in unsigned(6 downto 0);
             data_out : out unsigned(6 downto 0)
       );
    end component;

    component modulo_pc is
       port( data_in   : in unsigned(6 downto 0);
             data_out  : out unsigned(6 downto 0)
       );
    end component;

    signal data_out_pc : unsigned(6 downto 0);
    signal data_out_modulo : unsigned(6 downto 0);
    
begin 
    program_counter : pc port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en,
        data_in  => data_out_modulo,
        data_out => data_out_pc
    );

    incrementador : modulo_pc port map (
        data_in  => data_out_pc,
        data_out => data_out_modulo
    );

    data_o <= data_out_pc;
end architecture;                                           