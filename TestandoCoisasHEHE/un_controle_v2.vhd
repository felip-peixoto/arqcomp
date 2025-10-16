library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
    port(
        clk         : in  std_logic;
        rst         : in  std_logic;
        data_out_pc : out unsigned(6 downto 0);
        dado_rom    : out unsigned(16 downto 0);
        estado_out  : out std_logic
    );
end entity;

architecture a_un_controle of un_controle is
    -- Declaração dos componentes exatamente como nas suas entidades
    component rom is
       port( clk      : in std_logic;
             endereco : in unsigned(6 downto 0);
             dado     : out unsigned(16 downto 0)
       );
    end component;

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

    component maquina_estados is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        estado   : out std_logic -- O nome da porta é 'estado'
    );
    end component;

    -- Sinais internos
    signal pc_out_s        : unsigned(6 downto 0);
    signal pc_next_s       : unsigned(6 downto 0);
    signal jump_en         : std_logic;
    signal entrada_do_pc   : unsigned(6 downto 0);
    signal estado_s        : std_logic;
    signal pc_wr_en_s      : std_logic;
    signal dado_rom_s      : unsigned(16 downto 0);
    signal instrucao_s     : unsigned(16 downto 0);
    signal opcode_s        : unsigned(3 downto 0);
    signal endereco_jump_s : unsigned(6 downto 0);

begin
    -- Lógica de Controle
    pc_wr_en_s <= '1' when estado_s = '1' else '0';

    -- Instanciação dos componentes
    maquina_de_estados: maquina_estados port map (
        clk    => clk,
        rst    => rst,
        estado => estado_s -- A porta 'estado' é conectada ao sinal 'estado_s'
    );

    program_counter: pc port map (
        clk      => clk,
        rst      => rst,
        wr_en    => pc_wr_en_s,
        data_in  => entrada_do_pc,
        data_out => pc_out_s
    );

    incrementador: modulo_pc port map (
        data_in  => pc_out_s,
        data_out => pc_next_s
    );

    memoria_rom: rom port map (
        clk      => clk,
        endereco => pc_out_s,
        dado     => dado_rom_s
    );

    -- Conexões de saída e lógica de decodificação
    data_out_pc <= pc_out_s;
    estado_out  <= estado_s;
    dado_rom    <= dado_rom_s;

    instrucao_s     <= dado_rom_s;
    opcode_s        <= instrucao_s(16 downto 13);
    endereco_jump_s <= instrucao_s(6 downto 0);

    jump_en <= '1' when opcode_s = "1111" else '0';

    entrada_do_pc <= endereco_jump_s when jump_en = '1' else pc_next_s;

end architecture;