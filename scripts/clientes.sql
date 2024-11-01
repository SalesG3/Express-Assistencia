### SCRIPT PARA TABELA DE CLIENTES:

# CRIAÇÃO DA TABELA:
CREATE TABLE clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    codigo CHAR(4) NOT NULL UNIQUE,
    cliente VARCHAR(75) NOT NULL,
    tipo VARCHAR(4) NOT NULL,
    cadastro VARCHAR(18) NOT NULL UNIQUE,
    contato VARCHAR(13),
    email VARCHAR(75),
    endereco VARCHAR(75),
    historico TEXT,
    ativo BOOLEAN,
    notificar BOOLEAN
);

# CÓDIGO AUTOMÁTICO:
DELIMITER $$
CREATE PROCEDURE codigo_cliente ( )
BEGIN
	SELECT IFNULL(MAX(id_cliente), 0) +1 AS codigo FROM clientes;
END $$
DELIMITER ;

# DADOS GRID:
DELIMITER $$
CREATE PROCEDURE grid_clientes ( pesquisaIn VARCHAR(100))
BEGIN
	SELECT id_cliente, codigo, cliente, cadastro FROM clientes WHERE
    codigo REGEXP pesquisaIn OR
    cliente REGEXP pesquisaIn OR
    cadastro REGEXP pesquisaIn;
END $$
DELIMITER ;

# NOVO REGISTRO:
DELIMITER $$
CREATE PROCEDURE novo_cliente ( codigoIn CHAR(4), clienteIn VARCHAR(75), tipoIn VARCHAR(4), cadastroIn VARCHAR(18), contatoIn VARCHAR(13),
emailIn VARCHAR(75), enderecoIn VARCHAR(75), historicoIn TEXT, ativoIn BOOLEAN, notificarIn BOOLEAN)
BEGIN
	IF NOT EXISTS ( SELECT id_cliente FROM clientes WHERE codigo = codigoIn OR cadastro = cadastroIn ) THEN
		INSERT INTO clientes ( codigo, cliente, tipo, cadastro, contato, email, endereco, historico, ativo, notificar ) VALUES
			( codigoIn, clienteIn, tipoIn, cadastroIn, contatoIn, emailIn, enderecoIn, historicoIn, ativoIn, notificarIn);
            
	ELSE 
		SELECT CASE
			WHEN codigo = codigoIn THEN '#codigo'
			WHEN cadastro = cadastroIn THEN '#cadastro'
		END AS duplicado FROM clientes
			WHERE CASE
				WHEN codigo = codigoIn THEN '#codigo'
				WHEN cadastro = cadastroIn THEN '#cadastro'
			END IS NOT NULL;
	END IF;
END $$
DELIMITER ;

# CONSULTAR REGISTRO:
DELIMITER $$
CREATE PROCEDURE consultar_cliente ( idIn INT )
BEGIN
	SELECT * FROM clientes WHERE id_cliente = idIn;
END $$
DELIMITER ;