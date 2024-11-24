# ABERTURA DE ORDEM DE SERVIÇO

# CRIAR TABELA: ABERTURA
CREATE TABLE aberturas (
	`id_abertura` INT PRIMARY KEY AUTO_INCREMENT,
    `codigo` CHAR(5) NOT NULL UNIQUE	,
    `dt_abertura` DATE NOT NULL			,
    `status` VARCHAR(15) NOT NULL		,
    `id_usuario` INT NOT NULL			,
    `id_cliente` INT NOT NULL			,
    `equipamento` VARCHAR(100) NOT NULL	,
    `descricao` TEXT NOT NULL			,
    
    FOREIGN KEY (`id_cliente`) REFERENCES `clientes`(`id_cliente`),
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`)
);

# DADOS DA GRID: ABERTURA
DELIMITER $$
CREATE PROCEDURE grid_abertura ( `pesquisaIn` VARCHAR(100))
	BEGIN
		SELECT
			AB.`id_abertura`	,
            AB.`codigo`			,
            CL.`cliente`		,
            AB.`status`			,
            DATE_FORMAT(AB.`dt_abertura`, '%d/%m/%Y') AS dt_abertura
		FROM `aberturas` AS AB
        LEFT JOIN `clientes` AS CL ON AB.`id_cliente` = CL.`id_cliente`
        WHERE
			AB.`codigo` REGEXP `pesquisaIn` OR
            CL.`cliente` REGEXP `pesquisaIn` OR
            AB.`dt_abertura` REGEXP `pesquisaIn` OR
            AB.`status` REGEXP `pesquisaIn`;
	END $$
DELIMITER ;

# CÓDIGO AUTOMÁTICO: ABERTURA
DELIMITER $$
CREATE PROCEDURE codigo_abertura ( )
	BEGIN
		SELECT IFNULL(MAX(`codigo`), 0) +1 AS codigo FROM `aberturas`;
	END $$
DELIMITER ;

# NOVO REGISTRO: ABERTURA
DELIMITER $$
CREATE PROCEDURE novo_abertura (
	`codigoIn` CHAR(5)			,
    `aberturaIn` DATE			,
    `statusIn` VARCHAR(15)		,
    `usuarioIn` INT				,
    `clienteIn` INT				,
    `equipamentoIn` VARCHAR(100),
    `descricaoIn` TEXT
    )
		BEGIN
			IF NOT EXISTS ( SELECT `id_abertura` FROM `aberturas` WHERE `codigo` = `codigoIn` ) THEN
				INSERT INTO `aberturas` (
					`codigo`		,
                    `dt_abertura`	,
                    `status`		,
                    `id_usuario`	,
                    `id_cliente`	,
                    `equipamento`	,
					`descricao`
                     )
				VALUES (
					`codigoIn`		,
                    `aberturaIn`	,
                    `statusIn`		,
                    `usuarioIn`		,
                    `clienteIn`		,
                    `equipamentoIn`	,
                    `descricaoIn`
                    );
			ELSE
				SELECT CASE
					WHEN `codigo` = `codigoIn` THEN '#codigo'
				END AS duplicado FROM `aberturas`
				WHERE CASE
					WHEN `codigo`= `codigoIn` THEN '#codigo'
				END IS NOT NULL;
			END IF;
		END $$
DELIMITER ;

DROP PROCEDURE novo_abertura;
            
# ALTERAR REGISTRO: ABERTURA
DELIMITER $$
CREATE PROCEDURE alterar_abertura (
	`idIn` INT,
	`codigoIn` CHAR(5)			,
    `aberturaIn` DATE			,
    `statusIn` VARCHAR(15)		,
    `usuarioIn` INT				,
    `clienteIn` INT				,
    `equipamentoIn` VARCHAR(100),
    `descricaoIn` TEXT
    )
	BEGIN
		IF NOT EXISTS ( SELECT `id_abertura` FROM `aberturas` WHERE `codigo` = `codigoIn` AND `id_abertura` <> `idIn` ) THEN
			UPDATE `aberturas` SET
				`codigo` = `codigoIn`			,
                `dt_abertura` = `aberturaIn`	,
                `status` = `statusIn`			,
                `id_usuario` = `usuarioIn`		,
                `id_cliente` = `clienteIn`		,
                `equipamento` = `equipamentoIn`	,
                `descricao` = `descricaoIn`
			WHERE
				`id_abertura` = `idIn`;
		ELSE
			SELECT CASE
				WHEN `codigo` = `codigoIn` AND `id_abertura` <> `idIn` THEN '#codigo'
			END AS duplicado FROM `aberturas`
			WHERE CASE
				WHEN `codigo`= `codigoIn` AND `id_abertura` <> `idIn` THEN '#codigo'
			END IS NOT NULL;
		END IF;
	END $$
DELIMITER ;

# CONSULTAR REGISTRO: ABERTURA
DELIMITER $$
CREATE PROCEDURE consultar_abertura ( `idIn` INT )
	BEGIN
		SELECT
			AB.*				,
            CL.`cadastro`		,
            CL.`contato`		,
            US.`nome` AS usuario,
            CONCAT(CL.`codigo`, ' - ', CL.`cliente`) AS cliente,
            DATE_FORMAT(AB.`dt_abertura`, '%Y-%m-%d') AS dt_abertura
		FROM `aberturas` AS AB
			LEFT JOIN `clientes` AS CL ON AB.`id_cliente` = CL.`id_cliente`
            LEFT JOIN `usuarios` AS US ON AB.`id_usuario` = US.`id_usuario`
		WHERE AB.`id_abertura` = `idIn`;
	END $$
DELIMITER ;
DROP PROCEDURE consultar_abertura;

# APAGAR REGISTRO: ABERTURA // INSERIR VALIDAÇÃO DE DEPENDENCIAS POSTERIORMENTE
DELIMITER $$
CREATE PROCEDURE deletar_abertura ( `idIn_abertura` INT )
	BEGIN
		DELETE FROM `aberturas` WHERE `id_abertura` = `idIn_abertura`;
	END $$
DELIMITER ;