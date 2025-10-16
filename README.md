# arqcomp
ELEW30 - Arquitetura E Organização De Computadores

  --Características do BANCO DE REGISTRADORES do processador.

'Acumulador ou não': 'ULA com acumulador',
 'Número de registradores no banco': [7],
 'Carga de constantes': 'Carrega diretamente com LD sem somar',
 'ADD ops': 'ADD com dois operandos apenas',
 'SUB ops': 'Subtração com dois operandos apenas',
 'ADD ctes': 'ADD apenas entre registradores, nunca com constantes',
 'SUB ctes': 'Há instrução que subtrai uma constante'

  --Características para a UNIDADE DE CONTROLE do processador. 

Dados de sincronização de operações:
{'Largura da ROM / tamanho da instrução em bits': [17],
'Leitura da ROM': ['síncrona']}

  --Características para a CALCULADORA PROGRAMÁVEL.

Dados de sincronização de operações:
{'Registrador de Instruções': ['wr_en no segundo estado'],
 'Incremento do PC': ['PC sensível a clock de descida']}

Dados relativos ao lab #6:
{'Comparações': 'Comparação apenas com CMPI',
 'Saltos condicionais': ['BEQ', 'BVC']}

Os itens de condicionais (comparações, etc) são para quem quiser adiantar o serviço. Quaiquer dúvidas, preferencialmente me pergunte no lab, mas pode mandar email.

