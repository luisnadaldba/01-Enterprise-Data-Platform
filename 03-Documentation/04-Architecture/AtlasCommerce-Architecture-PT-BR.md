# Arquitetura do AtlasCommerce

## 1. Propósito

Este documento define a arquitetura do AtlasCommerce como o sistema transacional de origem dentro da plataforma de dados Atlas Engineering.

Seu propósito é descrever os principais componentes arquiteturais, responsabilidades, limites e decisões de projeto que determinam como o AtlasCommerce armazena dados operacionais e participa da plataforma de dados mais ampla.

O AtlasCommerce foi projetado principalmente para suportar operações transacionais de varejo.

Cargas de trabalho analíticas, relatórios, transformação de dados e *Business Intelligence* (Inteligência de Negócios) são responsabilidades arquiteturais separadas e não devem comprometer a confiabilidade ou o desempenho da carga de trabalho transacional.

Este documento descreve:

- O papel arquitetural do AtlasCommerce dentro do Atlas Engineering.

- Os limites entre as responsabilidades transacionais e analíticas.

- A organização lógica do banco de dados AtlasCommerce.

- As responsabilidades representadas por seus domínios de banco de dados.

- A arquitetura física do banco de dados quando ela afeta o projeto do sistema.

- Os princípios que governam a extração de dados da origem transacional.

- A relação entre o AtlasCommerce e as camadas subsequentes de ingestão, *staging* (preparação), análise e consumo.

- As decisões arquiteturais que sustentam confiabilidade, manutenibilidade, escalabilidade, rastreabilidade e evolução futura.

Este documento não define regras de negócio detalhadas, convenções de nomenclatura de objetos de banco de dados, definições individuais de tabelas ou regras de implementação de *deployment* (implantação).

Essas responsabilidades são documentadas separadamente na documentação aplicável de negócio, padrões de banco de dados, modelo de domínio e *deployment* (implantação) técnico do AtlasCommerce.

A arquitetura descrita aqui representa a arquitetura atual validada do AtlasCommerce juntamente com a direção arquitetural explicitamente identificada do Atlas Engineering.

Quando a arquitetura for alterada, este documento deverá ser atualizado para que as capacidades implementadas continuem refletindo o sistema que o AtlasCommerce efetivamente constrói e valida, enquanto as direções arquiteturais futuras permaneçam explicitamente identificadas como tal.

---

## 2. Contexto da Arquitetura

O AtlasCommerce é o sistema transacional de origem utilizado pelo Atlas Engineering para representar o domínio operacional de varejo.

Sua principal responsabilidade é persistir e proteger o estado operacional necessário aos processos de varejo, como gerenciamento de produtos, gerenciamento de clientes, controle de estoque, vendas, pagamentos e atendimento dos pedidos.

O AtlasCommerce não é, por si só, a plataforma analítica.

Dentro da arquitetura mais ampla do Atlas Engineering, o AtlasCommerce ocupa a camada de sistema de origem e fornece dados operacionais que podem ser consumidos por processos subsequentes de Engenharia de Dados.

O contexto arquitetural é:

```text
Atlas Engineering
│
├── Sistemas de Origem
│   │
│   └── AtlasCommerce
│       └── Banco de dados transacional SQL Server
│
├── Ingestão de Dados
│
├── Staging (Preparação) e Processamento de Dados
│
├── Plataforma Analítica de Dados
│
└── Consumo de Dados
    └── Business Intelligence (Inteligência de Negócios) e cargas de trabalho analíticas
```

No estágio atual do projeto, o AtlasCommerce é o sistema transacional de origem implementado.

As camadas subsequentes representam a direção arquitetural do Atlas Engineering e serão projetadas e implementadas durante as respectivas fases de Engenharia de Dados.

Sua representação neste documento estabelece limites e responsabilidades arquiteturais; ela não implica que suas tecnologias, estruturas ou estratégias de implementação finais já tenham sido definidas.

---

### 2.1 Responsabilidade Transacional

O AtlasCommerce é responsável pela persistência operacional e pela integridade transacional dos dados.

O projeto de seu banco de dados deve priorizar:

- Correção do estado operacional persistido.

- Consistência transacional.

- Integridade referencial.

- Comportamento operacional previsível.

- Proteção de dados críticos para o negócio.

- Manutenibilidade e evolução controlada.

- Disponibilidade confiável dos dados de origem para consumo subsequente.

O banco de dados transacional não deve ser reprojetado principalmente para atender a padrões de acesso analítico.

Requisitos analíticos podem influenciar a forma como os dados são extraídos ou interpretados nas camadas subsequentes, mas não devem comprometer a integridade ou a responsabilidade operacional primária do AtlasCommerce.

---

### 2.2 Responsabilidade Analítica

O processamento analítico é uma responsabilidade arquitetural separada.

Relatórios, análises históricas, transformações analíticas, agregações, modelagem dimensional e cargas de trabalho de *Business Intelligence* (Inteligência de Negócios) devem ser realizados fora da carga de trabalho transacional primária do AtlasCommerce sempre que for viável.

Essa separação permite que a plataforma analítica evolua de acordo com os requisitos analíticos sem forçar o modelo transacional a assumir responsabilidades para as quais não foi projetado.

Da mesma forma, o AtlasCommerce pode evoluir de acordo com os requisitos operacionais sem exigir que sua estrutura transacional interna se torne o modelo de apresentação para os consumidores analíticos.

---

### 2.3 Limite Arquitetural

O principal limite arquitetural é, portanto:

```text
Responsabilidade Operacional             Responsabilidade Analítica

AtlasCommerce
Banco de Dados Transacional
        │
        │  extração controlada de dados
        ▼
Engenharia de Dados
        │
        ▼
Plataforma Analítica
        │
        ▼
Consumidores Analíticos
```

Cruzar esse limite requer um processo explícito de extração ou ingestão de dados.

Os consumidores analíticos não devem depender de acesso direto e irrestrito ao banco de dados transacional primário como sua estratégia normal de acesso aos dados.

O mecanismo utilizado para cruzar esse limite será selecionado de acordo com as características do sistema de origem, o impacto operacional, os requisitos de latência dos dados, a capacidade de recuperação e a arquitetura definida durante a fase de Engenharia de Dados.

---

### 2.4 Independência Arquitetural

As arquiteturas transacional e analítica são relacionadas, mas projetadas de forma independente.

O AtlasCommerce define a verdade operacional do sistema de varejo.

As estruturas analíticas subsequentes podem reorganizar, transformar, enriquecer, agregar ou historizar esses dados de acordo com os requisitos analíticos, sem alterar o significado dos dados de origem.

Essa separação permite que o Atlas Engineering introduza futuras tecnologias de ingestão, estratégias de *staging* (preparação), modelos de armazenamento analítico, mecanismos de orquestração ou ferramentas de consumo sem exigir um reprojeto desnecessário do modelo transacional do AtlasCommerce.

O contrato arquitetural entre os dois lados é, portanto, baseado no consumo controlado dos dados operacionais, e não em um projeto físico compartilhado.

---

## 3. Arquitetura de Banco de Dados do AtlasCommerce

O AtlasCommerce é implementado como um banco de dados transacional SQL Server organizado em torno de domínios explícitos de negócio e técnicos.

O banco de dados foi projetado como um único limite transacional, cujas responsabilidades internas são separadas por meio de *schemas* (esquemas) de banco de dados.

Essa organização permite que objetos relacionados permaneçam logicamente agrupados, preservando ao mesmo tempo a integridade referencial e a consistência transacional entre os domínios.

A arquitetura de banco de dados em alto nível é:

```text
AtlasCommerce
│
├── metadata
│   └── Metadados técnicos e governança do banco de dados
│
├── catalog
│   └── Catálogo de produtos, classificação, variantes, atributos, mídia e preços
│
├── customer
│   └── Identidade do cliente, documentos, contatos, endereços e dados mestres relacionados
│
├── inventory
│   └── Posição de estoque, movimentações, contexto das movimentações e reservas de estoque
│
├── payment
│   └── Pagamentos, métodos de pagamento, status de pagamento, reembolsos e motivos de reembolso
│
├── reference
│   └── Dados de referência compartilhados entre domínios de negócio
│
├── sales
│   └── Transações de venda, itens de transação, canais e status da transação
│
└── shipping
    └── Remessa, método de entrega, status de entrega, rastreamento e informações de frete
```

Os *schemas* (esquemas) representam limites lógicos de responsabilidade dentro do banco de dados.

Eles não representam bancos de dados independentes, sistemas transacionais isolados ou unidades separadas de *deployment* (implantação).

Os relacionamentos podem atravessar os limites dos *schemas* quando isso for exigido pelo modelo de dados persistente.

---

### 3.1 Visão Geral do Modelo de Dados

O diagrama a seguir apresenta uma visão de alto nível do modelo de dados
relacional do AtlasCommerce.

Ele apresenta os *schemas* do banco de dados, as entidades atribuídas a
cada domínio, suas estruturas de chaves primárias e estrangeiras e os
relacionamentos que atravessam os limites entre os domínios.

![Modelo de Dados do AtlasCommerce](Diagrams/AtlasCommerce-Data-Model.png)

O diagrama concentra-se intencionalmente nos relacionamentos estruturais
e nas colunas de chave, em vez de reproduzir a definição completa das
colunas de cada entidade.

O diagrama foi criado utilizando o Schemity Lite a partir do modelo de
banco de dados validado do AtlasCommerce.

---

### 3.2 Banco de Dados Transacional Único

Atualmente, o AtlasCommerce utiliza um único banco de dados transacional para o modelo de varejo implementado.

Essa arquitetura permite que operações de negócio que abrangem múltiplos domínios participem de um modelo relacional consistente.

Por exemplo, uma transação de venda pode depender de informações mantidas pelos domínios `customer`, `catalog`, `inventory`, `payment` ou `shipping` sem exigir que essas responsabilidades sejam fisicamente separadas em bancos de dados independentes.

O uso de um único banco de dados não implica que todos os objetos pertençam à mesma responsabilidade lógica.

Os limites dos domínios permanecem explícitos por meio de *schemas* (esquemas), propriedade dos objetos, relacionamentos, documentação e organização do *deployment* (implantação).

Essa abordagem favorece a integridade relacional e a consistência transacional, evitando ao mesmo tempo a distribuição física prematura de dados operacionais fortemente relacionados.

Requisitos arquiteturais futuros podem justificar bancos de dados adicionais ou outros componentes arquiteturais, mas essa separação deve ser baseada em requisitos operacionais, de escalabilidade, segurança, propriedade ou ciclo de vida explicitamente definidos, e não apenas nos limites dos domínios.

---

### 3.3 Organização de Schemas Orientada a Domínios

Cada *schema* (esquema) do AtlasCommerce representa um domínio primário de negócio ou uma responsabilidade técnica.

As responsabilidades atuais dos *schemas* são:

| Schema | Responsabilidade Arquitetural |
|---|---|
| `metadata` | Governança do banco de dados e metadados técnicos |
| `catalog` | Catálogo de produtos e definição comercial dos produtos |
| `customer` | Identidade do cliente e dados mestres relacionados ao cliente |
| `inventory` | Estado do estoque, histórico de movimentações e responsabilidade pelas reservas |
| `payment` | Ciclo de vida dos pagamentos e responsabilidade pelos reembolsos |
| `reference` | Informações de referência compartilhadas utilizadas por múltiplos domínios |
| `sales` | Responsabilidade pelas transações comerciais e seus itens |
| `shipping` | Responsabilidade pelo atendimento dos pedidos e pelas remessas |

O limite do *schema* comunica propriedade e organização.

Ele não deve ser interpretado como uma proibição de relacionamentos entre domínios.

Relacionamentos entre domínios são esperados quando representam relacionamentos de negócio persistentes legítimos.

---

### 3.4 Domínio de Governança Técnica

O *schema* (esquema) `metadata` possui uma responsabilidade arquitetural diferente daquela dos *schemas* de domínio de negócio.

Ele existe para dar suporte à governança técnica do banco de dados, em vez de representar um processo de negócio do varejo.

Os objetos em `metadata` podem dar suporte à governança de nomenclatura, ao comportamento de *deployment* (implantação), à validação, à rastreabilidade ou a outras responsabilidades técnicas no nível do banco de dados.

Devido a esse papel, `metadata` recebe precedência intencional na ordenação lógica do banco de dados.

Essa precedência é técnica e não deve ser interpretada como uma hierarquia de domínios de negócio.

---

### 3.5 Domínio de Referência Compartilhada

O *schema* (esquema) `reference` contém informações de referência cuja responsabilidade não pertence exclusivamente a um único domínio de negócio.

Os dados de referência podem ser consumidos por objetos de múltiplos *schemas*, mantendo uma única representação autoritativa dentro do AtlasCommerce.

A existência do *schema* `reference` não significa que todos os dados de *lookup* (consulta) ou controlados pertençam a ele.

Um valor controlado cujo ciclo de vida e significado sejam de responsabilidade de um domínio de negócio específico deve permanecer dentro desse domínio.

O *schema* `reference` é reservado para informações genuinamente compartilhadas entre os limites dos domínios.

---

### 3.6 Relacionamentos entre Domínios

O AtlasCommerce permite relacionamentos referenciais entre *schemas* (esquemas) quando esses relacionamentos representam o modelo operacional persistente.

O limite de um *schema* não deve resultar na duplicação de dados autoritativos apenas para evitar uma *Foreign Key* (chave estrangeira) entre domínios.

Por exemplo, um domínio pode referenciar uma entidade pertencente a outro domínio em vez de manter uma cópia independente da mesma identidade operacional.

Os relacionamentos entre domínios devem preservar uma propriedade claramente definida:

- O domínio proprietário permanece responsável pela entidade que persiste.

- Os domínios que a referenciam consomem essa identidade por meio de relacionamentos explícitos.

- A integridade referencial protege os relacionamentos quando o modelo de banco de dados assim exige.

- Um relacionamento não transfere a propriedade da entidade referenciada para o domínio consumidor.

Isso permite que o AtlasCommerce mantenha a organização por domínios sem sacrificar a consistência relacional.

---

### 3.7 Limites dos Domínios e Processos de Negócio

Os processos de negócio podem abranger múltiplos domínios do banco de dados.

O *schema* (esquema) que contém um objeto identifica a responsabilidade primária pelo estado persistido desse objeto; isso não implica que todo o processo de negócio ocorra dentro daquele *schema*.

Uma transação de varejo, por exemplo, pode envolver:

```text
                 customer
                     │
                     ▼
catalog ─────────► sales
                 /   |   \
                ▼    ▼    ▼
          inventory payment shipping
```

Esse diagrama representa a interação entre os domínios, e não uma sequência obrigatória de execução.

Nem toda transação exige a participação de todos os domínios.

Por exemplo, os requisitos de atendimento dependem do cenário da venda, e uma transação concluída diretamente em uma loja física não exige uma remessa apenas porque o domínio `shipping` existe.

As condições de negócio detalhadas que governam essas interações são definidas pela Documentação de Negócio do AtlasCommerce.

Os relacionamentos detalhados entre as entidades são definidos pelo Modelo de Domínio do AtlasCommerce.

---

### 3.8 Separação Arquitetural dos Padrões de Objetos

A arquitetura de banco de dados define onde as responsabilidades pertencem e como os principais domínios se relacionam.

Ela não redefine as convenções de implementação utilizadas pelos objetos individuais do banco de dados.

Nomenclatura, prefixos, chaves, *constraints* (restrições), *indexes* (índices), documentação de objetos, comportamento de *deployment* (implantação), validação e ordenação dos objetos são regidos pelos Padrões de Banco de Dados do AtlasCommerce.

Essa separação permite que as decisões arquiteturais e os padrões de implementação evoluam de maneira controlada sem duplicar suas definições entre os documentos.

---

## 4. Arquitetura Física do Banco de Dados

A arquitetura física do AtlasCommerce dá suporte aos requisitos operacionais do modelo transacional, ao mesmo tempo em que fornece estruturas explícitas para organização do armazenamento, particionamento e crescimento controlado.

O projeto físico é tratado separadamente da organização lógica dos domínios.

Os *schemas* (esquemas) definem a responsabilidade lógica.

*Filegroups* (grupos de arquivos), *partition functions* (funções de particionamento), *partition schemes* (esquemas de particionamento), estruturas *clustered* (clusterizadas) e *indexes* (índices) definem como os objetos de banco de dados são fisicamente organizados quando a implementação exige um projeto físico explícito.

Um relacionamento lógico entre objetos não exige que eles compartilhem a mesma estratégia de armazenamento físico.

Da mesma forma, o posicionamento físico não deve redefinir a propriedade de negócio ou de domínio.

---

### 4.1 Armazenamento Estrutural

O AtlasCommerce utiliza `FG_CORE` como o *filegroup* (grupo de arquivos) estrutural padrão para objetos de banco de dados cuja definição física implementada os atribui explicitamente à estrutura comum de armazenamento não particionado.

Os objetos posicionados em `FG_CORE` podem incluir tabelas, *constraints* (restrições) ou *indexes* (índices), de acordo com suas definições físicas implementadas.

`FG_CORE` representa uma responsabilidade de armazenamento físico.

Ele não é um domínio de negócio e não deve ser interpretado como uma alternativa à organização por *schemas* (esquemas).

As perspectivas lógica e física, portanto, permanecem separadas:

```text
Organização Lógica
│
├── metadata
├── catalog
├── customer
├── inventory
├── payment
├── reference
├── sales
└── shipping

Organização Física
│
├── FG_CORE
│   └── Armazenamento estrutural padrão
│
└── Armazenamento particionado
    └── Posicionamento gerenciado pelo partition scheme (esquema de particionamento)
```

O posicionamento físico exato de um objeto é definido pelo *deployment* (implantação) implementado do banco de dados.

Um objeto não deve ser movido entre estruturas de armazenamento físico apenas para obter consistência visual ou porque outro objeto no mesmo *schema* utiliza uma estratégia de posicionamento diferente.

---

### 4.2 Arquitetura de Particionamento

O AtlasCommerce utiliza particionamento de tabelas quando as características dos dados, os padrões de acesso baseados em tempo, as considerações de ciclo de vida e os requisitos operacionais justificam um projeto físico consciente do particionamento.

O particionamento é, portanto, seletivo, e não uma característica universal das tabelas transacionais.

Uma tabela não deve ser particionada apenas porque se espera que ela cresça.

A decisão deve considerar as características dos dados e as operações que serão realizadas sobre eles.

A arquitetura de particionamento separa:

- A definição lógica da tabela.

- A chave de particionamento.

- A *partition function* (função de particionamento).

- O *partition scheme* (esquema de particionamento).

- O posicionamento físico gerenciado por esse *partition scheme*.

- Os requisitos de alinhamento dos *indexes* (índices) associados ao objeto particionado.

Esses elementos formam um projeto físico coordenado.

Uma tabela particionada não deve ser avaliada apenas por suas colunas lógicas e *constraints* (restrições) quando as características de particionamento fizerem parte de sua implementação esperada.

---

### 4.3 Particionamento Baseado em Tempo

Dados transacionais cujo ciclo de vida esteja naturalmente associado ao tempo podem utilizar uma coluna baseada em tempo como parte da arquitetura de particionamento.

Quando a coluna de particionamento também participa de chaves ou relacionamentos, sua presença não representa uma duplicação acidental de informação temporal.

Ela faz parte do projeto físico e relacional necessário para preservar a compatibilidade com a estrutura particionada.

Isso pode resultar em definições nas quais um identificador transacional é acompanhado por um componente baseado em tempo em:

- *Primary Keys* (chaves primárias).

- *Candidate Keys* (chaves candidatas).

- *Foreign Keys* (chaves estrangeiras).

- *Indexes* (índices) de suporte.

- *Indexes* alinhados ao particionamento.

Por exemplo, relacionamentos envolvendo entidades transacionais particionadas podem exigir tanto um identificador quanto o *timestamp* (registro de data e hora) correspondente da transação.

O componente adicional baseado em tempo deve, portanto, ser interpretado no contexto da arquitetura de particionamento, e não como um identificador de negócio independente.

---

### 4.4 Alinhamento de Particionamento

Os *indexes* (índices) associados a tabelas particionadas podem precisar permanecer alinhados à tabela à qual pertencem.

Quando o alinhamento faz parte da definição física implementada, o *index* deve utilizar a infraestrutura de particionamento e a coluna de particionamento esperadas.

A equivalência lógica, por si só, não é suficiente.

Um *index* com as colunas de chave esperadas, mas com um *partition scheme* (esquema de particionamento) ou uma definição de particionamento incompatível, representa uma arquitetura fisicamente diferente.

O alinhamento de particionamento oferece suporte ao gerenciamento previsível dos dados particionados e preserva a consistência entre a tabela e as estruturas físicas de acesso projetadas em torno dela.

O alinhamento esperado de cada *index* aplicável é definido e validado pelo *deployment* (implantação) do banco de dados.

---

### 4.5 Projeto Físico e Integridade Relacional

A arquitetura física e a integridade relacional devem ser projetadas em conjunto quando uma afetar a outra.

O particionamento pode influenciar:

- A composição da *Primary Key* (chave primária).

- A composição das *Candidate Keys* (chaves candidatas).

- A composição das *Foreign Keys* (chaves estrangeiras).

- O projeto de *indexes* (índices).

- O posicionamento físico.

- Os requisitos de validação.

Esses efeitos não alteram a propriedade semântica dos dados subjacentes.

Por exemplo, adicionar um componente baseado em tempo a uma chave para dar suporte a um projeto consciente do particionamento não transforma esse valor na identidade primária de negócio da entidade.

O significado lógico do relacionamento continua sendo definido pelo modelo de dados, enquanto a chave completa implementada preserva os requisitos da arquitetura física.

---

### 4.6 Validação da Arquitetura Física

A arquitetura física faz parte do estado esperado do banco de dados AtlasCommerce.

Quando aplicável, o *deployment* (implantação) e a *Final Validation* (Validação Final) devem verificar características como:

- *Filegroup* (grupo de arquivos) esperado.

- *Data space* (espaço de dados).

- *Partition function* (função de particionamento).

- *Partition scheme* (esquema de particionamento).

- Coluna de particionamento.

- Posicionamento da tabela.

- Posicionamento do *index* (índice).

- Alinhamento de particionamento.

- Características das chaves exigidas pelo projeto particionado.

A existência de uma tabela ou de um *index* com o nome lógico esperado não estabelece que sua arquitetura física esteja correta.

Uma divergência física deve ser reportada e preservada para revisão controlada, de acordo com os Padrões de Banco de Dados do AtlasCommerce.

O *deployment* (implantação) padrão não deve mover ou reconstruir automaticamente objetos existentes apenas para forçar a conformidade física.

---

### 4.7 Evolução Controlada do Projeto Físico

A arquitetura física do banco de dados pode evoluir à medida que o volume de dados, as características da carga de trabalho, os requisitos operacionais e as evidências mudarem.

Mudanças futuras podem incluir diferentes estratégias de armazenamento, requisitos adicionais de particionamento, limites de partição revisados ou outras otimizações físicas.

Essas mudanças devem ser orientadas por evidências e projetadas intencionalmente.

Uma decisão de arquitetura física não deve ser introduzida apenas porque um recurso do SQL Server está disponível.

Da mesma forma, uma estratégia física existente não deve ser preservada indefinidamente quando evidências operacionais demonstrarem que ela deixou de atender aos requisitos da plataforma.

Mudanças que afetem estruturas persistidas existentes devem seguir princípios de *controlled migration* (migração controlada), em vez de serem introduzidas silenciosamente pelo *deployment* (implantação) padrão reexecutável.

---

## 5. Arquitetura de Integridade de Dados

A integridade dos dados é uma responsabilidade fundamental da arquitetura transacional do AtlasCommerce.

O banco de dados não é tratado apenas como um mecanismo de persistência para dados que já foram validados pelas aplicações.

O AtlasCommerce deve proteger as regras persistentes necessárias para que seu estado operacional armazenado permaneça estrutural e relacionalmente válido, independentemente de qual aplicação autorizada, processo de *deployment* (implantação), integração ou operação administrativa modifique os dados.

A validação no nível da aplicação e a integridade no nível do banco de dados, portanto, desempenham responsabilidades complementares.

As aplicações podem validar a interação com o usuário, o fluxo de trabalho, o contexto de negócio e o comportamento específico de cada processo.

O banco de dados protege invariantes persistentes que devem permanecer válidas independentemente do caminho pelo qual os dados foram gravados.

---

### 5.1 Modelo de Integridade em Camadas

O AtlasCommerce utiliza múltiplos mecanismos complementares para proteger os dados persistidos.

Em nível arquitetural, a integridade pode ser representada como:

```text
Validação da Aplicação e dos Processos
            │
            ▼
Regras de Fluxo de Trabalho do Negócio
            │
            ▼
Integridade do Banco de Dados
│
├── Identidade das entidades
├── Valores obrigatórios e estado válido da linha
├── Unicidade
├── Relacionamentos referenciais
├── Invariantes entre colunas
└── Integridade baseada em tempo e consciente do particionamento
            │
            ▼
Estado Operacional Persistido
```

Essas camadas não são intercambiáveis.

Uma regra implementada por uma aplicação não elimina automaticamente a necessidade de uma *constraint* (restrição) no banco de dados quando a violação dessa regra tornaria os dados persistidos inválidos.

Da mesma forma, nem toda regra da aplicação ou do processo de negócio pertence a uma *constraint* (restrição) de banco de dados.

O mecanismo de integridade apropriado depende da responsabilidade da regra.

---

### 5.2 Identidade das Entidades

As entidades persistidas devem possuir uma estratégia de identificação estável e apropriada ao seu papel no modelo de dados.

Quando uma identidade de linha independente e estável é necessária, essa responsabilidade é normalmente representada por uma *Primary Key* (chave primária).

Identificadores substitutos são utilizados quando uma identidade técnica independente para a linha é apropriada, enquanto identificadores naturais de negócio podem permanecer protegidos separadamente por regras de unicidade.

Nem toda tabela exige um identificador independente artificial.

Quando a semântica de uma tabela não exigir esse identificador, a arquitetura não introduz uma chave substituta apenas para satisfazer uma convenção universal.

O projeto da identidade, portanto, segue o significado persistente e o ciclo de vida da entidade, em vez de uma exigência de que todas as tabelas utilizem uma estrutura de chave idêntica.

---

### 5.3 Integridade Referencial

Os relacionamentos que fazem parte do modelo operacional persistente devem ser protegidos por meio da integridade referencial do banco de dados quando o projeto relacional assim exigir.

*Foreign Keys* (chaves estrangeiras) permitem que o AtlasCommerce preserve relacionamentos válidos tanto dentro de um domínio quanto entre os limites dos domínios.

Isso é particularmente importante porque o AtlasCommerce está organizado como um único banco de dados transacional relacional.

Um relacionamento entre *schemas* (esquemas) não reduz a necessidade de integridade apenas porque as entidades participantes pertencem a domínios lógicos diferentes.

A integridade referencial estabelece que:

- Uma identidade persistente referenciada existe.

- Um relacionamento não pode apontar silenciosamente para uma entidade inexistente.

- Relacionamentos obrigatórios permanecem representados como estado persistido obrigatório.

- Relacionamentos opcionais permanecem explícitos, em vez de serem representados por identidades artificiais usadas como valores substitutos.

- Referências entre domínios preservam o modelo de propriedade definido pela arquitetura de banco de dados.

As ações referenciais fazem parte da semântica do ciclo de vida de um relacionamento e, portanto, devem ser projetadas intencionalmente.

Comportamentos automáticos em cascata são utilizados somente quando representam o ciclo de vida exigido pelo relacionamento persistido.

---

### 5.4 Invariantes Persistentes

O AtlasCommerce utiliza mecanismos de integridade do banco de dados para proteger regras que devem permanecer verdadeiras para que os dados persistidos sejam válidos.

Essas regras podem incluir:

- Estado persistido obrigatório.

- Domínios, intervalos ou formatos válidos.

- Relacionamentos entre valores da mesma linha.

- Unicidade obrigatória.

- Unicidade condicional quando a implementação física exige um mecanismo baseado em *index* (índice).

- Relacionamentos válidos de ciclo de vida ou baseados em tempo.

- Outras invariantes cuja violação representaria um estado inválido do banco de dados.

O banco de dados não deve depender exclusivamente do comportamento das aplicações para preservar essas regras.

Ao mesmo tempo, *constraints* (restrições) de banco de dados não devem ser utilizadas para reproduzir todas as regras existentes no processo de negócio.

Regras que dependem do estado do fluxo de trabalho, de contexto externo, da interação com o usuário ou de informações não representadas pela linha persistida podem pertencer à aplicação ou a outra camada arquitetural.

A distinção é baseada em determinar se a regra protege a validade do estado persistido, e não em determinar se o SQL Server é tecnicamente capaz de expressá-la.

---

### 5.5 Arquitetura de Unicidade

O AtlasCommerce distingue unicidade lógica de estratégia de acesso físico.

Quando valores duplicados representariam um estado persistente inválido do modelo de dados, a unicidade pertence à arquitetura de integridade.

Quando a unicidade exige recursos associados a um *index* (índice), como unicidade condicional baseada em um predicado de filtro, a implementação física pode utilizar um mecanismo baseado em *index*.

Essa distinção preserva o significado arquitetural da regra:

```text
Requisito de Unicidade Persistente
            │
            ├── Incondicional
            │       └── Integridade baseada em constraint (restrição)
            │
            └── Condicional / dependente de index (índice)
                    └── Mecanismo de integridade baseado em index (índice)
```

O mecanismo de implementação deve preservar a razão pela qual a unicidade existe.

Um *index* (índice) físico não deve substituir uma *constraint* (restrição) lógica de integridade apenas porque ambos os mecanismos são tecnicamente capazes de impedir valores duplicados.

A distinção detalhada entre *Unique Constraints* (restrições de unicidade) e *Unique Indexes* (índices únicos) é definida pelos Padrões de Banco de Dados do AtlasCommerce.

---

### 5.6 Integridade Baseada em Tempo e Consciente do Particionamento

A arquitetura física de particionamento pode afetar a definição relacional necessária para preservar a integridade.

Quando uma coluna de particionamento participa de uma *Primary Key* (chave primária) ou *Candidate Key* (chave candidata), os relacionamentos com essa chave também podem exigir o componente correspondente baseado em tempo.

O AtlasCommerce, portanto, trata os componentes baseados em tempo introduzidos pelo projeto de chaves consciente do particionamento como parte da definição relacional completa.

Para os relacionamentos aplicáveis, a integridade pode ser representada conceitualmente como:

```text
Identidade Transacional
        +
Componente Baseado em Tempo / de Particionamento
        │
        ▼
Chave Referenciada Completa
```

O componente baseado em tempo não substitui a identidade semântica da entidade.

Ele existe porque as arquiteturas física e relacional devem permanecer compatíveis.

Esse projeto permite que o AtlasCommerce preserve a integridade referencial enquanto mantém a estrutura física consciente do particionamento exigida.

---

### 5.7 Integridade e Desempenho

A integridade dos dados e o desempenho das consultas são responsabilidades arquiteturais distintas.

Uma *constraint* (restrição) existe porque um estado persistido deve ser protegido.

Um *index* (índice) existe principalmente porque um padrão de acesso ou um requisito de integridade específico de *index* justifica a estrutura física.

A existência de um não justifica automaticamente a existência do outro.

Por exemplo:

- Uma *Foreign Key* (chave estrangeira) não exige automaticamente um *index* (índice) de desempenho dedicado.

- Um *index* (índice) não estabelece integridade referencial.

- Uma estrutura única orientada ao desempenho não deve substituir automaticamente uma *constraint* (restrição) lógica de unicidade.

- Uma estrutura física associada a uma *constraint* deve continuar sendo compreendida principalmente de acordo com a regra de integridade que representa.

Essa separação impede que estruturas de desempenho sejam confundidas com requisitos do modelo lógico e impede que objetos de integridade sejam introduzidos apenas como otimizações de desempenho.

---

### 5.8 Validação da Integridade

A arquitetura de integridade está incompleta se os objetos esperados apenas existirem sem representar o estado esperado.

O AtlasCommerce, portanto, trata a validação como parte da integridade.

Quando aplicável, a validação da integridade deve estabelecer que a definição implementada representa o relacionamento ou a invariante esperada, incluindo características como:

- Objetos e colunas participantes.

- Correspondência e ordem das colunas.

- Unicidade obrigatória.

- Ações referenciais.

- Estado habilitado.

- Estado confiável.

- Compatibilidade com *Candidate Keys* (chaves candidatas).

- Componentes baseados em tempo ou conscientes do particionamento.

- Outras características exigidas pela definição de integridade implementada.

Um objeto de integridade desabilitado, não confiável, estruturalmente divergente ou incompatível de qualquer outra forma não deve ser tratado como equivalente ao estado válido esperado apenas porque existe um objeto com o nome esperado.

As regras detalhadas de validação para cada tipo de objeto são definidas pelos Padrões de Banco de Dados do AtlasCommerce e implementadas pelos processos de *deployment* (implantação) do banco de dados e de *Final Validation* (Validação Final).

---

### 5.9 Evolução Controlada da Integridade

As regras de integridade podem evoluir quando o modelo de negócio, a arquitetura ou os requisitos técnicos validados forem alterados.

Mudanças na integridade persistente devem ser intencionais, pois podem afetar dados e relacionamentos existentes.

O *deployment* (implantação) padrão não deve substituir silenciosamente uma definição de integridade existente e divergente apenas para forçar conformidade.

Quando uma mudança de integridade afetar o estado persistido, ela pode exigir:

- Avaliação dos dados existentes.

- Análise de dependências.

- Correção ou transformação controlada dos dados.

- Migração explícita.

- Validação do estado resultante.

- Sincronização da documentação de negócio, arquitetura, padrões e documentação técnica, quando aplicável.

Essa abordagem permite que o AtlasCommerce evolua sem tratar o estado persistido existente como descartável.

---

## 6. Arquitetura de Deployment e Validação

O *deployment* (implantação) e a validação fazem parte da arquitetura de banco de dados do AtlasCommerce, em vez de serem atividades administrativas independentes.

O banco de dados foi projetado para ser criado, validado e reavaliado com segurança por meio de um processo coordenado de *deployment* (implantação).

Esse processo deve oferecer suporte tanto a ambientes novos quanto a ambientes nos quais objetos do AtlasCommerce já existam.

O objetivo arquitetural não é forçar automaticamente todos os ambientes ao estado esperado.

O objetivo é estabelecer o estado esperado, avaliar o estado atual, executar operações seguras quando apropriado e tornar explícitas as divergências quando uma modificação automática for insegura ou ambígua.

Em alto nível, a arquitetura de *deployment* (implantação) segue este modelo:

```text
Definição Esperada do Banco de Dados
            │
            ▼
Validação de Dependências
            │
            ▼
Avaliação do Estado Atual
            │
       ┌────┴────┐
       │         │
       ▼         ▼
Ação Segura   Divergência
       │         │
       ▼         ▼
Criar /       Preservar /
Validar       Reportar
       │         │
       └────┬────┘
            ▼
Final Validation (Validação Final) Independente
            │
            ▼
Estado Validado do Banco de Dados
```

---

### 6.1 Deployment Coordenado

O AtlasCommerce utiliza um modelo coordenado de *deployment* (implantação) no qual as responsabilidades do banco de dados são organizadas em fases explícitas.

A estrutura de fases existe porque os objetos de banco de dados possuem diferentes características de dependência e ciclo de vida.

Por exemplo:

- A infraestrutura física de particionamento deve existir antes que os objetos que dependem dela possam ser criados.

- As tabelas e suas *Primary Keys* (chaves primárias) estabelecem a base estrutural do modelo relacional.

- A documentação de objetos depende da existência prévia dos objetos documentados.

- Os dados gerenciados pelo *deployment* (implantação) dependem das estruturas às quais pertencem.

- As *constraints* (restrições) de integridade dependem de tabelas, colunas e, em alguns casos, de outras *Candidate Keys* (chaves candidatas).

- Os *indexes* (índices) dependem das estruturas lógicas e físicas exigidas por suas definições implementadas.

- A *Final Validation* (Validação Final) depende da disponibilidade do estado completo esperado do banco de dados para uma avaliação independente.

A separação dessas responsabilidades em fases torna explícito o gerenciamento de dependências, preservando ao mesmo tempo um comportamento previsível de *deployment* (implantação).

Os nomes exatos das fases, a organização dos *scripts* e a ordem de orquestração são responsabilidades de implementação definidas pelo *deployment* atual do AtlasCommerce.

---

### 6.2 Execução Consciente das Dependências

As operações de *deployment* (implantação) devem avaliar as dependências necessárias antes de tentar modificar o banco de dados.

A consciência das dependências aplica-se tanto à arquitetura lógica quanto à física.

Uma dependência obrigatória pode incluir:

- Um *schema* (esquema).

- Uma tabela.

- Uma coluna.

- Uma *Primary Key* (chave primária) ou *Candidate Key* (chave candidata).

- Outro objeto de integridade.

- Um *filegroup* (grupo de arquivos).

- Uma *partition function* (função de particionamento).

- Um *partition scheme* (esquema de particionamento).

- Outra estrutura física ou relacional exigida pela definição esperada.

A existência, por si só, não estabelece que uma dependência seja compatível.

O *deployment* (implantação) deve distinguir entre:

```text
Dependência Ausente
        │
        └── A operação insegura não deve continuar

Dependência Presente e Compatível
        │
        └── A operação dependente pode prosseguir

Dependência Presente, porém Divergente
        │
        └── Preservar o estado e reportar a incompatibilidade
```

Isso impede que fases posteriores do *deployment* (implantação) tratem um objeto existente inesperado como uma base arquitetural válida apenas porque seu nome corresponde à dependência esperada.

---

### 6.3 Arquitetura Reexecutável

O *deployment* (implantação) do AtlasCommerce foi projetado para ser reexecutável.

Reexecutabilidade significa que um ambiente pode ser avaliado repetidamente sem recriar ou duplicar indiscriminadamente objetos e dados determinísticos gerenciados pelo *deployment* (implantação).

Uma reexecução deve reconhecer a diferença entre:

- Estado esperado ausente.

- Estado existente válido.

- Estado existente divergente.

- Dependências ausentes ou incompatíveis.

A arquitetura de *deployment* (implantação), portanto, depende de validação positiva, e não de supressão de erros.

Espera-se que uma segunda execução valide o estado correto já existente, em vez de tentar recriá-lo.

Esse princípio permite que a mesma arquitetura de *deployment* (implantação) dê suporte a:

- Criação inicial do ambiente.

- Validação técnica repetida.

- Evolução controlada.

- Recuperação após a correção de condições do *deployment* (implantação).

- Verificação de que um ambiente ainda representa a definição esperada do AtlasCommerce.

Reexecutável não significa *self-healing* (autocorretivo).

Um *deployment* (implantação) reexecutável não deve transformar automaticamente todo objeto divergente na definição esperada.

---

### 6.4 Comportamento Não Destrutivo

O *deployment* (implantação) padrão do AtlasCommerce preserva estados existentes inesperados quando a modificação correta não puder ser determinada de forma segura e inequívoca.

Essa é uma decisão arquitetural de segurança.

Uma divergência existente pode representar:

- Um ambiente obsoleto.

- Uma expectativa de *deployment* (implantação) obsoleta.

- Uma migração controlada anterior.

- Uma alteração deliberada específica de um ambiente.

- Um *deployment* (implantação) incompleto.

- Uma modificação manual inesperada.

- Outra condição que exija investigação.

O *deployment* (implantação) não consegue inferir o contexto histórico ou operacional correto apenas a partir dos metadados dos objetos.

Por essa razão, correções potencialmente destrutivas ou que transformem o estado são separadas do comportamento padrão do *deployment* (implantação).

O *deployment* (implantação) padrão pode criar o estado esperado ausente quando isso for seguro, mas estados existentes divergentes são preservados e reportados para revisão controlada.

---

### 6.5 Limite de Migração Explícita

O AtlasCommerce distingue *deployment* (implantação) padrão de migração.

O *deployment* (implantação) padrão estabelece ou valida a arquitetura esperada sem transformar silenciosamente um estado persistido incompatível.

Uma migração altera intencionalmente o estado existente.

Esse limite pode ser representado como:

```text
Deployment Padrão
│
├── Criar estado seguro ausente
├── Validar estado correspondente
├── Reportar estado divergente
└── Preservar estado existente inesperado

Migração Explícita
│
├── Transformar estruturas existentes
├── Transformar dados existentes
├── Substituir definições incompatíveis
├── Mover estruturas físicas
└── Executar outras alterações controladas de estado
```

Operações que possam afetar dados persistidos existentes, integridade relacional, posicionamento físico ou semântica de recuperação devem ser tratadas como alterações controladas quando não puderem ser executadas com segurança pelo *deployment* (implantação) padrão.

Essa separação impede que uma reexecução rotineira se transforme em uma migração implícita.

---

### 6.6 Coordenação Transacional

O *deployment* (implantação) coordenado atual do modelo de dados do AtlasCommerce utiliza uma estratégia transacional explícita para preservar uma semântica previsível de falha.

A infraestrutura física de particionamento necessária é estabelecida e validada antes do principal limite transacional do *deployment* (implantação).

As principais fases do *deployment* (implantação) relacional são então coordenadas dentro de uma única transação, de forma que uma falha fatal dentro dessa unidade transacional não deixe essas fases parcialmente confirmadas.

Conceitualmente:

```text
Infraestrutura de Particionamento
        │
        ├── Estabelecer
        └── Validar
        │
        ▼
Principal Limite Transacional
│
├── Tabelas
├── Documentação de Objetos
├── Dados Gerenciados pelo Deployment
├── Constraints de Integridade
├── Foreign Keys
├── Indexes
└── Final Validation
        │
        ▼
Commit / Rollback
```

Uma falha nas principais fases transacionais do *deployment* (implantação) desfaz essa unidade transacional.

As operações de particionamento físico concluídas antes da transação não fazem parte desse limite de *rollback* (reversão) e, portanto, devem permanecer seguras para execução reexecutável e validação subsequente.

Os limites das transações são decisões arquiteturais.

Eles afetam:

- Atomicidade.

- Duração dos bloqueios.

- Uso do *transaction log* (log de transações).

- Recuperação de falhas.

- Tempo operacional de execução.

- Comportamento de reexecução.

- Consequências de uma conclusão parcial.

Uma transação de *deployment* (implantação) de longa duração pode apresentar custo operacional.

Entretanto, dividir o *deployment* (implantação) principal em unidades confirmadas independentemente também altera o modelo de recuperação, pois fases anteriores podem permanecer confirmadas quando uma fase posterior falha.

A estratégia transacional deve, portanto, favorecer uma semântica de recuperação previsível e explicitamente compreendida, em vez de ser alterada apenas para reduzir o tempo de execução.

Qualquer mudança futura nos limites das transações deve definir como funcionarão a conclusão parcial, a recuperação, os pré-requisitos físicos e o comportamento seguro de reexecução.

---

### 6.7 Final Validation Independente

A *Final Validation* (Validação Final) é um controle arquitetural independente.

Ela não depende apenas das mensagens de sucesso produzidas pelas fases anteriores do *deployment* (implantação).

As fases anteriores respondem a perguntas como:

```text
Este objeto foi criado?

Esta dependência foi validada?

Esta fase foi concluída?
```

A *Final Validation* (Validação Final) responde a uma pergunta diferente:

```text
O banco de dados consolidado agora representa
o estado esperado do AtlasCommerce?
```

Por essa razão, a *Final Validation* (Validação Final) deve inspecionar independentemente o banco de dados implantado.

Dependendo das definições aplicáveis, ela pode avaliar:

- Tabelas.

- Colunas.

- *Primary Keys* (chaves primárias).

- Documentação de objetos.

- Dados gerenciados pelo *deployment* (implantação).

- *Constraints* (restrições) de integridade.

- Relacionamentos de *Foreign Key* (chave estrangeira).

- *Indexes* (índices).

- Posicionamento físico.

- Características conscientes do particionamento.

- Integridade baseada em tempo ou consciente do particionamento.

- Outros requisitos arquiteturais explicitamente implementados.

Um *deployment* (implantação) que alcance o fim da execução sem um erro de execução SQL não é automaticamente um *deployment* válido do AtlasCommerce.

O estado consolidado esperado também deve passar pela validação independente aplicável.

---

### 6.8 Deployment Limpo e Validação de Reexecução

O AtlasCommerce distingue a validação da criação da validação da reexecução.

Um *deployment* (implantação) em um ambiente limpo demonstra que a arquitetura pode ser criada a partir de seus pré-requisitos definidos.

Uma segunda execução nesse ambiente resultante demonstra que o *deployment* (implantação) consegue reconhecer corretamente e preservar o estado válido existente.

O ciclo completo de validação é, portanto:

```text
Ambiente Limpo
       │
       ▼
Primeiro Deployment (Implantação)
       │
       ▼
Final Validation (Validação Final)
       │
       ▼
Estado Esperado do Banco de Dados
       │
       ▼
Segundo Deployment (Implantação)
       │
       ▼
Validação do Estado Existente
       │
       ▼
Final Validation (Validação Final)
       │
       ▼
Estado Esperado do Banco de Dados Preservado
```

As duas execuções fornecem evidências diferentes.

A primeira valida o comportamento de criação.

A segunda valida o comportamento de reexecução.

Juntas, elas demonstram que a arquitetura de *deployment* (implantação) consegue estabelecer e posteriormente reconhecer o estado esperado do banco de dados AtlasCommerce sem duplicação ou modificação desnecessária.

---

### 6.9 Evidências e Rastreabilidade do Deployment

O comportamento do *deployment* (implantação) deve ser observável e rastreável.

O processo de *deployment* (implantação) deve comunicar informações suficientes para determinar:

- Qual fase está sendo executada.

- Qual objeto está sendo avaliado.

- Se um objeto foi criado ou já existia.

- Se a definição esperada foi validada.

- Se uma dependência foi validada.

- Se uma divergência foi detectada.

- Se uma operação não pôde continuar com segurança.

- Se o estado final do banco de dados passou pela validação.

A saída de diagnóstico faz parte das evidências técnicas de uma execução de *deployment* (implantação).

Essas evidências dão suporte à solução de problemas, revisão, decisões de migração controlada e comparação entre execuções.

O vocabulário exato das mensagens, os marcadores visuais e as convenções de implementação são definidos pelos Padrões de Banco de Dados do AtlasCommerce e pelos *scripts* atuais de *deployment* (implantação).

---

### 6.10 Evolução Controlada da Arquitetura de Deployment

A arquitetura de *deployment* (implantação) pode evoluir à medida que o AtlasCommerce incorporar novos tipos de objetos, estruturas físicas, mecanismos de integridade ou requisitos operacionais.

Novos comportamentos de *deployment* (implantação) devem preservar os princípios arquiteturais de:

- Dependências explícitas.

- Validação antes da modificação.

- Execução reexecutável.

- Comportamento padrão não destrutivo.

- Separação entre *deployment* (implantação) e migração.

- Semântica transacional previsível.

- *Final Validation* (Validação Final) independente.

- Execução rastreável.

Os detalhes de implementação podem mudar sem exigir que esses princípios sejam alterados.

Quando um requisito arquitetural futuro exigir um princípio diferente, a mudança deve ser intencional e sincronizada entre a implementação, os Padrões de Banco de Dados e a documentação de Arquitetura.

---

## 7. Arquitetura de Extração de Dados

O AtlasCommerce é um sistema transacional operacional e não deve assumir responsabilidades de cargas de trabalho analíticas apenas porque seus dados são necessários para plataformas subsequentes.

A extração de dados é, portanto, tratada como um limite arquitetural explícito entre a origem transacional e as camadas de Engenharia de Dados do Atlas Engineering.

A arquitetura de extração deve proteger a carga de trabalho operacional primária, ao mesmo tempo em que fornece aos processos subsequentes um mecanismo controlado e confiável para consumo dos dados de origem.

Em alto nível, o limite é:

```text
AtlasCommerce
Carga de Trabalho Transacional
        │
        ▼
Limite Controlado de Extração
        │
        ▼
Ingestão de Dados
        │
        ▼
Engenharia de Dados Subsequente
```

O AtlasCommerce define a origem operacional e os requisitos que devem ser respeitados quando seus dados forem consumidos.

As tecnologias finais de extração e ingestão são responsabilidades da arquitetura de Engenharia de Dados e não são predeterminadas pelo projeto do banco de dados transacional.

---

### 7.1 Proteção da Carga de Trabalho Transacional

As vendas e os demais processos operacionais constituem a carga de trabalho primária do AtlasCommerce.

A extração de dados não deve ser projetada de forma que concorra desnecessariamente com as transações operacionais por:

- CPU.

- Memória.

- Taxa de transferência do armazenamento.

- Conexões com o banco de dados.

- *Locks* (bloqueios).

- Recursos do *transaction log* (log de transações).

- Outra capacidade do banco de dados ou da infraestrutura necessária à carga de trabalho transacional.

A conveniência analítica não tem precedência sobre a confiabilidade operacional.

Uma estratégia de extração que forneça dados com sucesso às camadas subsequentes, mas cause impacto inaceitável nas operações transacionais, não atende aos requisitos arquiteturais do AtlasCommerce.

---

### 7.2 Extração Desacoplada

O consumo analítico deve ser desacoplado da carga de trabalho transacional primária sempre que a arquitetura selecionada tornar isso viável.

A futura arquitetura de ingestão pode avaliar mecanismos como:

- Cópias dedicadas para leitura ou réplicas.

- Extração baseada em *backup* (cópia de segurança).

- Mecanismos baseados em *transaction log* (log de transações).

- Mecanismos de *change capture* (captura de alterações).

- Consultas controladas à origem.

- Outras tecnologias apropriadas aos requisitos de latência, consistência, capacidade de recuperação e características operacionais.

Essa lista identifica possibilidades arquiteturais, e não escolhas de implementação predeterminadas.

O AtlasCommerce não exige uma tecnologia específica de extração antes que os requisitos de Engenharia de Dados tenham sido avaliados.

O mecanismo selecionado deve ser justificado por evidências e pelas características da origem e dos requisitos subsequentes.

---

### 7.3 Acesso Controlado à Origem

Quando a extração exigir consultas diretas ao AtlasCommerce, o acesso à origem deve ser controlado.

Os processos de extração devem evitar operações desnecessariamente custosas contra o banco de dados transacional.

Em particular, o projeto da extração deve considerar:

- Seletividade das consultas.

- Caminhos de acesso.

- Volume de dados.

- Comportamento de bloqueios.

- Duração da execução.

- Impacto no *transaction log* (log de transações).

- Concorrência com cargas de trabalho operacionais.

- Frequência da extração.

- Janelas de extração disponíveis.

- Comportamento em caso de falha e nova tentativa.

Uma consulta tecnicamente válida não é automaticamente uma estratégia de extração operacionalmente aceitável.

As consultas à origem devem ser avaliadas de acordo com seu impacto sobre a carga de trabalho transacional.

---

### 7.4 Cargas Iniciais de Dados

A ingestão inicial de dados pode exigir o processamento de um volume substancialmente maior de dados do que a extração incremental rotineira.

Uma carga inicial não deve ser implementada automaticamente como uma operação irrestrita de tabela completa contra a origem transacional.

Quando o volume de dados ou o impacto sobre a origem exigir, a extração inicial deve ser dividida preferencialmente em unidades controladas, como:

- Janelas de tempo.

- Intervalos de chaves.

- *Batches* (lotes) determinísticos.

- Outros limites de extração que permitam reinício controlado.

Conceitualmente:

```text
Dados de Origem
│
├── Batch / Window 1
├── Batch / Window 2
├── Batch / Window 3
├── ...
└── Batch / Window N
        │
        ▼
Ingestão Subsequente
```

O limite de extração deve permitir que o processo de ingestão controle o consumo de recursos e se recupere de forma previsível após uma interrupção.

A estratégia exata de particionamento da carga depende das características do objeto de origem e será definida durante a implementação da arquitetura de ingestão.

---

### 7.5 Extração Incremental

O processamento subsequente rotineiro deve evitar extrair repetidamente todo o conjunto operacional de dados quando uma estratégia incremental confiável puder ser estabelecida.

Uma arquitetura de extração incremental deve ser capaz de determinar quais dados de origem pertencem ao intervalo de extração ou ao *change set* (conjunto de alterações) que está sendo processado.

O mecanismo utilizado para identificar dados incrementais pode variar de acordo com a arquitetura de ingestão selecionada.

Os possíveis mecanismos podem se basear em:

- *Timestamps* (registros de data e hora) da origem.

- Identificadores ou intervalos estáveis.

- Informações de *change tracking* (rastreamento de alterações).

- Informações do *transaction log* (log de transações).

- Outras características determinísticas da origem.

A existência de *timestamps* de ciclo de vida no AtlasCommerce não os transforma automaticamente no mecanismo selecionado de ingestão incremental.

Sua semântica operacional deve ser avaliada antes que sejam utilizados como *watermarks* (marcadores de progresso) de extração ou indicadores de alteração.

A arquitetura de Engenharia de Dados deve definir a estratégia incremental efetiva após avaliar correção, latência, capacidade de recuperação e impacto sobre a origem.

---

### 7.6 Capacidade de Reinício e Limites de Extração

Os processos de extração devem ser projetados para que uma falha não exija o reprocessamento descontrolado de todo o conjunto de dados de origem sempre que isso for viável.

Um limite controlado de extração deve, preferencialmente, permitir que o processamento subsequente determine:

- Quais dados deveriam ser extraídos.

- Quais dados foram processados com sucesso.

- Quais dados permanecem não processados.

- Se uma unidade com falha pode ser executada novamente com segurança.

- Se a repetição de uma unidade de extração pode produzir duplicações nas camadas subsequentes.

- Como o próximo limite de extração é determinado.

Essa responsabilidade se torna especialmente importante para grandes cargas iniciais e para ingestões incrementais recorrentes.

A capacidade de reinício deve se basear em limites determinísticos de processamento, e não em suposições sobre o ponto em que uma execução com falha tenha simplesmente parado.

---

### 7.7 Semântica dos Dados de Origem

A extração subsequente deve preservar o significado dos dados operacionais do AtlasCommerce.

A camada de ingestão pode transformar a representação, mas não deve reinterpretar silenciosamente a semântica da origem.

Por exemplo:

```text
AtlasCommerce
Significado Operacional
        │
        ▼
Extração
        │
        ▼
Transformação
        │
        ▼
Representação Analítica
```

A transformação pode reorganizar os dados para fins analíticos, mas a linhagem entre o significado da origem e o significado analítico resultante deve permanecer compreensível.

O modelo transacional não deve ser modificado apenas para facilitar a construção de estruturas analíticas subsequentes quando a modificação não atender a um requisito operacional.

Da mesma forma, os consumidores subsequentes não devem assumir que a estrutura física do AtlasCommerce seja, por si só, o modelo analítico necessário.

---

### 7.8 Interpretação Histórica

O AtlasCommerce representa o estado operacional de acordo com a semântica de ciclo de vida definida por seus modelos de negócio e de banco de dados.

Os requisitos analíticos subsequentes podem exigir representações históricas diferentes da forma como o estado operacional é persistido.

A plataforma analítica pode, portanto, precisar:

- Preservar versões históricas.

- Derivar eventos analíticos.

- Rastrear alterações ao longo do tempo.

- Criar *snapshots* (instantâneos).

- Criar histórico dimensional.

- Agregar registros operacionais.

- Combinar informações de múltiplas entidades de origem.

Essas são responsabilidades arquiteturais subsequentes.

O AtlasCommerce deve preservar o histórico operacional quando esse histórico pertencer ao modelo transacional de negócio, mas não deve fabricar histórico analítico apenas para atender a um futuro projeto de armazenamento analítico.

---

### 7.9 Consistência da Extração

A estratégia de extração selecionada deve definir o nível de consistência exigido para os dados que estão sendo consumidos.

Um processo de extração pode ler dados enquanto transações operacionais continuam modificando a origem.

A arquitetura de ingestão deve, portanto, avaliar questões como:

- Se os dados extraídos devem representar um ponto no tempo transacionalmente consistente.

- Se objetos relacionados devem ser extraídos sob um limite coordenado de consistência.

- Como alterações ocorridas durante a extração são tratadas.

- Como alterações tardias ou repetidas são detectadas.

- Como unidades de extração com falha são executadas novamente.

- Como o processamento subsequente distingue uma ingestão completa de uma incompleta.

Essas decisões dependem da tecnologia de extração selecionada e dos requisitos analíticos.

O AtlasCommerce estabelece o requisito de que a consistência da origem seja explicitamente considerada; ele não prescreve a implementação final antes que esses requisitos sejam conhecidos.

---

### 7.10 Segurança e Escopo da Extração

Os processos subsequentes devem, preferencialmente, receber apenas o acesso à origem necessário para executar sua responsabilidade de extração definida.

Um mecanismo de ingestão não deve depender de acesso administrativo irrestrito ao AtlasCommerce apenas por conveniência de implementação.

A arquitetura de extração deve oferecer suporte ao acesso controlado aos dados e operações necessários, de acordo com a arquitetura de segurança disponível quando o mecanismo de ingestão for implementado.

O projeto detalhado de autenticação, autorização, gerenciamento de credenciais, criptografia e segurança da plataforma está fora do escopo atual deste documento e deve ser definido pela arquitetura de segurança e de Engenharia de Dados aplicável.

---

### 7.11 Observabilidade da Extração

A futura arquitetura de ingestão deve fornecer evidências suficientes para determinar se a extração está operando corretamente.

No mínimo, a arquitetura deve tornar possível determinar:

- O intervalo ou limite de extração processado.

- Quando a extração foi iniciada e concluída.

- Se a extração foi concluída com sucesso.

- Quanto dado foi processado.

- Se ocorreram novas tentativas.

- Se uma unidade de processamento falhou.

- Se o limite esperado da origem foi consumido completamente.

*Logging* (registro de eventos) detalhado, metadados de orquestração, plataformas de monitoramento, alertas e *dashboards* (painéis) operacionais serão definidos pela implementação de Engenharia de Dados.

O requisito arquitetural é que a extração não opere como um processo opaco cuja completude não possa ser determinada.

---

### 7.12 Seleção da Tecnologia de Extração

O AtlasCommerce intencionalmente não prescreve a tecnologia final de extração.

A seleção da tecnologia deve ocorrer após os requisitos de Engenharia de Dados serem conhecidos.

A avaliação deve considerar características como:

- Latência de dados exigida.

- Impacto sobre a carga de trabalho da origem.

- Volume e crescimento dos dados.

- Requisitos de consistência transacional.

- Requisitos de carga inicial.

- Requisitos de carga incremental.

- Capacidade de reinício.

- Capacidade de recuperação.

- Complexidade operacional.

- Custo de infraestrutura.

- Requisitos de segurança.

- Observabilidade.

- Manutenibilidade.

- Recursos disponíveis do SQL Server.

- Requisitos introduzidos por sistemas de origem adicionais no futuro.

A arquitetura selecionada pode utilizar mecanismos de extração diferentes para diferentes origens quando suas características justificarem estratégias distintas.

Uma tecnologia não deve ser selecionada apenas porque está disponível ou é amplamente utilizada.

O mecanismo de extração deve atender aos requisitos da plataforma enquanto preserva a responsabilidade operacional do sistema de origem.

---

## 8. Evolução Arquitetural e Limites

O AtlasCommerce foi projetado para evoluir à medida que evoluam os requisitos operacionais, as características da carga de trabalho, os volumes de dados, os requisitos de integração e a plataforma mais ampla do Atlas Engineering.

A arquitetura é, portanto, tratada como uma representação controlada das responsabilidades atuais e da direção futura explicitamente identificada, e não como uma descrição permanente de um projeto inicial.

A evolução arquitetural deve preservar limites claros entre as responsabilidades.

Um novo requisito não deve ser automaticamente implementado no AtlasCommerce apenas porque o banco de dados transacional é tecnicamente capaz de suportá-lo.

Da mesma forma, uma responsabilidade não deve ser automaticamente movida para fora do AtlasCommerce quando ela pertencer ao modelo operacional persistente.

A localização arquitetural apropriada de uma capacidade depende da razão pela qual essa capacidade existe e de qual camada é responsável por seu ciclo de vida.

---

### 8.1 Evolução Arquitetural Controlada

As mudanças arquiteturais devem ser intencionais e justificadas por requisitos ou evidências.

Possíveis motivadores podem incluir:

- Novas capacidades de negócio.

- Novos requisitos operacionais.

- Crescimento da carga de trabalho.

- Crescimento do volume de dados.

- Novos sistemas de origem.

- Novos requisitos de integração.

- Novos requisitos analíticos.

- Requisitos de segurança.

- Requisitos de disponibilidade e capacidade de recuperação.

- Evidências operacionais.

- Evolução da infraestrutura.

- Mudanças nas capacidades da plataforma.

A disponibilidade de uma tecnologia ou recurso de banco de dados não constitui, por si só, justificativa suficiente para alterar a arquitetura.

Uma mudança proposta deve ser avaliada de acordo com a responsabilidade à qual atende e com seu efeito sobre a plataforma existente.

A evolução arquitetural também deve considerar os contratos estabelecidos entre as camadas.

Uma alteração no AtlasCommerce que afete a extração subsequente, a semântica, a identidade, a interpretação do ciclo de vida ou outro limite arquitetural deve ser coordenada com os componentes afetados, em vez de ser introduzida como uma mudança isolada de implementação.

---

### 8.2 Limites Arquiteturais

O AtlasCommerce possui limites arquiteturais explícitos.

Sua responsabilidade principal é a persistência transacional do varejo.

Responsabilidades que normalmente pertencem fora da arquitetura transacional do AtlasCommerce incluem:

- Transformação analítica.

- Modelagem dimensional.

- Agregação analítica.

- Apresentação de *Business Intelligence* (Inteligência de Negócios).

- Historização analítica que não pertença ao modelo operacional.

- Orquestração de *data pipelines* (pipelines de dados).

- Armazenamento analítico subsequente.

- Integração analítica entre múltiplas origens.

Essas responsabilidades podem consumir dados do AtlasCommerce, mas não devem redefinir a responsabilidade principal do banco de dados transacional.

Da mesma forma, responsabilidades que pertençam ao modelo operacional persistente não devem ser movidas para as camadas subsequentes apenas porque também são úteis para análises.

Por exemplo, identidade operacional, integridade referencial, relacionamentos persistentes válidos e estado operacional de ciclo de vida permanecem responsabilidades do sistema de origem quando forem exigidos pelo modelo transacional.

O limite arquitetural é, portanto, baseado na responsabilidade, e não em determinar se uma capacidade poderia tecnicamente ser implementada em mais de uma camada.

---

### 8.3 Arquitetura Implementada e Direção Arquitetural

Este documento distingue arquitetura implementada de direção arquitetural.

A arquitetura implementada descreve capacidades e estruturas que atualmente fazem parte da plataforma AtlasCommerce validada.

A direção arquitetural descreve limites, responsabilidades e princípios de projeto estabelecidos para futuras capacidades do Atlas Engineering cuja implementação final ainda não tenha sido selecionada ou concluída.

Por exemplo:

```text
Implementado
│
└── AtlasCommerce
    └── Sistema transacional de origem SQL Server

Direção Arquitetural
│
├── Ingestão controlada de dados
├── Staging (Preparação) e processamento de dados
├── Plataforma analítica de dados
└── Consumo analítico
```

Um componente arquitetural futuro não deve ser descrito como implementado apenas porque sua responsabilidade ou posição pretendida já tenha sido definida.

Da mesma forma, uma capacidade implementada não deve continuar sendo descrita apenas como direção futura depois de se tornar parte da plataforma validada.

À medida que o Atlas Engineering evoluir, este documento deverá ser atualizado para que a distinção entre arquitetura implementada e direção arquitetural permaneça explícita e correta.

---

### 8.4 Limites da Documentação

A documentação de arquitetura define responsabilidades, limites, componentes principais e os relacionamentos entre eles.

Ela não deve se tornar uma fonte duplicada para regras detalhadas que já sejam regidas por documentação especializada.

As responsabilidades da documentação do AtlasCommerce são separadas conceitualmente da seguinte forma:

| Documentação | Responsabilidade Principal |
|---|---|
| Documentação de Negócio | Comportamento de negócio, conceitos, regras e semântica de ciclo de vida |
| Documentação de Arquitetura | Responsabilidades arquiteturais, limites, componentes e principais decisões de projeto |
| Padrões de Banco de Dados | Projeto de banco de dados, nomenclatura, integridade, indexação, ordenação, *deployment* (implantação) e convenções de validação |
| Documentação do Modelo de Domínio | Entidades persistidas, atributos, relacionamentos e estrutura de dados no nível do domínio |
| Documentação e *Scripts* de Deployment | Comportamento de *deployment* (implantação) implementado, orquestração e execução técnica |
| *Final Validation* (Validação Final) | Verificação independente do estado esperado do banco de dados implantado |

Esses artefatos podem descrever o mesmo sistema a partir de perspectivas diferentes.

Eles devem permanecer consistentes, mas não devem reproduzir uns aos outros desnecessariamente.

Quando o mesmo conceito aparecer em múltiplos documentos, cada documento deve descrever apenas o aspecto exigido por sua responsabilidade e referenciar a fonte aplicável da definição detalhada quando apropriado.

---

### 8.5 Fonte da Verdade e Sincronização

Nenhum artefato de documentação isolado substitui a plataforma implementada e validada.

Para as capacidades implementadas do AtlasCommerce, a implementação validada do banco de dados é a fonte técnica da verdade.

A documentação deve descrever essa implementação com precisão.

Quando uma premissa arquitetural antiga entrar em conflito com uma implementação validada, a divergência deve ser investigada.

Se for confirmado que a implementação representa a arquitetura atual pretendida, a documentação obsoleta deve ser atualizada, em vez de forçar a plataforma a preservar um projeto desatualizado apenas para manter consistência documental.

Esse princípio não significa que toda implementação existente esteja automaticamente correta.

Uma divergência pode revelar:

- Um documento obsoleto.

- Uma implementação obsoleta.

- Uma migração incompleta.

- Uma alteração arquitetural deliberada que ainda não tenha sido documentada.

- Uma divergência de implementação não intencional.

- Outra condição que exija revisão controlada.

O princípio da fonte da verdade, portanto, exige validação e investigação, e não preferência automática por qualquer artefato que tenha sido alterado mais recentemente.

As mudanças arquiteturais devem ser sincronizadas entre a implementação e a documentação afetada pela mudança.

---

### 8.6 Evolução Futura do Atlas Engineering

Espera-se que o Atlas Engineering evolua além da origem transacional AtlasCommerce atualmente implementada.

Fases futuras podem introduzir capacidades como:

- Ingestão de dados.

- *Staging* (preparação).

- Transformação de dados.

- Armazenamento analítico.

- Modelagem histórica.

- Orquestração de dados.

- Controles de qualidade de dados.

- Observabilidade.

- Consumo por *Business Intelligence* (Inteligência de Negócios).

- Sistemas de origem adicionais.

- Outras capacidades da plataforma de dados justificadas por requisitos futuros.

Suas tecnologias finais e padrões de implementação não são intencionalmente prescritos pela arquitetura atual do AtlasCommerce.

A seleção de tecnologias deve seguir os requisitos estabelecidos durante a fase de engenharia correspondente.

Os componentes futuros devem preservar o limite arquitetural que protege a responsabilidade transacional do AtlasCommerce, ao mesmo tempo em que permitem o consumo controlado de seus dados operacionais.

À medida que esses componentes forem implementados e validados, a documentação de arquitetura deverá evoluir da descrição da direção arquitetural para a descrição da arquitetura implementada resultante.

---

## Princípio Final

O AtlasCommerce é a base transacional da plataforma Atlas Engineering.

Sua arquitetura prioriza correção operacional, integridade relacional, responsabilidade explícita dos domínios, projeto físico controlado, *deployment* (implantação) previsível, validação independente e proteção da carga de trabalho transacional.

O banco de dados está organizado como um único sistema transacional relacional, com domínios lógicos explícitos e estruturas físicas aplicadas seletivamente quando os requisitos operacionais as justificam.

Seus dados podem ser consumidos por plataformas subsequentes de engenharia e análise, mas essas responsabilidades permanecem arquiteturalmente separadas da origem transacional.

O AtlasCommerce define a verdade operacional.

A Engenharia de Dados define como essa verdade operacional é consumida, processada, transformada, historizada e preparada com segurança para uso analítico.

As plataformas analíticas definem como as informações resultantes são organizadas e disponibilizadas para consumo analítico.

Essas responsabilidades podem evoluir de forma independente, mas seus limites e contratos devem permanecer explícitos.

A arquitetura descrita por este documento deve distinguir entre capacidades implementadas e validadas e a direção arquitetural futura explicitamente identificada.

À medida que o AtlasCommerce e o Atlas Engineering evoluírem, este documento deverá evoluir com eles para continuar descrevendo a arquitetura que a plataforma efetivamente implementa, os limites que atualmente impõe e a direção futura que foi intencionalmente estabelecida.