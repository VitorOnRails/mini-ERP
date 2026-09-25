# Progresso — Mini-ERP de Balcão

Registro do que já foi construído e o próximo passo. Atualizado em **2026-09-24**.

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

## ✅ Robustez da procedure — feita e testada 🏁

`usp_RegistrarVenda` ganhou 2 validações pre-flight (antes do BEGIN TRY): produto inexistente (`NOT EXISTS`) e produto duplicado (`GROUP BY` + `HAVING COUNT(*) > 1`). Testado: ambos barram com THROW e nada é gravado; venda válida segue OK. **Fase 1 (banco SQL Server) 100% concluída, com robustez.**

## 🚧 Fase 2 (Delphi) — EM ANDAMENTO

App desktop (PDV do balcão) em Delphi. Projeto em `delphi/` (`miniERP.dpr`, `uProdutos.pas/.dfm`).

- **Delphi 13 Community Edition** instalado (só Delphi + Windows).
- ⚠️ **A CE não tem o driver MSSQL no FireDAC** → conexão feita via **ADO / dbGo** (`TADOConnection` + OLE DB Driver for SQL Server). ADO = a via "legada", alinhada com a vaga.
- **Conexão OK:** localhost, Windows Auth, banco miniERP, `TrustServerCertificate=True`, `LoginPrompt=False`. Connection string enxuta: `Provider=MSOLEDBSQL19.1;Data Source=localhost;Initial Catalog=miniERP;Integrated Security=SSPI;Trust Server Certificate=True`.
- **✅ Tela de produtos LISTANDO:** trio montado — `conMiniERP` (TADOConnection) → `qryProdutos` (TADOQuery, `SELECT * FROM produtos`) → `dsProdutos` (TDataSource) → `grdProdutos` (TDBGrid). Colunas ajustadas via Columns Editor (larguras + títulos amigáveis: ID/Nome/Preço/Estoque/Estoque mínimo). **App compila e RODA (F9)** mostrando os 6 produtos.
- **✅ CRUD na grade:** adicionei um `TDBNavigator` ligado ao `dsProdutos` e habilitei `dgEditing` no grid — dá pra editar e excluir direto na grade, com o ADO gerando o UPDATE/DELETE sozinho. Testei criar/editar/excluir vendo persistir no banco. (Aprendi na prática por que editar num cursor vivo é frágil: o servidor aplica DEFAULT/IDENTITY que o cliente não conhece → deriva → erro "linha não pode ser localizada"; conserto = Cancel + Refresh.)
- **✅ Formulário de cadastro (INSERT parametrizado):** montei um painel com campos (`edtNome`/`edtPreco`/`edtEstoque`/`edtEstoqueMinimo`) + botão Salvar. Um 2º `TADOQuery` (`qryInsertProdutos`) carrega o `INSERT INTO produtos (...) VALUES (:nome, :preco, :estoque, :estoque_minimo)`. No `btnSalvarClick` preencho cada parâmetro (`ParamByName('x').Value`, convertendo o `.Text` com `StrToFloat`/`StrToInt`), disparo com `ExecSQL` e atualizo a lista com `Requery`. **Ler e escrever = queries separados** (`qryProdutos` lê e alimenta o grid; `qryInsertProdutos` só escreve).
- **Conceitos fixados aqui:** parâmetros no Delphi (`:x` na plaquinha do SQL, `ParamByName('x')` no código, sem o `:`); `SELECT` se abre (`Open`) e traz linhas, `INSERT` se executa (`ExecSQL`) e não traz nada (dobradinha GET/POST); a propriedade `SQL` é a *instrução* do query; e `procedure` do Pascal (subrotina que não retorna, vs `function`) **não** é a mesma coisa que *stored procedure* do SQL — palavra igual, mundos diferentes.

**Retomar aqui:** o **PDV** — vai *chamar* a `usp_RegistrarVenda` a partir do Delphi, preenchendo os parâmetros (`@forma_pagamento` + a lista de itens via TVP). É onde os parâmetros do Delphi encontram os da procedure. Depois: consulta de estoque, e polimentos no cadastro (limpar os campos após salvar; validar entrada inválida com `TryStrToFloat` / `try-except`). (Renomear form/componentes = sempre pela propriedade Name no Object Inspector, nunca editando código.)

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
1. **SQL Server** — fonte única da verdade. (_concluído_)
2. **Delphi** (desktop, ADO / dbGo) — PDV do balcão, lê **e escreve**. ← estamos aqui (primeiro executável criado)
3. **PHP** (API, PDO) — só leitura, devolve JSON.
4. **jQuery** (painel web) — consome o PHP via `$.ajax`.
