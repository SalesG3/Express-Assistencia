### SCRIPT PARA TABELA DE CLIENTES:

# CRIAÇÃO DA TABELA:
CREATE TABLE clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    codigo INT NOT NULL UNIQUE,
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
CREATE PROCEDURE codigo_clientes ( )
BEGIN
	SELECT IFNULL(MAX(id_cliente), 0) +1 FROM clientes;
END $$
DELIMITER ;

# NOVO REGISTRO:
DELIMITER $$
CREATE PROCEDURE novo_cliente ( codigoIn INT, clienteIn VARCHAR(75), tipoIn VARCHAR(4), cadastroIn VARCHAR(18), contatoIn VARCHAR(13),
emailIn VARCHAR(75), enderecoIn VARCHAR(75), historicoIn TEXT, ativoIn BOOLEAN, notificarIn BOOLEAN)
BEGIN
	IF NOT EXISTS ( SELECT id_cliente FROM clientes WHERE codigo = codigoIn OR cadastro = cadastroIn ) THEN
		INSERT INTO clientes ( codigo, cliente, tipo, cadastro, contato, email, endereco, historico, ativo, notificar ) VALUES
			( codigoIn, clienteIn, tipoIn, cadastroIn, contatoIn, emailIn, enderecoIn, historicoIn, ativoIn, notificarIn);
            
	ELSE 
		SELECT CASE
			WHEN codigo = codigoIn AND cadastro = cadastroIn THEN '#codigo, #cadastro'
			WHEN codigo = codigoIn THEN '#codigo'
			WHEN cadastro = cadastroIn THEN '#cadastro'
		END AS duplicado FROM clientes;
	END IF;
END $$
DELIMITER ;
	