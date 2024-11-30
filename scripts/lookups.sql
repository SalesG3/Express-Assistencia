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