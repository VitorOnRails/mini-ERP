CREATE OR ALTER PROCEDURE usp_RegistrarVenda
    @id_produto INT,
    @qtd INT,
    @forma_pagamento NVARCHAR(30)
AS
BEGIN
-- 7. commit ou rollback no caso de erros.
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @preco DECIMAL(10,2), @estoque_atual INT;
    SELECT @preco = preco, @estoque_atual = estoque FROM produtos WHERE id = @id_produto; 
    IF @estoque_atual < @qtd
    BEGIN
       ; THROW 50000, 'Estoque do produto selecionado é insuficiente para a quantidade desejada.', 1;
    END
    INSERT INTO vendas (
        forma_pagamento, total
    )
    VALUES (
        @forma_pagamento, @preco * @qtd
    );
    DECLARE @id_venda INT;
    SET @id_venda = SCOPE_IDENTITY();
    INSERT INTO itens_venda (
        id_venda, id_produto, qtd, preco_unitario
    )
    VALUES (
        @id_venda, @id_produto, @qtd, @preco
    );
    UPDATE produtos
    SET estoque = estoque - @qtd
    WHERE id = @id_produto;
    COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;