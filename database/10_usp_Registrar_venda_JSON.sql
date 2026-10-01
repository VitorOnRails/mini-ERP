CREATE OR ALTER PROCEDURE usp_RegistrarVenda_JSON
    @itensJson NVARCHAR(MAX),
    @forma_pagamento NVARCHAR(30)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @itens tipoItemVenda;
INSERT INTO @itens (id_produto, qtd)
SELECT id_produto, qtd
FROM OPENJSON(@itensJson) 
WITH (id_produto INT, qtd INT);
EXEC usp_RegistrarVenda @itens, @forma_pagamento;

END;