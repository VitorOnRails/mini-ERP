CREATE OR ALTER VIEW vw_ProdutosMaisVendidos AS
SELECT
    p.nome AS produto,
    SUM(iv.qtd) AS quantidade_vendida
FROM itens_venda iv
JOIN produtos p ON p.id = iv.id_produto
GROUP BY p.nome;