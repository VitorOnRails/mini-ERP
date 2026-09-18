# Progresso — Mini-ERP de Balcão

Registro do que já foi construído e o próximo passo. Atualizado em **2026-09-10**.

> Método: eu escrevo o SQL, o Claude só **guia e revisa** (nada de código pronto pra copiar).

---

## ✅ Fase 1 — Banco (SQL Server) — modelo relacional COMPLETO

### Ambiente (pronto)
- **SQL Server 2025 Developer Edition** local. Servidor: `localhost`, autenticação do Windows.
- **VS Code + extensão "SQL Server (mssql)"** (conexão "Delphi ERP Local").
- Banco: **`miniERP`**.

### As 3 tabelas — prontas e limpas ✔

**`produtos`** — id (INT IDENTITY PK), nome NVARCHAR(100) NOT NULL, preco DECIMAL(10,2) NOT NULL, estoque INT NOT NULL DEFAULT 0, estoque_minimo INT NOT NULL DEFAULT 10. CHECKs: `ck_preco_minimo`, `ck_estoque`. (4 linhas de teste.)

**`vendas`** (cabeçalho da nota) — id (PK), data_venda DATETIME DEFAULT getdate(), total DECIMAL(10,2) NOT NULL DEFAULT 0, forma_pagamento NVARCHAR(30) NOT NULL. CHECK: `ck_forma_pagamento` IN ('PIX','Cartão','Dinheiro').

**`itens_venda`** (linhas da nota) — id (PK), venda_id (FK `fk_itens_venda` → vendas), produto_id (FK `fk_itens_produto` → produtos), qtd INT NOT NULL, preco_unitario DECIMAL(10,2) NOT NULL, **subtotal** = coluna computada PERSISTED `(qtd * preco_unitario)`.

---

## ✅ Fase A concluída — schema em arquivos versionáveis

O schema agora vive em `database/`, em arquivos `.sql` re-rodáveis (rebuild testado do zero, tudo `[OK]`):
- `00_reset.sql` — DROP das 3 na ordem reversa (itens_venda → vendas → produtos)
- `01_produtos.sql`, `02_vendas.sql`, `03_itens_venda.sql` — CREATE puro, constraints todas **nomeadas** (pk_/ck_/df_/fk_)
- `04_seeds.sql` — 6 produtos de teste
- Rebuild completo = rodar `00 → 01 → 02 → 03 → 04` (fixa `USE miniERP;` ou banco ativo antes).

## ✅ Fase B (parcial) — `usp_RegistrarVenda` v1 pronta e testada

`database/05_usp_Registrar_venda.sql` — procedure completa: lê preço → valida estoque (THROW) → insere venda → captura id (SCOPE_IDENTITY) → insere item (preço congelado) → baixa estoque → tudo em transação (BEGIN TRY / BEGIN TRAN / COMMIT / CATCH com ROLLBACK + THROW). Testada: venda válida cria tudo certo; estoque insuficiente faz rollback (nada persiste). É a **v1 (1 item por venda)**.

## 🎯 Próximo passo (retomar aqui)

- **v2 da procedure:** aceitar **vários itens** numa venda (via TVP — table-valued parameter). Requer criar um *user-defined table type*.
- **Views:** `vw_VendasDoDia` (total do dia, nº vendas, ticket médio) e `vw_ProdutosMaisVendidos`.
- **Alerta de estoque baixo:** consulta `WHERE estoque < estoque_minimo`.
- (Obs: o banco tem 1 venda de teste — útil pra testar as views. Rebuild `00→04` zera se quiser.)

---

## 🧠 Conceitos já fixados nesta fase
- Modelo cabeçalho/linhas (nota fiscal): `vendas` + `itens_venda`; `produtos` é catálogo à parte.
- **PK** (identidade da linha) vs **FK** (aponta pra uma PK).
- Preço em dois lugares: `produtos.preco` (vivo) vs `itens_venda.preco_unitario` (congelado).
- **Coluna computada** (`subtotal AS (...)`) — virtual vs PERSISTED.
- Tipos SQL Server: `IDENTITY`, `NVARCHAR(n)` (o `N` = Unicode), dinheiro = `DECIMAL`.
- Restrições: `NOT NULL` vs `DEFAULT` vs `CHECK`; nomear constraints na criação (`CONSTRAINT nome ...`).
- **`GO`** = separador de lote (necessário quando um comando usa algo criado antes no mesmo lote).
- Pegadinhas registradas em [pegadinhas-sql-server.md](pegadinhas-sql-server.md).

---

## 🗺️ Visão geral do projeto (as 4 camadas)
Todas leem o mesmo `localhost`:
1. **SQL Server** — fonte única da verdade. ← estamos aqui (tabelas ok, falta procedure + views)
2. **Delphi** (desktop, FireDAC) — PDV do balcão, lê **e escreve**.
3. **PHP** (API, PDO) — só leitura, devolve JSON.
4. **jQuery** (painel web) — consome o PHP via `$.ajax`.
