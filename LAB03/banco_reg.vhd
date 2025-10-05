library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;                  
        addr_r   : in unsigned(2 downto 0);       
        addr_w   : in unsigned(2 downto 0);       
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)     
    );
end entity;

architecture a_banco_reg of banco_reg is
    component registrador is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal saida_r0, saida_r1, saida_r2, saida_r3, saida_r4, saida_r5, saida_r6 : unsigned(15 downto 0);
    
    signal wr_en_r0, wr_en_r1, wr_en_r2, wr_en_r3, wr_en_r4, wr_en_r5, wr_en_r6 : std_logic;

begin
    R0: registrador port map (clk=>clk, rst=>rst, wr_en=>wr_en_r0, data_in=>data_in, data_out=>saida_r0);
    R1: registrador port map (clk=>clk, rst=>rst, wr_en=>wr_en_r1, data_in=>data_in, data_out=>saida_r1);
    R2: registrador port map (clk=>clk, rst=>rst, wr_en=>wr_en_r2, data_in=>data_in, data_out=>saida_r2);
    R3: registrador port map (clk=>clk, rst=>rst, wr_en=>wr_en_r3, data_in=>data_in, data_out=>saida_r3);
    R4: registrador port map (clk=>clk, rst=>rst, wr_en=>wr_en_r4, data_in=>data_in, data_out=>saida_r4);
    R5: registrador port map (clk=>clk, rst=>rst, wr_en=>wr_en_r5, data_in=>data_in, data_out=>saida_r5);
    R6: registrador port map (clk=>clk, rst=>rst, wr_en=>wr_en_r6, data_in=>data_in, data_out=>saida_r6);

    wr_en_r0 <= '1' when wr_en = '1' and addr_w = "000" else '0';
    wr_en_r1 <= '1' when wr_en = '1' and addr_w = "001" else '0';
    wr_en_r2 <= '1' when wr_en = '1' and addr_w = "010" else '0';
    wr_en_r3 <= '1' when wr_en = '1' and addr_w = "011" else '0';
    wr_en_r4 <= '1' when wr_en = '1' and addr_w = "100" else '0';
    wr_en_r5 <= '1' when wr_en = '1' and addr_w = "101" else '0';
    wr_en_r6 <= '1' when wr_en = '1' and addr_w = "110" else '0';

    data_out <= saida_r0 when addr_r = "000" else
                saida_r1 when addr_r = "001" else
                saida_r2 when addr_r = "010" else
                saida_r3 when addr_r = "011" else
                saida_r4 when addr_r = "100" else
                saida_r5 when addr_r = "101" else
                saida_r6 when addr_r = "110" else
                "0000000000000000";

end architecture;
