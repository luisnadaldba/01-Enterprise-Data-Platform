# Atlas Engineering — Plataforma Corporativa de Dados

## Visão Geral

O Atlas Engineering é um projeto completo de plataforma corporativa de dados, projetado e implementado desde sua base como um portfólio técnico de engenharia.

A plataforma acompanha a evolução dos dados desde sua origem operacional, passando pela engenharia de dados e pela modelagem analítica, até a inteligência de negócios, com ênfase em arquitetura, qualidade de dados, reprodutibilidade, manutenibilidade e documentação técnica.

A primeira grande camada da plataforma é o **AtlasCommerce**, um sistema transacional em SQL Server que representa a origem operacional dos dados de uma empresa de varejo de produtos de beleza.

O AtlasCommerce inclui um modelo de dados relacional completo, dados de exemplo determinísticos, *scripts* de implantação reexecutáveis, documentação de negócio e de banco de dados, regras de integridade entre domínios, validação temporal e certificação automatizada dos dados.

A camada de banco de dados transacional está concluída e fornece os dados de origem certificados para a próxima etapa da plataforma: **Engenharia de Dados**.

---

## Arquitetura da Plataforma

O Atlas Engineering foi projetado como uma plataforma de dados completa, na qual os dados operacionais são progressivamente transformados em informação analítica.

A plataforma segue a arquitetura abaixo:

```text
┌──────────────────────────────┐
│        AtlasCommerce         │
│                              │
│   SQL Server Operacional     │
│   Banco Transacional         │
│                              │
│          CONCLUÍDO           │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│     Engenharia de Dados      │
│                              │
│   Ingestão · Processamento   │
│   Transformação · Qualidade  │
│                              │
│        PRÓXIMA ETAPA         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│        Data Warehouse        │
│                              │
│    Modelo Analítico de Dados │
│                              │
│          PLANEJADO           │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Camada Analítica       │
│                              │
│           Power BI           │
│                              │
│          PLANEJADO           │
└──────────────────────────────┘
```

O banco de dados operacional fornece os dados de origem controlados para a plataforma. Cada camada subsequente será desenvolvida seguindo os mesmos princípios de reprodutibilidade, validação, documentação e rastreabilidade estabelecidos no AtlasCommerce.

---

## *Status* Atual do Projeto

| Camada da Plataforma | *Status* | Descrição |
|---|---|---|
| Banco de Dados Operacional — AtlasCommerce | **Concluído** | Sistema transacional de origem em SQL Server, implantação de dados de exemplo, validação e certificação |
| Engenharia de Dados | **Próxima Etapa** | Ingestão, transformação, processamento e *pipelines* de qualidade de dados |
| *Data Warehouse* | **Planejado** | Modelo analítico de dados e estruturas de dados históricos |
| *Analytics* — Power BI | **Planejado** | Modelos analíticos, *dashboards* e informações de negócio |

---

## AtlasCommerce

O **AtlasCommerce** é o banco de dados transacional operacional da plataforma Atlas Engineering.

Construído em SQL Server, ele modela as principais operações de uma empresa de varejo de produtos de beleza em oito domínios de negócio e de suporte:

| Domínio | Responsabilidade |
|---|---|
| `catalog` | marcas, categorias, produtos, variantes, atributos, imagens e preços |
| `customer` | clientes, documentos, contatos, endereços de *e-mail* e endereços de clientes |
| `inventory` | saldos de estoque, reservas, movimentações, motivos de movimentação e observações operacionais |
| `payment` | métodos de pagamento, ciclo de vida dos pagamentos, reembolsos e motivos de reembolso |
| `sales` | transações, itens de transação, canais e ciclo de vida das transações |
| `shipping` | métodos de envio, ciclo de vida das entregas, endereços de entrega e rastreamento |
| `reference` | países, divisões administrativas, cidades, endereços e dados de referência compartilhados |
| `metadata` | metadados internos e governança dos objetos do banco de dados |

### Engenharia de Banco de Dados

A camada de banco de dados do AtlasCommerce foi projetada em torno de uma implantação determinística e reprodutível, em vez de um processo de criação executado apenas uma vez.

Sua implementação inclui:

- implantação reexecutável do banco de dados, esquemas, modelo de dados e dados de exemplo;
- criação controlada de objetos e validação estrutural;
- prefixos padronizados de tabelas e colunas;
- restrições de chave primária, chave estrangeira, unicidade, verificação e valores padrão;
- validação explícita de integridade referencial e dependências;
- projeto físico preparado para particionamento;
- índices e posicionamento físico padronizados;
- regras de integridade temporal;
- validação de regras de negócio entre os domínios do banco de dados;
- geração determinística dos dados de exemplo;
- reconciliação entre os domínios financeiro, estoque, vendas e entregas;
- certificação final automatizada dos dados.

### Conjunto de Dados de Exemplo

O conjunto de dados certificado atual contém atividade transacional entre **1º de janeiro de 2025 e 24 de agosto de 2026**, dentro de um limite temporal fixo utilizado para implantação e validação determinísticas dos dados de exemplo.

| Conjunto de Dados | Registros |
|---|---:|
| Transações | 6.306 |
| Itens de Transação | 13.769 |
| Reservas de Estoque | 4.116 |
| Movimentações de Estoque | 12.796 |
| Pagamentos | 6.959 |
| Reembolsos de Pagamentos | 272 |
| Entregas | 2.841 |

O conjunto de dados contém transações **STORE** e **ONLINE**, múltiplos estados de transação e pagamento, reservas e movimentações de estoque, reembolsos, ciclos de vida de entrega, devoluções de clientes e outros cenários operacionais destinados a fornecer dados de origem significativos para as etapas posteriores de engenharia e análise de dados.

### Certificação dos Dados

O AtlasCommerce inclui um processo automatizado de certificação executado após a implantação dos dados de exemplo.

A certificação valida a integridade referencial, regras de negócio específicas de cada domínio, consistência temporal e reconciliação em todo o modelo operacional.

```text
ATLASCOMMERCE DATA CERTIFICATION — PASS

Referential Integrity       : PASS
Sales Integrity             : PASS
Inventory Integrity         : PASS
Payment Integrity           : PASS
Shipping Integrity          : PASS
Temporal Integrity          : PASS
Cross-Domain Reconciliation : PASS
```

O conjunto de dados certificado do AtlasCommerce está, portanto, pronto para atuar como origem operacional da camada de Engenharia de Dados.

---

## Destaques de Engenharia

O AtlasCommerce foi desenvolvido como um projeto de engenharia de banco de dados, e não apenas como uma fonte de registros de exemplo.

A implementação enfatiza implantação controlada, consistência estrutural, integridade dos dados e reprodutibilidade durante todo o ciclo de vida do banco de dados.

### Implantação Reexecutável

Os *scripts* de implantação do banco de dados oferecem suporte tanto à instalação limpa quanto à reexecução segura, validando e preservando estruturas e dados existentes compatíveis em vez de depender de recriação destrutiva.

### Padrões de Banco de Dados

O AtlasCommerce segue padrões documentados para:

- esquemas, tabelas e colunas;
- prefixos de tabelas e colunas;
- chaves primárias e estrangeiras;
- restrições e índices;
- ordenação e dependências de objetos;
- posicionamento físico;
- documentação;
- implantação determinística dos dados.

Essas convenções são documentadas como parte do projeto e aplicadas de maneira consistente em toda a implementação do banco de dados.

### Integridade por Projeto

A integridade é validada em múltiplos níveis, em vez de depender exclusivamente de chaves estrangeiras.

O banco de dados valida:

- integridade referencial;
- regras de negócio;
- reconciliação monetária entre transações e itens de transação;
- reservas de estoque e saldos de estoque;
- saldos das movimentações de estoque;
- pagamentos e reembolsos;
- relacionamentos entre transações e entregas;
- consistência temporal entre eventos operacionais relacionados.

### Dados de Exemplo Determinísticos

O conjunto de dados de exemplo é gerado por meio de *scripts* controlados de implantação DML e utiliza um limite temporal fixo.

Isso torna o conjunto de dados reprodutível e permite que as mesmas validações de negócio, financeiras, de estoque, de entrega e temporais sejam executadas de maneira consistente entre diferentes implantações.

### Certificação Antes do Consumo

A implantação e a certificação dos dados de exemplo são etapas separadas, e o conjunto de dados somente é liberado para processamento posterior depois que o estado resultante do banco de dados é aprovado nas validações obrigatórias de integridade e reconciliação.

---

## Estrutura do Repositório

O repositório é organizado por responsabilidade dentro da plataforma, separando recursos dos sistemas de origem, estruturas de banco de dados, documentação, *scripts* de implantação e recursos de validação.

```text
01-Enterprise-Data-Platform/
│
├── 01-Source/
│   └── Recursos dos sistemas operacionais de origem
│
├── 02-Database/
│   └── Estruturas e recursos relacionados ao banco de dados
│
├── 03-Documentation/
│   └── Documentação técnica, arquitetural e de negócio
│
├── 04-Scripts/
│   └── Scripts de banco de dados, implantação de dados e certificação
│
├── 05-Tests/
│   └── Recursos de validação e testes
│
├── .gitignore
│
└── README.md
```

### Principais Áreas

**`01-Source`**  
Contém recursos relacionados aos sistemas operacionais de origem que fornecem dados para a plataforma.

**`02-Database`**  
Contém estruturas e recursos relacionados aos bancos de dados utilizados pela plataforma. Arquivos locais de dados e de log do SQL Server são excluídos do controle de versão.

**`03-Documentation`**  
Contém a documentação técnica, arquitetural e de negócio da plataforma, incluindo padrões de banco de dados do AtlasCommerce, definições de domínio, regras de negócio e documentação do modelo de dados.

**`04-Scripts`**  
Contém a estrutura executável de implantação da plataforma, incluindo criação do banco de dados SQL Server, implantação de esquemas, implantação do modelo de dados, implantação determinística dos dados de exemplo e certificação dos dados.

**`05-Tests`**  
Contém recursos de validação e testes utilizados para verificar os componentes da plataforma e o comportamento dos dados.

A estrutura do repositório evoluirá à medida que novos componentes de Engenharia de Dados, *Data Warehouse* e *Analytics* forem introduzidos.

---

## Documentação

A documentação é tratada como parte da entrega de engenharia, e não como um artefato separado ou opcional do projeto.

O AtlasCommerce mantém documentação técnica e de negócio em **inglês** e **português brasileiro (PT-BR)**, quando aplicável.

### Documentação do AtlasCommerce

A documentação atual abrange:

- **Arquitetura** — decisões arquiteturais, organização do banco de dados, limites dos domínios e princípios de projeto;
- **Documentação de Negócio** — conceitos operacionais, regras de negócio, ciclo de vida das transações, estoque, pagamentos e comportamento das entregas;
- **Padrões de Banco de Dados** — esquemas, convenções de nomenclatura, prefixos, chaves, restrições, índices, posicionamento físico, comportamento de implantação e regras para dados determinísticos;
- **Modelo de Domínio** — representação das entidades operacionais e seus relacionamentos;
- **Dicionário de Dados** — objetos documentados do banco de dados, colunas, relacionamentos e definições técnicas;
- **Diagrama Entidade-Relacionamento (ERD)** — representação visual do modelo de dados relacional do AtlasCommerce.

A documentação é mantida juntamente com a implementação para que decisões arquiteturais, regras de negócio e comportamento do banco de dados permaneçam rastreáveis até a solução implantada.

### Princípios de Documentação

A documentação do Atlas Engineering segue os mesmos princípios aplicados à implementação:

- precisão técnica;
- terminologia consistente;
- decisões arquiteturais e de negócio explícitas;
- separação entre conceitos de negócio e implementação física do banco de dados;
- documentação bilíngue quando apropriado;
- evolução controlada por versão juntamente com o projeto.

---

## *Stack* de Tecnologias

O Atlas Engineering combina tecnologias de banco de dados, engenharia de dados, análise, desenvolvimento e infraestrutura à medida que a plataforma evolui.

### *Stack* Atual

As tecnologias atualmente utilizadas na plataforma implementada incluem:

| Tecnologia | Função |
|---|---|
| **SQL Server** | Banco de dados relacional operacional do AtlasCommerce |
| **T-SQL** | Implantação do banco de dados, validação, geração de dados de exemplo e certificação |
| **SQL Server Management Studio (SSMS)** | Desenvolvimento, administração, execução e validação do banco de dados |
| **Git** | Controle de versão e histórico do projeto |
| **GitHub** | Hospedagem do repositório e publicação do projeto |
| **Visual Studio Code** | Edição do repositório, documentação e arquivos de código-fonte |
| **Markdown** | Documentação técnica e de negócio controlada por versão |
| **Schemity Lite** | Projeto e visualização do diagrama entidade-relacionamento |

### Tecnologias em Avaliação

À medida que a plataforma evoluir, tecnologias adicionais poderão ser avaliadas de acordo com os requisitos arquiteturais e de engenharia de cada etapa subsequente.

As tecnologias potenciais incluem:

- **Python** para engenharia de dados e automação;
- **PostgreSQL** para cenários adicionais de banco de dados e plataforma de dados;
- **Docker** para ambientes reprodutíveis de desenvolvimento e serviços;
- **APIs REST** como fontes externas de dados e cenários de integração;
- **plataformas de nuvem** para infraestrutura e serviços gerenciados de dados;
- **Power BI** para modelagem analítica, visualização e inteligência de negócios.

As escolhas tecnológicas para as camadas de Engenharia de Dados e *Data Warehouse* serão feitas à medida que suas arquiteturas forem projetadas, em vez de serem tratadas antecipadamente como decisões fixas de implementação.

---

## *Roadmap*

O Atlas Engineering é desenvolvido de forma incremental, com cada camada da plataforma tornando-se a base validada para a etapa seguinte.

| Etapa | *Status* | Escopo |
|---|---|---|
| **1. Banco de Dados Operacional — AtlasCommerce** | **Concluído** | Arquitetura transacional, modelo de dados, implantação, dados de exemplo determinísticos, validação, documentação e certificação |
| **2. Engenharia de Dados** | **Próxima Etapa** | Ingestão de dados de origem, processamento, transformação, controles de qualidade e orquestração de *pipelines* |
| **3. Data Warehouse** | **Planejado** | Arquitetura analítica, modelagem dimensional, estruturas de dados históricos e preparação de dados analíticos |
| **4. Analytics — Power BI** | **Planejado** | Modelagem semântica, métricas de negócio, *dashboards* e visualização analítica |

O *roadmap* define intencionalmente as etapas arquiteturais sem fixar detalhes de implementação antes que seus requisitos técnicos sejam avaliados.

---

## Reprodutibilidade

A reprodutibilidade é um princípio central de engenharia do AtlasCommerce.

O banco de dados é implantado por meio de um conjunto ordenado de *scripts* SQL Server que separa a criação da infraestrutura, a estrutura lógica, a implantação do modelo de dados, a implantação dos dados de exemplo e a certificação final dos dados.

### Fluxo de Implantação

```text
01 — Banco de Dados
     │
     ▼
02 — Esquemas
     │
     ▼
03 — Modelo de Dados
     │
     ▼
04 — Dados de Exemplo
     │
     ▼
05 — Certificação dos Dados
     │
     ▼
Origem Operacional Certificada
```

A sequência principal de implantação é:

| Etapa | *Script* | Responsabilidade |
|---|---|---|
| **1** | `01-Create-AtlasCommerce-Database.sql` | Cria e valida o banco de dados AtlasCommerce e sua configuração física no nível do banco de dados |
| **2** | `02-Create-AtlasCommerce-Schema.sql` | Cria e valida os esquemas necessários do banco de dados |
| **3** | `03-Deploy-AtlasCommerce-Data-Model.sql` | Implanta e valida o modelo de dados relacional e os objetos de banco de dados de suporte |
| **4** | `04-Deploy-AtlasCommerce-Data.sql` | Implanta o conjunto determinístico de dados de exemplo do AtlasCommerce |
| **5** | `05-Certify-AtlasCommerce-Data.sql` | Valida de forma independente o conjunto de dados resultante e o certifica para uso posterior |

### Comportamento Seguro para Reexecução

O processo de implantação foi projetado para permitir reexecução segura.

Os *scripts* inspecionam o estado existente do banco de dados antes de criar ou inserir as estruturas e os dados esperados. Objetos e registros existentes compatíveis são preservados, enquanto inconsistências estruturais ou de dados são apresentadas por meio de validações explícitas em vez de serem sobrescritas silenciosamente.

Esse comportamento permite que a mesma estrutura de implantação ofereça suporte tanto a uma instalação limpa do banco de dados quanto a execuções posteriores de validação.

### Certificação Final

O ciclo de vida da implantação dos dados de exemplo somente é considerado concluído depois que a etapa de certificação retorna:

```text
ATLASCOMMERCE DATA CERTIFICATION — PASS
```

Uma certificação bem-sucedida confirma que o conjunto de dados de exemplo implantado satisfaz as regras esperadas de integridade referencial, de negócio, financeira, de estoque, de entrega e temporal exigidas antes do consumo pelas etapas posteriores.

Isso cria uma fronteira reprodutível entre o banco de dados operacional e a próxima camada da plataforma: Engenharia de Dados.

---

## Propósito do Projeto

O Atlas Engineering é um portfólio técnico de longo prazo focado no projeto e na implementação de uma plataforma corporativa de dados, desde sua origem operacional até sua camada de consumo analítico.

O projeto tem como objetivo demonstrar decisões de engenharia por meio de implementações funcionais, em vez de exemplos isolados ou exercícios tecnológicos desconectados.

Seu desenvolvimento enfatiza:

- arquitetura de bancos de dados e de dados;
- implantação confiável e reprodutível;
- integridade e qualidade dos dados;
- documentação técnica e de negócio;
- rastreabilidade das decisões arquiteturais;
- controle de versão e práticas de engenharia de software;
- engenharia de dados e modelagem analítica;
- integração progressiva de tecnologias de acordo com os requisitos arquiteturais.

Cada etapa da plataforma é projetada, implementada, validada e documentada antes de se tornar a base para a etapa seguinte.

À medida que a plataforma evoluir, este repositório preservará tanto a solução implementada quanto as decisões de engenharia que a moldaram.