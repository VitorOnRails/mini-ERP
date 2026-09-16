CREATE TABLE vendas (
    id INT IDENTITY(1,1) NOT NULL,
    total DECIMAL(10,2) NOT NULL CONSTRAINT df_total DEFAULT 0,
    forma_pagamento NVARCHAR(30) NOT NULL,
    data_venda DATETIME NOT NULL CONSTRAINT df_data_venda DEFAULT GETDATE(),

    CONSTRAINT pk_venda PRIMARY KEY (id),
    CONSTRAINT ck_total CHECK (total  >= 0),
    CONSTRAINT ck_forma_pagamento CHECK (forma_pagamento IN ('Dinheiro', 'Cartão', 'PIX'))
);