CREATE OR ALTER PROCEDURE usp_RegistrarVenda
    @itens tipoItemVenda READONLY,
    @forma_pagamento NVARCHAR(30)
AS
BEGIN
-- 7. commit ou rollback no caso de erros.
    BEGIN TRY
        BEGIN TRANSACTION;
    IF EXISTS (
        SELECT 1
        FROM @itens i
        JOIN produtos p ON i.id_produto = p.id
        WHERE i.qtd > p.estoque
    )
    BEGIN
       ; THROW 50000, 'Estoque dos produtos selecionados é insuficiente para a quantidade desejada.', 1;
    END

    INSERT INTO vendas (forma_pagamento, total)
    SELECT @forma_pagamento, SUM(i.qtd * p.preco)
    FROM @itens i
    JOIN produtos p ON i.id_produto = p.id;

    DECLARE @id_venda INT;
    SET @id_venda = SCOPE_IDENTITY(); 
    INSERT INTO itens_venda (id_venda, id_produto, qtd, preco_unitario)
    SELECT @id_venda, i.id_produto, i.qtd, p.preco
    FROM @itens i
    JOIN produtos p ON i.id_produto = p.id;

    UPDATE p
    SET p.estoque = p.estoque - i.qtd
    FROM produtos p
    JOIN @itens i ON p.id = i.id_produto;
    COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;