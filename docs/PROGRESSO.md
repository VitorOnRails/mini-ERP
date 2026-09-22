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

## ✅ Fase B — `usp_RegistrarVenda` v2 (multi-item) pronta e testada

v2 aceita **vários itens** numa venda via **TVP** (`tipoItemVenda`, em `database/05_tipo_de_item_venda.sql`). Lógica **set-based**: valida estoque da lista (`IF EXISTS` + JOIN), insere venda com total agregado (`INSERT..SELECT` + `SUM`), captura id, insere todos os itens (`INSERT..SELECT`, preço congelado via JOIN), baixa estoque de todos (`UPDATE..FROM..JOIN`) — tudo transacional. Testada: venda de 2 itens ok; item insuficiente faz **rollback da venda inteira** (nem o item válido baixa). Limitações a revisitar (robustez): produto duplicado em @itens e id_produto inexistente (INNER JOIN descarta).

<details><summary>histórico: v1 (1 item)</summary>

`database/05_usp_Registrar_venda.sql` (v1) — lê preço → valida estoque → insere venda → captura id → insere item → baixa estoque, em transação. Substituída pela v2 (multi-item) no mesmo arquivo.
</details>

## ✅ Views e alerta — Fase 1 (banco) COMPLETA 🏁

- `07_vw_Vendas_dia.sql` — **vw_VendasDia**: total/nº/ticket médio do dia (CAST no ticket p/ 2 casas; filtro `CAST(... AS DATE)`).
- `08_vw_Produtos_mais_vendidos.sql` — **vw_ProdutosMaisVendidos**: ranking por produto (JOIN + GROUP BY; sem ORDER BY — é do consumidor).
- `09_vw_Alerta_estoque.sql` — **vw_AlertaEstoque**: produtos com `estoque < estoque_minimo`.
- Todas testadas e funcionando.

**Fase 1 (banco SQL Server) concluída:** schema + procedure transacional multi-item + 3 views/alerta. É o núcleo da vaga.

## 🎯 Próximo passo (retomar aqui) — Fase 2 (Delphi)

App desktop (PDV do balcão) em **Delphi + FireDAC** — o "maior gap" do plano. Precisa do **Delphi Community Edition** instalado. Telas: cadastro de produtos (CRUD), tela de venda/PDV (chama `usp_RegistrarVenda`), consulta de estoque.

(Opcional antes: robustez da procedure — produto duplicado em @itens, id_produto inexistente.)

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
