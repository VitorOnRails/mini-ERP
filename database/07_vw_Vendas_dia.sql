CREATE OR ALTER VIEW  vw_VendasDia AS 
SELECT 
    SUM(v.total) AS total_vendido,
    COUNT(*) AS quantidade_vendida,
    CAST(SUM(v.total) / COUNT(*) AS DECIMAL(10,2)) AS ticket_medio
FROM vendas v
WHERE CAST(v.data_venda AS DATE) = CAST(GETDATE() AS DATE);
