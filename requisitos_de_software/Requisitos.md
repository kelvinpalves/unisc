# Requisitos do Sistema

## Módulo de Mapeamento de Vagas
	1.1 O sistema deve conter uma área para realizar o cadastro de vagas do condomínio.
		Cada vaga deve possuir as seguintes informações:
			Número da Vaga (Único)
			Tipo de Vaga 
				Vaga Particular
				Vaga Pública
				Vaga Residencial
			Latitude
			Longitude
	1.2 O sistema deverá conter um cadastro de áreas.
		Uma área é um local que contém n vagas.
		Exemplo:
			Condomínio X
				* Área A (15 Vagas, 5 Particulares, 3 Residências e 7 Públicas)
				* Área B (20 Vagas, ...)
				* Área C (10 Vagas, ...)
	1.3	O sistema deverá possuir um mapeamento das vagas exibindo o status de cada uma.
	1.4 O sistema deverá possuir totalizadores por área.
		Os totais deverão ser agrupados por tipo de vaga e situação (Livre/Ocupada).
## Módulo de Residências
	2.1 O sistema deve conter um cadastro de residências.
		Cada residência do condomínio deve possuir as seguintes informações:
			Número da Residência (Único)
			Responsável
			Veículos
	2.2 O sistema deve conter o cadastro de responsáveis pelas residências e veículos.
		Cada responsável deve conter as seguintes informações:
			Nome
			CPF
	2.3 O sistema deve conter o cadastro de veículos da residência.
		Cada veículo deverá conter as seguintes informações:
			Placa
			Marca/Modelo
			Cor 
			Tipo de Veículo
			Responsável (2.2)
			Vaga (1.1)
	2.4 Não é possível vincular veículos a vagas destinadas ao estacionamento rotativo.
## Controle de Estacionamento 
	3.1 Na entrada de veículos, deverá ser efetuada a leitura da placa para liberar o acesso.
	3.2 Caso o acesso seja liberado, deverá registrar no histórico os seguintes dados:
			Vaga
			Veículo 
			Data e Hora
			Tipo de Operação (Entrada de Veículo)
	3.3 Caso o acesso seja negado, o sistema deve verificar se existem vagas disponíveis para área de acesso solicitada pelo motorista.
	3.4 Caso ainda restam vagas disponíveis no setor público da área solicitada, o veículo deverá ser registrado como visitante e os dados informados no histórico.
		Os dados necessários são:
			Vaga 
			Veículo 
			Data e Hora 
			Tipo de Operação (Entrada de Veículo).
	3.5 Caso o tipo de vaga a ser ocupado for público, deverá iniciar um timer de utilização da vaga, permitindo por um número x de minutos.
	3.6 Caso um veículo exceda o tempo máximo estipulado, o responsável deverá ser contactado para regularizar a situação.
	3.7 Deverá ser cobrada taxa de estacionamento para veículos que excederem o tempo máximo estipulado.
	3.8 Na saída de veículos deverá ser efetuado o registro da ação no histórico.
		Os dados necessários são:
			Vaga 
			Veículo 
			Data e Hora 
			Tipo de Operação (Entrada de Veículo).
	3.9 Não deverá ser liberado a saída de veículos que possuem tarifas não regularizadas.
	3.10 O pagamento das tarifas poderá ser efetuado através de dinheiro ou cartão de crédito/débito.