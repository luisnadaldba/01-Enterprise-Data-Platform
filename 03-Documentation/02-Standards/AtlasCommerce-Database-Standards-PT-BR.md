# Padrões de Banco de Dados do AtlasCommerce

## 1. Propósito

Este documento define os padrões de projeto, nomenclatura, documentação, integridade, indexação, ordenação e *deployment* (implantação) de banco de dados adotados pelo AtlasCommerce.

Seu propósito é garantir que os objetos de banco de dados sejam criados e mantidos de maneira consistente, previsível, rastreável e reexecutável durante todo o ciclo de vida da plataforma.

Esses padrões se aplicam a *schemas* (esquemas) de banco de dados, tabelas, colunas, prefixos, chaves, *constraints* (restrições), *indexes* (índices), documentação de objetos, posicionamento físico, ordenação de objetos e *scripts* de *deployment* (implantação).

Os padrões definidos neste documento devem ser seguidos ao criar novos objetos de banco de dados ou modificar objetos existentes.

Quando uma convenção documentada anteriormente divergir da implementação consolidada do banco de dados, o *deployment* (implantação) validado do AtlasCommerce é a fonte técnica da verdade. A documentação deve ser sincronizada com o padrão implementado, em vez de forçar objetos de banco de dados já estabelecidos a se adequarem a uma documentação obsoleta.

---

## 2. Organização de Schemas

O AtlasCommerce utiliza *schemas* (esquemas) de banco de dados para organizar objetos de acordo com seu domínio de negócio ou responsabilidade técnica.

Cada tabela deve pertencer ao *schema* (esquema) que melhor represente seu propósito principal de negócio.

Os *schemas* (esquemas) não devem ser utilizados apenas como contêineres de nomenclatura. Eles representam limites lógicos dentro do banco de dados.

Os seguintes *schemas* (esquemas) estão atualmente definidos:

| Schema | Propósito |
|---|---|
| `catalog` | Catálogo de produtos, classificação, variantes, atributos, mídia e dados de preços |
| `customer` | Identidade de clientes, documentos, contatos, endereços e respectivos dados mestres |
| `inventory` | Posição de estoque, movimentações, contexto das movimentações e dados de reserva de estoque |
| `metadata` | Metadados técnicos e informações de governança do banco de dados |
| `payment` | Pagamentos, métodos de pagamento, status de pagamento, reembolsos e motivos de reembolso |
| `reference` | Dados de referência compartilhados utilizados em múltiplos domínios de negócio |
| `sales` | Transações de venda, itens de transação, canais e status de transação |
| `shipping` | Remessa, método de entrega, status de entrega, rastreamento e dados de frete |

Novos *schemas* (esquemas) podem ser introduzidos quando um novo domínio de negócio ou responsabilidade técnica não puder ser adequadamente representado por um *schema* (esquema) existente.

Um novo *schema* (esquema) não deve ser criado exclusivamente para acomodar uma única tabela quando essa tabela pertencer logicamente a um domínio existente.

---

## 3. Nomenclatura de Tabelas

Os nomes das tabelas devem representar claramente a entidade de negócio ou técnica armazenada pela tabela.

Os nomes das tabelas devem:

- Utilizar inglês.
- Utilizar PascalCase.
- Utilizar a forma singular.
- Ser descritivos e não ambíguos.
- Evitar abreviações, a menos que a abreviação seja um padrão estabelecido do projeto.
- Não incluir o nome do *schema* (esquema) no nome da tabela.
- Não incluir o prefixo da tabela no nome da tabela.

Exemplos:

| Schema | Nome de Tabela Válido |
|---|---|
| `metadata` | `TablePrefix` |
| `catalog` | `ProductVariant` |
| `customer` | `CustomerAddress` |
| `inventory` | `InventoryReservation` |
| `payment` | `PaymentRefund` |
| `sales` | `TransactionItem` |
| `shipping` | `ShipmentMethod` |

O nome totalmente qualificado da tabela deve sempre ser considerado o nome canônico do objeto:

`schema.TableName`

Exemplos:

`metadata.TablePrefix`

`catalog.ProductVariant`

`customer.CustomerAddress`

`inventory.InventoryReservation`

`payment.PaymentRefund`

`sales.TransactionItem`

`shipping.ShipmentMethod`

Tabelas que representam a mesma entidade conceitual não devem ser duplicadas entre *schemas* (esquemas) sem uma justificativa arquitetural explícita.

---

## 4. Nomenclatura de Colunas

Os nomes das colunas devem representar claramente as informações armazenadas pela coluna e devem seguir o prefixo atribuído à tabela proprietária.

Toda coluna, sem exceção, deve começar com o prefixo registrado de sua tabela proprietária, seguido por um sublinhado:

`PFX_column_name`

Nenhuma coluna pode ser criada sem o prefixo atribuído à sua tabela proprietária.

Os nomes das colunas devem:

- Utilizar inglês.
- Utilizar o prefixo registrado da tabela em letras maiúsculas.
- Separar o prefixo do nome da coluna com um sublinhado.
- Utilizar *lowercase snake_case* (snake_case em letras minúsculas) após o prefixo.
- Ser descritivos e não ambíguos.
- Evitar abreviações desnecessárias.
- Utilizar terminologia consistente em todo o banco de dados.

Exemplos:

| Tabela | Prefixo | Coluna |
|---|---|---|
| `metadata.TablePrefix` | `PFX` | `PFX_schema_name` |
| `customer.Customer` | `CST` | `CST_name` |
| `sales.Transaction` | `TRN` | `TRN_gross_amount` |
| `shipping.Shipment` | `SHP` | `SHP_tracking_code` |

Uma coluna que referencia outra tabela deve preservar tanto o prefixo da tabela proprietária quanto o prefixo da tabela referenciada, de acordo com os Padrões de *Foreign Key* (chave estrangeira).

Exemplo:

`TRN_TRNST_id`

Onde:

- `TRN` identifica a tabela proprietária, `sales.Transaction`.
- `TRNST` identifica a tabela referenciada, `sales.TransactionStatus`.
- `id` identifica a chave referenciada.

Outro exemplo entre domínios é:

`SHP_CSTAD_id`

Onde:

- `SHP` identifica a tabela proprietária, `shipping.Shipment`.
- `CSTAD` identifica a tabela referenciada, `customer.CustomerAddress`.
- `id` identifica a chave referenciada.

A nomenclatura das colunas de *Foreign Key* (chave estrangeira) é definida em detalhes na Seção 8.

---

## 5. Registro de Prefixos de Tabelas

O AtlasCommerce mantém um registro centralizado de prefixos de tabelas para garantir que cada tabela possua um prefixo único e permanentemente atribuído.

O registro é implementado por meio de `metadata.TablePrefix` e atua como a fonte autoritativa para as atribuições de prefixos de tabelas em todo o banco de dados.

O prefixo de uma tabela faz parte da identidade técnica estável da tabela.

Os prefixos são utilizados não apenas nos nomes das colunas, mas também em *Primary Keys* (chaves primárias), *Foreign Keys* (chaves estrangeiras), *constraints* (restrições), *indexes* (índices), *scripts* de validação, saída de *deployment* (implantação) e documentação técnica.

Toda tabela deve possuir um prefixo AtlasCommerce atribuído antes que sua definição no banco de dados seja projetada e implantada.

A atribuição do prefixo é registrada em `metadata.TablePrefix` durante a fase de *seed* (carga inicial) gerenciada pelo *deployment* (implantação) e deve corresponder ao prefixo já utilizado pela definição da tabela.

Depois que um prefixo tiver sido atribuído a uma tabela, ele nunca deve ser reatribuído a outra tabela, mesmo que a tabela original seja posteriormente desativada ou removida.

Os registros de prefixos não devem ser fisicamente excluídos como parte da manutenção normal do banco de dados.

As atribuições históricas devem ser preservadas para:

- Impedir a reutilização de prefixos.
- Preservar a rastreabilidade.
- Manter a consistência histórica em *scripts* e documentação.
- Evitar ambiguidade durante a revisão de objetos de banco de dados descontinuados ou *legacy* (legados).

O registro é autoritativo para a propriedade dos prefixos.

Um prefixo presente em um *script* ou documento não se sobrepõe à atribuição registrada em `metadata.TablePrefix`.

Se for encontrada uma divergência entre a documentação e o registro validado, a divergência deve ser investigada e o artefato obsoleto corrigido, em vez de reatribuir silenciosamente o prefixo.

---

## 6. Regras de Nomenclatura de Prefixos

Os prefixos de tabelas devem fornecer um identificador curto, reconhecível, único e estável para cada tabela do AtlasCommerce.

Os prefixos devem:

- Utilizar letras ASCII maiúsculas de `A` a `Z`.
- Conter entre dois e cinco caracteres.
- Atender às regras de integridade implementadas em `metadata.TablePrefix`, que garantem tanto o comprimento entre dois e cinco caracteres quanto o formato em letras maiúsculas de `A` a `Z`.
- Ser únicos em todo o banco de dados, independentemente do *schema* (esquema).
- Ser registrados em `metadata.TablePrefix` antes do uso.
- Nunca ser reutilizados após a atribuição, incluindo prefixos associados a tabelas inativas ou descontinuadas.
- Permanecer estáveis durante toda a vida útil da tabela, a menos que uma decisão arquitetural explícita exija uma alteração controlada.

---

### 6.1 Comprimento Preferencial do Prefixo

Três caracteres são o padrão preferencial para entidades raiz ou independentes quando uma abreviação clara e significativa puder ser definida.

Exemplos:

| Tabela | Prefixo |
|---|---|
| `Transaction` | `TRN` |
| `Product` | `PRD` |
| `Customer` | `CST` |
| `Inventory` | `INV` |
| `Payment` | `PAY` |
| `Shipment` | `SHP` |

Tabelas estreitamente relacionadas ou dependentes normalmente devem preservar uma raiz reconhecível quando isso produzir um identificador claro e único.

Cinco caracteres são o padrão preferencial para muitas dessas tabelas, mas não são obrigatórios.

Exemplos:

| Tabela | Prefixo |
|---|---|
| `TransactionItem` | `TRNIT` |
| `CustomerAddress` | `CSTAD` |
| `InventoryReservation` | `INVRE` |
| `PaymentRefund` | `PAYRF` |
| `ShipmentMethod` | `SHPMT` |

Outros comprimentos de prefixo dentro do limite máximo de cinco caracteres são permitidos quando produzirem um identificador mais claro.

O comprimento do prefixo não deve ser tratado como uma representação rígida de hierarquia.

---

### 6.2 Entidades Relacionadas Independentes

Tabelas com uma identidade classificatória ou reutilizável independente não precisam herdar o prefixo de uma entidade relacionada.

Exemplos:

| Tabela | Prefixo |
|---|---|
| `CustomerDocumentType` | `DTP` |
| `ContactType` | `CTP` |

O relacionamento entre tabelas deve ser representado pelo modelo de dados, e não artificialmente codificado em cada prefixo.

---

### 6.3 Seleção de Prefixos

Ao definir um novo prefixo, aplicam-se as seguintes prioridades:

1. Unicidade em todo o AtlasCommerce.
2. Estabilidade durante toda a vida útil da tabela.
3. Reconhecimento claro da tabela ou entidade.
4. Consistência com prefixos relacionados quando for útil.
5. Brevidade.

Clareza e unicidade têm precedência sobre forçar artificialmente um prefixo a conter exatamente três ou cinco caracteres.

Um prefixo não deve ser selecionado apenas por ser curto se outro prefixo representar a tabela com maior clareza.

Da mesma forma, um prefixo não deve ser estendido apenas para atender a uma quantidade preferencial de caracteres quando a forma mais curta já for clara e única.

---

### 6.4 Reutilização de Prefixos

A reutilização de prefixos é proibida.

Quando uma tabela for descontinuada, renomeada por meio de uma alteração arquitetural controlada ou de outra forma removida do modelo ativo, sua atribuição histórica de prefixo deve permanecer reservada.

Um prefixo inativo não deve se tornar disponível para atribuição a outra tabela.

Essa regra preserva o significado histórico de:

- Nomes de colunas.
- Nomes de *constraints* (restrições).
- Nomes de *indexes* (índices).
- *Logs* (registros) de *deployment* (implantação).
- Histórico do controle de versão.
- Documentação técnica.
- Evidências operacionais.

---

### 6.5 Prefixos em Relacionamentos

Colunas de *Foreign Key* (chave estrangeira) devem preservar tanto o prefixo da tabela proprietária quanto o prefixo da tabela referenciada.

Exemplo:

`TRNIT_TRN_id`

Onde:

- `TRNIT` identifica `sales.TransactionItem`.
- `TRN` identifica `sales.Transaction`.
- `id` identifica a chave referenciada.

Essa convenção torna a propriedade do relacionamento visível diretamente no nome da coluna, preservando ao mesmo tempo a identidade técnica estável de ambas as tabelas participantes.

---

## 7. Padrões de Primary Key

As tabelas devem possuir uma *Primary Key* (chave primária) sempre que um identificador estável de linha for exigido pelo modelo de dados.

As *Primary Keys* (chaves primárias) são a estratégia padrão de identificação para as tabelas do AtlasCommerce, mas exceções são permitidas quando a semântica da tabela não exigir um identificador independente de linha.

As colunas de *Primary Key* (chave primária) devem:

- Seguir a convenção padrão de nomenclatura de colunas aplicável.
- Utilizar o prefixo registrado da tabela proprietária.
- Ser definidas como `NOT NULL`.
- Ser criadas juntamente com a tabela como parte de sua definição inicial.
- Possuir documentação de objeto padronizada que identifique sua função na *Primary Key* (chave primária).

Quando uma *Primary Key* (chave primária) utilizar um identificador substituto, esse identificador deve utilizar o sufixo `_id`.

Uma *Primary Key* (chave primária) composta pode, em vez disso, ser formada inteiramente por colunas cujos nomes reflitam suas próprias funções semânticas ou de relacionamento.

As *constraints* (restrições) de *Primary Key* (chave primária) devem:

- Utilizar um nome explícito e determinístico.
- Seguir a convenção de nomenclatura `PK_<PFX>`.
- Ser validadas como parte do *deployment* (implantação) da tabela.
- Não ser criadas, removidas ou substituídas posteriormente pelas fases separadas de *deployment* (implantação) de *constraints* (restrições).

Exemplos:

| Tabela | Prefixo | Constraint de Primary Key |
|---|---|---|
| `metadata.TablePrefix` | `PFX` | `PK_PFX` |
| `customer.Customer` | `CST` | `PK_CST` |
| `catalog.ProductVariant` | `PRDVA` | `PK_PRDVA` |
| `inventory.InventoryReservation` | `INVRE` | `PK_INVRE` |
| `payment.Payment` | `PAY` | `PK_PAY` |
| `sales.Transaction` | `TRN` | `PK_TRN` |

---

### 7.1 Primary Keys Substitutas

As *Primary Keys* (chaves primárias) normalmente devem utilizar um identificador numérico substituto quando a tabela exigir uma identidade independente de linha.

Identificadores naturais de negócio geralmente devem ser modelados como colunas regulares com as *Unique Constraints* (restrições de unicidade) apropriadas, em vez de serem utilizados como *Primary Key* (chave primária).

Isso separa a identidade técnica estável dos identificadores de negócio cujo significado, formato ou ciclo de vida podem evoluir de forma independente.

---

### 7.2 Tipo de Dados da Primary Key

O tipo de dados da *Primary Key* (chave primária) deve ser selecionado de acordo com a natureza, a cardinalidade esperada e o crescimento da tabela.

O AtlasCommerce não exige um único tipo numérico para todas as *Primary Keys* (chaves primárias).

O tipo selecionado deve fornecer capacidade suficiente para o tempo de vida esperado da tabela sem introduzir sobrecarga desnecessária de armazenamento.

A escolha de `TINYINT`, `SMALLINT`, `INT`, `BIGINT` ou outro tipo justificável deve, portanto, ser baseada nas características do objeto, e não em uma regra universal.

---

### 7.3 Identity

*Primary Keys* (chaves primárias) numéricas substitutas normalmente devem utilizar:

`IDENTITY(1,1)`

a menos que o projeto da tabela exija uma estratégia diferente de geração de chave.

`IDENTITY(1,1)` é o padrão do AtlasCommerce para identificadores numéricos substitutos, e não uma exigência incondicional para todas as *Primary Keys* (chaves primárias).

Qualquer estratégia alternativa de geração de chave deve ser explicitamente justificada pelo modelo de dados ou pela arquitetura.

---

### 7.4 Primary Keys Clustered

`PRIMARY KEY CLUSTERED` é o padrão atual do AtlasCommerce.

Entretanto, *clustering* (agrupamento) é uma decisão de projeto físico e não deve ser tratado como uma característica incondicional de todas as *Primary Keys* (chaves primárias).

Uma estratégia diferente de *clustering* (agrupamento) pode ser utilizada quando explicitamente justificada por:

- Requisitos de particionamento.
- Padrões de acesso.
- Organização física dos dados.
- Características da carga de trabalho.
- Outro requisito arquitetural documentado.

A definição esperada de *clustering* (agrupamento) faz parte do estado da *Primary Key* (chave primária) e deve ser validada durante o *deployment* (implantação).

---

### 7.5 Primary Keys Compostas

Uma tabela pode utilizar uma *Primary Key* (chave primária) composta quando exigido pelo modelo lógico de dados ou pelo projeto físico do banco de dados.

As *Primary Keys* (chaves primárias) compostas utilizam a mesma convenção de nomenclatura de *constraint* (restrição):

`PK_<PFX>`

O nome da *constraint* (restrição) identifica a *Primary Key* (chave primária) da tabela e não deve concatenar os nomes de todas as colunas participantes.

A quantidade, a identidade e a ordem das colunas participantes fazem parte da definição esperada da *Primary Key* (chave primária).

Tabelas transacionais particionadas podem exigir um componente temporal ou de particionamento além do identificador substituto.

Quando isso ocorrer, a definição completa da chave implementada deve ser validada durante o *deployment* (implantação).

---

### 7.6 Funções de Primary Key e Foreign Key

Uma coluna de *Primary Key* (chave primária) também pode participar de um relacionamento de *Foreign Key* (chave estrangeira) quando exigido por um relacionamento um-para-um ou identificador.

Quando uma coluna desempenhar ambas as funções, sua documentação de objeto deve descrever as duas responsabilidades.

---

### 7.7 Tabelas sem Primary Key

Tabelas que intencionalmente não exigem uma *Primary Key* (chave primária) são permitidas quando justificadas por seu propósito técnico ou arquitetural.

A ausência de uma *Primary Key* (chave primária) deve ser uma decisão explícita de projeto, e não uma omissão acidental.

Uma tabela não deve receber uma *Primary Key* (chave primária) artificial apenas para satisfazer uma convenção quando nenhuma identidade independente de linha for exigida pelo modelo.

---

## 8. Padrões de Foreign Key

As colunas de *Foreign Key* (chave estrangeira) devem identificar claramente tanto a tabela proprietária da coluna quanto a tabela referenciada pelo relacionamento.

O formato padrão de nomenclatura de coluna de *Foreign Key* (chave estrangeira) é:

`OWN_REF_id`

Onde:

- `OWN` é o prefixo registrado completo da tabela proprietária.
- `REF` é o prefixo registrado completo da tabela referenciada.
- `id` identifica a chave referenciada.

Exemplo:

`TRN_TRNST_id`

Onde:

- `TRN` identifica a tabela proprietária, `sales.Transaction`.
- `TRNST` identifica a tabela referenciada, `sales.TransactionStatus`.
- `id` identifica `TRNST_id`.

Outro exemplo entre domínios é:

`SHP_CSTAD_id`

Onde:

- `SHP` identifica a tabela proprietária, `shipping.Shipment`.
- `CSTAD` identifica a tabela referenciada, `customer.CustomerAddress`.
- `id` identifica `CSTAD_id`.

---

### 8.1 Definição de Coluna de Foreign Key

As colunas de *Foreign Key* (chave estrangeira) devem:

- Seguir a convenção padrão de nomenclatura de colunas aplicável.
- Identificar a tabela referenciada por meio de seu prefixo registrado quando a coluna representar o identificador referenciado.
- Utilizar uma definição compatível com a coluna correspondente da chave referenciada.
- Ser `NOT NULL` quando o relacionamento for obrigatório.
- Permitir `NULL` somente quando o relacionamento for explicitamente opcional no modelo de dados.
- Possuir documentação de objeto consistente com o padrão de documentação implementado.

A convenção padrão `OWN_REF_id` aplica-se ao componente identificador de um relacionamento.

Colunas adicionais participantes de uma *Foreign Key* (chave estrangeira) composta devem preservar a convenção de nomenclatura apropriada à sua própria função semântica e não precisam utilizar o padrão `_REF_id`.

A compatibilidade inclui as características relevantes da definição da chave referenciada.

Dependendo do tipo de dado, isso pode incluir:

- Tipo de dado.
- Comprimento.
- Precisão.
- Escala.

As definições das colunas de *Foreign Key* (chave estrangeira) não devem depender de conversões implícitas para compensar definições incompatíveis.

---

### 8.2 Relacionamentos Opcionais

A nulabilidade representa a opcionalidade do relacionamento.

Um relacionamento obrigatório utiliza uma coluna de *Foreign Key* (chave estrangeira) `NOT NULL`.

Um relacionamento opcional pode utilizar uma coluna de *Foreign Key* (chave estrangeira) que permita `NULL` quando a ausência da entidade referenciada representar um estado válido no modelo de dados.

`NULL` não deve ser introduzido apenas para simplificar o *deployment* (implantação) ou o comportamento da aplicação.

---

### 8.3 Múltiplos Relacionamentos com a Mesma Tabela

Quando uma tabela possuir múltiplas *Foreign Keys* (chaves estrangeiras) referenciando a mesma tabela, um qualificador descritivo poderá ser utilizado quando necessário para distinguir a função de negócio de cada relacionamento.

Formato:

`OWN_qualifier_REF_id`

O qualificador deve:

- Utilizar inglês.
- Utilizar *lowercase snake_case* (snake_case em letras minúsculas).
- Descrever a função semântica do relacionamento.
- Ser utilizado apenas quando necessário para remover ambiguidade.

Exemplo ilustrativo:

`ABC_origin_ADR_id`

`ABC_destination_ADR_id`

Esses exemplos ilustram a regra de nomenclatura e não representam objetos obrigatórios do AtlasCommerce.

Um qualificador não deve ser adicionado quando o formato normal `OWN_REF_id` já identificar o relacionamento sem ambiguidade.

---

### 8.4 Colunas e Constraints de Foreign Key

As colunas de *Foreign Key* (chave estrangeira) fazem parte da estrutura da tabela e devem ser criadas juntamente com a tabela.

A *constraint* (restrição) de *Foreign Key* (chave estrangeira) propriamente dita é criada separadamente durante a fase de *deployment* (implantação) de *Foreign Key Constraints* (restrições de chave estrangeira).

Essa separação permite que as tabelas sejam criadas em uma ordem lógica previsível enquanto as dependências referenciais são validadas e estabelecidas posteriormente.

O padrão de nomenclatura das *constraints* (restrições) de *Foreign Key* (chave estrangeira) é definido na Seção 10.5.

---

### 8.5 Foreign Keys Compostas

Um relacionamento pode exigir mais de uma coluna local e referenciada.

*Foreign Keys* (chaves estrangeiras) compostas preservam a convenção normal de nomenclatura de cada coluna participante.

A *constraint* (restrição) de *Foreign Key* (chave estrangeira) representa o relacionamento entre as duas tabelas e não deve concatenar todas as colunas participantes em seu nome.

Exemplos no modelo implementado do AtlasCommerce incluem relacionamentos de:

- `payment.Payment` para `sales.Transaction`.
- `inventory.InventoryReservation` para `sales.TransactionItem`.

Nesses relacionamentos, o *timestamp* (registro de data e hora) da transação participa da *Foreign Key* (chave estrangeira) além do identificador.

Para uma *Foreign Key* (chave estrangeira) composta, os seguintes elementos fazem parte da definição esperada:

- Quantidade de colunas participantes.
- Colunas proprietárias.
- Colunas referenciadas.
- Correspondência entre colunas proprietárias e referenciadas.
- Ordem das colunas.
- Definições de coluna compatíveis.

Uma *Foreign Key* (chave estrangeira) composta não deve ser considerada equivalente apenas porque contém as colunas esperadas em uma ordem diferente.

A convenção `OWN_REF_id` aplica-se ao componente identificador quando presente.

Componentes adicionais, como colunas temporais exigidas por uma *candidate key* (chave candidata) composta ou por um relacionamento consciente de particionamento, mantêm a convenção de nomenclatura apropriada à sua função semântica.

---

### 8.6 Semântica dos Relacionamentos

Uma *Foreign Key* (chave estrangeira) deve representar um relacionamento pertencente ao modelo de dados persistente.

*Foreign Keys* (chaves estrangeiras) não devem ser introduzidas exclusivamente para simplificar uma consulta ou implementação da aplicação.

A existência de uma *Foreign Key* (chave estrangeira) também não implica automaticamente que um *index* (índice) de desempenho correspondente seja necessário.

Integridade referencial e indexação são decisões de projeto separadas:

- *Foreign Keys* (chaves estrangeiras) protegem relacionamentos.
- *Indexes* (índices) suportam padrões de acesso.

Os requisitos de indexação são definidos separadamente na Seção 11.

---

## 9. Padrões de Documentação de Objetos

Tabelas e colunas do banco de dados devem incluir documentação técnica que explique por que o objeto existe e qual é sua função dentro do modelo de dados do AtlasCommerce.

A documentação de objetos complementa, mas não substitui, a documentação de negócio e de arquitetura.

As descrições dos objetos de banco de dados devem permanecer focadas na função técnica e na responsabilidade semântica do objeto dentro do modelo de dados.

A documentação deve:

- Utilizar inglês.
- Ser concisa e tecnicamente significativa.
- Explicar por que o objeto existe e o que ele representa.
- Fornecer informações além daquilo que já pode ser inferido pelo nome do objeto.
- Utilizar terminologia consistente em todo o banco de dados.
- Ser atualizada sempre que o significado ou a responsabilidade do objeto documentado mudar.
- Evitar detalhes voláteis de implementação, exceto quando forem essenciais para a compreensão do objeto.

A documentação obrigatória do objeto faz parte da definição esperada do banco de dados.

Uma tabela ou coluna permanente sem sua documentação obrigatória está incompleta, mesmo quando o objeto físico existe.

---

### 9.1 Documentação de Tabelas

Toda tabela permanente deve possuir uma descrição que explique por que a tabela existe e qual é sua responsabilidade dentro do modelo de dados.

Uma descrição de tabela deve fornecer contexto suficiente para compreender o propósito da tabela sem exigir que o leitor o deduza apenas pelo nome.

Exemplo:

`metadata.TablePrefix`

`Maintains the authoritative registry of table prefixes used to enforce naming consistency, prevent prefix reuse, and preserve prefix assignment history across AtlasCommerce.`

(Mantém o registro autoritativo dos prefixos de tabelas utilizado para garantir consistência de nomenclatura, impedir a reutilização de prefixos e preservar o histórico de atribuição de prefixos em todo o AtlasCommerce.)

As descrições de tabelas devem se concentrar na responsabilidade da tabela, em vez de enumerar detalhes de implementação que já estejam representados por suas colunas, *constraints* (restrições) ou *indexes* (índices).

---

### 9.2 Documentação de Colunas

Toda coluna de uma tabela permanente deve possuir uma descrição.

A descrição de uma coluna deve explicar a responsabilidade semântica da coluna, em vez de apenas repetir ou expandir seu nome.

Por exemplo, uma descrição como:

`Stores the prefix.`

(Armazena o prefixo.)

não fornece informação suficiente para uma coluna chamada `PFX_prefix`.

A descrição deve, em vez disso, explicar a função do valor dentro do modelo.

A documentação da coluna deve permanecer consistente com:

- A responsabilidade da tabela proprietária.
- Os dados representados pela coluna.
- A semântica do relacionamento quando a coluna participa de uma *Foreign Key* (chave estrangeira).
- A semântica de ciclo de vida quando a coluna representa um *timestamp* (registro de data e hora) de auditoria.
- A definição implementada do objeto.

---

### 9.3 Documentação de Primary Key

Uma coluna cuja única função de chave seja o identificador da *Primary Key* (chave primária) utiliza o formato padronizado de descrição:

`Primary key of <schema>.<TableName>.`

(Chave primária de `<schema>.<TableName>`.)

Exemplo:

`PFX_id`

`Primary key of metadata.TablePrefix.`

(Chave primária de `metadata.TablePrefix`.)

A descrição identifica a função técnica da coluna sem adicionar narrativa desnecessária.

Quando uma coluna de *Primary Key* (chave primária) também participar de uma *Foreign Key* (chave estrangeira) ou desempenhar outra função semântica, sua documentação deve descrever as responsabilidades aplicáveis de acordo com o padrão implementado de documentação de objetos, em vez de forçar o literal exclusivo de *Primary Key* (chave primária).

---

### 9.4 Documentação de Foreign Key

As descrições de *Foreign Key* (chave estrangeira) devem seguir as convenções literais implementadas pelos *scripts* de documentação de objetos do AtlasCommerce.

Para *Foreign Keys* (chaves estrangeiras) simples, a implementação atual utiliza descrições concisas que identificam a tabela referenciada.

Exemplos:

`Foreign key of customer.CustomerType.`

(Chave estrangeira de `customer.CustomerType`.)

`Foreign key of payment.Payment.`

(Chave estrangeira de `payment.Payment`.)

A descrição deve identificar o relacionamento semântico representado pela coluna sem reproduzir desnecessariamente detalhes de implementação já expressos pela *constraint* (restrição) de *Foreign Key* (chave estrangeira).

Quando um qualificador descritivo for necessário para distinguir múltiplos relacionamentos com a mesma tabela referenciada, a documentação também deve tornar clara a função de negócio do relacionamento.

#### Foreign Keys Compostas

Quando uma *Foreign Key* (chave estrangeira) contiver múltiplas colunas, cada coluna participante deve documentar sua função específica no relacionamento composto.

Os componentes identificador e temporal devem ser distinguíveis quando aplicável.

Por exemplo, um relacionamento composto pode conter:

- Um componente identificador que referencia a parte identificadora da *candidate key* (chave candidata).
- Um componente de *timestamp* (registro de data e hora) da transação que referencia a parte temporal da *candidate key* (chave candidata).

O texto exato das descrições utilizado para as colunas de *Foreign Key* (chave estrangeira) implementadas é definido pelos *scripts* de *deployment* (implantação) da documentação de objetos.

Os *scripts* de *deployment* (implantação) da documentação de objetos são a fonte da verdade para os literais de descrição esperados, e a *Final Validation* (validação final) deve permanecer sincronizada com essas definições.

---

### 9.5 Documentação de Colunas de Auditoria

Colunas de *timestamp* (registro de data e hora) de auditoria de ciclo de vida utilizam descrições padronizadas sempre que a semântica genérica de ciclo de vida for aplicável.

Para uma coluna padrão `<PFX>_created_at`, a descrição padrão é:

`Records the date and time when the row was initially created.`

(Registra a data e a hora em que a linha foi criada inicialmente.)

Para uma coluna padrão `<PFX>_updated_at`, a descrição padrão é:

`Records the date and time of the most recent meaningful modification to the row.`

(Registra a data e a hora da modificação significativa mais recente na linha.)

Uma tabela pode utilizar uma descrição de ciclo de vida mais específica quando a função semântica da linha exigir contexto adicional.

O *script* de *deployment* (implantação) da documentação de objetos permanece como fonte da verdade para a descrição exata esperada.

A palavra `meaningful` (significativa) é intencional.

`updated_at` representa a modificação significativa mais recente na linha persistida e não deve ser interpretado como uma exigência de alterar o *timestamp* (registro de data e hora) em toda operação técnica, independentemente do impacto semântico.

---

### 9.6 Manutenção da Documentação

A documentação de objetos é mantida com o mesmo nível de controle que o próprio objeto de banco de dados.

O comportamento padrão do *deployment* (implantação) é:

| Estado Atual | Comportamento do *Deployment* (Implantação) |
|---|---|
| A documentação esperada está ausente | Criar a documentação quando o objeto documentado existir |
| A documentação existente corresponde | Validar sem modificação |
| A documentação existente diverge | Relatar a divergência e preservar o valor existente |

O *deployment* (implantação) padrão não deve sobrescrever automaticamente documentação divergente.

Uma divergência pode representar:

- Uma descrição obsoleta no banco de dados.
- Uma definição esperada obsoleta.
- Uma alteração manual deliberada.
- Uma alteração semântica que ainda não foi sincronizada em todo o projeto.
- Outra condição que exija revisão humana.

O *deployment* (implantação) não possui contexto suficiente para decidir automaticamente qual lado de uma divergência de documentação é autoritativo.

As descrições esperada e existente devem, portanto, ser relatadas quando prático, para que a discrepância possa ser revisada.

A correção de documentação divergente exige uma alteração intencional e controlada.

---

### 9.7 Fonte da Verdade da Documentação

A documentação de objetos deve permanecer sincronizada entre:

- *Scripts* de *deployment* (implantação) da documentação de objetos.
- *Final Validation* (validação final).
- *Database Standards* (padrões de banco de dados).
- Documentação de arquitetura, quando aplicável.
- Documentação de negócio, quando o mesmo conceito for descrito no nível de negócio.

Esses artefatos possuem propósitos diferentes e não devem ser tratados como intercambiáveis.

Os *scripts* de *deployment* (implantação) da documentação de objetos definem as descrições técnicas exatas esperadas no banco de dados.

A *Final Validation* (validação final) verifica independentemente se as descrições implantadas correspondem a essas expectativas.

Os *Database Standards* (padrões de banco de dados) definem as convenções utilizadas para criar e manter essas descrições.

A documentação de negócio e de arquitetura fornece contexto mais amplo e não deve ser copiada integralmente para as *extended properties* (propriedades estendidas) do banco de dados.

Quando um artefato de documentação mais antigo entrar em conflito com a implementação consolidada e validada do banco de dados, a definição implementada e validada do banco de dados deve ser investigada primeiro.

Se for confirmado que a implementação representa o padrão atual do AtlasCommerce, a documentação obsoleta deve ser sincronizada com ela, em vez de modificar objetos de banco de dados já estabelecidos apenas para preservar um documento desatualizado.

---

## 10. Padrões de Constraints

As *constraints* (restrições) de banco de dados devem ser explicitamente definidas, nomeadas de forma consistente e validadas independentemente durante o *deployment* (implantação).

As *constraints* (restrições) devem:

- Utilizar nomes explícitos e determinísticos.
- Seguir os padrões de nomenclatura de *constraints* (restrições) do AtlasCommerce.
- Ser validadas antes da criação.
- Nunca ser duplicadas em uma reexecução.
- Nunca ser automaticamente removidas ou substituídas quando uma definição inesperada for encontrada.
- Relatar divergências.
- Ser criadas separadamente da definição da tabela, exceto *Primary Keys* (chaves primárias).
- Ser tratadas como regras de integridade de dados, e não como mecanismos de desempenho.

A existência apenas pelo nome não constitui validação suficiente.

A validação deve considerar tanto a identidade do objeto quanto as características que fazem parte da definição esperada.

Uma *constraint* (restrição) funcionalmente equivalente com um nome inesperado deve ser relatada como uma divergência de nomenclatura.

Uma divergência de nomenclatura não transforma o objeto inesperado na *constraint* (restrição) esperada.

O *deployment* (implantação) pode preservar o objeto existente para revisão controlada, mas a validação deve continuar distinguindo a identidade da *constraint* (restrição) esperada de um objeto funcionalmente equivalente com nome diferente.

O *deployment* (implantação) padrão não deve renomear, remover ou recriar automaticamente o objeto apenas para forçar seu nome a corresponder à convenção esperada.

A ordem padrão de *deployment* (implantação) das *constraints* (restrições) é:

1. *Primary Keys* (chaves primárias) — criadas e validadas como parte do *deployment* (implantação) das tabelas.
2. *Default Constraints* (restrições de valor padrão).
3. *Check Constraints* (restrições de verificação).
4. *Unique Constraints* (restrições de unicidade).
5. *Foreign Key Constraints* (restrições de chave estrangeira).

*Indexes* (índices) orientados a desempenho são tratados separadamente na Seção 11.

---

### 10.1 Primary Keys

Os padrões das *constraints* (restrições) de *Primary Key* (chave primária) são definidos na Seção 7.

O formato padrão de nomenclatura da *constraint* (restrição) de *Primary Key* (chave primária) é:

`PK_<PFX>`

Exemplos:

- `PK_PFX`
- `PK_CST`
- `PK_PRDVA`
- `PK_PAY`
- `PK_INVRE`
- `PK_TRN`

As *Primary Keys* (chaves primárias) são criadas juntamente com suas tabelas proprietárias e validadas como parte do *deployment* (implantação) da tabela.

Elas não são criadas pelas fases posteriores de *deployment* (implantação) de *constraints* (restrições).

A validação de uma *Primary Key* (chave primária) deve considerar sua definição esperada completa, incluindo, quando aplicável:

- Nome da *constraint* (restrição).
- Colunas participantes.
- Ordem das colunas.
- *Clustering* (agrupamento).
- Componentes relacionados ao particionamento.
- Outras características explicitamente padronizadas da *Primary Key* (chave primária) implementada.

*Primary Keys* (chaves primárias) compostas utilizam a mesma convenção de nomenclatura `PK_<PFX>`.

O nome da *constraint* (restrição) identifica a *Primary Key* (chave primária) da tabela e não deve concatenar os nomes de todas as colunas participantes.

---

### 10.2 Default Constraints

*Default Constraints* (restrições de valor padrão) definem um valor inicial legítimo que o banco de dados pode atribuir quando um valor não for explicitamente fornecido durante a criação da linha.

Uma *Default Constraint* (restrição de valor padrão) representa um estado inicial intencional.

Ela não define comportamento automático para atualizações subsequentes.

O formato padrão de nomenclatura é:

`DF_<PFX>_<column_name>`

O prefixo da tabela não deve ser repetido na parte referente à coluna no nome da *constraint* (restrição).

Exemplo:

`PFX_is_active`

torna-se:

`DF_PFX_is_active`

e não:

`DF_PFX_PFX_is_active`

Outro exemplo implementado é:

`TRNIT_unit_discount`

com:

`DF_TRNIT_unit_discount`

e um valor inicial padrão de:

`0.00`

*Timestamps* (registros de data e hora) de auditoria de ciclo de vida podem utilizar:

`SYSDATETIME()`

como seu valor inicial padrão quando definido pelo projeto aplicável da tabela.

#### NOT NULL e DEFAULT

`NOT NULL` e `DEFAULT` representam decisões de projeto diferentes.

`NOT NULL` significa:

> Um valor é obrigatório.

`DEFAULT` significa:

> O banco de dados conhece o valor inicial semanticamente correto quando nenhum valor é explicitamente fornecido.

Uma coluna obrigatória não exige automaticamente uma *Default Constraint* (restrição de valor padrão).

*Default Constraints* (restrições de valor padrão) não devem fabricar valores *placeholder* (substitutos) apenas para evitar `NULL` ou satisfazer uma definição `NOT NULL`.

Exemplos de valores artificiais que não devem ser introduzidos sem significado legítimo de negócio incluem:

- *Strings* (cadeias de caracteres) vazias representando texto desconhecido.
- Valores numéricos arbitrários representando identificadores desconhecidos.
- Datas históricas artificiais representando *timestamps* (registros de data e hora) desconhecidos.
- Valores de *status* (estado) selecionados apenas para satisfazer a nulabilidade.

As *Default Constraints* (restrições de valor padrão) são criadas durante sua fase dedicada de *deployment* (implantação).

A validação deve verificar:

- Tabela proprietária.
- Coluna proprietária.
- Nome esperado da *constraint* (restrição).
- Expressão `DEFAULT` esperada.

Um `DEFAULT` divergente existente deve ser relatado e preservado para revisão controlada.

A comparação da expressão `DEFAULT` deve considerar a representação de metadados do SQL Server para que diferenças sintáticas de formatação, por si só, não produzam uma falsa divergência semântica.

---

### 10.3 Check Constraints

*Check Constraints* (restrições de verificação) impõem regras permanentes de integridade de dados que devem permanecer verdadeiras para os dados armazenados válidos.

O formato padrão de nomenclatura é:

`CK_<PFX>_<rule_name>`

O nome da regra deve:

- Utilizar inglês.
- Utilizar *lowercase snake_case* (snake_case em letras minúsculas).
- Descrever a regra de integridade.
- Evitar simplesmente concatenar todos os nomes das colunas participantes.
- Evitar sufixos numéricos sem significado.

Exemplos:

- `CK_PFX_prefix_format`
- `CK_PFX_prefix_length`
- `CK_PRDVP_valid_period`
- `CK_CSTAD_primary_active`
- `CK_TRN_discount_not_greater_than_gross_amount`

Uma *Check Constraint* (restrição de verificação) pode validar:

- Uma única coluna.
- Um relacionamento entre múltiplas colunas da mesma linha.

O nome da *constraint* (restrição) deve descrever a regra protegida.

Por exemplo:

`CK_TRN_discount_not_greater_than_gross_amount`

comunica a regra de integridade protegida de forma mais clara do que um nome construído apenas com os nomes das colunas participantes.

Sufixos numéricos utilizados exclusivamente para distinguir regras que, de outra forma, seriam ambíguas não são permitidos.

Exemplos como:

`CK_PFX_prefix_1`

`CK_PFX_prefix_2`

devem ser substituídos por nomes de regra significativos.

#### Uso Apropriado de CHECK Constraints

*CHECK Constraints* (restrições CHECK) devem proteger regras invariantes dos dados.

Uma `CHECK` é apropriada quando a violação da regra tornaria os dados persistidos estrutural ou semanticamente inválidos, independentemente de qual aplicação, interface, processo ou *deployment* (implantação) inseriu a linha.

*CHECK Constraints* (restrições CHECK) não devem ser utilizadas apenas para duplicar:

- Comportamento temporário da aplicação.
- Validação da interface do usuário.
- Regras específicas de processo.
- Validação cuja semântica dependa de contexto externo não representado pela linha.

#### Validação de Check Constraint

A validação deve verificar:

- Tabela proprietária.
- Nome esperado da *constraint* (restrição).
- Definição esperada da regra.
- Estado *enabled* (habilitado).
- Estado *trusted* (confiável).

Uma *CHECK Constraint* (restrição CHECK) do AtlasCommerce é totalmente válida somente quando estiver *enabled* (habilitada) e *trusted* (confiável).

Uma *CHECK Constraint* (restrição CHECK) recém-criada deve validar os dados existentes para que a *constraint* (restrição) resultante seja *trusted* (confiável) desde seu estado inicial.

Uma *constraint* (restrição) existente com o nome esperado, mas com definição divergente, deve ser relatada e preservada, em vez de ser automaticamente removida e recriada.

---

### 10.4 Unique Constraints

*Unique Constraints* (restrições de unicidade) impõem a unicidade exigida pelo modelo de dados.

O formato padrão de nomenclatura é:

`UQ_<PFX>_<rule_name>`

O nome da regra deve descrever a regra de unicidade e não deve repetir desnecessariamente o prefixo da tabela.

Exemplos:

- `UQ_BRD_name`
- `UQ_PRDVA_sku`
- `UQ_PRD_brand_name`
- `UQ_CTG_parent_name`
- `UQ_TRNCH_code`

Uma *Unique Constraint* (restrição de unicidade) pode conter uma ou múltiplas colunas.

#### Unique Constraints de Uma Única Coluna

Quando uma única coluna representar claramente a regra de unicidade, a parte semântica do nome da coluna poderá ser utilizada sem repetir o prefixo da tabela.

Exemplo:

`PRDVA_sku`

torna-se:

`UQ_PRDVA_sku`

e não:

`UQ_PRDVA_PRDVA_sku`

#### Unique Constraints Compostas

Uma *Unique Constraint* (restrição de unicidade) composta pode conter múltiplas colunas quando a regra de unicidade se aplicar à combinação delas.

O nome da *constraint* (restrição) deve descrever a regra semântica, em vez de concatenar todas as colunas participantes.

Exemplos:

`UQ_PRD_brand_name`

`UQ_CTG_parent_name`

A quantidade, identidade e ordem das colunas participantes fazem parte da definição esperada da *constraint* (restrição).

Uma `UQ` composta não deve ser considerada equivalente apenas porque contém as colunas esperadas em uma ordem diferente.

#### Identificadores Naturais de Negócio

Identificadores naturais de negócio que não sejam utilizados como *Primary Keys* (chaves primárias) devem utilizar uma *Unique Constraint* (restrição de unicidade) quando valores duplicados violarem o modelo de dados.

Por exemplo:

`PRDVA_sku`

utiliza:

`UQ_PRDVA_sku`

A *Primary Key* (chave primária) substituta fornece identidade técnica estável à linha, enquanto a *Unique Constraint* (restrição de unicidade) protege o identificador de negócio.

#### UQ, IX e UX

O AtlasCommerce distingue *constraints* (restrições) de integridade de dados de estruturas físicas de acesso.

| Prefixo | Objeto | Propósito Principal |
|---|---|---|
| `UQ_` | *Unique Constraint* (restrição de unicidade) | Unicidade incondicional do modelo de dados |
| `IX_` | *Non-Unique Index* (índice não único) | Desempenho e acesso |
| `UX_` | *Unique Index* (índice único) | Unicidade baseada em índice, incluindo unicidade condicional ou filtrada quando exigida pelo modelo |

A capacidade de um objeto impedir valores duplicados não determina, por si só, qual tipo de objeto deve ser utilizado.

A pergunta principal é:

> Por que o requisito de unicidade existe?

Se valores duplicados representarem um estado inválido do modelo de dados, a regra normalmente deve ser representada por uma *Unique Constraint* (restrição de unicidade):

`UQ_`

Se a unicidade exigir recursos específicos de *index* (índice), como um predicado filtrado, a regra poderá ser implementada como um *Unique Index* (índice único):

`UX_`

Estruturas de acesso não únicas orientadas a desempenho utilizam:

`IX_`

Um `UX_` não deve ser utilizado como substituto de um `UQ_` apenas porque o SQL Server consegue impor unicidade por ambos os mecanismos.

*Unique Indexes* (índices únicos) são tratados em detalhes na Seção 11.

#### Validação de Unique Constraint

A validação deve verificar:

- Tabela proprietária.
- Nome esperado da *constraint* (restrição).
- Colunas participantes.
- Ordem das colunas.
- Estado *enabled* (habilitado).
- Posicionamento físico esperado, incluindo *filegroup* (grupo de arquivos) quando explicitamente definido pela implementação.

As *Unique Constraints* (restrições de unicidade) do AtlasCommerce implantadas no armazenamento estrutural padrão devem estar *enabled* (habilitadas) e posicionadas em `FG_CORE`, salvo quando outro projeto físico for explicitamente definido.

Um *Unique Index* (índice único) contendo as mesmas colunas de uma *Unique Constraint* (restrição de unicidade) esperada continua sendo um tipo de objeto diferente.

Essa condição deve ser relatada como *object-type mismatch* (incompatibilidade de tipo de objeto), em vez de ser silenciosamente tratada como uma `UQ` válida.

Quando um *Unique Index* (índice único) funcionalmente equivalente existir no lugar da *Unique Constraint* (restrição de unicidade) esperada, o *deployment* (implantação) padrão deve preservar o *index* (índice) existente e não deve criar automaticamente uma *Unique Constraint* (restrição de unicidade) duplicada.

A condição deve permanecer visível como *object-type mismatch* (incompatibilidade de tipo de objeto) para revisão controlada.

Uma *Unique Constraint* (restrição de unicidade) divergente existente deve ser preservada para revisão controlada.

---

### 10.5 Foreign Keys

As *constraints* (restrições) de *Foreign Key* (chave estrangeira) impõem integridade referencial aos relacionamentos explicitamente definidos pelo modelo de dados do AtlasCommerce.

O formato padrão de nomenclatura é:

`FK_<OWN>_<REF>`

Onde:

- `OWN` é o prefixo registrado completo da tabela proprietária.
- `REF` é o prefixo registrado completo da tabela referenciada.

Exemplos:

- `FK_TRN_TRNST`
- `FK_PRDVA_PRD`
- `FK_SHP_CSTAD`
- `FK_PAY_TRN`
- `FK_INVRE_TRNIT`

Quando múltiplos relacionamentos entre o mesmo par de tabelas exigirem um qualificador, o formato de nomenclatura da *constraint* (restrição) é:

`FK_<OWN>_<qualifier>_<REF>`

O qualificador deve seguir os mesmos princípios semânticos definidos para colunas qualificadas de *Foreign Key* (chave estrangeira) na Seção 8.

#### Foreign Keys Compostas

*Foreign Keys* (chaves estrangeiras) compostas utilizam a mesma convenção de nomenclatura orientada ao relacionamento.

O nome da *constraint* (restrição) identifica o relacionamento entre as tabelas proprietária e referenciada e não deve concatenar todas as colunas participantes.

Por exemplo, um relacionamento composto de:

`payment.Payment`

para:

`sales.Transaction`

continua utilizando um nome conciso orientado ao relacionamento:

`FK_PAY_TRN`

A quantidade, identidade, correspondência e ordem das colunas participantes fazem parte da definição esperada da *Foreign Key* (chave estrangeira).

#### Chaves Referenciadas

Uma *Foreign Key* (chave estrangeira) pode referenciar:

- Uma *Primary Key* (chave primária).
- Outra *candidate key* (chave candidata) cuja unicidade seja explicitamente garantida pelo modelo de dados.

As colunas referenciadas devem, portanto, formar uma *candidate key* (chave candidata) única apropriada.

A existência das colunas referenciadas, por si só, não é suficiente.

#### Compatibilidade de Colunas

As colunas participantes da *Foreign Key* (chave estrangeira) devem possuir definições compatíveis.

A validação deve considerar características relevantes do tipo, incluindo, quando aplicável:

- Tipo de dado.
- Comprimento.
- Precisão.
- Escala.

Relacionamentos de *Foreign Key* (chave estrangeira) não devem depender de conversão implícita entre definições incompatíveis.

#### Ações Referenciais

As ações referenciais devem ser explicitamente avaliadas para cada relacionamento.

Ações em cascata não são o comportamento padrão do AtlasCommerce.

Ações como:

`ON DELETE CASCADE`

`ON UPDATE CASCADE`

`ON DELETE SET NULL`

ou comportamentos automáticos semelhantes podem ser utilizadas somente quando representarem corretamente uma regra de ciclo de vida intencional e documentada.

O comportamento em cascata não deve ser introduzido apenas para simplificar código de aplicação ou operações administrativas.

Quando nenhuma ação referencial automática for necessária, o relacionamento preserva o comportamento restritivo do mecanismo de banco de dados.

A implementação atual das *Foreign Keys* (chaves estrangeiras) do AtlasCommerce utiliza `NO ACTION` tanto para `ON DELETE` quanto para `ON UPDATE`, salvo quando um relacionamento definir explicitamente outro comportamento de ciclo de vida documentado.

#### Validação de Dependências

Antes de criar uma *Foreign Key* (chave estrangeira), o *deployment* (implantação) deve validar as dependências necessárias.

Dependendo do relacionamento, a validação inclui:

- Tabela proprietária.
- Colunas proprietárias.
- Tabela referenciada.
- Colunas referenciadas.
- *Primary Key* (chave primária) ou *candidate key* (chave candidata) referenciada.
- Definições de coluna compatíveis.
- Quantidade de colunas participantes.
- Correspondência entre colunas proprietárias e referenciadas.
- Ordem das colunas.
- Ações referenciais.

Uma *Foreign Key* (chave estrangeira) não deve ser criada quando uma dependência necessária estiver ausente ou incompatível.

#### Estado Enabled e Trusted

Uma *Foreign Key* (chave estrangeira) do AtlasCommerce é totalmente válida somente quando estiver:

- *Enabled* (habilitada).
- *Trusted* (confiável).

Uma *Foreign Key* (chave estrangeira) que exista, mas esteja *disabled* (desabilitada) ou *not trusted* (não confiável), não representa o estado final esperado.

Novas *Foreign Keys* (chaves estrangeiras) devem validar os dados existentes para que a *constraint* (restrição) resultante seja *trusted* (confiável) desde seu estado inicial.

#### Divergência de Foreign Key

A existência de uma *Foreign Key* (chave estrangeira) com o nome esperado não constitui validação suficiente.

Uma `FK` existente ainda pode divergir em:

- Colunas proprietárias.
- Tabela referenciada.
- Colunas referenciadas.
- Correspondência de colunas.
- Ordem das colunas.
- *Candidate key* (chave candidata) referenciada.
- Ações referenciais.
- Estado *enabled* (habilitado).
- Estado *trusted* (confiável).

Uma *Foreign Key* (chave estrangeira) que exista com o relacionamento esperado, mas esteja *disabled* (desabilitada) ou *not trusted* (não confiável), constitui um estado divergente de *Foreign Key* (chave estrangeira) e não deve ser relatada como totalmente válida.

Uma *Foreign Key* (chave estrangeira) existente com definição divergente deve ser relatada.

O *deployment* (implantação) padrão não deve remover e recriar automaticamente a `FK` apenas para forçá-la ao estado esperado.

A correção exige uma alteração intencional e controlada.

---

## 11. Padrões de Índices

Os *indexes* (índices) tratados nesta seção são estruturas físicas de acesso criadas para suportar desempenho de consultas, padrões de acesso ou requisitos de unicidade baseados em *index* (índice) que não possam ser adequadamente representados por uma *Unique Constraint* (restrição de unicidade).

*Indexes* (índices) não únicos são estruturas de acesso orientadas a desempenho.

*Unique Indexes* (índices únicos) também podem impor unicidade condicional ou filtrada exigida pelo modelo de dados.

*Indexes* (índices) não devem ser criados apenas porque uma coluna existe, porque uma coluna participa de uma *Foreign Key* (chave estrangeira) ou porque uma coluna aparece em uma consulta.

Todo *index* (índice) orientado a desempenho deve possuir um padrão de acesso identificado ou uma justificativa técnica.

O AtlasCommerce utiliza duas convenções de nomenclatura para objetos de *index* (índice):

`IX_<PFX>_<purpose>`

para *indexes* (índices) não únicos, e:

`UX_<PFX>_<purpose>`

para *Unique Indexes* (índices únicos) utilizados tanto como estruturas de acesso orientadas a desempenho com um requisito de unicidade no nível do *index* (índice) quanto para implementar regras de unicidade baseadas em *index* (índice), como unicidade filtrada.

Onde:

- `PFX` é o prefixo registrado da tabela proprietária.
- `purpose` descreve o padrão de acesso ou propósito técnico suportado pelo *index* (índice).

A parte `purpose` deve utilizar inglês e *lowercase snake_case* (snake_case em letras minúsculas).

O nome do *index* (índice) deve comunicar por que ele existe, em vez de concatenar automaticamente todas as colunas participantes.

Os *indexes* (índices) devem:

- Utilizar nomes explícitos e determinísticos.
- Seguir os padrões de nomenclatura de *indexes* (índices) do AtlasCommerce.
- Ser criados separadamente durante a fase de *deployment* (implantação) de *indexes* (índices).
- Ser validados antes da criação.
- Nunca ser duplicados em uma reexecução.
- Nunca ser automaticamente removidos, movidos ou substituídos quando uma definição divergente for encontrada.
- Ser justificados por um padrão de acesso, requisito técnico mensurável ou regra de unicidade baseada em *index* (índice) que não possa ser adequadamente representada por uma *Unique Constraint* (restrição de unicidade).
- Considerar tanto o benefício de leitura quanto o custo de escrita/manutenção.
- Ser revisados quando a carga de trabalho que os justificou mudar.

A existência de uma *Foreign Key* (chave estrangeira) não exige automaticamente um *index* (índice) correspondente.

*Foreign Keys* (chaves estrangeiras) e *indexes* (índices) possuem propósitos diferentes:

- *Foreign Keys* (chaves estrangeiras) protegem a integridade referencial.
- *Indexes* (índices) suportam padrões de acesso e desempenho.

Um *index* (índice) deve, portanto, ser justificado independentemente da *constraint* (restrição) ou coluna que possa suportar.

---

### 11.1 Projeto de Índices

O projeto de um *index* (índice) deve ser baseado no padrão de acesso ou na regra de unicidade baseada em *index* (índice) que ele se destina a suportar.

As seguintes características devem ser avaliadas quando aplicável:

- Colunas-chave.
- Ordem das colunas-chave.
- Direção de ordenação.
- Colunas incluídas.
- Seletividade.
- Cardinalidade e crescimento esperados.
- Padrões de *join* (junção).
- Padrões de filtragem.
- Requisitos de ordenação.
- Carga de leitura.
- Carga de escrita.
- *Indexes* (índices) sobrepostos existentes.
- Custo de armazenamento.
- Custo de manutenção.
- Posicionamento físico.
- Requisitos de particionamento.

Uma coluna não deve receber automaticamente um *index* (índice) apenas porque é frequentemente utilizada em uma consulta.

A carga de trabalho completa e o projeto físico existente devem ser considerados.

Um *index* (índice) que melhora um padrão de acesso pode aumentar o custo de:

- `INSERT`.
- `UPDATE`.
- `DELETE`.
- Armazenamento.
- Uso de memória.
- Manutenção de *indexes* (índices).

O projeto de *indexes* (índices) deve, portanto, equilibrar o benefício de leitura com o custo introduzido ao restante da carga de trabalho.

---

### 11.2 Índices Compostos

*Indexes* (índices) compostos podem conter múltiplas colunas-chave quando exigido pelo padrão de acesso.

A ordem das colunas-chave faz parte da definição do *index* (índice).

Um *index* (índice) definido como:

`(A, B)`

não deve ser automaticamente considerado equivalente a:

`(B, A)`

mesmo quando ambos os *indexes* (índices) contiverem as mesmas colunas.

A direção de ordenação também faz parte da definição esperada.

Por exemplo:

`A ASC, B DESC`

não é automaticamente equivalente a:

`A ASC, B ASC`

O nome do *index* (índice) deve descrever o padrão de acesso suportado, em vez de concatenar todas as colunas-chave.

Isso permite que o nome permaneça significativo mesmo quando a definição física contiver múltiplas colunas.

*Indexes* (índices) compostos devem ser projetados de acordo com o padrão de acesso esperado, e não de acordo com a ordem visual das colunas na tabela proprietária.

---

### 11.3 Colunas Incluídas

Colunas incluídas podem ser utilizadas quando fornecerem um benefício de desempenho justificado sem expandir desnecessariamente a chave do *index* (índice).

Colunas incluídas não fazem parte da chave do *index* (índice), mas fazem parte da definição esperada do *index* (índice) no AtlasCommerce.

Quando um *index* (índice) utilizar colunas incluídas, a validação do *deployment* (implantação) deve verificar o conjunto esperado de colunas incluídas.

Colunas incluídas não devem ser adicionadas mecanicamente.

Um *index* (índice) não deve acumular colunas incluídas apenas para eliminar todos os possíveis *lookups* (buscas adicionais).

O benefício de cobrir um padrão de acesso deve ser equilibrado com:

- Aumento do tamanho do *index* (índice).
- Custo adicional de escrita.
- Custo adicional de manutenção.
- Requisitos adicionais de armazenamento.
- Sobreposição com *indexes* (índices) existentes.

A ausência de um *Key Lookup* (busca de chave) não constitui, por si só, justificativa suficiente para expandir continuamente um *index* (índice).

---

### 11.4 Unique Indexes

*Unique Indexes* (índices únicos) utilizam a convenção de nomenclatura:

`UX_<PFX>_<purpose>`

Um `UX_` pode representar:

- Uma estrutura de acesso orientada a desempenho cuja definição física exige intencionalmente unicidade.
- Uma regra de unicidade baseada em *index* (índice), como unicidade condicional ou filtrada, que não possa ser adequadamente representada por uma *Unique Constraint* (restrição de unicidade) normal.

Um *Unique Index* (índice único) continua sendo um *index* (índice).

Ele não deve ser utilizado como substituto de uma *Unique Constraint* (restrição de unicidade) quando a unicidade for fundamentalmente uma regra obrigatória do modelo de dados.

O AtlasCommerce, portanto, distingue:

| Prefixo | Objeto | Propósito Principal |
|---|---|---|
| `UQ_` | *Unique Constraint* (restrição de unicidade) | Unicidade incondicional do modelo de dados |
| `IX_` | *Non-Unique Index* (índice não único) | Desempenho e acesso |
| `UX_` | *Unique Index* (índice único) | Unicidade baseada em índice, incluindo unicidade condicional ou filtrada quando exigida pelo modelo |

A principal pergunta de projeto não é:

> Este objeto consegue impedir valores duplicados?

A pergunta principal é:

> Por que a unicidade deve existir?

Se valores duplicados representarem um estado inválido do modelo de dados, a regra normalmente deve ser representada por:

`UQ_`

Se a unicidade exigir recursos específicos de *index* (índice), como um predicado filtrado, a regra poderá ser implementada como um *Unique Index* (índice único):

`UX_`

Um *index* (índice) orientado a desempenho cuja definição física exija intencionalmente unicidade também pode utilizar:

`UX_`

Um `UX_` não deve ser utilizado como substituto de um `UQ_` apenas porque o SQL Server consegue impor unicidade incondicional por ambos os mecanismos.

#### Filtered Unique Indexes

Um *filtered unique index* (índice único filtrado) pode ser utilizado quando a unicidade exigida depender de um predicado que não possa ser representado por uma *Unique Constraint* (restrição de unicidade) normal.

Nesse caso, o objeto continua sendo um *index* (índice) e é implantado durante a fase de *indexes* (índices).

O predicado de filtro faz parte da definição esperada do *index* (índice).

As regras implementadas em `catalog.ProductImage` fornecem exemplos nos quais *filtered unique indexes* (índices únicos filtrados) impõem unicidade condicional associada às funções das imagens.

Esses *indexes* (índices) devem ser validados como *indexes* (índices) e não devem ser tratados como *Unique Constraints* (restrições de unicidade) apenas porque impõem unicidade.

---

### 11.5 Validação de Índices

A validação de *indexes* (índices) deve avaliar as características que fazem parte da definição esperada implementada.

Dependendo do *index* (índice), a validação inclui:

- Tabela proprietária.
- Nome esperado do *index* (índice).
- Tipo do *index* (índice).
- Estado *enabled* (habilitado).
- Colunas-chave.
- Ordem das colunas-chave.
- Direção de ordenação.
- Colunas incluídas.
- Unicidade.
- Predicado de filtro.
- Opções relevantes do *index* (índice).
- *Data space* (espaço de dados).
- *Filegroup* (grupo de arquivos).
- *Partition scheme* (esquema de particionamento).
- Coluna de particionamento.
- Alinhamento de particionamento.

A existência apenas pelo nome não constitui validação suficiente.

Um *index* (índice) com o nome esperado, mas com uma definição diferente ou com um estado *disabled* (desabilitado) inesperado, constitui uma divergência.

Da mesma forma, um *index* (índice) com uma definição equivalente ou semelhante, mas com um nome inesperado, pode representar uma divergência de nomenclatura.

O *deployment* (implantação) padrão deve relatar essas condições e preservar o objeto existente para revisão controlada.

Ele não deve automaticamente:

- Remover o *index* (índice).
- Recriar o *index* (índice).
- Renomear o *index* (índice).
- Mover o *index* (índice).
- Alterar seu posicionamento físico.
- Alterar sua estratégia de particionamento.

Essas alterações exigem uma operação intencional e controlada.

---

### 11.6 Índices Particionados

*Indexes* (índices) em tabelas particionadas devem respeitar a estratégia física de particionamento definida para a tabela proprietária.

Quando se espera que um *index* (índice) esteja alinhado ao particionamento, as seguintes características fazem parte de sua definição esperada:

- *Partition scheme* (esquema de particionamento).
- *Data space* (espaço de dados).
- Coluna de particionamento.
- Alinhamento obrigatório com a tabela proprietária.
- Outras características físicas explicitamente definidas pelo *deployment* (implantação) implementado do *index* (índice).

Um *index* (índice) não deve ser considerado totalmente válido apenas porque sua chave lógica e suas colunas incluídas correspondem quando seu posicionamento físico obrigatório divergir.

O alinhamento de particionamento faz parte da arquitetura física e deve, portanto, ser validado quando aplicável.

Um *index* (índice) existente fisicamente divergente não deve ser automaticamente movido, removido ou recriado pelo *deployment* (implantação) padrão.

A correção de uma divergência de posicionamento físico exige uma alteração controlada.

*Indexes* (índices) não particionados também devem ser validados em relação ao seu posicionamento físico esperado quando o *deployment* (implantação) definir explicitamente um.

---

### 11.7 Índices Sobrepostos

O projeto de *indexes* (índices) deve considerar os *indexes* (índices) que já existem na tabela proprietária.

Um novo *index* (índice) não deve ser criado apenas porque sua definição exata ainda não existe.

Antes de introduzir um novo *index* (índice), o projeto deve avaliar se um *index* (índice) existente já suporta total ou suficientemente o padrão de acesso necessário.

Possíveis sobreposições incluem:

- Prefixos de chave idênticos.
- Chaves compostas semelhantes.
- Cobertura por colunas incluídas.
- *Unique Indexes* (índices únicos) existentes.
- *Indexes* (índices) existentes associados a *constraints* (restrições).
- *Indexes* (índices) particionados que suportem o mesmo caminho de acesso.

Um *index* (índice) sobreposto ainda pode ser justificado quando a carga de trabalho demonstrar um benefício significativo, mas a duplicação deve ser intencional.

O objetivo não é minimizar a quantidade de *indexes* (índices) a qualquer custo.

O objetivo é evitar estruturas físicas desnecessárias cujo custo de manutenção não seja justificado pelo benefício.

---

### 11.8 Ciclo de Vida dos Índices

Um *index* (índice) não deve ser considerado permanente apenas porque foi útil quando originalmente introduzido.

As cargas de trabalho evoluem.

Um *index* (índice) pode se tornar:

- Mais importante.
- Menos importante.
- Redundante.
- Ineficaz.
- Desnecessariamente caro.
- Substituído por outra estratégia de acesso.

Os *indexes* (índices) devem, portanto, ser revisados utilizando evidências da carga de trabalho.

Um *index* (índice) pode ser modificado ou descontinuado quando as evidências demonstrarem que sua justificativa original não se aplica mais.

Essas alterações devem ser intencionais e controladas.

O *deployment* (implantação) padrão não deve remover automaticamente um *index* (índice) apenas porque a lógica atual do *deployment* (implantação) deixou de esperá-lo.

Políticas operacionais de manutenção de *indexes* (índices), como limites de *rebuild* (reconstrução) ou *reorganize* (reorganização), estão fora do escopo deste documento e devem ser definidas separadamente.

---

## 12. Padrões de Deployment

Os *scripts* de *deployment* (implantação) do banco de dados AtlasCommerce devem ser reexecutáveis, previsíveis, rastreáveis e seguros para execução tanto em ambientes novos quanto existentes.

Um *deployment* (implantação) reexecutável não é um *deployment self-healing* (autocorretivo).

Reexecutável significa que o mesmo *deployment* (implantação) pode ser executado novamente sem duplicar indiscriminadamente objetos, dados, *constraints* (restrições), *indexes* (índices) ou documentação.

Isso não significa que o *deployment* (implantação) esteja autorizado a forçar automaticamente todos os objetos existentes ao estado esperado.

O comportamento padrão do *deployment* (implantação) é:

| Estado Atual | Comportamento do *Deployment* (Implantação) |
|---|---|
| O objeto não existe | Criá-lo quando as dependências e condições de segurança forem atendidas |
| O objeto existe e corresponde à definição esperada | Validá-lo sem modificações desnecessárias |
| O objeto existe, mas diverge da definição esperada | Relatar a divergência e preservar o objeto existente para revisão controlada |
| Uma dependência obrigatória está ausente ou é incompatível | Relatar a condição e impedir a operação insegura afetada |

O *deployment* (implantação) deve preferir diagnóstico explícito em vez de correção silenciosa.

Uma correção automática tecnicamente possível não é necessariamente uma ação apropriada de *deployment* (implantação).

---

### 12.1 Mensagens de Status do Deployment

A saída do *deployment* (implantação) deve utilizar as convenções consolidadas de mensagens do AtlasCommerce implementadas pelos *scripts* de *deployment* (implantação) atuais.

As mensagens devem comunicar claramente a ação executada ou o estado validado.

O *deployment* (implantação) atual utiliza mensagens semânticas e marcadores visuais de status, em vez de depender de convenções genéricas obsoletas como:

`[OK]`

ou:

`[CREATE]`

O vocabulário e os símbolos exatos da saída devem permanecer sincronizados com os *scripts* de *deployment* (implantação) implementados.

Exemplos de mensagens semânticas de *deployment* (implantação) incluem estados como:

- Objeto criado.
- Objeto já existente.
- Dependência validada.
- Coluna validada.
- *Primary Key* (chave primária) validada.
- *Constraint* (restrição) validada.
- *Index* (índice) validado.
- Documentação validada.
- Divergência detectada.
- Validação falhou.

A redação deve identificar o objeto relevante sempre que possível.

A saída do *deployment* (implantação) deve permanecer previsível e visualmente consistente entre *schemas* (esquemas), tabelas, *constraints* (restrições), *indexes* (índices) e fases de validação.

As informações de diagnóstico necessárias para compreender o comportamento do *deployment* (implantação) devem ser gravadas no fluxo de Mensagens do SQL Server.

Os diagnósticos do *deployment* (implantação) não devem depender das grades de conjuntos de resultados.

Isso permite que a saída da execução seja capturada e preservada como evidência do *deployment* (implantação), independentemente da interface cliente utilizada para executar os *scripts*.

---

### 12.2 Validação Antes da Modificação

O estado atual do banco de dados deve ser avaliado antes que qualquer modificação seja realizada.

A existência, por si só, não constitui validação suficiente quando características adicionais fizerem parte da definição esperada do objeto.

A validação deve avaliar todas as características definidas pelo padrão AtlasCommerce aplicável ao objeto que está sendo processado.

Dependendo do tipo de objeto, isso pode incluir:

- *Schema* (esquema).
- Nome do objeto.
- Tipo do objeto.
- Definição da coluna.
- Tipo de dados.
- Comprimento.
- Precisão.
- Escala.
- Nulabilidade.
- Definição de `IDENTITY`.
- Definição da *Primary Key* (chave primária).
- Definição da *constraint* (restrição).
- Estado *enabled* (habilitado) da *constraint* (restrição).
- Estado *trusted* (confiável) da *constraint* (restrição).
- Estado *enabled* (habilitado) do *index* (índice).
- Ordem das colunas.
- Direção de ordenação.
- Colunas incluídas.
- Unicidade.
- Predicados de filtro.
- Documentação de objetos.
- *Data space* (espaço de dados).
- *Filegroup* (grupo de arquivos).
- *Partition scheme* (esquema de particionamento).
- Alinhamento de particionamento.
- Outras características explicitamente padronizadas.

Os padrões específicos de cada objeto definem quais características fazem parte do estado esperado.

O *deployment* (implantação) deve validar essas características antes de decidir se o comportamento apropriado é criação, validação, aviso ou erro.

---

### 12.3 Deployment Não Destrutivo

O *deployment* (implantação) padrão do AtlasCommerce é não destrutivo por padrão.

Ele não deve automaticamente:

- Remover tabelas.
- Remover colunas.
- Remover *constraints* (restrições) existentes apenas porque divergem.
- Remover *indexes* (índices) existentes apenas porque divergem.
- Renomear objetos divergentes.
- Realizar alterações inseguras de tipos de dados incompatíveis.
- Reduzir o comprimento de colunas.
- Reduzir precisão ou escala numérica.
- Alterar a nulabilidade quando dados existentes puderem ser afetados.
- Mover automaticamente *indexes* (índices) entre estruturas físicas de armazenamento.
- Alterar automaticamente a estratégia de particionamento.
- Excluir dados de negócio existentes.
- Sobrescrever documentação de objetos divergente.
- Reescrever dados determinísticos existentes apenas para forçar conformidade sem uma alteração controlada explícita.

O *deployment* (implantação) não deve assumir que a definição esperada está automaticamente autorizada a substituir a definição existente.

Uma divergência pode indicar:

- Um ambiente obsoleto.
- Uma expectativa de *deployment* (implantação) obsoleta.
- Uma alteração manual controlada.
- Uma migração anterior.
- Um *deployment* (implantação) incompleto.
- Uma condição específica de produção.
- Outro estado que exija investigação.

O *deployment* (implantação) deve relatar informações suficientes para dar suporte a essa investigação.

O fato de uma correção ser tecnicamente possível não a torna apropriada para o *deployment* (implantação) padrão.

---

### 12.4 Migrações Explícitas

Alterações potencialmente destrutivas ou que transformem o estado exigem uma migração controlada explícita.

Exemplos incluem:

- Alterações incompatíveis de tipo de dados.
- Reduções do comprimento de colunas.
- Reduções de precisão ou escala.
- Alterações de uma coluna que permite `NULL` para `NOT NULL` quando já existirem dados.
- Substituição de *constraints* (restrições) divergentes.
- Substituição ou movimentação física de *indexes* (índices).
- Alterações na estratégia de particionamento.
- Transformações de dados exigidas por uma alteração no modelo.
- Remoção de objetos obsoletos do banco de dados.
- Outras operações que possam afetar o estado persistido existente.

Uma migração deve documentar:

- Motivo da alteração.
- Objetos afetados.
- Estado anterior esperado.
- Estado final esperado.
- Impacto nos dados.
- Dependências.
- Pré-condições obrigatórias.
- Validação antes da alteração.
- Validação após a alteração.
- Considerações de falha e recuperação, quando aplicável.

Uma migração deve ser invocada intencionalmente.

O *deployment* (implantação) reexecutável padrão não deve converter silenciosamente uma divergência detectada em uma migração implícita.

---

### 12.5 Validação de Dependências

Um objeto não deve ser criado quando uma dependência obrigatória estiver ausente ou for incompatível.

As dependências devem ser validadas antes da operação afetada.

Dependendo do objeto, as dependências podem incluir:

- *Schema* (esquema) do banco de dados.
- Tabela proprietária.
- Tabela referenciada.
- Colunas obrigatórias.
- *Primary Key* (chave primária).
- *Candidate key* (chave candidata).
- *Constraint* (restrição).
- *Index* (índice) de suporte.
- *Data space* (espaço de dados).
- *Filegroup* (grupo de arquivos).
- *Partition function* (função de particionamento).
- *Partition scheme* (esquema de particionamento).
- Outra infraestrutura física ou lógica.

A validação de dependências deve avaliar a compatibilidade quando ela fizer parte do relacionamento.

A existência de um objeto com o nome esperado não significa automaticamente que ele satisfaça a dependência.

Por exemplo, uma dependência de *Foreign Key* (chave estrangeira) exige uma chave referenciada apropriada, e não apenas a existência das colunas referenciadas.

Da mesma forma, um objeto particionado exige a infraestrutura física de particionamento esperada, e não apenas um objeto com nome correspondente.

Quando uma dependência não puder ser validada com segurança, a operação afetada não deve continuar como se a dependência fosse válida.

---

### 12.6 Deployment de Dados

Esta seção trata dos dados determinísticos gerenciados pelo *deployment* (implantação).

Exemplos incluem:

- Metadados.
- Dados de referência.
- *Lookup values* (valores controlados de referência).
- Dados de *seed* (carga inicial) exigidos pelo modelo de banco de dados.

A ingestão operacional de dados de negócio é uma responsabilidade separada e não faz parte do *deployment* (implantação) de objetos de banco de dados.

Os dados gerenciados pelo *deployment* (implantação) devem seguir os mesmos princípios não destrutivos utilizados para os objetos de banco de dados.

Os dados gerenciados pelo *deployment* (implantação) devem possuir uma identidade determinística que permita ao *deployment* (implantação) distinguir uma linha esperada de outros dados existentes.

O comportamento padrão é:

| Estado Atual | Comportamento do *Deployment* (Implantação) |
|---|---|
| A linha esperada não existe | Inserir quando as dependências e a identidade determinística forem válidas |
| A linha existente corresponde à definição determinística esperada | Validar sem modificação |
| A linha existente diverge | Relatar a divergência e preservar a linha existente, salvo quando uma alteração controlada explícita autorizar a modificação |

O *deployment* (implantação) de *seed* (carga inicial) não deve sobrescrever silenciosamente uma linha divergente existente apenas porque o *deployment* (implantação) contém um valor esperado diferente.

O *deployment* (implantação) deve distinguir entre:

- Valores determinísticos que definem a linha esperada.
- Valores de ciclo de vida que legitimamente diferem após a criação da linha.

*Timestamps* (registros de data e hora) históricos de ciclo de vida não devem ser comparados com *timestamps* (registros de data e hora) recém-gerados como se fossem valores determinísticos de *seed* (carga inicial).

Por exemplo, um valor `created_at` existente não deve ser considerado divergente apenas porque uma nova execução do *deployment* (implantação) geraria um horário atual diferente.

Alterações em dados controlados existentes devem ser intencionais e devem preservar o significado histórico e semântico da linha afetada.

---

### 12.7 Fases de Deployment

O *deployment* (implantação) do AtlasCommerce é organizado em fases explícitas.

A estrutura de fases existe para:

- Tornar as dependências previsíveis.
- Separar as responsabilidades dos objetos.
- Suportar validação independente.
- Melhorar a rastreabilidade da execução.
- Preservar a organização lógica.
- Tornar o comportamento de reexecução mais fácil de compreender e diagnosticar.

O *deployment* (implantação) consolidado segue uma sequência consciente das dependências que inclui:

1. Pré-requisitos de *schema* (esquema) e banco de dados.
2. Infraestrutura de particionamento.
3. Tabelas e *Primary Keys* (chaves primárias).
4. Documentação de Objetos.
5. Dados de *seed* (carga inicial), referência e metadados.
6. *Default Constraints* (restrições de valor padrão).
7. *Check Constraints* (restrições de verificação).
8. *Unique Constraints* (restrições de unicidade).
9. *Foreign Key Constraints* (restrições de chave estrangeira).
10. *Indexes* (índices).
11. Validação temporal ou de integridade especializada, quando aplicável.
12. *Final Validation* (validação final).

A orquestração exata, os nomes dos *scripts*, a ordem de inclusão e os nomes literais das fases são definidos pelos *scripts* atuais de *deployment* (implantação) SQLCMD.

Esses *scripts* são a fonte técnica da verdade para a sequência de *deployment* (implantação) implementada.

O documento de Padrões define a responsabilidade arquitetural das fases e deve permanecer sincronizado com a implementação.

Um objeto deve ser implantado na fase responsável por seu tipo de objeto ou responsabilidade técnica.

A ordenação alfabética lógica não deve mover um objeto para uma fase de *deployment* (implantação) inadequada.

---

### 12.8 Final Validation

Todo *deployment* (implantação) completo do AtlasCommerce deve terminar com uma validação independente do estado esperado do banco de dados.

A *Final Validation* (validação final) não é apenas um resumo das mensagens emitidas pelas fases anteriores do *deployment* (implantação).

Ela deve consultar e avaliar independentemente o estado consolidado do banco de dados.

O fato de uma fase anterior ter relatado criação ou validação bem-sucedida não elimina a necessidade da *Final Validation* (validação final).

Dependendo da tabela e de suas definições aplicáveis, a *Final Validation* (validação final) avalia categorias como:

- Tabela.
- *Primary Key* (chave primária).
- Colunas.
- Documentação de Objetos.
- Dados de *Seed* (carga inicial).
- *Default Constraints* (restrições de valor padrão).
- *Check Constraints* (restrições de verificação).
- *Unique Constraints* (restrições de unicidade).
- *Foreign Key Constraints* (restrições de chave estrangeira).
- *Indexes* (índices) Adicionais.
- Integridade Temporal.
- Outras categorias de validação explicitamente implementadas.

Uma categoria que não se aplique a uma tabela deve utilizar o estado padronizado de não aplicável definido pelos *scripts* implementados de *Final Validation* (validação final).

A *Final Validation* (validação final) deve distinguir entre:

- Estado esperado válido.
- Estado não aplicável.
- Estado divergente.
- Estado obrigatório ausente.
- Falha de validação.

O vocabulário exato da saída deve permanecer sincronizado com a implementação consolidada da *Final Validation* (validação final).

Um *deployment* (implantação) que termine sem um erro de execução SQL não é automaticamente um *deployment* (implantação) bem-sucedido.

O sucesso do *deployment* (implantação) exige que o estado esperado do AtlasCommerce tenha sido validado independentemente e que nenhuma condição não resolvida impeça o ambiente de satisfazer os padrões obrigatórios.

---

### 12.9 Deployment Transacional

O *deployment* (implantação) coordenado do AtlasCommerce deve utilizar uma estratégia transacional explícita.

Operações que formam uma única unidade atômica de *deployment* (implantação) não devem deixar o banco de dados em um estado parcialmente confirmado após uma falha fatal.

Quando o *deployment* (implantação) consolidado for executado como uma única unidade transacional, uma falha fatal deve realizar *rollback* (reversão) dessa unidade de acordo com a implementação do coordenador do *deployment* (implantação).

A estratégia transacional deve considerar:

- Atomicidade.
- Duração da transação.
- Duração dos bloqueios.
- Impacto no *transaction log* (log de transações).
- Recuperação de falhas.
- Comportamento de reexecução.
- Janela operacional de *deployment* (implantação).
- Consequências de uma conclusão parcial.

Uma transação de longa duração pode introduzir custo operacional, mas dividir um *deployment* (implantação) em fases confirmadas independentemente também altera a semântica de falha.

Se fases anteriores forem confirmadas antes que uma fase posterior falhe, o *deployment* (implantação) poderá deixar o ambiente parcialmente atualizado.

Portanto, os limites transacionais devem ser uma decisão arquitetural explícita, e não uma otimização aplicada apenas porque o *deployment* (implantação) leva tempo para ser executado.

Qualquer decisão futura de dividir o *deployment* (implantação) em unidades confirmadas menores deve documentar:

- Por que a alteração é necessária.
- Quais fases se tornam unidades transacionais independentes.
- O que acontece quando uma fase posterior falha.
- Como a conclusão parcial é detectada.
- Como a reexecução retoma ou valida com segurança o estado anterior.
- Se o *rollback* (reversão) entre fases anteriormente confirmadas ainda é necessário ou possível.

A estratégia transacional deve priorizar uma recuperação previsível em vez de conveniência.

---

### 12.10 Validação de Reexecução

Uma primeira execução bem-sucedida não constitui evidência suficiente de que um *script* de *deployment* (implantação) atende aos padrões de *deployment* (implantação) do AtlasCommerce.

Um *deployment* (implantação) completo também deve ser reexecutável com segurança.

A validação do comportamento do *deployment* (implantação) deve, portanto, incluir, quando aplicável:

1. Execução em um ambiente limpo.
2. Validação do estado resultante do banco de dados.
3. Reexecução no ambiente criado pela primeira execução.
4. Confirmação de que objetos existentes e válidos são reconhecidos e preservados.
5. Confirmação de que dados determinísticos não são duplicados.
6. Confirmação de que *constraints* (restrições) e *indexes* (índices) não são duplicados.
7. Confirmação de que a documentação de objetos não é reescrita desnecessariamente.
8. Confirmação de que dados existentes e válidos gerenciados pelo *deployment* (implantação) são reconhecidos sem modificação desnecessária.
9. *Final Validation* (validação final) após a reexecução.

Um *deployment* (implantação) limpo valida o comportamento de criação.

Uma segunda execução valida o comportamento de reexecução.

Ambas são necessárias para demonstrar que o *deployment* (implantação) se comporta conforme projetado.

A segurança da reexecução não deve depender da supressão de erros enquanto deixa o banco de dados em um estado desconhecido.

A segunda execução deve validar positivamente o estado esperado existente.

---

## 13. Padrões de Ordenação de Objetos

Os objetos de banco de dados do AtlasCommerce seguem uma ordenação lógica previsível para melhorar a legibilidade, a manutenibilidade, a capacidade de revisão e a consistência do *deployment* (implantação).

A ordenação destina-se principalmente a otimizar a compreensão humana.

A ordenação lógica não deve sobrepor a segurança do *deployment* (implantação), os requisitos arquiteturais ou as dependências técnicas.

A precedência geral de ordenação é:

`Safety and Dependencies (Segurança e Dependências) → Deployment Phase (Fase de Deployment) → Schema Order (Ordem de Schema) → Object Order (Ordem de Objeto)`

Isso significa que:

1. A segurança e as dependências técnicas obrigatórias têm precedência.
2. Os objetos devem permanecer na fase de *deployment* (implantação) responsável por seu tipo ou propósito técnico.
3. Dentro de uma fase, a ordenação dos *schemas* (esquemas) deve ser preservada sempre que possível.
4. Dentro de um *schema* (esquema), a ordenação dos objetos deve ser preservada sempre que possível.

A consistência alfabética ou visual nunca deve ser obtida por meio da violação de uma dependência técnica ou pela movimentação de um objeto para uma fase de *deployment* (implantação) inadequada.

---

### 13.1 Ordenação de Schemas

`metadata` é intencionalmente colocado em primeiro lugar porque contém metadados técnicos e objetos de governança utilizados pelo *deployment* (implantação) e pelos padrões do banco de dados.

Todos os demais *schemas* (esquemas) do AtlasCommerce são ordenados alfabeticamente.

A ordem lógica atual dos *schemas* (esquemas) é:

1. `metadata`
2. `catalog`
3. `customer`
4. `inventory`
5. `payment`
6. `reference`
7. `sales`
8. `shipping`

`metadata` é, portanto, uma exceção técnica intencional à ordenação alfabética normal.

Novos *schemas* (esquemas) devem ser inseridos na posição alfabética apropriada após `metadata`, salvo quando uma dependência técnica ou arquitetural explícita justificar uma posição diferente.

A existência de uma dependência entre objetos de *schemas* (esquemas) diferentes não justifica automaticamente alterar a ordem lógica dos *schemas* (esquemas).

Essas dependências normalmente devem ser resolvidas pela fase apropriada de *deployment* (implantação).

---

### 13.2 Ordenação de Tabelas

Dentro de cada *schema* (esquema), as tabelas devem ser organizadas alfabeticamente pelo nome da tabela sempre que possível.

Exemplo:

| Schema | Tabela |
|---|---|
| `payment` | `Payment` |
| `payment` | `PaymentMethod` |
| `payment` | `PaymentRefund` |
| `payment` | `PaymentRefundReason` |
| `payment` | `PaymentStatus` |

Essa ordenação é lógica, e não orientada por dependências.

Por exemplo, o fato de uma tabela referenciar outra por meio de uma *Foreign Key* (chave estrangeira) não exige que a tabela referenciada apareça primeiro em toda documentação ou inventário de *deployment* (implantação).

A ordenação alfabética das tabelas deve ser preservada sempre que possível em:

- Documentação técnica.
- Registros de prefixos.
- Definições de *deployment* (implantação).
- Definições de *constraints* (restrições).
- Definições de *indexes* (índices).
- *Final Validation* (validação final).
- Inventários técnicos.

Uma dependência técnica pode sobrepor essa ordenação quando necessário para um *deployment* (implantação) seguro.

---

### 13.3 Exceções Técnicas de Ordenação

Exceções técnicas de ordenação são permitidas somente quando exigidas por uma dependência operacional ou arquitetural explícita.

Exemplos incluem:

- Objetos de governança que devem existir antes que metadados dependentes possam ser implantados.
- Infraestrutura física necessária antes que objetos particionados possam ser criados.
- Objetos de suporte necessários antes que um mecanismo especializado de integridade possa ser implantado.

`metadata.TablePrefix` é um exemplo de objeto de governança cuja função técnica pode exigir que esteja disponível antes que os dados do registro de prefixos sejam implantados.

*Partition functions* (funções de particionamento), *partition schemes* (esquemas de particionamento), *filegroups* (grupos de arquivos) e a infraestrutura física relacionada também podem exigir *deployment* (implantação) antes das tabelas ou *indexes* (índices) que dependem deles.

As exceções técnicas de ordenação devem:

- Possuir uma razão operacional ou arquitetural clara.
- Ser explicitamente identificáveis.
- Ser limitadas à alteração mínima de ordenação necessária.
- Não ser introduzidas apenas por conveniência.
- Não se tornar uma justificativa para abandonar a ordenação lógica previsível em outros pontos.

A existência de uma exceção técnica não redefine o padrão normal de ordenação para objetos não relacionados.

---

### 13.4 Ordem Lógica e Ordem de Dependências

Ordem lógica e ordem de dependências são responsabilidades separadas.

A ordem lógica existe principalmente para:

- Legibilidade humana.
- Documentação previsível.
- Revisão de código mais fácil.
- Comparação mais fácil entre *scripts*.
- Inventários consistentes.
- Navegação mais fácil pela definição do banco de dados.

A ordem de dependências existe para garantir que um objeto não seja criado antes que os objetos ou a infraestrutura exigidos por sua definição estejam disponíveis.

Uma tabela não deve ser movida de sua posição lógica normal apenas porque referencia outra tabela por meio de uma *Foreign Key* (chave estrangeira).

O AtlasCommerce resolve esse tipo de dependência separando:

- Criação de tabelas e *Primary Keys* (chaves primárias).
- Criação de *Foreign Key Constraints* (restrições de chave estrangeira).

Isso permite que as tabelas permaneçam em uma ordem lógica previsível enquanto as dependências referenciais são estabelecidas posteriormente, durante a fase apropriada de *deployment* (implantação).

O mesmo princípio se aplica a outros tipos de objeto sempre que as fases de *deployment* (implantação) puderem separar com segurança a organização lógica da criação das dependências.

---

### 13.5 Ordenação Dentro das Fases de Deployment

Dentro de uma fase de *deployment* (implantação), a ordenação lógica preferencial é:

`Deployment Phase (Fase de Deployment) → Schema → Object (Objeto)`

Para fases de *deployment* (implantação) específicas de tabelas, a ordenação preferencial é:

`Deployment Phase (Fase de Deployment) → Schema → Table (Tabela)`

Por exemplo, todas as *Default Constraints* (restrições de valor padrão) pertencem à fase de *Default Constraint* antes que o *deployment* (implantação) prossiga para a fase de *Check Constraint*.

Dentro da fase de *Default Constraint*, os objetos devem então seguir a ordenação padrão de *schema* (esquema) e tabela sempre que as dependências técnicas permitirem.

A responsabilidade da fase de *deployment* (implantação) tem precedência sobre a ordenação alfabética.

Um objeto não deve ser movido para uma fase anterior ou posterior apenas para tornar um *script* visualmente alfabético.

As dependências técnicas e os requisitos de segurança têm precedência tanto sobre a ordenação de *schema* (esquema) quanto sobre a de objeto.

---

### 13.6 Ordenação do Registro TablePrefix

O registro `metadata.TablePrefix` é logicamente ordenado por:

`Schema → Table (Tabela)`

`metadata` segue sua precedência técnica intencional, e os demais *schemas* (esquemas) seguem a ordenação lógica padrão de *schemas* (esquemas).

Dentro de cada *schema* (esquema), as atribuições de prefixos devem aparecer alfabeticamente pelo nome da tabela sempre que possível.

O registro de prefixos é a fonte autoritativa para as atribuições atuais e históricas de prefixos.

O documento *Database Standards* (Padrões de Banco de Dados) não deve duplicar o registro completo de prefixos, pois isso criaria um segundo inventário que poderia se tornar inconsistente com o banco de dados implementado.

As atribuições de prefixos inativas ou descontinuadas permanecem preservadas.

Elas não devem ser:

- Excluídas.
- Reordenadas apenas para ocultar sua posição histórica.
- Reatribuídas a outra tabela.
- Removidas apenas para melhorar a apresentação visual.

A preservação histórica dos prefixos tem precedência sobre a ordenação estética.

---

### 13.7 Ordenação de Colunas

A ordenação das colunas na definição inicial da tabela deve seguir uma estrutura lógica previsível apropriada à tabela.

Quando aplicável, a organização lógica preferencial é:

1. Identificador primário.
2. Chaves de relacionamento.
3. Atributos principais de negócio.
4. Atributos de *status* (estado) ou classificação.
5. Atributos monetários, quantitativos, temporais ou outros específicos do domínio.
6. Colunas de ciclo de vida e auditoria.

Essa ordenação é uma diretriz de projeto, e não uma justificativa para realizar alterações físicas destrutivas em uma tabela existente.

Uma coluna adicionada após a tabela já existir pode aparecer fisicamente no final da tabela, mesmo quando sua categoria lógica normalmente a colocaria antes.

O AtlasCommerce não deve reconstruir uma tabela existente e populada apenas para melhorar a posição ordinal física de uma coluna.

A documentação lógica pode continuar descrevendo a coluna de acordo com sua categoria semântica mesmo quando sua posição ordinal física divergir devido a uma alteração controlada posterior.

#### Novas Colunas NOT NULL

Adicionar uma nova coluna cuja definição final seja `NOT NULL` exige consideração especial quando a tabela já contém dados.

O *deployment* (implantação) não deve inventar um `DEFAULT` artificial apenas para tornar tecnicamente possível a adição da coluna.

Quando necessário, uma migração controlada pode:

1. Introduzir a coluna em um estado temporário que permita que as linhas existentes permaneçam válidas.
2. Preencher ou derivar os valores obrigatórios.
3. Validar os dados resultantes.
4. Aplicar a definição final `NOT NULL`.

A estratégia de migração deve preservar a correção semântica.

Um valor *placeholder* (substituto) tecnicamente conveniente não é um substituto aceitável para dados válidos.

---

### 13.8 Ordenação de Constraints e Índices

A ordem lógica padrão para *constraints* (restrições) de integridade e *indexes* (índices) de desempenho é:

1. *Primary Keys* (chaves primárias).
2. *Default Constraints* (restrições de valor padrão).
3. *Check Constraints* (restrições de verificação).
4. *Unique Constraints* (restrições de unicidade).
5. *Foreign Key Constraints* (restrições de chave estrangeira).
6. *Performance Indexes* (índices de desempenho).

As *Primary Keys* (chaves primárias) são criadas juntamente com suas tabelas proprietárias.

Os demais tipos de *constraint* (restrição) são implantados em suas fases dedicadas.

Os *indexes* (índices) de desempenho são implantados após as *constraints* (restrições) de integridade.

O AtlasCommerce distingue:

- `UQ_` — *Unique Constraint* (restrição de unicidade).
- `IX_` — *Non-Unique performance index* (índice de desempenho não único).
- `UX_` — *Unique performance index* (índice de desempenho único).

Tanto `IX_` quanto `UX_` pertencem à fase de *deployment* (implantação) de *Index* (índice).

Um `UX_` não deve ser colocado na fase de *Unique Constraint* (restrição de unicidade) apenas porque impõe unicidade.

Da mesma forma, um *Unique Index* (índice único) físico não deve ser tratado como intercambiável com uma *Unique Constraint* (restrição de unicidade) durante a validação.

Objetos especializados de integridade que não pertençam às categorias padrão `PK`, `DEFAULT`, `CHECK`, `UQ` ou `FK` devem seguir sua fase de *deployment* (implantação) e dependências explicitamente definidas.

Seus requisitos técnicos têm precedência sobre a ordenação visual normal das *constraints* (restrições) e *indexes* (índices) padrão.

---

### 13.9 Consistência de Ordenação

Os mesmos princípios de ordenação devem ser refletidos consistentemente nos artefatos técnicos do AtlasCommerce.

Isso inclui:

- *Database Standards* (Padrões de Banco de Dados).
- Documentação de arquitetura.
- *Scripts* de *deployment* (implantação).
- Definições de tabelas.
- Registro de prefixos.
- *Deployment* (implantação) da Documentação de Objetos.
- *Deployment* (implantação) de dados de *seed* (carga inicial) e referência.
- Definições de *constraints* (restrições).
- Definições de *indexes* (índices).
- *Final Validation* (validação final).
- Inventários técnicos.

Um objeto recém-introduzido deve ser inserido em sua posição lógica correta sempre que possível.

Ele não deve ser automaticamente acrescentado ao final de uma lista estruturada existente apenas porque foi criado posteriormente.

Por exemplo:

- Um novo *schema* (esquema) deve ser inserido na posição correta de *schema*.
- Uma nova tabela deve ser inserida na posição alfabética apropriada dentro de seu *schema* (esquema).
- Uma nova *constraint* (restrição) deve ser colocada na fase de *deployment* (implantação) responsável por aquele tipo de *constraint* (restrição).
- Um novo *index* (índice) deve ser colocado na fase de *Index* (índice).
- Um novo prefixo deve ser registrado de acordo com o padrão de ordenação do registro.

Quando uma dependência técnica exigir uma exceção, a exceção deve permanecer limitada ao objeto ou fase afetados.

A consistência de ordenação não deve ser alcançada às custas da correção do *deployment* (implantação).

---

## Princípio Final

Os padrões de banco de dados do AtlasCommerce favorecem intenção explícita em vez de comportamento implícito.

A nomenclatura comunica propriedade e propósito.

As *constraints* (restrições) comunicam integridade de dados.

Os *indexes* (índices) comunicam estratégia de acesso.

A documentação de objetos comunica responsabilidade semântica.

A ordenação fornece previsibilidade sem sobrepor dependências técnicas.

O *deployment* (implantação) valida antes de modificar e preserva estados existentes inesperados para revisão controlada.

Reexecutável não significa *self-healing* (autocorretivo).

A implementação consolidada e validada do banco de dados AtlasCommerce permanece como a fonte técnica da verdade.

Esses padrões devem evoluir juntamente com essa implementação para que a documentação descreva o banco de dados que o AtlasCommerce efetivamente constrói e valida, em vez de preservar convenções obsoletas de uma etapa anterior do modelo.