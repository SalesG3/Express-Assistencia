### PRODUTOS:

# TABELA:
CREATE TABLE produtos (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
    codigo CHAR(4) NOT NULL UNIQUE,
    produto VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    id_categoria INT,
    custo FLOAT,
    desconto FLOAT, 
    valor FLOAT,
    descricao TEXT,
    ativo BOOLEAN,
    
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

# DADOS PARA GRID:
DELIMITER $$
CREATE PROCEDURE grid_produtos ( pesquisaIn VARCHAR(100) )
BEGIN
	SELECT id_produto, codigo, produto, marca, valor FROM produtos WHERE
    codigo REGEXP pesquisaIn OR
    produto REGEXP pesquisaIn OR
    marca REGEXP pesquisaIn OR
    valor REGEXP pesquisaIn;
END $$
DELIMITER ;

# CÓDIGO AUTOMÁTICO:
DELIMITER $$
CREATE PROCEDURE codigo_produtos ( )
BEGIN
	SELECT IFNULL(MAX(codigo), 0) +1 AS codigo FROM produtos;
END $$
DELIMITER ;

# NOVO REGISTRO:
DELIMITER $$
CREATE PROCEDURE novo_produto ( codigoIn CHAR(4), produtoIn VARCHAR(100), marcaIn VARCHAR(50), categoriaIn INT,
	custoIn FLOAT, descontoIn FLOAT, valorIn FLOAT, descricaoIn TEXT, ativoIn BOOLEAN)
BEGIN
	IF NOT EXISTS ( SELECT id_produto FROM produtos WHERE codigo = codigoIn ) THEN
		INSERT INTO produtos ( codigo, produto, marca, id_categoria, custo, desconto, valor, descricao, ativo) VALUES
			( codigoIn, produtoIn, marcaIn, categoriaIn, custoIn, descontoIn, valorIn, descricaoIn, ativoIn);
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

# ALTERAR REGISTRO:
DELIMITER $$
CREATE PROCEDURE alterar_produto (
	idIn		INT,
    codigoIn	CHAR(4),
    produtoIn	VARCHAR(100),
    marcaIn		VARCHAR(50),
    categoriaIn INT,
    custoIn		FLOAT,
	descontoIn 	FLOAT,
    valorIn		FLOAT,
    descricaoIn TEXT,
    ativoIn		BOOLEAN
    ) BEGIN
		IF NOT EXISTS (
			SELECT id_produto
			FROM produtos
			WHERE codigo = codigoIn AND id_produto <> idIn
		) THEN
			UPDATE produtos SET
            codigo = codigoIn			,
            produto = produtoIn			,
            marca = marcaIn				,
            id_categoria = categoriaIn	,
            custo = custoIn				,
            desconto = descontoIn		,
            valor = valorIn				,
            descricao = descricaoIn		,
            ativo = ativoIn
			WHERE id_produto = idIn;
		ELSE 
			SELECT CASE
				WHEN codigo = codigoIn AND id_produto <> idIn THEN "#codigo"
			END AS duplicado FROM produtos WHERE CASE
				WHEN codigo = codigoIn AND id_produto <> idIn THEN "#codigo"
			END IS NOT NULL;
		END IF;
	END $$
DELIMITER ;
DROP PROCEDURE alterar_produto;

# CONSULTAR REGISTRO:
DELIMITER $$
CREATE PROCEDURE consultar_produto ( idIn INT )
	BEGIN
		SELECT
			produtos.*,
            CONCAT(categorias.codigo, ' - ', categorias.categoria) AS categoria
		FROM produtos
        LEFT JOIN categorias ON produtos.id_categoria = categorias.id_categoria
        WHERE id_produto = idIn;
	END $$
DELIMITER ;

# APAGAR REGISTRO
DELIMITER $$
CREATE PROCEDURE deletar_produto ( idIn INT )
	BEGIN
		DELETE FROM produtos WHERE id_produto = idIn;
	END $$
DELIMITER ;