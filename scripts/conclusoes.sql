### CONCLUSÃO DA ORDEM DE SERVIÇO:

# TABELA DE CONCLUSÃO:
CREATE TABLE IF NOT EXISTS conclusoes (
	id_conclusao INT PRIMARY KEY AUTO_INCREMENT	,
    id_andamento INT NOT NULL UNIQUE			,
    dt_conclusao DATE NOT NULL					,
    dt_entrega	DATE							,
    pagamento INT								,
    garantia INT								,
    observacoes	TEXT							
);

# DADOS PARA GRID

DELIMITER $$
CREATE PROCEDURE grid_conclusoes ( p_pesquisa VARCHAR(100) )
	BEGIN
		SELECT 
			CO.ID_CONCLUSAO	,
			AB.CODIGO		,
            CL.CLIENTE		,
            DATE_FORMAT(CO.DT_CONCLUSAO , '%d/%m/%Y') AS DT_CONCLUSAO,
            (SELECT SUM((EX.VALOR - (EX.VALOR * EX.DESCONTO / 100 )) * EX.QUANTIDADE) FROM executados AS EX WHERE AN.ID_ANDAMENTO = EX.ID_ANDAMENTO) AS VALOR,
            IF(CO.DT_ENTREGA IS NOT NULL, 'Concluído', 'Retirada') AS STATUS
		FROM conclusoes AS CO
			LEFT JOIN andamentos AS AN ON CO.ID_ANDAMENTO = AN.ID_ANDAMENTO
			LEFT JOIN aberturas AS AB ON AN.ID_ABERTURA = AB.ID_ABERTURA
            LEFT JOIN clientes AS CL ON AB.ID_CLIENTE = CL.ID_CLIENTE
		WHERE
			AB.CODIGO REGEXP p_pesquisa OR
            CL.CLIENTE REGEXP p_pesquisa OR
            CO.DT_CONCLUSAO REGEXP p_pesquisa OR
            (SELECT
				SUM((EX.VALOR - (EX.VALOR * EX.DESCONTO / 100 )) * EX.QUANTIDADE)
			FROM executados AS EX
				WHERE AN.ID_ANDAMENTO = EX.ID_ANDAMENTO)
			REGEXP p_pesquisa;
	END $$
DELIMITER ;
        
# NOVO REGISTRO

DELIMITER $$
CREATE PROCEDURE novo_conclusao (
	IN p_id_andamento INT	,
    IN p_dt_conclusao DATE	,
    IN p_dt_entrega DATE	,
    IN p_pagamento INT		,
    IN p_garantia INT		,
    IN p_observacoes TEXT	)
	BEGIN
		IF NOT EXISTS ( SELECT id_andamento FROM conclusoes WHERE id_andamento = p_id_andamento ) THEN
			INSERT INTO conclusoes (
				id_andamento	,
                dt_conclusao	,
                dt_entrega		,
                pagamento		,
                garantia		,
                observacoes
                )
			VALUES (
				p_id_andamento	,
                p_dt_conclusao	,
                p_dt_entrega  	,
                p_pagamento   	,
                p_garantia    	,
                p_observacoes 	
				);
                
			UPDATE aberturas AS AB
				LEFT JOIN andamentos AS AN ON AB.id_abertura = AN.id_abertura
			SET `status` = 'Conclusão'
				WHERE
					AN.id_andamento = p_id_andamento AND
                    AN.id_abertura = AB.id_abertura;
		ELSE 
			SELECT '#andamento' AS duplicado;
		END IF;
	END $$
DELIMITER ;

# CONSULTAR CONCLUSÃO
DELIMITER $$
CREATE PROCEDURE consultar_conclusao ( IN p_id_conclusao INT )
	BEGIN
		SELECT
			AN.id_andamento											,
			CONCAT(AB.codigo, ' - ', AB.equipamento) AS andamento	,
            CONCAT(CL.codigo, ' - ', CL.cliente) AS cliente			,
            CL.cadastro												,
            CL.contato												,
            DATE_FORMAT(dt_conclusao, '%Y-%m-%d') AS dt_conclusao	,
            CO.pagamento											,
            CO.garantia												,
            (SELECT
				SUM(EX.valor * EX.quantidade)
			FROM executados AS EX WHERE AN.id_andamento = EX.id_andamento) AS bruto,
            (SELECT
				SUM((EX.valor * EX.desconto / 100) * EX.quantidade)
            FROM executados AS EX WHERE AN.id_andamento = EX.id_andamento) AS desconto,
            DATE_FORMAT(dt_entrega, '%Y-%m-%d') AS dt_entrega		,
            IF(CO.dt_entrega IS NOT NULL, 'Concluído', 'Retirada') AS status
		FROM conclusoes AS CO
			LEFT JOIN andamentos AS AN ON CO.id_andamento = AN.id_andamento
            LEFT JOIN aberturas AS AB ON AN.id_abertura = AB.id_abertura
            LEFT JOIN clientes AS CL ON AB.id_cliente = CL.id_cliente
		WHERE id_conclusao = p_id_conclusao;
	END $$
DELIMITER ;

# ALTERAR REGISTRO:
DELIMITER $$
CREATE PROCEDURE alterar_conclusao (
	IN p_id_conclusao INT	,
	IN p_id_andamento INT	,
    IN p_dt_conclusao DATE	,
    IN p_dt_entrega DATE	,
    IN p_pagamento INT		,
    IN p_garantia INT		,
    IN p_observacoes TEXT	)
	BEGIN
		IF NOT EXISTS ( SELECT id_conclusao FROM conclusoes WHERE id_andamento = p_id_andamento AND id_conclusao <> p_id_conclusao ) THEN
			UPDATE conclusoes SET
                id_andamento = p_id_andamento	,
                dt_conclusao = p_dt_conclusao	,
                dt_entrega = p_dt_entrega		,
                pagamento = p_pagamento			,
                garantia = p_garantia			,
                observacoes = p_observacoes		
			WHERE id_conclusao = p_id_conclusao;
			
		ELSE
			SELECT id_conclusao FROM conclusoes WHERE id_andamento = p_id_andamento AND id_conclusao <> p_id_conclusao;
		
		END IF;
	END $$
DELIMITER ;
		