CREATE TABLE itens_venda (
    id INT IDENTITY(1,1) NOT NULL,
    qtd INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL CONSTRAINT df_preco_unitario DEFAULT 0,
    subtotal AS (qtd * preco_unitario) PERSISTED,
    id_produto INT NOT NULL,
    id_venda INT NOT NULL,

    CONSTRAINT pk_itens_venda PRIMARY KEY (id),
    CONSTRAINT ck_qtd CHECK (qtd > 0),
    CONSTRAINT ck_preco_unitario CHECK (preco_unitario >= 0),
    CONSTRAINT fk_itens_produto FOREIGN KEY (id_produto) REFERENCES produtos(id),
    CONSTRAINT fk_itens_venda FOREIGN KEY (id_venda) REFERENCES vendas(id)
);