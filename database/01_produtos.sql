CREATE TABLE produtos (
    id INT IDENTITY(1,1) NOT NULL,
    nome NVARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL CONSTRAINT df_estoque DEFAULT 0,
    estoque_minimo INT NOT NULL  CONSTRAINT df_estoque_minimo DEFAULT 10,

    CONSTRAINT pk_produto PRIMARY KEY (id),
    CONSTRAINT ck_preco_minimo CHECK (preco >= 0),
    CONSTRAINT ck_estoque CHECK (estoque >= 0)
);