library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
port(
    clk, rst: in std_logic
);
end entity;

architecture a_processador of processador is
    component maq_estados is
        port( 
            clk,rst: in std_logic;
            estado: out unsigned(1 downto 0) );
    end component;
    
    component pc is
        port ( 
            clk, rst, wr_en: in std_logic;
            data_in: in unsigned(6 downto 0);
            data_out: out unsigned(6 downto 0) );
    end component;
    
    component rom is
        port( 
            clk: in std_logic;
            endereco: in unsigned(6 downto 0);
            dado: out unsigned(16 downto 0) );
    end component;

    component reg_instr is
        port( 
            clk, rst, wr_en: in std_logic;
            data_in: in unsigned(16 downto 0);
            data_out: out unsigned(16 downto 0) );
    end component;

    component acumulador is
        port( 
            clk, rst, wr_en: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0) );
    end component;
    
    component banco_reg is
        port ( 
            clk, rst, wr_en: in std_logic;
            addr_r: in unsigned(2 downto 0);
            addr_w: in unsigned(2 downto 0);
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0) );
    end component;
    
    component ula is 
        port ( 
            entr_A, entr_B: in unsigned(15 downto 0);
            selec_op: in unsigned(1 downto 0);
            carry, overflow, zero, sinal: out std_logic;
            saida: out unsigned(15 downto 0) );
    end component;

    signal s_estado   : unsigned(1 downto 0);
    signal s_pc_out   : unsigned(6 downto 0);
    signal s_pc_in    : unsigned(6 downto 0);
    signal s_rom_out  : unsigned(16 downto 0);
    signal s_ir_out   : unsigned(16 downto 0);

    signal s_acc_out  : unsigned(15 downto 0);
    signal s_acc_in   : unsigned(15 downto 0);
    signal s_regbank_out : unsigned(15 downto 0);
    signal s_regbank_in  : unsigned(15 downto 0);
    signal s_ula_out  : unsigned(15 downto 0);
    signal s_ula_A    : unsigned(15 downto 0);
    signal s_ula_B    : unsigned(15 downto 0);

    signal s_opcode   : unsigned(3 downto 0);
    signal s_reg_d    : unsigned(2 downto 0);
    signal s_reg_s    : unsigned(2 downto 0);
    signal s_imediato : unsigned(6 downto 0);
    signal s_imediato_16bit: unsigned(15 downto 0);

    signal s_pc_wr_en, s_ir_wr_en, s_acc_wr_en, s_regbank_wr_en : std_logic;
    signal s_sel_op_ula : unsigned(1 downto 0);
    signal s_sel_mux_acc : std_logic;
    signal s_sel_mux_regbank : std_logic; 

begin
    maquina_de_estados: maq_estados port map (
        clk => clk, rst => rst, estado => s_estado
    );

    program_counter: pc port map (
        clk => clk, rst => rst, wr_en => s_pc_wr_en,
        data_in => s_pc_in, data_out => s_pc_out
    );

    memoria_rom: rom port map (
        clk => clk, endereco => s_pc_out, dado => s_rom_out
    );

    registrador_de_instrucao: reg_instr port map (
        clk => clk, rst => rst, wr_en => s_ir_wr_en,
        data_in => s_rom_out, data_out => s_ir_out
    );

    instancia_acumulador: acumulador port map (
        clk => clk, rst => rst, wr_en => s_acc_wr_en,
        data_in => s_acc_in, data_out => s_acc_out
    );

    banco_de_registradores: banco_reg port map (
        clk => clk, rst => rst, wr_en => s_regbank_wr_en,
        addr_r => s_reg_s,  
        addr_w => s_reg_d,  
        data_in => s_regbank_in,
        data_out => s_regbank_out
    );

    Inst_ULA: ula port map (
        entr_A => s_ula_A, entr_B => s_ula_B,
        selec_op => s_sel_op_ula, saida => s_ula_out,
        carry => open, overflow => open, zero => open, sinal => open
    );
    s_opcode   <= s_ir_out(16 downto 13);
    s_reg_d    <= s_ir_out(12 downto 10);
    s_reg_s    <= s_ir_out(9 downto 7);
    s_imediato <= s_ir_out(6 downto 0);
    s_imediato_16bit <= "000000000" & s_imediato;
    s_ir_wr_en <= '1' when s_estado = "01" else '0';
    s_pc_wr_en <= '1' when s_estado = "10" else '0';
    s_acc_wr_en <= '1' when s_estado = "10" and 
                           (s_opcode = "0010" or  -- MOV A, R
                            s_opcode = "0100" or  -- ADD A, R
                            s_opcode = "0101" or  -- SUBI A, const
                            s_opcode = "0110")    -- SUB A, R
                   else '0';
                    
    s_regbank_wr_en <= '1' when s_estado = "10" and
                               (s_opcode = "0001" or  -- LD R, const
                                s_opcode = "0011")    -- MOV R, A
                       else '0';

    s_pc_in <= s_imediato when s_opcode = "1000" else -- Se for JMP, salta
               s_pc_out + 1;
               
    s_regbank_in <= s_acc_out when s_opcode = "0011" else  -- MOV R, A
                    s_imediato_16bit;                     -- LD R, const
    
    s_acc_in <= s_regbank_out when s_opcode = "0010" else  -- MOV A, R
                s_ula_out;                                -- ADD/SUBI
    
    s_ula_A <= s_acc_out;
    s_ula_B <= s_regbank_out when (s_opcode = "0100" or s_opcode = "0110") else  -- ADD A, R ou SUB A, R
           s_imediato_16bit;                     -- SUBI A, const
    
    s_sel_op_ula <= "01" when (s_opcode = "0101" or s_opcode = "0110") else -- SUBI ou SUB A, R
                "00";                             -- ADD A, R
end architecture;