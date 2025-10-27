# --- Configuração do Projeto ---

# Lista de todos os arquivos VHDL que compõem o processador.
# A ordem pode importar: componentes básicos (como reg16bits) vêm antes.
# --- Configuração do Projeto ---

# CORREÇÃO AQUI: maq_estados não tem dependências
VHDL_COMPONENTS = 

# CORREÇÃO AQUI: O componente a testar
VHDL_TOP = maq_estados.vhd

# CORREÇÃO AQUI: O testbench dele
TB_SOURCE = maq_estados_tb.vhd

# CORREÇÃO AQUI: A entidade do testbench
TB_ENTITY = maq_estados_tb

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
# O '&' no final roda o gtkwave em background
view: $(WAVE)
	@echo ">>> Abrindo o GTKWave..."
	@echo "    Arquivo de onda: $(WAVE)"
	@echo "    Arquivo de sinais: $(GTKWAVE_SAVE)"
	gtkwave $(WAVE) --save=$(GTKWAVE_SAVE) &

# Alvo para simular e já abrir o visualizador
all: simular view

# Alvo para limpar o diretório de arquivos gerados
clean:
	@echo ">>> Limpando arquivos de compilação e simulação..."
	ghdl --clean
	rm -f $(WAVE)