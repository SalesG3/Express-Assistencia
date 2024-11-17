# LOOKUPS SELECT:

# CATEGORIAS:
DELIMITER $$
CREATE PROCEDURE lookup_categorias ( )
BEGIN
	SELECT id_categoria, codigo, categoria FROM categorias WHERE ativo = 1;
END $$
DELIMITER ;

# CLIENTES:
DELIMITER $$
CREATE PROCEDURE lookup_clientes ( )
BEGIN
	SELECT id_cliente, codigo, cliente, cadastro, contato FROM clientes WHERE ativo = 1;
END $$
DELIMITER ;
DROP PROCEDURE lookup_clientes;