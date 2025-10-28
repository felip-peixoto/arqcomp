# --- Configuração do Projeto ---

# Lista de todos os arquivos VHDL que compõem o processador.
# (Todos os "tijolos" que o processador.vhd utiliza)
VHDL_COMPONENTS = reg16bits.vhd \
                  acumulador.vhd \
                  reg_instr.vhd \
                  pc.vhd \
                  maq_estados.vhd \
                  ula.vhd \
                  rom.vhd \
                  banco_reg.vhd

# Arquivo VHDL do "top-level" (o processador em si)
VHDL_TOP = processador.vhd

# Arquivo VHDL do testbench
TB_SOURCE = processador_tb.vhd

# Nome da ENTIDADE do testbench (o que vai ser executado)
TB_ENTITY = processador_tb

# --- Configuração dos Arquivos de Saída ---
WAVE = wave.ghw
GTKWAVE_SAVE = sinais.gtkw

# --- Alvos (Targets) ---

# Alvo padrão: roda a simulação
.DEFAULT_GOAL := simular

# Alvo para compilar e simular
simular: $(VHDL_COMPONENTS) $(VHDL_TOP) $(TB_SOURCE)
	@echo ">>> [1/3] Analisando arquivos VHDL..."
	ghdl -a $(VHDL_COMPONENTS) $(VHDL_TOP) $(TB_SOURCE)
	@echo ">>> [2/3] Elaborando o testbench: $(TB_ENTITY)..."
	ghdl -e $(TB_ENTITY)
	@echo ">>> [3/3] Rodando a simulação..."
	ghdl -r $(TB_ENTITY) --wave=$(WAVE)
	@echo ">>> Simulação concluída. Arquivo gerado: $(WAVE)"

# Alvo para visualizar as formas de onda
view: $(WAVE)
	@echo ">>> Abrindo o GTKWave..."
	gtkwave $(WAVE) --save=$(GTKWAVE_SAVE) &

# Alvo para simular e já abrir o visualizador
all: simular view

# Alvo para limpar o diretório de arquivos gerados
clean:
	@echo ">>> Limpando arquivos de compilação e simulação..."
	ghdl --clean
	rm -f $(WAVE)