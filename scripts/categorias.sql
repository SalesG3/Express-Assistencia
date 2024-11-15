# SCRIPTS PARA TABELA DE CATEGORIAS;

CREATE TABLE categorias (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    codigo CHAR(4) NOT NULL UNIQUE,
    categoria VARCHAR(75) NOT NULL,
    descricao TEXT,
    ativo BOOLEAN
);

# DADOS PARA GRID:
DELIMITER $$
CREATE PROCEDURE grid_categorias ( pesquisaIn VARCHAR(100))
BEGIN
	SELECT id_categoria, codigo, categoria, ativo FROM categorias WHERE
    codigo REGEXP pesquisaIn OR
    categoria REGEXP pesquisaIn;
END $$
DELIMITER ;

# CODIGO AUTOMATICO:
DELIMITER $$
CREATE PROCEDURE codigo_categorias ( )
BEGIN
	SELECT IFNULL(MAX(codigo), 0) +1 AS codigo FROM categorias;
END $$
DELIMITER ;

# NOVO REGISTRO:
DELIMITER $$
CREATE PROCEDURE novo_categoria ( codigoIn CHAR(4), categoriaIn VARCHAR(75), descricaoIn TEXT, ativoIn BOOLEAN)
BEGIN
	IF NOT EXISTS ( SELECT id_categoria FROM categorias WHERE codigo = codigoIn ) THEN
		INSERT INTO categorias ( codigo, categoria, descricao, ativo) VALUES
			( codigoIn, categoriaIn, descricaoIn, ativoIn);
	ELSE
		SELECT CASE
			WHEN codigo = codigoIn THEN "#codigo"
		END AS duplicado FROM categorias
        WHERE CASE
			WHEN codigo = codigoIn THEN "#codigo"
		END IS NOT NULL;
	END IF;
END $$
DELIMITER ;

# ALTERAR REGISTRO:
DELIMITER $$
CREATE PROCEDURE alterar_categoria ( idIn INT, codigoIn CHAR(4), categoriaIn VARCHAR(75), descricaoIn TEXT, ativoIn BOOLEAN)
BEGIN
	IF NOT EXISTS( SELECT id_categoria FROM categorias WHERE codigo = codigoIn AND id_categoria <> idIn ) THEN
		UPDATE categorias SET codigo = codigoIn, categoria = categoriaIn, descricao = descricaoIn, ativo = ativoIn
        WHERE id_categoria = idIn;
	ELSE 
		SELECT CASE
			WHEN codigo = codigoIn AND id_categoria <> idIn THEN "#codigo"
		END AS duplicado FROM categorias WHERE CASE
			WHEN codigo = codigoIn AND id_categoria <> idIn THEN "#codigo"
		END IS NOT NULL;
	END IF;
END $$
DELIMITER ;

# CONSULTAR REGISTRO:
DELIMITER $$
CREATE PROCEDURE consultar_categoria ( idIn INT )
BEGIN
	SELECT * FROM categorias WHERE id_categoria = idIn;
END $$
DELIMITER ;

# APAGAR REGISTRO:
DELIMITER $$
CREATE PROCEDURE deletar_categoria ( idIn INT )
BEGIN
	IF NOT EXISTS ( SELECT id_categoria FROM servicos WHERE id_categoria = idIn ) THEN
		DELETE FROM categorias WHERE id_categoria = idIn;
	END IF;
END $$
DELIMITER ;

# LOOKUP CATEGORIAS:
DELIMITER $$
CREATE PROCEDURE lookup_categorias ( )
BEGIN
	SELECT id_categoria, codigo, categoria FROM categorias WHERE ativo = 1;
END $$
DELIMITER ;