\copy atv02.vendas_outubro_stage FROM 'C:\dados_migracao\vendas_outubro.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');

CREATE TABLE IF NOT EXISTS atv02.usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cpf VARCHAR(20) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS atv02.pedidos (
    id SERIAL PRIMARY KEY,
    pedido_ref VARCHAR(50) UNIQUE NOT NULL,
    pedido_data TIMESTAMP,
    usuario_id INTEGER REFERENCES atv02.usuarios(id)
);


CREATE TABLE IF NOT EXISTS atv02.pedidos_itens (
    id SERIAL PRIMARY KEY,
    pedido_id INTEGER REFERENCES atv02.pedidos(id),
    produto_id INTEGER REFERENCES atv02.produtos(id),
    quantidade INTEGER,
    valor_unitario DECIMAL(10, 2)
);


CREATE TABLE IF NOT EXISTS atv02.vendas_outubro_stage (
    id_pedido VARCHAR(100),
    data_pedido VARCHAR(100),
    cpf_cliente VARCHAR(100),
    nome_cliente VARCHAR(100),
    email_cliente VARCHAR(100),
    sku_produto VARCHAR(100),
    quantidade VARCHAR(100),
    valor_unitario_brl VARCHAR(100)
);


INSERT INTO atv02.usuarios (cpf, nome, email)
SELECT
    DISTINCT ON (cpf_cliente)
    cpf_cliente,
    INITCAP(nome_cliente),
    email_cliente
FROM
    atv02.vendas_outubro_stage; 
	
INSERT INTO atv02.pedidos (pedido_ref, pedido_data, usuario_id)
SELECT
    DISTINCT ON (ss.id_pedido)
    ss.id_pedido,
    CAST(ss.data_pedido AS TIMESTAMP),
    u.id
FROM
    atv02.vendas_outubro_stage AS ss
JOIN
    atv02.usuarios AS u ON ss.cpf_cliente = u.cpf; 


INSERT INTO atv02.pedidos_itens (pedido_id, produto_id, quantidade, valor_unitario)
SELECT
    pd.id,
    p.id,
    CAST(ss.quantidade AS INTEGER),
    CAST(ss.valor_unitario_brl AS DECIMAL(10, 2))
FROM
    atv02.vendas_outubro_stage AS ss
JOIN
    atv02.pedidos AS pd ON ss.id_pedido = pd.pedido_ref
JOIN
    atv02.produtos AS p ON ss.sku_produto = p.sku;


SELECT
    pd.pedido_ref AS "Referência",
    pd.pedido_data AS "Data",
    u.nome AS "Cliente",
    p.name AS "Produto",
    pi.quantidade AS "Qtd",
    pi.valor_unitario AS "Preço Unit."
FROM
    atv02.pedidos AS pd
JOIN
    atv02.usuarios AS u ON pd.usuario_id = u.id
JOIN
    atv02.pedidos_itens AS pi ON pd.id = pi.pedido_id
JOIN
    atv02.produtos AS p ON pi.produto_id = p.id
ORDER BY
    pd.pedido_ref, p.name;


SELECT
    pd.pedido_ref AS "Referência",
    u.nome AS "Cliente",
    SUM(pi.quantidade * pi.valor_unitario) AS "Valor Total do Pedido"
FROM
    atv02.pedidos AS pd
JOIN
    atv02.pedidos_itens AS pi ON pd.id = pi.pedido_id
JOIN
    atv02.usuarios AS u ON pd.usuario_id = u.id
GROUP BY
    pd.pedido_ref, u.nome
ORDER BY
    "Valor Total do Pedido" DESC;


DROP TABLE atv02.vendas_outubro_stage;

