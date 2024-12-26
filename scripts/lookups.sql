### LOOKUPS PARA SELECT'S:

# LOOKUP CATEGORIAS:
DELIMITER $$
CREATE PROCEDURE lookup_categorias ( )
BEGIN
	SELECT id_categoria, codigo, categoria FROM categorias WHERE ativo = 1;
END $$
DELIMITER ;

# LOOKUP CLIENTES:
DELIMITER $$
CREATE PROCEDURE lookup_clientes ( )
BEGIN
	SELECT id_cliente, codigo, cliente, cadastro, contato FROM clientes WHERE ativo = 1;
END $$
DELIMITER ;
DROP PROCEDURE lookup_clientes;

# LOOKUP ABERTURAS:
DELIMITER $$
CREATE PROCEDURE lookup_aberturas ( )
	BEGIN
		SELECT
			AB.`id_abertura`	,
			AB.`codigo`			,
            CL.`cadastro`		,
            CL.`contato`		,
            CONCAT(CL.`codigo`, ' - ', CL.`cliente`) AS cliente,
			AB.`equipamento` AS ordem_servico		,
            DATE_FORMAT(AB.`dt_abertura`, '%Y-%m-%d') AS dt_abertura
		FROM `aberturas` AS AB
			LEFT JOIN `clientes` AS CL ON CL.`id_cliente` = AB.`id_cliente`
        WHERE AB.`status` = "Abertura";
	END $$
DELIMITER ;

# LOOKUP SERVIÇOS:
DELIMITER $$
CREATE PROCEDURE lookup_servicos ( )
	BEGIN
		SELECT
			`id_servico`	,
            `codigo`		,
            `servico`		,
			`valor`
		FROM servicos WHERE `ativo` = 1;
	END $$
DELIMITER ;

#LOOKUP PRODUTOS:
DELIMITER $$
CREATE PROCEDURE lookup_produtos ( )
	BEGIN
		SELECT
			`id_produto`	,
			`codigo`		,
			`produto`		,
			`valor`
		FROM produtos WHERE `ativo` = 1;
	END $$
DELIMITER ;

# LOOKUP ANDAMENTO:
DELIMITER $$
CREATE PROCEDURE lookup_andamento ( )
	BEGIN
		SELECT 
			AN.`id_andamento`	,
            AB.`codigo`			,
            CL.`cadastro`		,
            CL.`contato`		,
            AB.`equipamento`	,
            CONCAT(CL.`codigo`, ' - ', CL.`cliente`) AS 'cliente',
            
            (SELECT SUM(EX.`valor` * EX.`quantidade`) FROM executados AS EX WHERE AN.`id_andamento` = EX.`id_andamento`) AS bruto,
            (SELECT SUM((EX.`valor` * EX.`desconto` / 100) * EX.`quantidade`) FROM executados AS EX WHERE AN.`id_andamento` = EX.`id_andamento`) AS desconto
        FROM andamentos AS AN
			LEFT JOIN aberturas AS AB ON AN.`id_abertura` = AB.`id_abertura`
            LEFT JOIN clientes AS CL ON AB.`id_cliente` = CL.`id_cliente`
		WHERE AB.status = "Andamento";
	END $$
DELIMITER ;