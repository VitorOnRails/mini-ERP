# Pegadinhas do SQL Server — colinha do Vitor

Caderninho pessoal das quirks que fui batendo construindo o Mini-ERP.
Regra de ouro: **não é pra decorar — é pra reconhecer o cheiro do problema e consultar aqui.**

---

## Tipos

| Pegadinha | Por quê | Jeito certo |
|---|---|---|
| `NVARCHAR` sem tamanho vira `NVARCHAR(1)` (1 caractere!) | Sem número, o SQL Server assume 1 — bug silencioso, não dá erro | Sempre dê o tamanho: `NVARCHAR(100)` |
| Dinheiro em `MONEY` ou `FLOAT` erra centavos | Ponto flutuante não é exato (`0.1 + 0.2 ≠ 0.3`) | **Dinheiro = `DECIMAL(10,2)`**, sempre |
| `SERIAL` / `AUTO_INCREMENT` não existem | São de Postgres/MySQL | Auto-numerar = `INT IDENTITY(1,1)` |
| `NVARCHAR` vs `VARCHAR` | `N` = Unicode (acentos, ç, emoji) | Texto em PT-BR → `NVARCHAR` |
| Coluna computada `int * decimal(10,2)` virou `decimal(21,2)` | O SQL Server **alarga o tipo do resultado** pra não perder precisão | Normal, inofensivo — não precisa "consertar" |

## Colunas e restrições

| Pegadinha | Por quê | Jeito certo |
|---|---|---|
| **`ADD` sem `COLUMN`, mas `DROP COLUMN` com** | Assimetria sem lógica do T-SQL | `ADD col tipo` / `DROP COLUMN col` |
| Vírgula sobrando antes do `)` no `CREATE TABLE` = erro | O SQL Server não perdoa trailing comma (diferente do JS/JSON) | Última coluna/constraint **sem** vírgula no fim |
| `DEFAULT` num `CREATE` vai **inline na coluna**, não como linha separada | `DEFAULT ... FOR col` só existe no `ALTER TABLE ADD` | `estoque INT NOT NULL CONSTRAINT df_x DEFAULT 0` |
| Não dá pra dropar coluna com FK pendurada | A constraint depende da coluna | Dropar a FK primeiro (`DROP CONSTRAINT`), depois a coluna |
| Constraint criada sem nome ganha nome feio (`FK__vendas__...`) | O SQL Server auto-nomeia quando você não batiza | Nomeie na criação: `CONSTRAINT fk_x FOREIGN KEY ...` |
| **Coluna ≠ constraint** | São objetos diferentes, cada um com seu nome | `sp_rename` usa `'OBJECT'` p/ constraint, `'COLUMN'` p/ coluna (e coluna precisa `'tabela.coluna'`) |
| Coluna computada (`AS (a * b)`) — nunca se insere nela | Ela **é** uma fórmula, o banco calcula | Virtual (calcula ao ler) ou `PERSISTED` (grava; permite indexar) |

## Execução e lotes

| Pegadinha | Por quê | Jeito certo |
|---|---|---|
| "Coluna inválida" logo depois de criá-la no mesmo lote | O lote é **compilado inteiro antes de rodar**; a coluna nova ainda não existe na compilação | Separar com **`GO`** entre criar e usar (só quando há dependência) |
| Query rodou no banco errado (`master`) | Roda no **banco ativo** da conexão; rodar uma *seleção* executa só o texto selecionado | `USE miniERP;` ou trocar o banco ativo; conferir a barra de baixo |
| `CREATE TABLE` de tabela que já existe dá erro | O SQL Server se recusa a duplicar | É inofensivo (não cria cópia); num script re-rodável, usar `IF NOT EXISTS` ou não recriar |
| Editei o `.sql` mas o banco não mudou | O arquivo ≠ o objeto no banco; salvar não aplica | **Executar** o script (`CREATE OR ALTER`) pra aplicar — como recompilar |

## Procedures e convenções

| Pegadinha | Por quê | Jeito certo |
|---|---|---|
| Não prefixe suas procedures com `sp_` | `sp_` é reservado pras procedures de **sistema**; o SQL Server procura primeiro no banco de sistema (custo bobo + risco de colisão) | Use `usp_` (user) ou nome simples: `usp_RegistrarVenda` |
| `EXEC nome_da_proc @param...` chama uma procedure | O mesmo `EXEC` vale pras embutidas (`sp_rename`) e pras suas | — |
| `BEGIN ... END` só com comentários dá "erro perto de END" | O bloco precisa de **pelo menos 1 statement real**; comentário não conta | Pôr um placeholder (`RETURN;` / `PRINT '...'`) enquanto está vazio |
| `CREATE OR ALTER PROCEDURE` = cria ou atualiza | Versão re-rodável do CREATE; edita a procedure sem dropar | Usar sempre em scripts de procedure |
| "Incorrect syntax near 'THROW'" | O `THROW` exige que o comando **anterior** termine com `;` | Na dúvida, escreva `;THROW num, 'msg', 1;` (com `;` na frente) |
| `IF ... BEGIN` sem `END` | Todo `BEGIN` precisa do seu `END` (conte os pares) | Fechar cada bloco; conferir nº de BEGIN = nº de END |
| `SCOPE_IDENTITY()` inline num `INSERT...SELECT` p/ tabela com IDENTITY | A função pode retornar o id da PRÓPRIA tabela sendo inserida, não o que você queria | **Capturar em variável** (`SET @id = SCOPE_IDENTITY()`) logo após o insert de origem, e usar a variável |

## Comportamentos que assustam mas são normais

| Coisa | Por quê é normal |
|---|---|
| Buracos na numeração do `id` (1 some, começa no 2) | `IDENTITY` reserva o número **antes** de inserir; se a linha falha (ex: CHECK), o número já foi gasto |
| `INSERT` sem informar uma coluna | Se você **lista** as colunas, as omitidas pegam o `DEFAULT`. Sem lista = posicional (tem que preencher todas na ordem) |

---

> Atualizar conforme eu bater em novas. Cada linha aqui é uma que eu **entendi**, não decorei.
