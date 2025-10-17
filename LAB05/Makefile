# =============================================================================
# Makefile para Simulação VHDL com GHDL
# Disciplina: Arquitetura de Computadores
# =============================================================================

# --- 1. Configuração do Projeto ---

# O nome da entidade TOP-LEVEL (seu processador)
ENTITY       := processador

# O nome da entidade do TESTBENCH (Lab 5 pede "processador_tb" )
TESTBENCH    := $(ENTITY)_tb

# O nome do arquivo de formas de onda gerado [cite: 403]
WAVEFILE     := $(TESTBENCH).ghw

# O nome do arquivo de configuração de sinais do GTKWave 
WAVECONFIG   := $(TESTBENCH).gtkw

# --- 2. Lista de Arquivos Fonte ---
#
# Adicione todos os seus arquivos .vhd do PROJETO (não o testbench)
# A ordem é importante: liste as dependências primeiro.
# (ex: 'registrador.vhd' deve vir antes de 'reg_banco.vhd' [cite: 183])
#
SOURCES := \
	registrador.vhd \
	ula.vhd \
	maq_estados.vhd \
	pc.vhd \
	rom.vhd \
	reg_banco.vhd \
	unidade_controle.vhd \
	$(ENTITY).vhd

# Arquivo fonte do testbench
TB_SOURCE := $(TESTBENCH).vhd


# --- 3. Comandos do GHDL ---
# Define os comandos de análise e simulação
GHDL_ANALYZE := ghdl -a
GHDL_RUN     := ghdl -r

# =============================================================================
# --- 4. Regras (Targets) ---
# =============================================================================

# Regra padrão: executada quando você digita apenas 'make'
# 'all' depende do arquivo de onda, então ele será criado.
.PHONY: all
all: $(WAVEFILE)
	@echo "Simulação concluída. Arquivo de onda gerado: $(WAVEFILE)"

# Regra para criar o arquivo de onda [cite: 403]
# 1. Depende de todos os arquivos VHDL.
# 2. Se qualquer arquivo VHDL mudou, executa as receitas:
# 3. Analisa (compila) todas as fontes[cite: 328, 645].
# 4. Executa (simula) o testbench para gerar o .ghw[cite: 401, 404].
$(WAVEFILE): $(SOURCES) $(TB_SOURCE)
	@echo "Analisando arquivos VHDL..."
	$(GHDL_ANALYZE) $(SOURCES) $(TB_SOURCE)
	@echo "Executando simulação..."
	$(GHDL_RUN) $(TESTBENCH) --wave=$(WAVEFILE)

# Regra para visualizar as formas de onda [cite: 408]
# 'make view'
# O '&' no final abre o GTKWave em background, liberando seu terminal.
.PHONY: view
view: $(WAVEFILE)
	@echo "Abrindo GTKWave..."
	gtkwave $(WAVEFILE) $(WAVECONFIG) &

# Regra para rodar tudo (simular e já abrir o visualizador)
# 'make run'
.PHONY: run
run: view

# Regra de limpeza: remove os arquivos gerados
# 'make clean'
.PHONY: clean
	@echo "Limpando arquivos gerados..."
	ghdl --clean
	rm -f *.ghw