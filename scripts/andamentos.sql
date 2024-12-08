### ANDAMENTO DA ORDEM DE SERVIÇO:

# TABELA DE ANDAMENTO DE OS:
CREATE TABLE IF NOT EXISTS andamentos (
	`id_andamento` INT PRIMARY KEY AUTO_INCREMENT,
    `id_abertura` INT NOT NULL UNIQUE			,
    `dt_andamento` DATE NOT NULL				,
	`tecnico` INT								,

    CONSTRAINT `id_abertura` FOREIGN KEY (id_abertura) REFERENCES `aberturas`(id_abertura),
    CONSTRAINT `tecnico` FOREIGN KEY (tecnico) REFERENCES `usuarios`(id_usuario)
);

# RELACIONAMENTO 1:1 / ANDAMENTO X PEÇAS E SERVIÇOS:
CREATE TABLE IF NOT EXISTS executados (
	`id_andamento` INT NOT NULL	,
    `id_executado` INT			,
    `id_servico` INT			,
    `id_produto` INT			,
    `quantidade` INT			,
    `desconto` FLOAT			,
    `valor` FLOAT				,
    
    CONSTRAINT `id_andamento` FOREIGN KEY (`id_andamento`) REFERENCES `andamentos`(`id_andamento`),
    CONSTRAINT `id_servico` FOREIGN KEY (`id_servico`) REFERENCES `servicos`(`id_servico`),
    CONSTRAINT `id_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos`(`id_produto`)
);

# DADOS PARA GRID: ANDAMENTO
DELIMITER $$
CREATE PROCEDURE grid_andamento ( pesquisaIn VARCHAR(100) )
	BEGIN
		SELECT
			AN.`id_andamento`	,
			AB.`codigo`			,
            CL.`cliente`		,
            DATE_FORMAT(AN.`dt_andamento`,'%d/%m/%Y') as dt_andamento,
			(SELECT SUM((EX.`valor` - (EX.`valor` * EX.`desconto` / 100)) * EX.`quantidade`) FROM executados AS EX WHERE AN.`id_andamento` = EX.`id_andamento`) AS valor
		FROM andamentos AS AN
        LEFT JOIN aberturas AS AB ON AN.`id_abertura` = AB.`id_abertura`
        LEFT JOIN clientes AS CL ON AB.`id_cliente` = CL.`id_cliente`
		WHERE
			AB.`codigo` REGEXP pesquisaIn OR
            CL.`cliente` REGEXP pesquisaIn OR
            AN.`dt_andamento` REGEXP pesquisaIn OR
            (SELECT SUM(EX.`valor`) FROM executados AS EX WHERE AN.`id_andamento` = EX.`id_andamento`) REGEXP pesquisaIn;
	END $$
DELIMITER ;

# NOVO REGISTRO : PRINCIPAL
DELIMITER $$
CREATE PROCEDURE novo_andamento (
	`id_aberturaIn` INT,
    `dt_andamentoIn` DATE,
    `tecnicoIn` INT
    )
    BEGIN
		IF NOT EXISTS ( SELECT `id_andamento` FROM `andamentos` WHERE `id_abertura` = `id_aberturaIn` ) THEN
			INSERT INTO `andamentos` (
				`id_abertura`	, 
				`dt_andamento`	, 
				`tecnico`
            )
            VALUES (
				`id_aberturaIn`		, 
				`dt_andamentoIn`	, 
				`tecnicoIn`
            );
            UPDATE `aberturas` SET `status` = "Andamento" WHERE `id_abertura` = `id_aberturaIn`;
            SELECT LAST_INSERT_ID() AS id_andamento;
		ELSE
			SELECT "#ordem_servico" AS duplicado;
		END IF;
	END $$
DELIMITER ;

# NOVO SUB REGISTRO:
DELIMITER $$
CREATE PROCEDURE novo_executado (
    `id_andamentoIn` INT			,
    `tipo_executado` VARCHAR(10)	,
    `id_executadoIn` INT			,
    `quantidadeIn` INT				,
    `descontoIn` FLOAT				,
    `valorIn` FLOAT					,
    `id_registro` INT
    )
    BEGIN
		IF `tipo_executado` = "Servico" THEN
			INSERT INTO `executados` (
				`id_andamento`	,
				`id_servico`	,
				`quantidade`	,
				`desconto`		,
				`valor`			,
                `id_executado`	
				)
			VALUES (
				`id_andamentoIn`	,
				`id_executadoIn`	,
				`quantidadeIn`		,
				`descontoIn`		,
				`valorIn`			,
                `id_registro`
				);
		END IF;
		
		IF `tipo_executado` = "Produto" THEN
			INSERT INTO `executados` (
				`id_andamento`	,
				`id_produto`	,
				`quantidade`	,
				`desconto`		,
				`valor`			,
                `id_executado`
				)
			VALUES (
				`id_andamentoIn`	,
				`id_executadoIn`	,
				`quantidadeIn`		,
				`descontoIn`		,
				`valorIn`			,
                `id_registro`
				);
		END IF;
	END $$
DELIMITER ;

# CONSULTAR ANDAMENTO / EXECUTADOS:
DELIMITER $$
CREATE PROCEDURE consultar_andamento ( idIn INT )
	BEGIN
		SELECT
			CONCAT(AB.codigo, ' - ', AB.equipamento) AS ordem_servico	,
            CONCAT(CL.codigo, ' - ', CL.cliente) AS cliente				,
            DATE_FORMAT(AB.dt_abertura, '%Y-%m-%d') AS dt_abertura		,
            CL.cadastro AS cadastro										,
            CL.contato AS contato										
		FROM andamentos AS AN
			LEFT JOIN aberturas AS AB ON AN.id_abertura = AB.id_abertura
            LEFT JOIN clientes AS CL ON AB.id_cliente = CL.id_cliente
		WHERE AN.id_andamento = idIn;
        
        # SUB-REGISTROS:
        SELECT
			CASE
				WHEN EX.id_servico <> 'null' THEN 'Servico'
				WHEN EX.id_produto <> 'null' THEN 'Produto'
			END AS tipo,
            COALESCE(EX.id_servico, EX.id_produto) AS executado	,
            COALESCE(SE.codigo, PR.codigo) AS codigo			,
            COALESCE(SE.servico, PR.produto) AS descricao		,
            EX.desconto AS desconto								,
            EX.quantidade AS quantidade							,
            EX.valor AS valor									,
            EX.id_executado AS id_executado						,
            "Consultando" AS status
		FROM executados AS EX
			LEFT JOIN servicos AS SE ON EX.id_servico = SE.id_servico
            LEFT JOIN produtos AS PR ON EX.id_produto = PR.id_produto
		WHERE EX.id_andamento = idIn;
	END $$
DELIMITER ;
DROP PROCEDURE consultar_andamento;
			
# EXCLUIR ANDAMENTO:
DELIMITER $$
CREATE PROCEDURE deletar_andamento ( idIn INT )
	BEGIN
		DELETE FROM executados WHERE id_andamento = idIn;
        
		UPDATE aberturas AS AB
        LEFT JOIN andamentos AS AN ON AB.id_abertura = AN.id_abertura
        SET AB.`status` = "Abertura"
        WHERE AB.id_abertura = AN.id_abertura AND AN.id_andamento = idIn;
        
		DELETE FROM andamentos WHERE id_andamento = idIn;
	END $$
DELIMITER ;