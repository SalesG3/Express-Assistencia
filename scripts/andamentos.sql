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
	`id_andamento` INT NOT NULL,
    `id_servico` INT,
    `id_produto` INT,
    `quantidade` INT,
    `desconto` FLOAT,
    `valor` FLOAT	,
    
    CONSTRAINT `id_andamento` FOREIGN KEY (`id_andamento`) REFERENCES `andamentos`(`id_andamento`),
    CONSTRAINT `id_servico` FOREIGN KEY (`id_servico`) REFERENCES `servicos`(`id_servico`),
    CONSTRAINT `id_produto` FOREIGN KEY (`id_produto`) REFERENCES `produtos`(`id_produto`)
);

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
            SELECT LAST_INSERT_ID() AS ID;
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
    `valorIn` FLOAT		
    )
    BEGIN
		IF `tipo_executado` = "Servico" THEN
			INSERT INTO `executados` (
				`id_andamento`	,
				`id_servico`	,
				`quantidade`	,
				`desconto`		,
				`valor`
				)
			VALUES (
				`id_andamentoIn`	,
				`id_executadoIn`	,
				`quantidadeIn`		,
				`descontoIn`		,
				`valorIn`	
				);
		END IF;
		
		IF `tipo_executado` = "Produto" THEN
			INSERT INTO `executados` (
				`id_andamento`	,
				`id_produto`	,
				`quantidade`	,
				`desconto`		,
				`valor`
				)
			VALUES (
				`id_andamentoIn`	,
				`id_executadoIn`	,
				`quantidadeIn`		,
				`descontoIn`		,
				`valorIn`	
				);
		END IF;
	END $$
DELIMITER ;