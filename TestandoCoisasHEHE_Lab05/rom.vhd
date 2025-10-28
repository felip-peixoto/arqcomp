library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(16 downto 0) 
   );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned (16 downto 0);
    constant conteudo_rom : mem := (
        -- Formato: OPCODE(4b) | REG_D(3b) | REG_S(3b) | IMEDIATO(7b)
        
        -- A: LD R3, 5
        0   => B"0001_011_000_0000101",
        
        -- B: LD R4, 8
        1   => B"0001_100_000_0001000",
        
        -- C: (Loop H) R5 <= R3 + R4
        --    MOV A, R3
        2   => B"0010_000_011_0000000",
        --    ADD A, R4
        3   => B"0100_000_100_0000000",
        --    MOV R5, A
        4   => B"0011_101_000_0000000",
        
        -- D: R5 <= R5 - 1
        --    MOV A, R5
        5   => B"0010_000_101_0000000",
        --    SUBI A, 1
        6   => B"0101_000_000_0000001",
        --    MOV R5, A
        7   => B"0011_101_000_0000000",
        
        -- E: JMP 20
        8   => B"1000_000_000_0010100",
        
        -- F: LD R5, 0 (Nunca executa)
        9   => B"0001_101_000_0000000",

        -- Endereços 10-19 (NOP)
        10  => B"0000_000_000_0000000",
        11  => B"0000_000_000_0000000",
        12  => B"0000_000_000_0000000",
        13  => B"0000_000_000_0000000",
        14  => B"0000_000_000_0000000",
        15  => B"0000_000_000_0000000",
        16  => B"0000_000_000_0000000",
        17  => B"0000_000_000_0000000",
        18  => B"0000_000_000_0000000",
        19  => B"0000_000_000_0000000",
        
        -- G: (Endereço 20) MOV R3, R5
        --    MOV A, R5
        20  => B"0010_000_101_0000000",
        --    MOV R3, A
        21  => B"0011_011_000_0000000",
        
        -- H: JMP 2
        22  => B"1000_000_000_0000010",
        
        -- I: LD R3, 0 (Nunca executa)
        23  => B"0001_011_000_0000000",

        -- Preenche todo o resto da ROM (24-127) com NOP
        others => B"0000_000_000_0000000"
    );

begin 
    process(clk)
    begin 
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;