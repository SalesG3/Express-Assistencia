# SCRIPTS PARA TABELA DE SERVIÇOS

CREATE TABLE servicos (
	id_servico INT PRIMARY KEY AUTO_INCREMENT,
    codigo CHAR(4) NOT NULL UNIQUE,
    servico VARCHAR(75) NOT NULL,
    duracao VARCHAR(5),
    categoria INT,
    desconto FLOAT,
    valor FLOAT NOT NULL,
    descricao TEXT,
    ativo BOOLEAN NOT NULL
);


# DADOS PARA GRID:
DELIMITER $$
CREATE PROCEDURE grid_servicos ( pesquisaIn VARCHAR(100) )
BEGIN
	SELECT id_servico, codigo, servico, duracao, valor FROM servicos WHERE
    codigo REGEXP pesquisaIn OR
    servico REGEXP pesquisaIn OR
    duracao REGEXP pesquisaIn OR
    valor REGEXP pesquisaIn;
END $$
DELIMITER ;

# CÓDIGO AUTOMÁTICO:
DELIMITER $$
CREATE PROCEDURE codigo_servicos ( )
BEGIN
	SELECT IFNULL(MAX(codigo), 0) +1 AS codigo FROM servicos;
END $$
DELIMITER ;

# NOVO REGISTRO:
DELIMITER $$
CREATE PROCEDURE novo_servico ( codigoIn CHAR(4), servicoIn VARCHAR(75), duracaoIn VARCHAR(5), categoriaIn INT,
	descontoIn FLOAT, valorIn FLOAT, descricaoIn TEXT, ativoIn BOOLEAN)
BEGIN
	IF NOT EXISTS ( SELECT id_servico FROM servicos WHERE codigo = codigoIn ) THEN
		INSERT INTO servicos ( codigo, servico, duracao, categoria, desconto, valor, descricao, ativo) VALUES
			( codigoIn, servicoIn, duracaoIn, categoriaIn, descontoIn, valorIn, descricaoIn, ativoIn);
	ELSE
		SELECT CASE
			WHEN codigo = codigoIn THEN '#codigo'
		END AS duplicado FROM servicos
		WHERE CASE
			WHEN codigo = codigo THEN '#codigo'
		END IS NOT NULL;
	END IF;
END $$
DELIMITER ;
	