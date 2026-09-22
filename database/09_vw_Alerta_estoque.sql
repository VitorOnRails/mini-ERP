CREATE OR ALTER VIEW vw_AlertaEstoque AS
SELECT
    p.nome AS produto,
    p.estoque AS estoque_atual,
    p.estoque_minimo AS estoque_minimo
FROM produtos p
WHERE p.estoque < p.estoque_minimo;