# AtlasCommerce — Modelo de Domínio

## Índice

- [1. Propósito](#1-propósito)

- [2. Escopo do Modelo de Domínio e Fonte da Verdade](#2-escopo-do-modelo-de-domínio-e-fonte-da-verdade)
  - [2.1 Escopo do Modelo](#21-escopo-do-modelo)
  - [2.2 Modelo Implementado](#22-modelo-implementado)
  - [2.3 Representação Conceitual e Física](#23-representação-conceitual-e-física)
  - [2.4 Fonte da Verdade](#24-fonte-da-verdade)
  - [2.5 Reconciliação do Modelo](#25-reconciliação-do-modelo)
  - [2.6 Propriedade do Domínio](#26-propriedade-do-domínio)
  - [2.7 Extensões Futuras do Domínio](#27-extensões-futuras-do-domínio)

- [3. Visão Geral dos Domínios](#3-visão-geral-dos-domínios)
  - [3.1 Domínio de Metadados](#31-domínio-de-metadados)
  - [3.2 Domínio de Catálogo](#32-domínio-de-catálogo)
  - [3.3 Domínio de Cliente](#33-domínio-de-cliente)
  - [3.4 Domínio de Estoque](#34-domínio-de-estoque)
  - [3.5 Domínio de Pagamento](#35-domínio-de-pagamento)
  - [3.6 Domínio de Referência](#36-domínio-de-referência)
  - [3.7 Domínio de Vendas](#37-domínio-de-vendas)
  - [3.8 Domínio de Entrega](#38-domínio-de-entrega)
  - [3.9 Propriedade dos Domínios](#39-propriedade-dos-domínios)
  - [3.10 Modelo entre Domínios](#310-modelo-entre-domínios)
  - [3.11 A Interação entre Domínios Não Implica Participação Universal](#311-a-interação-entre-domínios-não-implica-participação-universal)
  - [3.12 Princípio do Modelo de Domínio](#312-princípio-do-modelo-de-domínio)

- [4. Domínio de Metadados](#4-domínio-de-metadados)
  - [4.1 TablePrefix](#41-tableprefix)
  - [4.2 Atribuição de Prefixos](#42-atribuição-de-prefixos)
  - [4.3 Identidade de Schema e Tabela](#43-identidade-de-schema-e-tabela)
  - [4.4 Ciclo de Vida dos Prefixos](#44-ciclo-de-vida-dos-prefixos)
  - [4.5 Imutabilidade dos Prefixos](#45-imutabilidade-dos-prefixos)
  - [4.6 Responsabilidade de Governança](#46-responsabilidade-de-governança)
  - [4.7 Limite do Domínio](#47-limite-do-domínio)
  - [4.8 Princípio do Domínio de Metadados](#48-princípio-do-domínio-de-metadados)

- [5. Domínio de Catálogo](#5-domínio-de-catálogo)
  - [5.1 Marca](#51-marca)
  - [5.2 Categoria](#52-categoria)
  - [5.3 Produto](#53-produto)
  - [5.4 Categoria do Produto](#54-categoria-do-produto)
  - [5.5 Imagem do Produto](#55-imagem-do-produto)
  - [5.6 Variante do Produto](#56-variante-do-produto)
  - [5.7 Atributo do Produto](#57-atributo-do-produto)
  - [5.8 Valor do Atributo do Produto](#58-valor-do-atributo-do-produto)
  - [5.9 Valor do Atributo da Variante do Produto](#59-valor-do-atributo-da-variante-do-produto)
  - [5.10 Preço da Variante do Produto](#510-preço-da-variante-do-produto)
  - [5.11 Limite entre Product e ProductVariant](#511-limite-entre-product-e-productvariant)
  - [5.12 Limite de Propriedade do Catálogo](#512-limite-de-propriedade-do-catálogo)
  - [5.13 Uso entre Domínios](#513-uso-entre-domínios)
  - [5.14 Princípio do Domínio de Catálogo](#514-princípio-do-domínio-de-catálogo)

- [6. Domínio de Cliente](#6-domínio-de-cliente)
  - [6.1 CustomerType](#61-customertype)
  - [6.2 Customer](#62-customer)
  - [6.3 CustomerDocument](#63-customerdocument)
  - [6.4 CustomerDocumentType](#64-customerdocumenttype)
  - [6.5 CustomerContact](#65-customercontact)
  - [6.6 CustomerEmail](#66-customeremail)
  - [6.7 CustomerAddress](#67-customeraddress)
  - [6.8 Limite entre Customer e Reference](#68-limite-entre-customer-e-reference)
  - [6.9 Responsabilidades de Contato e E-mail](#69-responsabilidades-de-contato-e-e-mail)
  - [6.10 Customer e Sales](#610-customer-e-sales)
  - [6.11 Customer e Shipping](#611-customer-e-shipping)
  - [6.12 Ciclo de Vida dos Relacionamentos do Customer](#612-ciclo-de-vida-dos-relacionamentos-do-customer)
  - [6.13 Preservação dos Dados do Customer](#613-preservação-dos-dados-do-customer)
  - [6.14 Princípio do Domínio de Cliente](#614-princípio-do-domínio-de-cliente)

- [7. Domínio de Estoque](#7-domínio-de-estoque)
  - [7.1 Inventory](#71-inventory)
  - [7.2 Identidade do Inventory](#72-identidade-do-inventory)
  - [7.3 Estado Atual e Histórico de Movimentações](#73-estado-atual-e-histórico-de-movimentações)
  - [7.4 InventoryMovementReason](#74-inventorymovementreason)
  - [7.5 InventoryMovement](#75-inventorymovement)
  - [7.6 Semântica da Quantidade de Movimentação](#76-semântica-da-quantidade-de-movimentação)
  - [7.7 InventoryMovement e Sales](#77-inventorymovement-e-sales)
  - [7.8 InventoryMovementNote](#78-inventorymovementnote)
  - [7.9 InventoryReservation](#79-inventoryreservation)
  - [7.10 InventoryReservationStatus](#710-inventoryreservationstatus)
  - [7.11 Limite Temporal da Reserva](#711-limite-temporal-da-reserva)
  - [7.12 Reserva e Estoque Físico](#712-reserva-e-estoque-físico)
  - [7.13 Reserva e TransactionItem](#713-reserva-e-transactionitem)
  - [7.14 Reserva e ProductVariant](#714-reserva-e-productvariant)
  - [7.15 Consistência do Estoque](#715-consistência-do-estoque)
  - [7.16 Preservação do Histórico de Estoque](#716-preservação-do-histórico-de-estoque)
  - [7.17 Limites do Domínio de Estoque](#717-limites-do-domínio-de-estoque)
  - [7.18 Princípio do Domínio de Estoque](#718-princípio-do-domínio-de-estoque)

- [8. Domínio de Pagamento](#8-domínio-de-pagamento)
  - [8.1 Payment](#81-payment)
  - [8.2 Payment e Transaction](#82-payment-e-transaction)
  - [8.3 PaymentMethod](#83-paymentmethod)
  - [8.4 PaymentStatus](#84-paymentstatus)
  - [8.5 Valor do Payment](#85-valor-do-payment)
  - [8.6 Múltiplos Payments](#86-múltiplos-payments)
  - [8.7 Informações de Parcelamento](#87-informações-de-parcelamento)
  - [8.8 Estado Temporal do Payment](#88-estado-temporal-do-payment)
  - [8.9 Aprovação do Payment](#89-aprovação-do-payment)
  - [8.10 Cancelamento e Recusa do Payment](#810-cancelamento-e-recusa-do-payment)
  - [8.11 PaymentRefund](#811-paymentrefund)
  - [8.12 Múltiplos Reembolsos](#812-múltiplos-reembolsos)
  - [8.13 PaymentRefundReason](#813-paymentrefundreason)
  - [8.14 Reembolso e Outros Domínios](#814-reembolso-e-outros-domínios)
  - [8.15 Payment e Inventory](#815-payment-e-inventory)
  - [8.16 Payment e Shipping](#816-payment-e-shipping)
  - [8.17 Preservação do Histórico Financeiro](#817-preservação-do-histórico-financeiro)
  - [8.18 Limites do Domínio de Pagamento](#818-limites-do-domínio-de-pagamento)
  - [8.19 Princípio do Domínio de Pagamento](#819-princípio-do-domínio-de-pagamento)

- [9. Domínio de Referência](#9-domínio-de-referência)
  - [9.1 Modelo de Referência Geográfica](#91-modelo-de-referência-geográfica)
  - [9.2 Country](#92-country)
  - [9.3 AdministrativeDivision](#93-administrativedivision)
  - [9.4 City](#94-city)
  - [9.5 Address](#95-address)
  - [9.6 ContactType](#96-contacttype)
  - [9.7 Propriedade de Referência Compartilhada](#97-propriedade-de-referência-compartilhada)
  - [9.8 Dados de Referência e Dados Controlados pelo Domínio](#98-dados-de-referência-e-dados-controlados-pelo-domínio)
  - [9.9 Dados de Referência e Ciclo de Vida](#99-dados-de-referência-e-ciclo-de-vida)
  - [9.10 Capacidade Geográfica vs. Escopo Comercial](#910-capacidade-geográfica-vs-escopo-comercial)
  - [9.11 Princípio do Domínio de Referência](#911-princípio-do-domínio-de-referência)

- [10. Domínio de Vendas](#10-domínio-de-vendas)
  - [10.1 Transaction](#101-transaction)
  - [10.2 Identidade da Transaction](#102-identidade-da-transaction)
  - [10.3 TransactionChannel](#103-transactionchannel)
  - [10.4 Transações Online e em Loja](#104-transações-online-e-em-loja)
  - [10.5 TransactionStatus](#105-transactionstatus)
  - [10.6 Ciclo de Vida Comercial](#106-ciclo-de-vida-comercial)
  - [10.7 TransactionItem](#107-transactionitem)
  - [10.8 Identidade do TransactionItem](#108-identidade-do-transactionitem)
  - [10.9 Precificação do TransactionItem](#109-precificação-do-transactionitem)
  - [10.10 Preço Histórico de Venda](#1010-preço-histórico-de-venda)
  - [10.11 Unit Discount](#1011-unit-discount)
  - [10.12 Imutabilidade do TransactionItem](#1012-imutabilidade-do-transactionitem)
  - [10.13 Vendas e Customer](#1013-vendas-e-customer)
  - [10.14 Vendas e Catálogo](#1014-vendas-e-catálogo)
  - [10.15 Vendas e Estoque](#1015-vendas-e-estoque)
  - [10.16 Vendas e Pagamento](#1016-vendas-e-pagamento)
  - [10.17 Vendas e Shipping](#1017-vendas-e-shipping)
  - [10.18 Estado Comercial e Estado Operacional](#1018-estado-comercial-e-estado-operacional)
  - [10.19 Arquitetura Particionada de Vendas](#1019-arquitetura-particionada-de-vendas)
  - [10.20 Consistência do Momento da Transaction](#1020-consistência-do-momento-da-transaction)
  - [10.21 Preservação do Histórico de Vendas](#1021-preservação-do-histórico-de-vendas)
  - [10.22 Limites do Domínio de Vendas](#1022-limites-do-domínio-de-vendas)
  - [10.23 Princípio do Domínio de Vendas](#1023-princípio-do-domínio-de-vendas)

- [11. Domínio de Entregas](#11-domínio-de-entregas)
  - [11.1 Shipment](#111-shipment)
  - [11.2 Transactions sem Shipment](#112-transactions-sem-shipment)
  - [11.3 Shipment e Identidade da Transaction](#113-shipment-e-identidade-da-transaction)
  - [11.4 Uma Transaction, Uma Entrega](#114-uma-transaction-uma-entrega)
  - [11.5 Endereço de Entrega](#115-endereço-de-entrega)
  - [11.6 ShipmentMethod](#116-shipmentmethod)
  - [11.7 ShipmentStatus](#117-shipmentstatus)
  - [11.8 Ciclo de Vida do Shipment](#118-ciclo-de-vida-do-shipment)
  - [11.9 Valor do Envio](#119-valor-do-envio)
  - [11.10 Previsão de Entrega](#1110-previsão-de-entrega)
  - [11.11 Código de Rastreamento](#1111-código-de-rastreamento)
  - [11.12 Timestamps do Shipment](#1112-timestamps-do-shipment)
  - [11.13 Shipping e Customer](#1113-shipping-e-customer)
  - [11.14 Shipping e Sales](#1114-shipping-e-sales)
  - [11.15 Shipping e Inventory](#1115-shipping-e-inventory)
  - [11.16 Shipping e Payment](#1116-shipping-e-payment)
  - [11.17 Entrega e Conclusão Comercial](#1117-entrega-e-conclusão-comercial)
  - [11.18 Shipments Retornados](#1118-shipments-retornados)
  - [11.19 Shipments Cancelados](#1119-shipments-cancelados)
  - [11.20 Preservação do Histórico de Entrega](#1120-preservação-do-histórico-de-entrega)
  - [11.21 Integridade de Shipping](#1121-integridade-de-shipping)
  - [11.22 Limites do Domínio de Shipping](#1122-limites-do-domínio-de-shipping)
  - [11.23 Princípio do Domínio de Shipping](#1123-princípio-do-domínio-de-shipping)

- [12. Relacionamentos entre Domínios](#12-relacionamentos-entre-domínios)
  - [12.1 Propriedade e Consumo](#121-propriedade-e-consumo)
  - [12.2 Customer e Sales](#122-customer-e-sales)
  - [12.3 Catalog e Sales](#123-catalog-e-sales)
  - [12.4 Catalog e Inventory](#124-catalog-e-inventory)
  - [12.5 Sales e Inventory](#125-sales-e-inventory)
  - [12.6 Sales e Payment](#126-sales-e-payment)
  - [12.7 Sales e Shipping](#127-sales-e-shipping)
  - [12.8 Customer e Shipping](#128-customer-e-shipping)
  - [12.9 Reference e Customer](#129-reference-e-customer)
  - [12.10 Reference e Outros Domínios](#1210-reference-e-outros-domínios)
  - [12.11 Relacionamentos entre Domínios Compatíveis com Particionamento](#1211-relacionamentos-entre-domínios-compatíveis-com-particionamento)
  - [12.12 Integridade Referencial entre Domínios](#1212-integridade-referencial-entre-domínios)
  - [12.13 Independência de Ciclo de Vida entre Domínios](#1213-independência-de-ciclo-de-vida-entre-domínios)
  - [12.14 Preservação Histórica entre Domínios](#1214-preservação-histórica-entre-domínios)
  - [12.15 Consequências de Eventos entre Domínios](#1215-consequências-de-eventos-entre-domínios)
  - [12.16 Sem Duplicação de Autoridade entre Domínios](#1216-sem-duplicação-de-autoridade-entre-domínios)
  - [12.17 Propriedade do Relacionamento](#1217-propriedade-do-relacionamento)
  - [12.18 Coordenação de Alterações entre Domínios](#1218-coordenação-de-alterações-entre-domínios)
  - [12.19 Resumo dos Relacionamentos entre Domínios](#1219-resumo-dos-relacionamentos-entre-domínios)
  - [12.20 Princípio dos Relacionamentos entre Domínios](#1220-princípio-dos-relacionamentos-entre-domínios)

- [13. Princípios Históricos e de Ciclo de Vida](#13-princípios-históricos-e-de-ciclo-de-vida)
  - [13.1 Estado Atual e Fatos Históricos](#131-estado-atual-e-fatos-históricos)
  - [13.2 Preservação da Transaction Comercial](#132-preservação-da-transaction-comercial)
  - [13.3 Histórico de Preços do Catálogo](#133-histórico-de-preços-do-catálogo)
  - [13.4 Ciclo de Vida das Mídias do Catálogo](#134-ciclo-de-vida-das-mídias-do-catálogo)
  - [13.5 Ciclo de Vida dos Relacionamentos do Customer](#135-ciclo-de-vida-dos-relacionamentos-do-customer)
  - [13.6 Significado Histórico do Endereço](#136-significado-histórico-do-endereço)
  - [13.7 Estado Atual e Histórico de Movimentações de Estoque](#137-estado-atual-e-histórico-de-movimentações-de-estoque)
  - [13.8 Ciclo de Vida de InventoryReservation](#138-ciclo-de-vida-de-inventoryreservation)
  - [13.9 Histórico de Payment e Correções Financeiras](#139-histórico-de-payment-e-correções-financeiras)
  - [13.10 Ciclo de Vida de Shipment](#1310-ciclo-de-vida-de-shipment)
  - [13.11 Ciclos de Vida Independentes entre Domínios](#1311-ciclos-de-vida-independentes-entre-domínios)
  - [13.12 Valores Controlados e Significado do Ciclo de Vida](#1312-valores-controlados-e-significado-do-ciclo-de-vida)
  - [13.13 Dados Temporais Não Significam Automaticamente Histórico](#1313-dados-temporais-não-significam-automaticamente-histórico)
  - [13.14 Metadados de Auditoria e Histórico de Negócio](#1314-metadados-de-auditoria-e-histórico-de-negócio)
  - [13.15 Preservação Histórica e Integridade Referencial](#1315-preservação-histórica-e-integridade-referencial)
  - [13.16 Correções e Fatos Compensatórios](#1316-correções-e-fatos-compensatórios)
  - [13.17 Exclusão e Responsabilidade Histórica](#1317-exclusão-e-responsabilidade-histórica)
  - [13.18 Histórico Operacional vs. Histórico Analítico](#1318-histórico-operacional-vs-histórico-analítico)
  - [13.19 Alterações de Ciclo de Vida entre Domínios](#1319-alterações-de-ciclo-de-vida-entre-domínios)
  - [13.20 Princípio Histórico e de Ciclo de Vida](#1320-princípio-histórico-e-de-ciclo-de-vida)

- [14. Modelo Implementado vs. Extensões Futuras](#14-modelo-implementado-vs-extensões-futuras)
  - [14.1 Modelo Implementado](#141-modelo-implementado)
  - [14.2 Capacidades Implementadas de Catalog](#142-capacidades-implementadas-de-catalog)
  - [14.3 Capacidades Implementadas de Customer](#143-capacidades-implementadas-de-customer)
  - [14.4 Capacidades Implementadas de Reference](#144-capacidades-implementadas-de-reference)
  - [14.5 Capacidades Implementadas de Sales](#145-capacidades-implementadas-de-sales)
  - [14.6 Capacidades Implementadas de Inventory](#146-capacidades-implementadas-de-inventory)
  - [14.7 Capacidades Implementadas de Payment](#147-capacidades-implementadas-de-payment)
  - [14.8 Capacidades Implementadas de Shipping](#148-capacidades-implementadas-de-shipping)
  - [14.9 Conceitos Removidos do Modelo Atual](#149-conceitos-removidos-do-modelo-atual)
  - [14.10 Extensões Futuras São Orientadas por Requisitos](#1410-extensões-futuras-são-orientadas-por-requisitos)
  - [14.11 Warehouse e Estoque em Múltiplas Localizações no Futuro](#1411-warehouse-e-estoque-em-múltiplas-localizações-no-futuro)
  - [14.12 Complexidade Futura de Fulfillment](#1412-complexidade-futura-de-fulfillment)
  - [14.13 Internacionalização Futura](#1413-internacionalização-futura)
  - [14.14 Requisitos Analíticos Futuros](#1414-requisitos-analíticos-futuros)
  - [14.15 Capacidades Futuras de Extração e Integração](#1415-capacidades-futuras-de-extração-e-integração)
  - [14.16 Evolução das Capacidades Implementadas](#1416-evolução-das-capacidades-implementadas)
  - [14.17 Princípio de Simplificação do Modelo](#1417-princípio-de-simplificação-do-modelo)
  - [14.18 Compatibilidade com Evolução Futura](#1418-compatibilidade-com-evolução-futura)
  - [14.19 Evolução da Documentação](#1419-evolução-da-documentação)
  - [14.20 Princípio do Modelo Implementado vs. Extensões Futuras](#1420-princípio-do-modelo-implementado-vs-extensões-futuras)

- [Princípio de Encerramento](#princípio-de-encerramento)

---

## 1. Propósito

Este documento define o modelo lógico de domínio do AtlasCommerce.

Seu propósito é descrever as entidades persistentes que compõem o modelo transacional do AtlasCommerce, as responsabilidades atribuídas a essas entidades e os relacionamentos que conectam os domínios de negócio e técnicos do banco de dados.

O *Domain Model* (Modelo de Domínio) concentra-se no significado e na estrutura dos dados persistidos.

Ele descreve:

- As principais entidades implementadas em cada domínio do AtlasCommerce.

- A responsabilidade semântica de cada entidade.

- Os relacionamentos entre entidades dentro do mesmo domínio.

- Os relacionamentos entre domínios exigidos pelo modelo transacional.

- As responsabilidades de ciclo de vida e preservação histórica que afetam o significado das entidades.

- A distinção entre entidades de estado atual e entidades históricas ou orientadas a eventos.

- Os limites entre as estruturas de domínio implementadas e extensões futuras.

Este documento não define:

- Regras de negócio detalhadas que pertencem à *AtlasCommerce Business Documentation* (Documentação de Negócio do AtlasCommerce).

- Convenções de nomenclatura, prefixos, *constraints* (restrições), *indexes* (índices), ordenação, *deployment* (implantação) ou validação de banco de dados, regidas pelos *AtlasCommerce Database Standards* (Padrões de Banco de Dados do AtlasCommerce).

- Armazenamento físico, particionamento, limites transacionais de *deployment* (implantação) ou arquitetura de extração, regidos pela *AtlasCommerce Architecture* (Arquitetura do AtlasCommerce).

- Implementação detalhada de *deployment* (implantação) contida nos *scripts* SQL do AtlasCommerce.

O *Domain Model* (Modelo de Domínio) deve permanecer sincronizado com a implementação validada do banco de dados AtlasCommerce.

Quando uma premissa de domínio anterior entrar em conflito com o modelo implementado consolidado, a divergência deve ser investigada.

Se for confirmado que o banco de dados implementado representa o modelo atual pretendido, o *Domain Model* (Modelo de Domínio) deve ser atualizado para descrever essa implementação, em vez de preservar uma estrutura conceitual obsoleta.

O objetivo deste documento, portanto, não é preservar a primeira versão conceitual do AtlasCommerce.

Seu objetivo é descrever o modelo de domínio persistente que o AtlasCommerce efetivamente implementa e valida.

---

## 2. Escopo do Modelo de Domínio e Fonte da Verdade

O *Domain Model* (Modelo de Domínio) do AtlasCommerce descreve a estrutura lógica persistente implementada pelo banco de dados transacional.

Seu escopo é limitado às entidades, aos relacionamentos e às responsabilidades persistentes que fazem parte do modelo de dados validado do AtlasCommerce.

O modelo é organizado de acordo com os domínios do banco de dados representados pelos seguintes *schemas* (esquemas):

- `metadata`

- `catalog`

- `customer`

- `inventory`

- `payment`

- `reference`

- `sales`

- `shipping`

Esses *schemas* (esquemas) estabelecem limites lógicos de responsabilidade dentro de um único banco de dados transacional.

O *Domain Model* (Modelo de Domínio) pode descrever relacionamentos que atravessam os limites entre *schemas* (esquemas) quando esses relacionamentos são exigidos pelo modelo operacional persistente.

O limite de um *schema* (esquema) não implica um banco de dados independente, um sistema transacional isolado ou a proibição de relacionamentos entre domínios.

---

### 2.1 Escopo do Modelo

O *Domain Model* (Modelo de Domínio) descreve as estruturas persistentes de acordo com sua responsabilidade semântica.

Para cada domínio aplicável, o modelo identifica:

- Entidades persistentes implementadas.

- A responsabilidade principal de cada entidade.

- Relacionamentos entre entidades.

- Cardinalidade quando relevante para a compreensão do modelo.

- Entidades de domínio controlado utilizadas para representar classificações persistentes ou estados de ciclo de vida.

- Estruturas de estado atual.

- Estruturas históricas, de eventos ou de ciclo de vida.

- Dependências entre domínios.

- Limites de identidade persistente e propriedade.

O modelo descreve o que as estruturas persistidas representam.

As características detalhadas de implementação física são documentadas pelos artefatos responsáveis por essas questões.

Por exemplo, a existência e o significado de um relacionamento pertencem ao *Domain Model* (Modelo de Domínio), enquanto o nome exato da *foreign key* (chave estrangeira) e a lógica de validação de *deployment* (implantação) pertencem aos *Database Standards* (Padrões de Banco de Dados) e à implementação de *deployment* (implantação).

Da mesma forma, o papel semântico de uma entidade transacional pertence a este documento, enquanto sua estratégia de particionamento físico pertence à *Architecture* (Arquitetura) e à definição implementada do banco de dados.

---

### 2.2 Modelo Implementado

O principal objeto deste documento é o modelo de domínio implementado do AtlasCommerce.

Uma entidade é descrita como parte do modelo implementado quando faz parte da implementação consolidada e validada do banco de dados.

Conceitos considerados durante etapas anteriores da modelagem, mas que não estão presentes na implementação validada atual, não devem ser apresentados como se permanecessem sendo entidades implementadas.

Da mesma forma, um nome conceitual anterior não deve ser preservado quando o modelo implementado adotou uma entidade ou responsabilidade diferente.

Essa distinção é particularmente importante porque o modelo do AtlasCommerce evoluiu durante a implementação.

O *Domain Model* (Modelo de Domínio), portanto, deve descrever o modelo consolidado resultante, em vez de preservar premissas intermediárias e obsoletas de projeto.

---

### 2.3 Representação Conceitual e Física

O *Domain Model* (Modelo de Domínio) descreve o significado lógico sem ignorar características do banco de dados implementado que afetem materialmente esse significado.

Um relacionamento lógico pode possuir uma representação física mais detalhada devido a requisitos como:

- Chaves compatíveis com particionamento.

- Chaves candidatas compostas.

- Preservação histórica.

- Unicidade condicional.

- Separação entre estado atual e eventos históricos.

- Representação controlada de ciclo de vida.

Quando essas características afetam a forma como as entidades se relacionam, elas podem ser explicadas neste documento no nível necessário para a compreensão do modelo de domínio.

O *Domain Model* (Modelo de Domínio), entretanto, não deve duplicar a definição física completa de chaves, *constraints* (restrições), *indexes* (índices), *filegroups* (grupos de arquivos), *partition schemes* (esquemas de particionamento) ou *deployment scripts* (scripts de implantação).

O objetivo é explicar o relacionamento persistente e seu significado, e não reproduzir sua implementação SQL.

---

### 2.4 Fonte da Verdade

A implementação consolidada e validada do banco de dados AtlasCommerce é a fonte técnica da verdade para o modelo persistente implementado.

O *Domain Model* (Modelo de Domínio) deve permanecer sincronizado com essa implementação.

Outras documentações do AtlasCommerce fornecem fontes complementares de significado:

- A *Business Documentation* (Documentação de Negócio) define conceitos de negócio, comportamentos, regras e semântica de ciclo de vida.

- A *Architecture Documentation* (Documentação de Arquitetura) define responsabilidades arquiteturais, limites e as principais decisões técnicas de projeto.

- Os *Database Standards* (Padrões de Banco de Dados) definem convenções de implementação e regras de governança do banco de dados.

- Os *deployment scripts* (scripts de implantação) definem os objetos implementados no banco de dados e o comportamento de implantação.

- A *Final Validation* (Validação Final) verifica de forma independente o estado esperado após a implantação.

Essas fontes devem permanecer consistentes, mas possuem responsabilidades diferentes.

O *Domain Model* (Modelo de Domínio) não deve se sobrepor a uma implementação validada apenas porque um projeto conceitual anterior descrevia uma estrutura diferente.

Da mesma forma, uma divergência na implementação não deve ser automaticamente aceita como o modelo pretendido apenas porque existe atualmente em um banco de dados.

Uma divergência exige revisão controlada.

---

### 2.5 Reconciliação do Modelo

Quando o *Domain Model* (Modelo de Domínio), a *Business Documentation* (Documentação de Negócio), a *Architecture* (Arquitetura), os *Database Standards* (Padrões de Banco de Dados), a implementação de *deployment* (implantação) ou o estado validado do banco de dados aparentarem divergir, a discrepância deve ser investigada de acordo com a responsabilidade da informação afetada.

As possíveis causas incluem:

- Um modelo conceitual obsoleto.

- Uma implementação obsoleta.

- Uma regra de negócio que mudou após a criação do modelo original.

- Uma alteração arquitetural controlada.

- Uma atualização incompleta da documentação.

- Uma migração incompleta.

- Uma divergência não intencional na implementação.

O objetivo da reconciliação não é forçar um artefato a corresponder a outro sem análise.

O objetivo é estabelecer o estado atual pretendido e sincronizar todos os artefatos afetados de acordo com ele.

Uma vez confirmado o estado pretendido, representações obsoletas devem ser atualizadas ou descontinuadas para que o AtlasCommerce não mantenha definições concorrentes do mesmo modelo persistente.

---

### 2.6 Propriedade do Domínio

Toda entidade persistente pertence a um domínio principal do AtlasCommerce.

A propriedade do domínio identifica onde reside a responsabilidade pelo estado persistido da entidade.

Um relacionamento com uma entidade pertencente a outro domínio não transfere sua propriedade.

Por exemplo, quando uma entidade em um *schema* (esquema) referencia uma entidade em outro *schema* (esquema):

- O domínio referenciado permanece responsável pela entidade referenciada.

- O domínio consumidor é proprietário do relacionamento a partir de seu lado do modelo.

- A integridade referencial pode proteger o relacionamento.

- A identidade referenciada não deve ser duplicada apenas para evitar uma dependência entre domínios.

Esse princípio permite que o AtlasCommerce preserve limites claros de responsabilidade enquanto permanece um sistema transacional relacional consistente.

---

### 2.7 Extensões Futuras do Domínio

Entidades ou capacidades futuras de domínio podem ser discutidas quando necessário para estabelecer explicitamente um limite do modelo, mas devem ser claramente diferenciadas das estruturas implementadas.

Um requisito futuro não deve ser representado como parte do modelo atual até que sua responsabilidade de negócio, seu projeto lógico e sua implementação tenham sido intencionalmente definidos.

Da mesma forma, a ausência de uma entidade no modelo atual não impede sua introdução futura.

Extensões futuras devem ser incorporadas de acordo com os mesmos princípios utilizados pelo modelo existente:

- Responsabilidade explícita do domínio.

- Significado persistente claro.

- Relacionamentos controlados.

- Comportamento histórico apropriado.

- Consistência com a semântica de negócio.

- Sincronização com a *Architecture* (Arquitetura) e os *Database Standards* (Padrões de Banco de Dados).

- Validação por meio do processo de *deployment* (implantação) implementado.

---

## 3. Visão Geral dos Domínios

O AtlasCommerce é organizado em domínios lógicos explícitos, implementados por meio de *schemas* (esquemas) do SQL Server.

Os domínios técnicos e de negócio atuais são:

| *Schema* (Esquema) | Responsabilidade Principal |
|---|---|
| `metadata` | Metadados técnicos e governança do banco de dados |
| `catalog` | Catálogo de produtos, classificação, variantes, atributos, mídias e preços |
| `customer` | Identidade do cliente, documentos, contatos, endereços de e-mail, endereços e dados mestres relacionados ao cliente |
| `inventory` | Posição de estoque, movimentações, contexto das movimentações e reservas de estoque |
| `payment` | Métodos de pagamento, execução de pagamentos, estado dos pagamentos, reembolsos e motivos de reembolso |
| `reference` | Dados geográficos de referência compartilhados e classificações controladas compartilhadas |
| `sales` | Transações comerciais, itens de transação, canais e ciclo de vida da transação |
| `shipping` | Remessa, método de entrega, estado da entrega, rastreamento e informações de frete |

Esses domínios definem limites de responsabilidade dentro de um único banco de dados transacional relacional.

O limite de um *schema* (esquema) identifica propriedade.

Ele não proíbe relacionamentos entre domínios.

---

### 3.1 Domínio de Metadados

O domínio `metadata` é responsável pelas informações técnicas utilizadas para governar o próprio banco de dados AtlasCommerce.

Sua responsabilidade atual inclui o registro controlado dos prefixos de tabelas utilizados pelos objetos do banco de dados.

Conceitualmente:

```text
metadata
│
└── TablePrefix
```

`metadata.TablePrefix` representa metadados técnicos, e não dados de negócio do varejo.

Ele oferece suporte à governança do banco de dados e à consistência da implementação sem participar diretamente dos processos comerciais.

---

### 3.2 Domínio de Catálogo

O domínio `catalog` é responsável pela definição e representação comercial dos produtos.

Suas responsabilidades atuais incluem:

- Marca.

- Categoria e hierarquia de categorias.

- Produto.

- Relacionamentos entre produtos e categorias.

- Imagens de produtos.

- Variantes de produtos.

- Atributos de produtos.

- Valores controlados de atributos.

- Relacionamentos entre variantes e valores de atributos.

- Precificação de variantes de produtos.

Conceitualmente:

```text
catalog
│
├── Brand
├── Category
├── Product
├── ProductCategory
├── ProductImage
├── ProductVariant
├── ProductAttribute
├── ProductAttributeValue
├── ProductVariantAttributeValue
└── ProductVariantPrice
```

O catálogo define o que pode ser vendido e como o item comercializável é representado comercialmente.

Os domínios operacionais consomem identidades do catálogo sem adquirir sua propriedade.

---

### 3.3 Domínio de Cliente

O domínio `customer` é responsável pela identidade dos clientes registrados e pelos dados mestres específicos do cliente.

Suas responsabilidades atuais incluem:

- Classificação do cliente.

- Identidade do cliente.

- Documentos do cliente.

- Tipos controlados de documentos do cliente.

- Contatos telefônicos.

- Endereços de e-mail.

- Relacionamentos entre clientes e endereços.

Conceitualmente:

```text
customer
│
├── CustomerType
├── Customer
├── CustomerDocument
├── CustomerDocumentType
├── CustomerContact
├── CustomerEmail
└── CustomerAddress
```

CustomerContact consome a classificação compartilhada `reference.ContactType`.

CustomerAddress consome a identidade compartilhada `reference.Address`.

Esses relacionamentos entre domínios não transferem para o domínio `customer` a propriedade das entidades referenciadas.

---

### 3.4 Domínio de Estoque

O domínio `inventory` é responsável pelo estado operacional do estoque e pelo histórico necessário para explicar suas alterações.

Suas responsabilidades atuais incluem:

- Posição atual do estoque.

- Histórico de movimentações de estoque.

- Motivos controlados de movimentação.

- Observações opcionais das movimentações.

- Reservas de estoque.

- Estado do ciclo de vida das reservas.

Conceitualmente:

```text
inventory
│
├── Inventory
├── InventoryMovementReason
├── InventoryMovement
├── InventoryMovementNote
├── InventoryReservationStatus
└── InventoryReservation
```

O estoque opera sobre `catalog.ProductVariant` porque a responsabilidade pelo estoque pertence à variante específica comercializável, e não apenas ao Product conceitual.

As reservas de estoque são associadas aos itens de transação adquiridos quando o ciclo de vida de vendas aplicável exige que o estoque seja reservado.

---

### 3.5 Domínio de Pagamento

O domínio `payment` é responsável pela execução financeira associada às Transactions comerciais.

Suas responsabilidades atuais incluem:

- Métodos de pagamento.

- Estado do ciclo de vida do pagamento.

- Tentativas de pagamento e fatos financeiros.

- Eventos de reembolso.

- Motivos controlados de reembolso.

Conceitualmente:

```text
payment
│
├── PaymentMethod
├── PaymentStatus
├── PaymentRefundReason
├── Payment
└── PaymentRefund
```

Payment referencia a `sales.Transaction` aplicável.

Os eventos de reembolso preservam os valores devolvidos referentes a Payments previamente registrados sem reescrever o fato original do Payment.

O estado do pagamento permanece distinto do estado do ciclo de vida comercial pertencente ao domínio `sales`.

---

### 3.6 Domínio de Referência

O domínio `reference` é responsável por identidades e classificações de referência compartilhadas cujo significado não é exclusivo de um único domínio de negócio.

Suas responsabilidades atuais incluem:

- Country.

- AdministrativeDivision.

- City.

- Address.

- ContactType.

Conceitualmente:

```text
reference
│
├── Country
│      │
│      ▼
│   AdministrativeDivision
│      │
│      ▼
│     City
│      │
│      ▼
│   Address
│
└── ContactType
```

A hierarquia geográfica fornece identidades compartilhadas e autoritativas de localização.

ContactType fornece a classificação controlada consumida pelos contatos telefônicos dos clientes.

O AtlasCommerce não utiliza `reference` como um contêiner genérico para todos os valores controlados.

Classificações específicas de um domínio permanecem no domínio responsável por seu significado de negócio.

---

### 3.7 Domínio de Vendas

O domínio `sales` é responsável pela transação comercial e pelos itens adquiridos nessa transação.

Suas responsabilidades atuais incluem:

- Transaction.

- TransactionItem.

- TransactionChannel.

- TransactionStatus.

Conceitualmente:

```text
sales
│
├── TransactionChannel
├── TransactionStatus
├── Transaction
└── TransactionItem
```

Transaction representa a compra comercial.

TransactionItem preserva o ProductVariant adquirido, a quantidade, o preço unitário e o desconto unitário aplicáveis àquela venda.

O domínio `sales` preserva os fatos comerciais independentemente de alterações posteriores nos preços do catálogo, eventos de pagamento, eventos de estoque ou alterações no ciclo de vida da remessa.

---

### 3.8 Domínio de Entrega

O domínio `shipping` é responsável pelo processo logístico quando uma Transaction comercial exige entrega física.

Suas responsabilidades atuais incluem:

- Shipment.

- ShipmentMethod.

- ShipmentStatus.

Conceitualmente:

```text
shipping
│
├── ShipmentMethod
├── ShipmentStatus
└── Shipment
```

A existência de um Shipment é condicional.

Uma Transaction concluída diretamente em uma loja física não exige um Shipment apenas porque o domínio `shipping` existe.

No modelo atual, uma Transaction pode possuir no máximo um Shipment.

O Shipment consome o CustomerAddress selecionado para entrega sem adquirir a propriedade dos dados mestres do cliente.

---

### 3.9 Propriedade dos Domínios

Cada entidade persistida possui um domínio principal responsável por sua propriedade.

A propriedade determina qual domínio é responsável por:

- O significado persistente da entidade.

- Seu ciclo de vida.

- Sua integridade específica de domínio.

- Suas classificações controladas, quando aplicável.

- Sua evolução como parte do modelo AtlasCommerce.

Uma *foreign key* (chave estrangeira) não transfere propriedade.

Conceitualmente:

```text
Domínio Proprietário
     │
     └── persiste a entidade autoritativa
                │
                ▼
         Domínio Referenciador
                │
                └── consome a identidade
```

Por exemplo:

- `catalog` é proprietário de ProductVariant; `sales` e `inventory` o consomem.

- `customer` é proprietário de Customer; `sales` pode consumi-lo.

- `reference` é proprietário de Address; `customer` o consome por meio de CustomerAddress.

- `reference` é proprietário de ContactType; `customer` o consome por meio de CustomerContact.

- `customer` é proprietário de CustomerAddress; `shipping` o consome.

- `sales` é proprietário de Transaction; `payment` e `shipping` a consomem.

- `sales` é proprietário de TransactionItem; `inventory` pode consumi-lo para rastreabilidade de reservas e movimentações.

Os relacionamentos entre domínios, portanto, integram o modelo operacional sem duplicar identidades autoritativas.

---

### 3.10 Modelo entre Domínios

Os principais relacionamentos implementados entre os domínios podem ser representados conceitualmente como:

```text
                           metadata
                              │
                              │ governança técnica
                              ▼
reference ───────────────► customer
   │                         │
   │                         │
   │                         ▼
   │                       sales ◄──────── catalog
   │                      /  │  \
   │                     /   │   \
   │                    ▼    ▼    ▼
   │              inventory payment shipping
   │                                    ▲
   └────────────────────────────────────┘
```

Este diagrama representa propriedade e interação persistente, e não ordem de execução.

Mais especificamente:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        └────────────────────────► shipping.Shipment

reference.ContactType
        │
        ▼
customer.CustomerContact


customer.Customer
        │
        ▼
sales.Transaction
        │
        ├─────────────────────────► payment.Payment
        │
        └─────────────────────────► shipping.Shipment
        │
        ▼
sales.TransactionItem
        │
        ├─────────────────────────► inventory.InventoryReservation
        └─────────────────────────► inventory.InventoryMovement

catalog.ProductVariant
        │
        ├─────────────────────────► sales.TransactionItem
        ├─────────────────────────► inventory.Inventory
        ├─────────────────────────► inventory.InventoryReservation
        └─────────────────────────► inventory.InventoryMovement
```

Esses relacionamentos conectam responsabilidades de domínios com propriedades independentes enquanto preservam um único modelo operacional relacional.

---

### 3.11 A Interação entre Domínios Não Implica Participação Universal

Um processo de negócio pode envolver diversos domínios do AtlasCommerce sem exigir que todos os domínios participem de cada Transaction.

Por exemplo:

```text
Transaction em Loja Física
        │
        ├── sales
        ├── payment
        ├── inventory
        └── nenhum Shipment necessário
```

Uma transação que exige entrega pode envolver adicionalmente:

```text
Transaction com Entrega
        │
        ├── sales
        ├── payment
        ├── inventory
        └── shipping
```

Da mesma forma, uma Transaction pode existir sem um Customer registrado associado quando o cenário de negócio aplicável permite um comprador não identificado ou convidado.

A existência de um domínio, portanto, define uma responsabilidade disponível, e não sua participação obrigatória em todos os cenários comerciais.

---

### 3.12 Princípio do Modelo de Domínio

A estrutura de domínios do AtlasCommerce segue estes princípios:

- Cada entidade possui um domínio principal proprietário explicitamente definido.

- *Schemas* (esquemas) representam limites lógicos de responsabilidade.

- Relacionamentos entre domínios são permitidos quando representam relacionamentos persistentes legítimos.

- Uma *foreign key* (chave estrangeira) não transfere propriedade.

- Identidades autoritativas não devem ser duplicadas apenas para evitar relacionamentos entre domínios.

- Identidades de referência compartilhadas permanecem em `reference`.

- Classificações controladas específicas de um domínio permanecem em seus respectivos domínios proprietários.

- ProductVariant é a principal identidade do catálogo consumida por `sales` e `inventory` quando o item comercializável exato é relevante.

- Os dados mestres do Customer permanecem separados dos fatos comerciais da Transaction.

- O estado de Payment permanece separado do estado do ciclo de vida de `sales`.

- O estado e o histórico de `inventory` permanecem separados dos fatos comerciais da venda.

- `shipping` participa apenas quando a Transaction comercial exige entrega física.

- Uma Transaction realizada em loja física não exige Shipment.

- O modelo atual permite no máximo um Shipment por Transaction.

- A interação entre domínios não implica uma sequência obrigatória de execução.

- A interação entre domínios não implica que todos os domínios participem de cada Transaction.

O princípio central é:

> **O AtlasCommerce é um único modelo transacional relacional composto por domínios com propriedade explicitamente definida, cujos relacionamentos preservam a integridade operacional sem obscurecer as responsabilidades.**

---

## 4. Domínio de Metadados

O domínio `metadata` contém metadados técnicos persistentes utilizados para dar suporte à governança do banco de dados AtlasCommerce.

Diferentemente dos domínios de negócio, `metadata` não representa atividades de varejo.

Suas entidades descrevem informações técnicas sobre o próprio banco de dados quando essas informações precisam ser explicitamente governadas, persistidas e validadas como parte da implementação do AtlasCommerce.

O modelo de domínio atual é:

```text
metadata
│
└── TablePrefix
```

`metadata.TablePrefix` é o registro persistente autoritativo das atribuições de prefixos de tabelas utilizadas pelos objetos do banco de dados AtlasCommerce.

---

### 4.1 TablePrefix

`metadata.TablePrefix` representa o prefixo registrado atribuído a uma tabela do AtlasCommerce.

Os prefixos de tabelas fornecem uma identidade técnica estável utilizada pelas convenções de nomenclatura do banco de dados, incluindo nomes de colunas e outros objetos de banco de dados cujos padrões de nomenclatura dependem do prefixo registrado da tabela.

Conceitualmente, cada registro associa:

```text
Schema
   +
Tabela
   +
Prefixo Registrado
   +
Estado do Ciclo de Vida
```

O registro permite que a propriedade dos prefixos permaneça explícita e seja governada de forma independente, em vez de ser inferida a partir dos nomes atuais dos objetos.

---

### 4.2 Atribuição de Prefixos

Cada tabela do AtlasCommerce governada pelo padrão de prefixos possui uma atribuição de prefixo registrada.

Um prefixo identifica a tabela para fins de governança de nomenclatura.

O relacionamento pode ser representado conceitualmente como:

```text
Tabela do AtlasCommerce
        │
        │ governada por
        ▼
metadata.TablePrefix
        │
        ▼
Prefixo Registrado
```

O prefixo não é um identificador de negócio e não participa do significado de negócio da entidade representada pela tabela.

Ele é um metadado técnico utilizado pelo modelo de governança do banco de dados.

A atribuição de prefixos deve permanecer determinística e não ambígua.

Um prefixo registrado deve identificar apenas a tabela à qual esse prefixo foi atribuído.

---

### 4.3 Identidade de Schema e Tabela

Um registro de TablePrefix identifica a tabela associada ao prefixo por meio da identidade de seu *schema* (esquema) e da tabela.

Essa distinção é necessária porque o AtlasCommerce organiza entidades em múltiplos *schemas* (esquemas), e os nomes das tabelas devem ser interpretados dentro de seu *schema* (esquema) proprietário.

Conceitualmente:

```text
Schema + Tabela
      │
      ▼
Identidade Registrada da Tabela
      │
      ▼
Atribuição de Prefixo
```

O registro, portanto, preserva o relacionamento entre:

- *Schema* (esquema) proprietário.

- Nome da tabela.

- Prefixo registrado.

A definição técnica completa e as regras de validação que governam esses valores são definidas pelos *AtlasCommerce Database Standards* (Padrões de Banco de Dados do AtlasCommerce) e pelo *deployment* (implantação) implementado.

---

### 4.4 Ciclo de Vida dos Prefixos

As atribuições de prefixos possuem significado histórico.

Um prefixo atribuído a uma tabela passa a fazer parte do histórico técnico do banco de dados AtlasCommerce.

Se uma atribuição for descontinuada, sua identidade histórica deve permanecer distinguível das atribuições ativas.

O ciclo de vida pode, portanto, ser representado conceitualmente como:

```text
Prefixo Registrado
       │
       ├── Ativo
       │     └── Atribuição atual de prefixo da tabela
       │
       └── Inativo
             └── Atribuição histórica ou descontinuada
```

Uma atribuição inativa permanece como parte do registro.

Descontinuar um prefixo não torna esse prefixo disponível para atribuição a outra tabela.

Isso impede que um identificador técnico que historicamente representava um objeto de banco de dados adquira posteriormente um significado diferente.

---

### 4.5 Imutabilidade dos Prefixos

A identidade representada por um prefixo registrado é historicamente estável.

Depois que um prefixo tiver sido atribuído, sua associação histórica não deve ser reescrita apenas porque:

- Uma tabela não está mais ativa.

- Um objeto de banco de dados foi descontinuado.

- Uma nova tabela foi introduzida.

- Um prefixo diferente pareceria mais conveniente.

- Uma reordenação ou renomeação melhoraria a consistência visual.

Se o modelo evoluir de forma que exija uma nova identidade técnica, a alteração deve preservar o significado histórico das atribuições anteriores.

Esse princípio permite que *scripts*, documentação, artefatos históricos e evidências técnicas do banco de dados continuem interpretando um prefixo de forma consistente ao longo do tempo.

---

### 4.6 Responsabilidade de Governança

`metadata.TablePrefix` é autoritativo para as atribuições atuais e históricas de prefixos.

Outros artefatos do AtlasCommerce podem consumir ou exibir informações de prefixos, mas não devem estabelecer registros independentes e concorrentes de prefixos.

Isso inclui:

- Definições de objetos de banco de dados.

- *Deployment scripts* (scripts de implantação).

- *Validation scripts* (scripts de validação).

- *Database Standards* (Padrões de Banco de Dados).

- Documentação de domínio.

- Inventários técnicos.

Esses artefatos podem referenciar prefixos registrados quando exigido por sua responsabilidade.

O registro completo permanece sob responsabilidade de `metadata.TablePrefix`.

Isso impede que a documentação ou os artefatos de *deployment* (implantação) se tornem fontes independentes de propriedade dos prefixos que possam posteriormente divergir do banco de dados implementado.

---

### 4.7 Limite do Domínio

O domínio `metadata` deve permanecer limitado aos metadados técnicos cuja governança persistente pertence ao modelo de banco de dados.

Uma classificação de negócio não deve ser colocada em `metadata` apenas porque contém valores controlados.

Da mesma forma, *statuses* (estados), tipos, motivos ou classificações específicos de um domínio permanecem no domínio de negócio ou de referência responsável por seu significado.

A distinção é:

```text
Governança Técnica do Banco de Dados
             │
             ▼
          metadata

Significado Operacional de Negócio
ou Compartilhado
             │
             ▼
Domínio de Negócio / reference
```

Esse limite impede que os metadados técnicos de governança se tornem um repositório genérico para dados controlados de negócio.

---

### 4.8 Princípio do Domínio de Metadados

O domínio `metadata` existe para tornar explícita e persistente a governança técnica do banco de dados quando o AtlasCommerce assim exigir.

Para o modelo atual:

- `TablePrefix` é responsável pelo registro dos prefixos de tabelas.

- As atribuições de prefixos identificam objetos técnicos do banco de dados, e não entidades de negócio.

- A identidade do *schema* (esquema) e da tabela determina a propriedade do prefixo.

- Os prefixos permanecem historicamente estáveis.

- Atribuições descontinuadas permanecem preservadas.

- Um prefixo descontinuado não deve adquirir uma nova identidade de tabela.

- Outros artefatos consomem o registro sem se tornarem fontes concorrentes de propriedade dos prefixos.

O domínio pode evoluir caso requisitos futuros de governança de banco de dados justifiquem entidades adicionais de metadados persistentes.

Essas entidades devem possuir uma responsabilidade técnica de governança claramente definida e não devem ser introduzidas apenas porque um valor controlado precisa ser armazenado.

---

## 5. Domínio de Catálogo

O domínio `catalog` é responsável pelas estruturas que definem o catálogo comercial de produtos.

Suas responsabilidades incluem:

- marcas;

- categorias e hierarquia de categorias;

- produtos;

- classificação de produtos;

- mídias de produtos;

- variantes de produtos;

- atributos de produtos;

- valores controlados de atributos;

- características das variantes;

- precificação comercial.

O catálogo define **o que pode ser vendido e como é representado comercialmente**.

Ele não é responsável pelos fatos transacionais de vendas, quantidades de estoque, execução de pagamentos ou execução de entregas.

---

### 5.1 Marca

`catalog.Brand` representa uma marca comercial associada aos produtos.

Uma marca fornece uma identidade de negócio reutilizável que pode ser referenciada por múltiplos produtos.

As informações de marca pertencem ao catálogo porque descrevem a identidade comercial de um produto, e não uma venda específica ou uma posição de estoque.

---

### 5.2 Categoria

`catalog.Category` representa uma classificação de catálogo utilizada para organizar produtos.

As categorias permitem organização hierárquica por meio de um relacionamento autorreferenciado, permitindo que uma categoria possua uma categoria pai.

Essa estrutura permite classificações como:

- *Makeup* (Maquiagem)

  - *Face* (Rosto)

  - *Eyes* (Olhos)

  - *Lips* (Lábios)

A hierarquia faz parte do modelo de catálogo e não depende de atividade transacional.

---

### 5.3 Produto

`catalog.Product` representa o produto comercial conceitual.

Um produto identifica o item no nível compartilhado por suas variantes comercializáveis.

Exemplos de informações pertencentes ao nível do produto incluem:

- associação com a marca;

- nome do produto;

- identidade no catálogo;

- estado do ciclo de vida.

Um *Product* (Produto) não é necessariamente a unidade comercializável exata.

A representação comercializável específica é modelada por `catalog.ProductVariant`.

---

### 5.4 Categoria do Produto

`catalog.ProductCategory` representa a associação entre um *Product* (Produto) e uma *Category* (Categoria).

O relacionamento é modelado separadamente porque um produto pode participar de mais de uma classificação de catálogo.

Isso evita incorporar a classificação diretamente à entidade *Product* (Produto) e permite que a organização do catálogo evolua independentemente da definição do produto.

---

### 5.5 Imagem do Produto

`catalog.ProductImage` representa a mídia de produto associada ao catálogo.

As imagens fazem parte da representação comercial de um produto e, portanto, pertencem ao domínio `catalog`.

A entidade permite que as informações de mídia permaneçam independentes da definição principal de *Product* (Produto), ao mesmo tempo em que continuam sendo governadas como parte do catálogo de produtos.

A mídia do produto não representa evidência transacional e não pertence aos domínios de vendas, estoque, pagamento ou entrega.

---

### 5.6 Variante do Produto

`catalog.ProductVariant` representa uma variação comercializável específica de um *Product* (Produto).

Um *Product* (Produto) pode possuir múltiplas variantes representando combinações comercialmente distintas, como:

- cor;

- tonalidade;

- tamanho;

- volume;

- outras características controladas.

O *Product* (Produto) define a identidade comercial comum.

A *ProductVariant* (Variante do Produto) define o item específico que pode participar de processos operacionais, como vendas e estoque.

Por esse motivo, as estruturas transacionais e de estoque referenciam *ProductVariant* (Variante do Produto), e não apenas *Product* (Produto).

---

### 5.7 Atributo do Produto

`catalog.ProductAttribute` define uma característica que pode ser utilizada para distinguir ou descrever *ProductVariants* (Variantes do Produto).

Exemplos incluem:

- *COLOR* (COR);

- *SHADE* (TONALIDADE);

- *SIZE* (TAMANHO);

- *VOLUME* (VOLUME).

Um atributo define a própria característica.

Os valores permitidos para atributos controlados são representados separadamente por `catalog.ProductAttributeValue`.

---

### 5.8 Valor do Atributo do Produto

`catalog.ProductAttributeValue` representa um valor controlado associado a um *ProductAttribute* (Atributo do Produto).

Exemplos incluem:

- *COLOR* (COR) → *RED* (VERMELHO);

- *COLOR* (COR) → *BLACK* (PRETO);

- *SIZE* (TAMANHO) → *SMALL* (PEQUENO);

- *SIZE* (TAMANHO) → *MEDIUM* (MÉDIO).

Separar os atributos de seus valores controlados fornece um vocabulário consistente para o catálogo e evita representações arbitrárias da mesma característica comercial.

---

### 5.9 Valor do Atributo da Variante do Produto

`catalog.ProductVariantAttributeValue` associa uma *ProductVariant* (Variante do Produto) a um *ProductAttributeValue* (Valor do Atributo do Produto) controlado.

Essa estrutura descreve as características que distinguem uma variante de outra.

Por exemplo, uma *ProductVariant* (Variante do Produto) pode estar associada a:

- *COLOR* (COR) → *RED* (VERMELHO);

- *SIZE* (TAMANHO) → *MEDIUM* (MÉDIO).

`ProductVariantAttributeValue` referencia o `ProductAttributeValue` aplicável.

O `ProductAttribute` correspondente é determinado por meio desse valor controlado, e não por um relacionamento direto separado a partir de `ProductVariantAttributeValue`.

Conceitualmente:

```text
ProductVariant
      │
      ▼
ProductVariantAttributeValue
      │
      ▼
ProductAttributeValue
      │
      ▼
ProductAttribute
```

O relacionamento permite que as características das variantes permaneçam normalizadas e reutilizáveis em todo o catálogo.

---

### 5.10 Preço da Variante do Produto

`catalog.ProductVariantPrice` representa a precificação comercial associada a uma *ProductVariant* (Variante do Produto).

A precificação é mantida separadamente da definição de *ProductVariant* (Variante do Produto) porque o preço comercial é uma responsabilidade de negócio distinta e pode evoluir independentemente da identidade da variante comercializável.

O catálogo é responsável pela definição do preço comercial.

Uma venda concluída não depende do preço atual do catálogo para preservar seu histórico financeiro.

O preço efetivamente aplicado a uma venda é persistido pelo domínio de vendas como parte do item da transação.

Essa separação garante que futuras alterações nos preços do catálogo não modifiquem transações históricas.

---

### 5.11 Limite entre Product e ProductVariant

A distinção entre *Product* (Produto) e *ProductVariant* (Variante do Produto) é fundamental para o modelo de catálogo.

Um *Product* (Produto) representa o conceito comercial compartilhado.

Uma *ProductVariant* (Variante do Produto) representa a forma comercializável específica desse produto.

Os domínios operacionais, portanto, referenciam a variante quando o item comercial exato é relevante.

Por exemplo:

- o estoque é mantido para *ProductVariant* (Variante do Produto);

- *TransactionItem* (Item da Transação) de vendas referencia *ProductVariant* (Variante do Produto);

- as características da variante descrevem *ProductVariant* (Variante do Produto);

- a precificação comercial está associada a *ProductVariant* (Variante do Produto).

Isso evita ambiguidades quando diferentes variações do mesmo produto possuem posições de estoque, características ou preços diferentes.

---

### 5.12 Limite de Propriedade do Catálogo

O domínio `catalog` é responsável pela definição dos produtos e por sua representação comercial.

Ele é responsável por:

- *Brand* (Marca);

- *Category* (Categoria);

- *Product* (Produto);

- *ProductCategory* (Categoria do Produto);

- *ProductImage* (Imagem do Produto);

- *ProductVariant* (Variante do Produto);

- *ProductAttribute* (Atributo do Produto);

- *ProductAttributeValue* (Valor do Atributo do Produto);

- *ProductVariantAttributeValue* (Valor do Atributo da Variante do Produto);

- *ProductVariantPrice* (Preço da Variante do Produto).

Ele não é responsável por:

- quantidades atualmente disponíveis em estoque;

- reservas de estoque;

- movimentações de estoque;

- vendas concluídas;

- preços historicamente aplicados a vendas concluídas;

- execução de pagamentos;

- execução de entregas.

Outros domínios podem referenciar entidades do catálogo sem assumir a propriedade dos dados mestres do catálogo.

---

### 5.13 Uso entre Domínios

O catálogo fornece dados mestres consumidos pelos domínios operacionais.

O principal limite operacional é `catalog.ProductVariant`.

Conceitualmente:

```text
Product
   │
   ├── ProductImage
   │
   ├── ProductCategory ── Category
   │
   └── ProductVariant
          │
          ├── ProductVariantAttributeValue
          │        │
          │        └── ProductAttributeValue
          │                  │
          │                  └── ProductAttribute
          │
          └── ProductVariantPrice
```

Os domínios operacionais podem então referenciar a variante comercializável:

```text
catalog.ProductVariant
        │
        ├── sales.TransactionItem
        │
        └── estruturas de inventory
```

Essas referências não transferem a propriedade de *ProductVariant* (Variante do Produto) para esses domínios.

---

### 5.14 Princípio do Domínio de Catálogo

O Domínio de Catálogo segue um princípio central:

> **O catálogo define o que pode ser vendido e como é representado comercialmente; os domínios operacionais registram o que acontece com esses itens comercializáveis.**

`Brand`, `Category`, `Product`, `ProductCategory`, `ProductImage`, `ProductVariant`, `ProductAttribute`, `ProductAttributeValue`, `ProductVariantAttributeValue` e `ProductVariantPrice`, em conjunto, descrevem o catálogo comercial.

Os fatos operacionais permanecem fora desse limite.

O estoque determina quantidades e movimentações.

Vendas preserva o que foi efetivamente vendido, incluindo o preço aplicado no momento da transação.

Pagamento registra a execução financeira.

Entrega registra o processo de atendimento e entrega.

Essa separação permite que o catálogo evolua sem reescrever fatos operacionais históricos.

---

## 6. Domínio de Cliente

O domínio `customer` é responsável pelas identidades persistentes e pelos dados mestres associados aos clientes do AtlasCommerce.

O domínio separa a identidade do cliente de documentos, contatos, endereços de e-mail, endereços do cliente e classificações controladas pertencentes ao domínio `customer`.

Identidades de referência compartilhadas permanecem sob responsabilidade do domínio `reference` quando seu significado não é exclusivo da gestão de clientes.

As principais entidades do domínio de cliente podem ser representadas conceitualmente como:

```text
customer
│
├── CustomerType
│
├── Customer
│   ├── CustomerDocument
│   │       └── CustomerDocumentType
│   │
│   ├── CustomerContact
│   │       └── reference.ContactType
│   │
│   ├── CustomerEmail
│   │
│   └── CustomerAddress
│           └── reference.Address
│
└── Classificações controladas pertencentes ao domínio customer
```

Essa separação permite que cada tipo de informação do cliente siga as regras de ciclo de vida e integridade apropriadas ao seu significado, sem acumular estados não relacionados em uma única entidade Customer.

---

### 6.1 CustomerType

`customer.CustomerType` representa a classificação controlada de um Customer de acordo com o tipo de identidade de cliente representado pelo modelo.

Conceitualmente:

```text
CustomerType
     │
     └── 1:N ──► Customer
```

Um Customer pertence ao CustomerType aplicável.

A classificação controlada impede que o tipo de cliente seja representado por valores textuais irrestritos ou inconsistentes.

Os valores controlados atuais distinguem as classificações de clientes suportadas pelo AtlasCommerce sem exigir entidades principais de Customer separadas para cada tipo.

---

### 6.2 Customer

`customer.Customer` representa a identidade persistente de um cliente registrado no AtlasCommerce.

Customer é a entidade central do domínio de cliente.

Conceitualmente:

```text
CustomerType
     │
     ▼
 Customer
     │
     ├── CustomerDocument
     ├── CustomerContact
     ├── CustomerEmail
     └── CustomerAddress
```

Customer contém o estado que pertence diretamente à identidade do cliente registrado.

Informações com significado ou ciclo de vida distintos são modeladas separadamente, em vez de serem acumuladas na linha de Customer.

Isso inclui:

- Documentos de identificação.

- Valores de contato telefônico.

- Endereços de e-mail.

- Relacionamentos entre cliente e endereço.

Um Customer pode participar de transações comerciais por meio de relacionamentos pertencentes ao domínio transacional aplicável.

A ausência de um relacionamento com um Customer registrado não torna uma transação comercial inválida quando o cenário de negócio permite um comprador não identificado ou convidado.

O domínio `sales`, portanto, é responsável pela Transaction comercial e pode opcionalmente associar essa Transaction a um Customer registrado.

---

### 6.3 CustomerDocument

`customer.CustomerDocument` representa um documento de identificação associado a um Customer.

Conceitualmente:

```text
Customer
   │
   └── 1:N ──► CustomerDocument
                       │
                       └──► CustomerDocumentType
```

Um Customer pode possuir múltiplos documentos associados.

CustomerDocument é responsável pelas informações do documento individual associado ao Customer.

A classificação do documento é representada por `customer.CustomerDocumentType`, e não por texto irrestrito.

O relacionamento do documento permanece como parte dos dados mestres do cliente e deve preservar o significado das informações de identificação representadas pelo modelo implementado.

A aceitação de um determinado documento em uma operação de negócio específica pode depender de contexto de negócio, regulatório ou de processo e não é automaticamente equivalente à validade persistente da entidade CustomerDocument.

---

### 6.4 CustomerDocumentType

`customer.CustomerDocumentType` representa a classificação controlada dos tipos de documentos de identificação suportados pelo AtlasCommerce.

Conceitualmente:

```text
CustomerDocumentType
          │
          └── 1:N ──► CustomerDocument
```

A classificação controlada impede que tipos de documentos equivalentes sejam representados por valores textuais inconsistentes.

A implementação atual suporta tipos de documentos controlados apropriados ao modelo de clientes do AtlasCommerce.

CustomerDocumentType é responsável pela classificação.

CustomerDocument é responsável pelo documento individual associado a um Customer.

A existência de um tipo de documento controlado não determina, por si só, se esse documento pode ser aceito em todos os processos de negócio ou regulatórios.

---

### 6.5 CustomerContact

`customer.CustomerContact` representa um valor de contato telefônico associado a um Customer.

Conceitualmente:

```text
customer.Customer
        │
        └── 1:N ──► customer.CustomerContact
                              │
                              └──► reference.ContactType
```

CustomerContact persiste diretamente o valor de contato como parte do relacionamento com o cliente.

O modelo atual não introduz uma entidade `Contact` independente e reutilizável.

O tipo de contato é representado por `reference.ContactType`, que fornece a classificação controlada compartilhada necessária para interpretar o valor de contato armazenado.

Um Customer pode possuir múltiplos registros CustomerContact.

CustomerContact também preserva o estado operacional que indica se o contato está ativo e se é o contato principal ativo do Customer.

O modelo de integridade implementado permite no máximo um CustomerContact principal e ativo por Customer.

Um contato principal também deve estar ativo.

A validação do formato de telefone pertence à camada da aplicação, em vez de ser codificada como uma *database format constraint* (restrição de formato no banco de dados).

---

### 6.6 CustomerEmail

`customer.CustomerEmail` representa um endereço de e-mail associado a um Customer.

Conceitualmente:

```text
customer.Customer
        │
        └── 1:N ──► customer.CustomerEmail
```

Um Customer pode possuir múltiplos endereços de e-mail.

CustomerEmail preserva se o relacionamento com o e-mail está ativo e se ele é o e-mail principal ativo do Customer.

O modelo de integridade implementado permite no máximo um CustomerEmail principal e ativo por Customer.

Um e-mail principal também deve estar ativo.

Os valores de e-mail não são globalmente únicos no AtlasCommerce.

O mesmo endereço de e-mail pode estar legitimamente associado a mais de um Customer.

Isso permite cenários de negócio legítimos nos quais múltiplas identidades de clientes utilizam o mesmo endereço de e-mail.

A validação do formato de e-mail pertence à camada da aplicação, em vez de ser codificada como uma *database format constraint* (restrição de formato no banco de dados).

---

### 6.7 CustomerAddress

`customer.CustomerAddress` representa o relacionamento entre um Customer e uma identidade de endereço pertencente ao domínio `reference`.

Conceitualmente:

```text
customer.Customer
        │
        ▼
customer.CustomerAddress
        │
        ▼
reference.Address
```

O domínio `customer` é responsável pelo relacionamento entre o Customer e o endereço.

O domínio `reference` é responsável pela identidade compartilhada de Address e por sua estrutura geográfica.

Um Customer pode possuir múltiplos registros CustomerAddress.

CustomerAddress preserva o ciclo de vida do relacionamento do cliente com um endereço, incluindo o estado operacional exigido pelo modelo implementado.

O domínio `customer` não deve duplicar a hierarquia geográfica autoritativa apenas porque os endereços dos clientes a consomem.

---

### 6.8 Limite entre Customer e Reference

Os dados mestres do cliente consomem identidades de referência compartilhadas sem adquirir sua propriedade.

Conceitualmente:

```text
reference
│
├── Country
├── AdministrativeDivision
├── City
├── Address
└── ContactType
        │
        ▼
customer
```

Exemplos incluem:

- `customer.CustomerAddress` consumindo `reference.Address`.

- `customer.CustomerContact` consumindo `reference.ContactType`.

O domínio `reference` permanece responsável pela identidade compartilhada.

O domínio `customer` permanece responsável pelo relacionamento ou valor específico do cliente que consome essa identidade.

Isso impede que dados de referência compartilhados sejam duplicados dentro do domínio `customer`.

---

### 6.9 Responsabilidades de Contato e E-mail

Contatos telefônicos e endereços de e-mail são representados por entidades de cliente separadas porque possuem requisitos de classificação e operação distintos.

Conceitualmente:

```text
Customer
   │
   ├── CustomerContact
   │       └── ContactType
   │
   └── CustomerEmail
```

`CustomerContact` utiliza `reference.ContactType` para distinguir as classificações de contato telefônico suportadas.

`CustomerEmail` não exige ContactType porque o e-mail é representado por sua própria entidade dedicada.

Ambas as estruturas podem conter múltiplos registros para um Customer, aplicando independentemente a regra pertinente de relacionamento principal e ativo.

Essa separação evita introduzir uma abstração genérica de contato quando o modelo implementado de clientes não exige uma.

---

### 6.10 Customer e Sales

A identidade do cliente e a identidade da transação comercial permanecem responsabilidades separadas.

Conceitualmente:

```text
customer.Customer
        │
        │ relacionamento comercial opcional
        ▼
sales.Transaction
```

Um Customer registrado pode participar de múltiplas Transactions.

Uma Transaction pode referenciar um Customer quando um cliente registrado e identificado estiver associado à compra.

Entretanto, o modelo comercial também permite cenários nos quais nenhum Customer registrado está associado à Transaction.

A ausência de um relacionamento com Customer, portanto, não deve ser automaticamente interpretada como estado persistido inválido.

Isso é particularmente relevante em cenários como:

- Transactions de convidados.

- Transactions em loja física com cliente não identificado.

`sales.Transaction` é responsável pelo fato comercial.

`customer.Customer` é responsável pela identidade do cliente registrado.

O relacionamento opcional entre eles preserva essa distinção.

---

### 6.11 Customer e Shipping

Quando o atendimento exige um Shipment, o domínio `shipping` consome um relacionamento de endereço pertencente ao cliente.

Conceitualmente:

```text
customer.Customer
        │
        ▼
customer.CustomerAddress
        │
        ▼
shipping.Shipment
```

O Shipment referencia o CustomerAddress aplicável àquela operação de atendimento.

O domínio `shipping` não se torna proprietário de CustomerAddress apenas porque consome essa identidade.

O domínio `customer` permanece responsável pelo relacionamento entre cliente e endereço.

O domínio `reference` permanece responsável pela identidade compartilhada de Address subjacente.

Isso preserva o limite de propriedade entre:

- Identidade do cliente.

- Relacionamento entre cliente e endereço.

- Identidade geográfica/de endereço compartilhada.

- Atendimento por Shipment.

---

### 6.12 Ciclo de Vida dos Relacionamentos do Customer

As informações relacionadas ao Customer podem possuir um ciclo de vida independente da própria identidade do Customer.

O AtlasCommerce, portanto, representa o estado do ciclo de vida na estrutura responsável por esse relacionamento.

Exemplos incluem:

```text
Customer
   │
   ├── CustomerContact
   │       ├── active / inactive
   │       └── primary / non-primary
   │
   ├── CustomerEmail
   │       ├── active / inactive
   │       └── primary / non-primary
   │
   └── CustomerAddress
           └── ciclo de vida do relacionamento
```

Alterar o estado operacional de um relacionamento do cliente não exige alterar a identidade do Customer.

Da mesma forma, desativar um contato, e-mail ou relacionamento de endereço não deve implicar a exclusão do Customer ou de dados mestres do cliente não relacionados.

O estado do ciclo de vida permanece associado à entidade ou ao relacionamento cujo significado operacional ele representa.

---

### 6.13 Preservação dos Dados do Customer

Os dados mestres do cliente contêm informações cujo ciclo de vida pode se estender além de seu uso ativo atual.

O AtlasCommerce distingue entre:

- Identidade do cliente registrado.

- Documentos de identificação.

- Relacionamentos de contato telefônico.

- Relacionamentos de e-mail.

- Relacionamentos de endereço.

- Identidades de referência compartilhadas.

- Fatos comerciais que consomem identidades pertencentes ao cliente.

Quando a preservação histórica for exigida pelo ciclo de vida implementado, relacionamentos anteriores do cliente não devem ser fisicamente removidos apenas porque deixaram de ser atuais.

O estado operacional do ciclo de vida permite distinguir relacionamentos atuais daqueles preservados para fins históricos ou de rastreabilidade.

Fatos comerciais e de atendimento que referenciam identidades pertencentes ao cliente devem preservar seu significado histórico independentemente de alterações posteriores nos dados mestres atuais do cliente.

---

### 6.14 Princípio do Domínio de Cliente

O domínio `customer` separa a identidade do cliente registrado das estruturas de dados mestres e dos relacionamentos associados a essa identidade.

Para o modelo atual do AtlasCommerce:

- CustomerType fornece a classificação controlada do cliente.

- Customer representa a identidade do cliente registrado.

- CustomerDocument representa documentos de identificação associados a um Customer.

- CustomerDocumentType fornece a classificação controlada de documentos.

- CustomerContact representa informações de contato telefônico associadas a um Customer.

- `reference.ContactType` fornece a classificação controlada utilizada por CustomerContact.

- CustomerEmail representa informações de e-mail associadas a um Customer.

- CustomerAddress representa o relacionamento do Customer com uma identidade compartilhada de Address.

- `reference.Address` e sua hierarquia geográfica permanecem sob responsabilidade do domínio `reference`.

- O modelo atual não introduz uma entidade Contact independente e reutilizável.

- A validação de formato de telefone e e-mail permanece como responsabilidade da aplicação.

- Um Customer pode possuir múltiplos contatos, e-mails, endereços e documentos, de acordo com as regras aplicáveis do modelo.

- A integridade de principal e ativo é aplicada independentemente para CustomerContact e CustomerEmail.

- Endereços de e-mail não são globalmente únicos entre Customers.

- Transactions comerciais podem referenciar um Customer registrado sem exigir que toda Transaction possua um.

- `shipping` pode consumir um CustomerAddress sem adquirir a propriedade dos dados mestres do cliente.

- O ciclo de vida dos relacionamentos do cliente deve permanecer distinguível da identidade do Customer.

O domínio `customer` pode evoluir à medida que requisitos adicionais relacionados aos clientes forem introduzidos, mas novas estruturas devem preservar propriedade explícita e responsabilidade de ciclo de vida, em vez de expandir Customer para uma única entidade contendo todas as formas de informação do cliente.

---

## 7. Domínio de Estoque

O domínio `inventory` é responsável pelo estado operacional persistente necessário para representar a posição de estoque, as movimentações de estoque, o contexto das movimentações e as reservas de estoque dentro do AtlasCommerce.

O domínio separa o estado atual do estoque dos eventos históricos que explicam como esse estado foi alcançado.

Ele também separa o estoque físico das reservas comerciais temporárias.

As principais entidades do domínio de estoque podem ser representadas conceitualmente como:

```text
inventory
│
├── Inventory
│
├── InventoryMovementReason
│
├── InventoryMovement
│   └── InventoryMovementNote
│
├── InventoryReservationStatus
│
└── InventoryReservation
```

O domínio `inventory` consome identidades de produtos comercializáveis pertencentes a `catalog` e, quando aplicável, identidades de itens de transação comercial pertencentes a `sales`.

Esses relacionamentos não transferem para `inventory` a propriedade dessas entidades.

---

### 7.1 Inventory

`inventory.Inventory` representa a posição operacional atual de estoque de uma *ProductVariant* (Variante do Produto).

Conceitualmente:

```text
catalog.ProductVariant
          │
          ▼
inventory.Inventory
```

Inventory representa dados operacionais de estado atual.

Ele existe para que o AtlasCommerce possa determinar a posição física do estoque sem precisar reconstruir esse estado a partir de todo o histórico de movimentações de estoque em cada solicitação operacional.

O estado de estoque implementado distingue entre:

- Quantidade física disponível em estoque.

- Quantidade atualmente reservada.

Conceitualmente:

```text
Quantidade Física em Estoque
       │
       ├── Quantidade Reservada
       │
       └── Quantidade Não Reservada
```

A quantidade reservada faz parte do estado operacional do estoque porque as unidades reservadas permanecem fisicamente presentes, embora temporariamente indisponíveis para operações comerciais concorrentes.

O relacionamento entre as quantidades física e reservada deve permanecer válido de acordo com as regras de integridade definidas pelo modelo implementado do banco de dados.

---

### 7.2 Identidade do Inventory

Inventory é mantido para a *ProductVariant* (Variante do Produto) comercializável representada pelo domínio `catalog`.

Conceitualmente:

```text
catalog.Product
      │
      ▼
catalog.ProductVariant
      │
      ▼
inventory.Inventory
```

Inventory não pertence diretamente a *Product* (Produto), porque Product representa a identidade comercial, enquanto ProductVariant representa o item comercializável específico.

O domínio `inventory`, portanto, consome `catalog.ProductVariant` como a identidade de produto relevante para o controle de estoque.

Consequentemente, o mesmo Product pode possuir múltiplas posições de estoque controladas independentemente por meio de suas diferentes ProductVariants.

O domínio `catalog` permanece responsável pela identidade da ProductVariant.

O domínio `inventory` permanece responsável por seu estado de estoque.

---

### 7.3 Estado Atual e Histórico de Movimentações

O AtlasCommerce separa intencionalmente o estado atual do estoque do histórico de movimentações de estoque.

Conceitualmente:

```text
Histórico de InventoryMovement
          │
          │ explica
          ▼
      Inventory
          │
          └── Estado atual do estoque
```

`Inventory` responde a questões relacionadas à posição operacional atual do estoque.

`InventoryMovement` preserva os fatos históricos que alteraram essa posição.

Essa duplicação controlada atende a responsabilidades diferentes:

- O acesso ao estado atual oferece suporte à eficiência operacional.

- O histórico de movimentações oferece suporte à rastreabilidade e investigação.

A quantidade atual não deve se tornar um valor sem explicação, desconectado das movimentações responsáveis pelas alterações no estoque.

Operações que alteram o estoque físico devem preservar a movimentação histórica correspondente de acordo com as regras de negócio e transacionais implementadas.

---

### 7.4 InventoryMovementReason

`inventory.InventoryMovementReason` representa o motivo controlado de uma movimentação de estoque.

Conceitualmente:

```text
InventoryMovementReason
          │
          └── 1:N ──► InventoryMovement
```

Os motivos de movimentação fornecem significado semântico às alterações no estoque físico.

O domínio controlado implementado distingue eventos de estoque como:

```text
PURCHASE_RECEIPT
SALE
CUSTOMER_RETURN
DAMAGED_IN_TRANSIT
DAMAGED_INTERNAL
LOSS_IN_TRANSIT
LOSS_INTERNAL
FOUND_INTERNAL
INVENTORY_ADJUSTMENT_IN
INVENTORY_ADJUSTMENT_OUT
```

Esses valores representam significados operacionais controlados e não devem ser substituídos por descrições textuais irrestritas.

Separar o motivo da movimentação de InventoryMovement permite que a semântica das movimentações permaneça consistente em todo o histórico de estoque.

---

### 7.5 InventoryMovement

`inventory.InventoryMovement` representa um evento histórico que altera o estoque físico.

Conceitualmente:

```text
InventoryMovementReason
          │
          ▼
InventoryMovement
          │
          ├──► catalog.ProductVariant
          │
          ├──► sales.TransactionItem
          │        quando aplicável
          │
          └──► InventoryMovementNote
                   quando aplicável
```

Um InventoryMovement identifica:

- A ProductVariant afetada.

- O motivo da movimentação.

- A alteração de quantidade.

- Quando a movimentação ocorreu.

- O item de transação comercial relacionado quando a movimentação se origina de um evento de vendas aplicável.

InventoryMovement representa evidência operacional histórica.

Uma movimentação que já ocorreu não deve ser reescrita de forma destrutiva apenas porque um evento posterior compensa seu efeito.

Quando um evento de estoque precisar ser revertido ou compensado, a correção deve preservar o fato histórico original e representar o novo efeito sobre o estoque por meio da movimentação subsequente apropriada.

---

### 7.6 Semântica da Quantidade de Movimentação

InventoryMovement utiliza semântica de quantidade com sinal para representar a direção da alteração física do estoque.

Conceitualmente:

```text
Quantidade Positiva
      │
      └── Estoque entra na posição física

Quantidade Negativa
      │
      └── Estoque sai da posição física
```

Exemplos incluem:

```text
PURCHASE_RECEIPT           +
CUSTOMER_RETURN            +
FOUND_INTERNAL             +
INVENTORY_ADJUSTMENT_IN    +

SALE                       -
DAMAGED_IN_TRANSIT         -
DAMAGED_INTERNAL           -
LOSS_IN_TRANSIT            -
LOSS_INTERNAL              -
INVENTORY_ADJUSTMENT_OUT   -
```

O motivo da movimentação comunica por que o estoque mudou.

O sinal da quantidade comunica a direção da alteração física.

Essas responsabilidades devem permanecer semanticamente consistentes.

---

### 7.7 InventoryMovement e Sales

Uma movimentação de estoque pode estar associada a `sales.TransactionItem` quando o evento de estoque possui origem comercial direta.

Conceitualmente:

```text
sales.Transaction
       │
       ▼
sales.TransactionItem
       │
       ▼
inventory.InventoryMovement
```

Esse relacionamento fornece rastreabilidade entre o fato comercial e o efeito correspondente no estoque.

Nem toda movimentação de estoque se origina de uma venda.

Por exemplo, o estoque pode mudar em razão de:

- Recebimento de compra.

- Dano.

- Perda.

- Localização interna de estoque.

- Ajuste de estoque.

O relacionamento com TransactionItem, portanto, é aplicável apenas quando a semântica da movimentação exige rastreabilidade comercial.

A ausência de um relacionamento com TransactionItem em uma movimentação cujo motivo não o exige não deve ser automaticamente interpretada como dado ausente.

---

### 7.8 InventoryMovementNote

`inventory.InventoryMovementNote` representa um contexto descritivo opcional associado a um InventoryMovement.

Conceitualmente:

```text
InventoryMovement
       │
       └── 0..1 ──► InventoryMovementNote
```

A observação é separada da entidade principal InventoryMovement porque o texto descritivo não é necessário para o processamento normal do estoque.

Isso preserva uma estrutura de movimentação enxuta e de alto volume, ao mesmo tempo em que permite manter contexto adicional quando uma movimentação individual exige explicação.

InventoryMovementNote não substitui o InventoryMovementReason controlado.

O motivo fornece uma classificação operacional padronizada.

A observação fornece detalhes contextuais opcionais.

Conceitualmente:

```text
InventoryMovementReason
       │
       └── Por que a movimentação ocorreu
           em termos controlados

InventoryMovementNote
       │
       └── Contexto adicional opcional
```

---

### 7.9 InventoryReservation

`inventory.InventoryReservation` representa uma alocação temporária de estoque para um `sales.TransactionItem` específico.

Conceitualmente:

```text
sales.TransactionItem
          │
          ▼
InventoryReservation
          │
          ├──► catalog.ProductVariant
          │
          └──► InventoryReservationStatus
```

Uma reserva protege o estoque destinado a uma transação comercial em andamento sem representar uma movimentação física de estoque.

Essa distinção é fundamental:

```text
Reserva
    │
    └── Altera a disponibilidade do estoque

InventoryMovement
    │
    └── Altera o estoque físico
```

O estoque reservado permanece fisicamente presente.

A reserva impede temporariamente que a quantidade reservada seja tratada como disponível para operações concorrentes, de acordo com o processo de negócio aplicável.

---

### 7.10 InventoryReservationStatus

`inventory.InventoryReservationStatus` representa o estado controlado do ciclo de vida de uma InventoryReservation.

Conceitualmente:

```text
InventoryReservationStatus
            │
            └── 1:N ──► InventoryReservation
```

O *status* (estado) comunica o estado atual do ciclo de vida da reserva, e não o estado do TransactionItem ou da ProductVariant associados.

A responsabilidade pelo ciclo de vida da reserva pertence ao domínio `inventory`.

Uma reserva pode avançar pelo ciclo de vida definido pelos valores controlados implementados e pelas regras de negócio aplicáveis.

Encerrar, consumir, liberar ou expirar uma reserva não deve exigir que o registro histórico da reserva seja fisicamente excluído.

A reserva permanece como evidência de que o estoque foi alocado a uma operação comercial durante determinado período.

---

### 7.11 Limite Temporal da Reserva

Uma InventoryReservation possui um ciclo de vida temporal explícito.

Conceitualmente:

```text
reserved_at
     │
     ▼
Reserva Ativa
     │
     ├────────► expires_at
     │
     └────────► closed_at
```

`reserved_at` identifica quando a reserva começou.

`expires_at` identifica o limite de expiração estabelecido para a reserva.

`closed_at`, quando aplicável, identifica quando o ciclo de vida da reserva foi encerrado.

Esses valores preservam fatos temporais diferentes e não devem ser tratados como intercambiáveis.

Os relacionamentos temporais entre eles fazem parte da integridade persistida da reserva.

---

### 7.12 Reserva e Estoque Físico

A reserva não representa, por si só, a retirada de estoque físico.

Conceitualmente:

```text
Estoque Físico
       │
       ├── Não Reservado
       │
       └── Reservado
              │
              └── InventoryReservation
```

Por exemplo:

```text
Quantidade em estoque : 10
Quantidade reservada  :  3
-------------------------
Não reservada         :  7
```

As três unidades reservadas continuam fazendo parte da quantidade física em estoque.

Um evento de negócio posterior pode provocar uma alteração no estoque físico e criar o InventoryMovement correspondente.

Até que esse evento ocorra, a reserva representa alocação, e não retirada física.

Essa distinção impede que o AtlasCommerce trate reserva temporária e consumo efetivo de estoque como o mesmo evento de estoque.

---

### 7.13 Reserva e TransactionItem

InventoryReservation pertence a um item específico da transação comercial.

Conceitualmente:

```text
sales.Transaction
       │
       ▼
sales.TransactionItem
       │
       ▼
inventory.InventoryReservation
```

O relacionamento preserva qual item adquirido provocou a alocação de estoque.

Como as estruturas de vendas aplicáveis participam da arquitetura transacional compatível com particionamento, o relacionamento implementado completo pode incluir o componente temporal exigido pela chave referenciada de TransactionItem.

Conceitualmente:

```text
Identidade de TransactionItem
          +
Componente Temporal da Transaction
          │
          ▼
InventoryReservation
```

O componente temporal oferece suporte à definição relacional completa implementada e compatível com particionamento.

Ele não cria uma identidade de negócio separada para a reserva.

---

### 7.14 Reserva e ProductVariant

InventoryReservation também identifica a ProductVariant cujo estoque está sendo reservado.

Conceitualmente:

```text
sales.TransactionItem
        │
        └──► catalog.ProductVariant
                       │
                       ▼
             InventoryReservation
```

A reserva deve permanecer semanticamente compatível com a ProductVariant representada pelo item de transação comercial relacionado.

Esse relacionamento permite que o domínio `inventory` torne explícita a identidade do estoque reservado, preservando ao mesmo tempo a rastreabilidade até a operação comercial responsável pela reserva.

A ProductVariant permanece pertencente a `catalog`.

O TransactionItem permanece pertencente a `sales`.

A reserva permanece pertencente a `inventory`.

---

### 7.15 Consistência do Estoque

O domínio `inventory` contém múltiplas representações que devem permanecer mutuamente consistentes.

Conceitualmente:

```text
                  Inventory
                 Estado Atual
                 /          \
                /            \
               ▼              ▼
InventoryReservation    InventoryMovement
 Estado de Alocação     Alteração Histórica
```

Essas estruturas atendem a responsabilidades diferentes:

- `Inventory` representa as quantidades físicas e reservadas atuais.

- `InventoryReservation` representa alocações temporárias e seus ciclos de vida.

- `InventoryMovement` representa alterações históricas no estoque físico.

A existência de estruturas separadas não deve permitir estados operacionais contraditórios.

Por exemplo:

- A quantidade reservada deve permanecer compatível com a quantidade física.

- As alterações no ciclo de vida das reservas devem permanecer consistentes com o estado reservado atual.

- As alterações no estoque físico devem permanecer rastreáveis pelo histórico de movimentações.

- Uma reserva não deve ser interpretada como movimentação física apenas porque afeta a disponibilidade.

Operações que modificam múltiplas responsabilidades de estoque como parte de um único evento de negócio devem preservar a consistência transacional entre os estados afetados.

---

### 7.16 Preservação do Histórico de Estoque

O histórico de estoque deve permanecer disponível depois que o estado operacional atual mudar.

Isso se aplica tanto a:

```text
InventoryMovement
        │
        └── Evento histórico de estoque físico

InventoryReservation
        │
        └── Ciclo de vida histórico da alocação
```

Uma reserva concluída, expirada, liberada ou encerrada de outra forma não deve ser fisicamente excluída apenas porque deixou de afetar a disponibilidade atual.

Da mesma forma, uma movimentação de estoque não deve ser excluída nem reescrita apenas porque uma movimentação posterior a compensou.

O estado atual pode mudar.

Os fatos históricos que explicam como esse estado evoluiu devem permanecer distinguíveis do estado atual.

---

### 7.17 Limites do Domínio de Estoque

O domínio `inventory` é responsável pelo estado do estoque e pela alocação de estoque.

Ele não é responsável por:

- Identidade comercial do produto.

- Identidade da transação de venda.

- Ciclo de vida do pagamento.

- Ciclo de vida da entrega.

Conceitualmente:

```text
catalog
   │
   └── ProductVariant
           │
           ▼
       inventory
       /       \
      /         \
     ▼           ▼
Inventory   InventoryReservation
                 │
                 └──► sales.TransactionItem

payment
   │
   └── Responsabilidade financeira

shipping
   │
   └── Responsabilidade de atendimento
```

Eventos em outros domínios podem provocar operações de estoque, mas esses eventos não transferem a propriedade do estado de estoque.

Por exemplo, um evento comercial pode exigir reserva de estoque ou consumo físico de estoque.

Uma devolução pode exigir que o estoque retorne à posição física.

Uma perda logística pode exigir que o estoque deixe a posição física reconhecida.

O domínio `inventory` registra a consequência no estoque, enquanto o domínio de origem permanece responsável pelo evento de negócio que a provocou.

---

### 7.18 Princípio do Domínio de Estoque

O domínio `inventory` separa o estado atual do estoque, a alocação temporária e a movimentação física histórica em responsabilidades explícitas.

Para o modelo atual do AtlasCommerce:

- Inventory representa a posição atual de estoque de uma ProductVariant.

- Quantidade física e quantidade reservada permanecem conceitos distintos.

- InventoryMovement preserva alterações históricas no estoque físico.

- InventoryMovementReason fornece classificação semântica controlada para essas movimentações.

- Quantidades de movimentação com sinal representam a direção das alterações no estoque físico.

- InventoryMovementNote preserva contexto descritivo opcional sem ampliar a estrutura principal de movimentações.

- InventoryReservation representa alocação temporária para um TransactionItem.

- InventoryReservationStatus é responsável pela classificação do ciclo de vida da reserva.

- A reserva altera a disponibilidade sem representar, por si só, retirada física do estoque.

- O histórico da reserva permanece preservado após seu encerramento.

- Alterações no estoque físico permanecem rastreáveis por meio de InventoryMovement.

- Identidades comerciais consumidas por `inventory` permanecem sob responsabilidade de seus respectivos domínios.

- Estado de estoque, reservas e histórico de movimentações devem permanecer transacional e semanticamente consistentes.

O domínio `inventory` pode evoluir à medida que requisitos adicionais de gestão de estoque forem introduzidos, mas estruturas futuras devem preservar a distinção entre estoque físico, alocação de disponibilidade e os eventos históricos que explicam as alterações no estoque.

---

## 8. Domínio de Pagamento

O domínio `payment` é responsável pelo estado financeiro persistente associado a pagamentos e reembolsos dentro do AtlasCommerce.

O domínio registra como as tentativas de pagamento, aprovações, cancelamentos, recusas e devoluções de valores ocorrem em relação às transações comerciais.

A responsabilidade de pagamento é intencionalmente separada do ciclo de vida comercial representado por `sales`.

Uma transação de venda estabelece a obrigação comercial.

O domínio `payment` registra os eventos financeiros associados ao cumprimento ou à reversão dessa obrigação.

As principais entidades de pagamento podem ser representadas conceitualmente como:

```text
payment
│
├── PaymentMethod
├── PaymentStatus
├── Payment
├── PaymentRefundReason
└── PaymentRefund
```

O domínio `payment` consome identidades de transação pertencentes a `sales`.

Esse relacionamento não transfere para `payment` a propriedade da transação de venda.

---

### 8.1 Payment

`payment.Payment` representa uma tentativa de pagamento financeiro associada a uma `sales.Transaction`.

Conceitualmente:

```text
sales.Transaction
       │
       └── 1:N ──► payment.Payment
```

Uma Transaction pode possuir múltiplos registros Payment.

Isso permite que o modelo financeiro represente cenários como:

- Múltiplas tentativas de pagamento.

- Uma tentativa recusada seguida por uma tentativa aprovada.

- Pagamentos divididos.

- Pagamentos utilizando diferentes métodos de pagamento.

- Alterações no ciclo de vida financeiro que devem permanecer historicamente distinguíveis.

Os registros Payment preservam os fatos financeiros que efetivamente ocorreram.

Uma tentativa de pagamento anterior não deve ser reescrita de forma destrutiva apenas porque uma tentativa posterior foi bem-sucedida ou porque um evento financeiro posterior alterou a posição financeira efetiva da transação.

---

### 8.2 Payment e Transaction

Payment pertence a uma Transaction comercial.

Conceitualmente:

```text
sales.Transaction
       │
       ▼
payment.Payment
```

O domínio `sales` é responsável pela transação comercial.

O domínio `payment` é responsável pelo estado financeiro do pagamento associado a essa transação.

Essas responsabilidades devem permanecer separadas.

Um Payment não deve se tornar a representação autoritativa do ciclo de vida comercial de uma Transaction.

Da mesma forma, a Transaction não deve duplicar o ciclo de vida financeiro detalhado já representado por Payment.

Como `sales.Transaction` participa da arquitetura transacional compatível com particionamento, o relacionamento implementado completo inclui o componente temporal exigido pela chave referenciada de Transaction.

Conceitualmente:

```text
Identidade da Transaction
        +
Componente Temporal da Transaction
        │
        ▼
      Payment
```

O componente temporal oferece suporte à definição relacional completa implementada e compatível com particionamento.

Ele não representa uma identidade financeira ou de negócio independente.

---

### 8.3 PaymentMethod

`payment.PaymentMethod` representa o método controlado por meio do qual um Payment é realizado.

Conceitualmente:

```text
PaymentMethod
      │
      └── 1:N ──► Payment
```

O domínio controlado implementado inclui:

```text
PIX
CREDIT_CARD
DEBIT_CARD
CASH
```

Os métodos de pagamento devem utilizar valores controlados, e não descrições textuais irrestritas.

Isso fornece uma classificação financeira consistente e impede que métodos de pagamento semanticamente equivalentes sejam representados por diferentes valores textuais.

PaymentMethod descreve como o pagamento é realizado.

Ele não descreve se o pagamento foi bem-sucedido.

Essa responsabilidade pertence a PaymentStatus.

---

### 8.4 PaymentStatus

`payment.PaymentStatus` representa o estado controlado do ciclo de vida financeiro de um Payment.

Conceitualmente:

```text
PaymentStatus
      │
      └── 1:N ──► Payment
```

O domínio controlado implementado inclui:

```text
PENDING
APPROVED
DECLINED
CANCELLED
PARTIALLY_REFUNDED
REFUNDED
```

Esses estados pertencem especificamente ao ciclo de vida financeiro de Payment.

Eles não devem ser interpretados como equivalentes ao ciclo de vida comercial representado pelo domínio `sales`.

Por exemplo:

```text
Transaction Status
       │
       └── Ciclo de vida comercial

Payment Status
       │
       └── Ciclo de vida financeiro
```

As duas responsabilidades de ciclo de vida podem influenciar uma à outra por meio dos processos de negócio, mas permanecem conceitos persistidos distintos.

---

### 8.5 Valor do Payment

Payment preserva o valor monetário associado ao evento financeiro individual.

Conceitualmente:

```text
Transaction
    │
    ├── Payment A
    │      └── Valor
    │
    ├── Payment B
    │      └── Valor
    │
    └── Payment N
           └── Valor
```

O valor do Payment representa o montante associado àquele registro Payment.

O AtlasCommerce deve preservar o valor que efetivamente participou do evento financeiro, em vez de reescrever informações históricas de pagamento apenas para fazer com que o estado acumulado dos pagamentos pareça igual ao total comercial.

O valor comercial devido e os eventos financeiros registrados em relação a ele são fatos relacionados, porém distintos.

Qualquer correção financeira deve preservar o significado histórico do Payment original.

---

### 8.6 Múltiplos Payments

Uma Transaction pode possuir múltiplos registros Payment.

Conceitualmente:

```text
sales.Transaction
       │
       ├──► Payment 1
       ├──► Payment 2
       └──► Payment N
```

Essa arquitetura permite que o AtlasCommerce preserve múltiplos eventos financeiros de forma independente.

Por exemplo:

```text
Transaction
│
├── Payment
│     Method : PIX
│     Status : DECLINED
│
└── Payment
      Method : CREDIT_CARD
      Status : APPROVED
```

A tentativa *DECLINED* (RECUSADA) permanece como parte do histórico financeiro.

Ela não deve ser sobrescrita pelo pagamento posteriormente *APPROVED* (APROVADO).

Múltiplos registros Payment também podem representar cenários legítimos de pagamento dividido quando o processo comercial assim permitir.

O estado financeiro da Transaction deve, portanto, ser determinado a partir dos fatos Payment aplicáveis, e não a partir da premissa de que uma Transaction sempre possui exatamente um Payment.

---

### 8.7 Informações de Parcelamento

Payment pode preservar informações de parcelamento quando o método de pagamento selecionado suporta processamento parcelado.

O modelo Payment implementado inclui uma quantidade opcional de parcelas.

Conceitualmente:

```text
Payment
   │
   ├── PaymentMethod
   ├── Amount
   └── InstallmentCount
```

InstallmentCount descreve como o valor do Payment é dividido comercialmente para a operação de pagamento aplicável.

Ele não cria entidades independentes de parcelas no modelo atual do AtlasCommerce.

O gerenciamento detalhado do ciclo de vida das parcelas está fora do escopo atualmente implementado.

Um método de pagamento que não utiliza parcelamento não exige um valor artificial de parcelas apenas para preencher o campo.

---

### 8.8 Estado Temporal do Payment

Payment preserva *timestamps* (registros de data e hora) associados a eventos significativos do ciclo de vida financeiro.

O modelo implementado distingue fatos temporais como:

```text
attempted_at
     │
     ▼
Tentativa de Payment
     │
     ├────────► approved_at
     │
     └────────► cancelled_at
```

`attempted_at` identifica quando ocorreu a tentativa de pagamento.

`approved_at`, quando aplicável, identifica quando ocorreu a aprovação.

`cancelled_at`, quando aplicável, identifica quando ocorreu o cancelamento.

Esses valores representam fatos financeiros diferentes e não devem ser tratados como intercambiáveis.

Os relacionamentos temporais aplicáveis fazem parte do estado persistente esperado de Payment.

Os *timestamps* (registros de data e hora) do ciclo de vida devem preservar o que efetivamente ocorreu, em vez de serem preenchidos com valores artificiais apenas para evitar `NULL`.

---

### 8.9 Aprovação do Payment

A aprovação de um Payment representa um evento financeiro.

Um Payment *APPROVED* (APROVADO) indica que a operação de pagamento aplicável alcançou o estado financeiro aprovado.

Conceitualmente:

```text
Payment
   │
   ▼
APPROVED
   │
   └── Fato financeiro estabelecido
```

A aprovação pode permitir que processos de negócio em outros domínios prossigam.

Por exemplo, um estado financeiro aprovado pode permitir operações subsequentes de vendas, estoque ou atendimento, de acordo com as regras de negócio aplicáveis.

Essas consequências posteriores permanecem responsabilidades de seus respectivos domínios.

O domínio `payment` registra o fato financeiro.

Ele não assume a propriedade do consumo de estoque, da conclusão da transação comercial ou do atendimento da remessa apenas porque a aprovação do pagamento pode desencadear esses processos.

---

### 8.10 Cancelamento e Recusa do Payment

Um Payment *DECLINED* (RECUSADO) e um Payment *CANCELLED* (CANCELADO) representam resultados financeiros diferentes.

Conceitualmente:

```text
Tentativa de Payment
      │
      ├── DECLINED
      │      └── A aprovação não foi obtida
      │
      └── CANCELLED
             └── O ciclo de vida do Payment foi cancelado
```

Essas condições devem permanecer distinguíveis porque representam significados financeiros diferentes.

Um Payment bem-sucedido posteriormente não elimina o evento financeiro anterior recusado ou cancelado.

Os fatos financeiros históricos devem permanecer disponíveis para rastreabilidade operacional e futura interpretação analítica.

---

### 8.11 PaymentRefund

`payment.PaymentRefund` representa dinheiro devolvido em relação a um Payment previamente registrado.

Conceitualmente:

```text
Payment
   │
   └── 1:N ──► PaymentRefund
```

Um reembolso é um evento financeiro separado.

Ele não deve ser representado por:

- Exclusão do Payment original.

- Redução do valor do Payment original.

- Reescrita de um Payment aprovado como se o evento financeiro original nunca tivesse ocorrido.

- Criação de um Payment negativo artificial apenas para representar o dinheiro devolvido.

Conceitualmente:

```text
Payment Original
       │
       └── Fato financeiro preservado
                │
                ▼
          PaymentRefund
                │
                └── Fato financeiro subsequente
```

Isso preserva o histórico financeiro tanto do dinheiro originalmente recebido quanto do dinheiro posteriormente devolvido.

---

### 8.12 Múltiplos Reembolsos

Um Payment pode possuir zero, um ou múltiplos registros PaymentRefund.

Conceitualmente:

```text
Payment
   │
   ├──► PaymentRefund 1
   ├──► PaymentRefund 2
   └──► PaymentRefund N
```

Isso permite que um Payment seja reembolsado de forma incremental quando o processo de negócio assim exigir.

O histórico financeiro permanece explícito, em vez de ser condensado em um único valor de reembolso mutável.

A existência de múltiplos reembolsos também permite que o ciclo de vida de Payment diferencie estados financeiros parcialmente reembolsados e integralmente reembolsados.

Conceitualmente:

```text
APPROVED
    │
    ▼
PARTIALLY_REFUNDED
    │
    ▼
REFUNDED
```

O PaymentStatus atual comunica o estado do ciclo de vida financeiro.

Os registros PaymentRefund preservam os eventos financeiros individuais responsáveis por esse estado.

---

### 8.13 PaymentRefundReason

`payment.PaymentRefundReason` representa o motivo controlado para a devolução de dinheiro associado a um Payment.

Conceitualmente:

```text
PaymentRefundReason
         │
         └── 1:N ──► PaymentRefund
```

O domínio controlado implementado inclui:

```text
CUSTOMER_RETURN
DUPLICATE_CHARGE
FRAUD
OPERATIONAL_ERROR
ORDER_CANCELLATION
```

Os motivos de reembolso fornecem classificação financeira consistente para explicar por que o dinheiro foi devolvido.

Eles não devem ser substituídos por descrições textuais irrestritas como classificação autoritativa do reembolso.

Um motivo controlado de reembolso pode dar suporte a:

- Investigação operacional.

- Reconciliação financeira.

- Auditabilidade.

- Relatórios.

- Classificação analítica futura.

O motivo do reembolso descreve a razão financeira para a devolução do dinheiro.

Ele não estabelece, por si só, que um evento em outro domínio tenha ocorrido.

---

### 8.14 Reembolso e Outros Domínios

Um PaymentRefund representa apenas um evento financeiro.

Ele não deve ser automaticamente interpretado como evidência de:

- Uma devolução física de produto.

- Uma devolução ao estoque.

- Um cancelamento de Transaction.

- Uma devolução de Shipment.

- Outro evento não financeiro de ciclo de vida.

Conceitualmente:

```text
Evento de Negócio
    │
    ├──► consequência em sales
    ├──► consequência em inventory
    ├──► consequência em shipping
    └──► consequência em payment
              │
              ▼
         PaymentRefund
```

Uma mesma situação de negócio pode produzir consequências em múltiplos domínios, mas cada domínio permanece responsável por seus próprios fatos persistidos.

Por exemplo, uma *CUSTOMER_RETURN* (DEVOLUÇÃO DO CLIENTE) pode eventualmente produzir tanto:

```text
Consequência no Estoque
        │
        └── InventoryMovement

Consequência Financeira
        │
        └── PaymentRefund
```

A existência de um deles não deve ser utilizada como substituto para representar explicitamente o outro quando ambos os fatos forem exigidos pelo modelo operacional.

---

### 8.15 Payment e Inventory

Payment e `inventory` representam responsabilidades operacionais separadas.

Conceitualmente:

```text
sales.Transaction
      /       \
     /         \
    ▼           ▼
payment      inventory
```

Um evento financeiro pode desencadear um processo de estoque de acordo com o fluxo de negócio aplicável, mas Payment não representa diretamente o estado do estoque.

Da mesma forma, Inventory não representa se o dinheiro foi recebido com sucesso.

Essa separação impede que o estado financeiro e o estado do estoque fiquem implicitamente acoplados por meio de valores de *status* (estado) duplicados.

Os processos entre domínios devem coordenar as alterações de estado necessárias enquanto preservam a responsabilidade autoritativa de cada domínio.

---

### 8.16 Payment e Shipping

Payment e `shipping` também representam responsabilidades independentes de ciclo de vida.

Conceitualmente:

```text
sales.Transaction
      /       \
     /         \
    ▼           ▼
payment       shipping
Financeiro    Atendimento
Ciclo de Vida Ciclo de Vida
```

A aprovação de um Payment não significa, por si só, que um Shipment tenha sido postado ou entregue.

Da mesma forma, um Shipment entregue não substitui a evidência financeira representada por Payment.

Cada domínio preserva seus próprios fatos operacionais.

O processo de negócio pode avaliar esses fatos em conjunto ao determinar o estado comercial mais amplo de uma Transaction.

---

### 8.17 Preservação do Histórico Financeiro

O histórico financeiro deve permanecer distinguível do estado financeiro atual.

Para o domínio `payment`:

```text
Payment
   │
   └── Evento financeiro original

PaymentRefund
   │
   └── Evento subsequente de devolução de dinheiro

PaymentStatus
   │
   └── Classificação atual do ciclo de vida financeiro
```

Um evento financeiro posterior não deve eliminar a evidência de um evento anterior.

Por exemplo:

```text
Payment aprovado
      │
      ▼
Dinheiro recebido
      │
      ▼
Reembolso parcial
      │
      ▼
Reembolso adicional
```

O estado atual final pode ser *REFUNDED* (REEMBOLSADO), mas o banco de dados ainda deve preservar o Payment e os eventos individuais de reembolso que explicam como esse estado foi alcançado.

Essa distinção oferece suporte à investigação operacional, reconciliação, auditabilidade e futuro processamento analítico.

---

### 8.18 Limites do Domínio de Pagamento

O domínio `payment` é responsável pelos pagamentos financeiros e reembolsos.

Ele não é responsável por:

- Identidade do produto.

- Identidade do cliente.

- Identidade da transação comercial.

- Estado do estoque.

- Ciclo de vida das reservas de estoque.

- Ciclo de vida da remessa.

- Estado comercial do atendimento.

Conceitualmente:

```text
                    sales
                 Transaction
                  /       \
                 /         \
                ▼           ▼
            payment       inventory
               │
               │
               └── Responsabilidade financeira

                 Transaction
                     │
                     ▼
                  shipping
                     │
                     └── Responsabilidade de atendimento
```

O domínio `payment` consome a identidade de Transaction necessária para associar eventos financeiros à operação comercial.

O domínio `sales` permanece responsável por essa Transaction.

As consequências financeiras são registradas por `payment`.

As consequências comerciais permanecem representadas por `sales`.

As consequências de estoque permanecem representadas por `inventory`.

As consequências de atendimento permanecem representadas por `shipping`.

---

### 8.19 Princípio do Domínio de Pagamento

O domínio `payment` separa os eventos financeiros dos ciclos de vida comercial, de estoque e de atendimento que podem causá-los ou responder a eles.

Para o modelo atual do AtlasCommerce:

- Payment representa uma tentativa individual de pagamento financeiro associada a uma Transaction.

- Uma Transaction pode possuir múltiplos Payments.

- PaymentMethod fornece classificação controlada de como o pagamento é realizado.

- PaymentStatus representa o ciclo de vida financeiro de um Payment individual.

- O valor de Payment preserva o montante associado ao evento financeiro efetivamente ocorrido.

- As informações de parcelamento permanecem como parte de Payment quando aplicável.

- Os *timestamps* (registros de data e hora) do ciclo de vida de Payment preservam fatos financeiros distintos.

- Payments *DECLINED* (RECUSADOS) e *CANCELLED* (CANCELADOS) permanecem historicamente distinguíveis.

- Um Payment posteriormente bem-sucedido não sobrescreve tentativas anteriores.

- PaymentRefund representa dinheiro devolvido após um Payment previamente registrado.

- Um Payment pode possuir múltiplos eventos PaymentRefund.

- PaymentRefundReason fornece classificação controlada do motivo pelo qual o dinheiro foi devolvido.

- Reembolsos preservam o Payment original em vez de reescrevê-lo.

- Reembolsos financeiros não representam automaticamente eventos de produto, estoque, remessa ou ciclo de vida comercial.

- O estado de Payment não deve ser duplicado como estado de Transaction, Inventory ou Shipment.

- Processos de negócio entre domínios podem coordenar eventos financeiros com outras consequências operacionais enquanto preservam a propriedade de cada domínio.

- O histórico financeiro deve permanecer rastreável mesmo após alterações no estado atual de Payment.

O domínio `payment` pode evoluir à medida que requisitos financeiros adicionais forem introduzidos, mas estruturas futuras devem preservar a distinção entre a obrigação comercial, os eventos financeiros utilizados para satisfazê-la e correções financeiras ou reembolsos subsequentes.

---

## 9. Domínio de Referência

O domínio `reference` é responsável por identidades de referência compartilhadas e classificações controladas cujo significado é utilizado entre limites de domínios e não pertence exclusivamente a um único domínio de negócio.

O atual Domínio de Referência contém:

- Country.

- AdministrativeDivision.

- City.

- Address.

- ContactType.

Conceitualmente:

```text
reference
│
├── Country
│      │
│      ▼
│   AdministrativeDivision
│      │
│      ▼
│     City
│      │
│      ▼
│   Address
│
└── ContactType
```

O Domínio de Referência fornece identidades compartilhadas autoritativas.

Um domínio consumidor pode referenciar essas identidades sem adquirir sua propriedade.

Nem todo valor controlado pertence a `reference`.

Quando uma classificação controlada possui significado e ciclo de vida pertencentes exclusivamente a um domínio de negócio específico, ela permanece nesse domínio.

---

### 9.1 Modelo de Referência Geográfica

O modelo de referência geográfica é representado por:

```text
Country
   │
   ▼
AdministrativeDivision
   │
   ▼
City
   │
   ▼
Address
```

Cada nível possui uma responsabilidade distinta.

`reference.Country` representa um país.

`reference.AdministrativeDivision` representa uma divisão administrativa pertencente a um Country.

`reference.City` representa uma cidade pertencente a uma AdministrativeDivision.

`reference.Address` representa uma identidade reutilizável de endereço associada a uma City.

A hierarquia permite que as informações geográficas sejam representadas uma única vez e consumidas pelos domínios de negócio sem duplicar toda a estrutura geográfica em cada entidade consumidora.

---

### 9.2 Country

`reference.Country` representa um país no modelo geográfico compartilhado.

Conceitualmente:

```text
Country
   │
   └── 1:N ──► AdministrativeDivision
```

Country fornece o nível geográfico mais alto representado pela hierarquia de referência atual.

A existência de um Country no modelo de referência não implica, por si só, que o AtlasCommerce atualmente suporte operação comercial nesse país.

Representação geográfica e escopo comercial são responsabilidades distintas.

---

### 9.3 AdministrativeDivision

`reference.AdministrativeDivision` representa uma divisão administrativa de um Country.

Dependendo do país, esse conceito pode corresponder a estruturas como estado, província ou outra divisão administrativa aplicável.

Conceitualmente:

```text
Country
   │
   ▼
AdministrativeDivision
   │
   └── 1:N ──► City
```

Uma AdministrativeDivision pertence a um Country.

A entidade evita incorporar terminologia administrativa específica de um país aos domínios de negócio consumidores.

---

### 9.4 City

`reference.City` representa uma cidade associada a uma AdministrativeDivision.

Conceitualmente:

```text
AdministrativeDivision
          │
          └── 1:N ──► City
```

City fornece a identidade geográfica consumida pelo modelo de Address.

Uma City pertence a uma AdministrativeDivision.

As informações de Country são obtidas por meio da hierarquia geográfica, em vez de serem representadas de forma redundante como um relacionamento independente a partir de cada Address ou entidade de negócio consumidora.

---

### 9.5 Address

`reference.Address` representa uma identidade reutilizável de endereço dentro do modelo de referência compartilhado.

Conceitualmente:

```text
Country
   │
   ▼
AdministrativeDivision
   │
   ▼
City
   │
   ▼
Address
```

Address é responsável pelas informações de localização representadas pela identidade compartilhada de endereço.

Os domínios de negócio que necessitam de um endereço consomem essa identidade por meio de seus próprios relacionamentos, em vez de duplicar a representação autoritativa do endereço.

Por exemplo:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        ▼
customer.Customer
```

O domínio `customer` é responsável pelo relacionamento entre Customer e Address.

O domínio `reference` é responsável pelo próprio Address.

Essa distinção permite que a mesma estrutura de referência permaneça independente do ciclo de vida de um relacionamento específico entre cliente e endereço.

---

### 9.6 ContactType

`reference.ContactType` representa a classificação controlada utilizada para identificar os tipos de contato telefônico suportados.

O modelo atual de contato do cliente consome ContactType por meio de `customer.CustomerContact`.

Conceitualmente:

```text
reference.ContactType
          │
          └── 1:N ──► customer.CustomerContact
```

Exemplos das classificações de contato atualmente controladas incluem:

- *PHONE* (TELEFONE).

- *MOBILE* (CELULAR).

ContactType pertence a `reference` porque fornece uma classificação controlada consumida fora da definição física da própria identidade do cliente.

O valor do contato permanece sob responsabilidade de `customer.CustomerContact`.

Conceitualmente:

```text
reference.ContactType
          │
          ▼
customer.CustomerContact
          │
          ▼
customer.Customer
```

O Domínio de Referência é, portanto, responsável pela classificação.

O Domínio de Cliente é responsável pelas informações de contato específicas do cliente e por seu ciclo de vida.

Email não utiliza ContactType no modelo atual porque os endereços de email são representados separadamente por `customer.CustomerEmail`.

---

### 9.7 Propriedade de Referência Compartilhada

Um relacionamento com uma entidade de referência não transfere a propriedade dessa entidade para o domínio consumidor.

Conceitualmente:

```text
reference
   │
   ├── Address ─────────► customer.CustomerAddress
   │
   └── ContactType ─────► customer.CustomerContact
```

O domínio consumidor é responsável por seu relacionamento ou uso operacional.

O Domínio de Referência é responsável pela identidade ou classificação compartilhada.

Isso impede que informações de referência equivalentes sejam reproduzidas de forma independente entre os domínios de negócio.

---

### 9.8 Dados de Referência e Dados Controlados pelo Domínio

A existência do domínio `reference` não significa que todo valor controlado pertença a ele.

O AtlasCommerce distingue entre:

```text
Responsabilidade de Referência Compartilhada
          │
          └── reference

Classificação Pertencente ao Domínio
          │
          └── domínio de negócio responsável
```

Exemplos de classificações controladas pertencentes aos domínios incluem:

- `customer.CustomerType`.

- `customer.CustomerDocumentType`.

- `inventory.InventoryReservationStatus`.

- `inventory.InventoryMovementReason`.

- `payment.PaymentMethod`.

- `payment.PaymentStatus`.

- `payment.PaymentRefundReason`.

- `sales.TransactionChannel`.

- `sales.TransactionStatus`.

- `shipping.ShipmentMethod`.

- `shipping.ShipmentStatus`.

Esses valores permanecem em seus domínios responsáveis porque seu significado e ciclo de vida pertencem a esses domínios.

O Domínio de Referência é, portanto, reservado para responsabilidades de referência genuinamente compartilhadas, em vez de servir como um contêiner genérico para toda tabela de consulta.

---

### 9.9 Dados de Referência e Ciclo de Vida

As entidades de referência podem possuir características de ciclo de vida apropriadas à sua responsabilidade implementada.

O estado do ciclo de vida deve permanecer associado à entidade cuja disponibilidade operacional ele descreve.

O AtlasCommerce não exige uma entidade genérica compartilhada `reference.Status` para representar o ciclo de vida de entidades não relacionadas pertencentes a diferentes domínios.

Em vez disso, o estado do ciclo de vida é representado de acordo com a semântica da entidade ou do domínio responsável.

Isso impede que conceitos de ciclo de vida não relacionados sejam artificialmente acoplados por meio de uma abstração universal de *Status* (ESTADO).

---

### 9.10 Capacidade Geográfica vs. Escopo Comercial

O modelo geográfico pode ser capaz de representar localidades além do escopo comercial atual do AtlasCommerce.

Essa capacidade não deve ser confundida com autorização para operação comercial em todas as geografias representadas.

Conceitualmente:

```text
Representação Geográfica
          │
          └── Quais localidades o modelo de referência
              consegue representar?

Escopo Comercial
          │
          └── Onde o AtlasCommerce opera atualmente?
```

Essas são responsabilidades distintas.

A expansão da operação comercial para outros países pode exigir alterações que vão além dos dados de referência geográfica, incluindo:

- Identificação de clientes.

- Requisitos de documentos.

- Tributação.

- Pagamento.

- Moeda.

- Entrega.

- Requisitos regulatórios.

- Localização.

A capacidade de representar um Country, portanto, não implica suporte completo ao comércio internacional.

---

### 9.11 Princípio do Domínio de Referência

O domínio `reference` fornece identidades e classificações compartilhadas autoritativas que não pertencem exclusivamente a um único domínio de negócio.

Para o modelo atual do AtlasCommerce:

- Country representa o nível mais alto de referência geográfica.

- AdministrativeDivision representa divisões de um Country.

- City pertence a uma AdministrativeDivision.

- Address pertence à hierarquia geográfica por meio de City.

- ContactType fornece classificação controlada de contatos telefônicos.

- `customer.CustomerAddress` consome Address sem adquirir sua propriedade.

- `customer.CustomerContact` consome ContactType sem adquirir sua propriedade.

- Email é representado independentemente por `customer.CustomerEmail` e não consome ContactType.

- Classificações controladas específicas de um domínio permanecem em seus domínios responsáveis.

- O AtlasCommerce não utiliza uma entidade genérica `reference.Status` para responsabilidades de ciclo de vida não relacionadas.

- A capacidade geográfica não define o escopo comercial.

- O consumo entre domínios não transfere propriedade.

O princípio central é:

> **Identidades de referência compartilhadas pertencem a `reference` quando seu significado atravessa os limites dos domínios; valores controlados que pertencem a uma responsabilidade de negócio específica permanecem com o domínio responsável por essa responsabilidade.**

---

## 10. Domínio de Vendas

O domínio `sales` é responsável pelo estado persistente das transações comerciais do AtlasCommerce.

Ele representa o evento comercial no qual Product Variants são adquiridas, o canal pelo qual a transação se origina, o ciclo de vida comercial atual dessa transação e os itens individuais que a compõem.

O domínio de vendas estabelece os fatos comerciais que outros domínios operacionais podem consumir.

Ele não é responsável pelos ciclos de vida financeiro, de reserva de estoque ou de atendimento que podem resultar desses fatos.

As principais entidades de vendas podem ser representadas conceitualmente como:

```text
sales
│
├── TransactionChannel
├── TransactionStatus
├── Transaction
└── TransactionItem
```

O domínio de vendas consome identidades pertencentes a outros domínios quando exigido pelo modelo comercial, incluindo Customer e Product Variant.

Outros domínios podem posteriormente consumir identidades de Transaction ou TransactionItem para representar consequências de pagamento, estoque ou atendimento.

Esses relacionamentos não transferem a propriedade da transação comercial para fora de `sales`.

---

### 10.1 Transaction

`sales.Transaction` representa uma transação comercial de compra registrada pelo AtlasCommerce.

Conceitualmente:

```text
sales.Transaction
       │
       └── 1:N ──► sales.TransactionItem
```

Uma Transaction estabelece o contexto comercial no qual uma ou mais Product Variants são adquiridas.

Ela preserva fatos como:

- Quando a transação ocorreu.

- O Customer aplicável quando um é identificado.

- O canal pelo qual a transação se originou.

- O estado atual de alto nível do ciclo de vida comercial.

Uma Transaction pode existir sem um Customer registrado identificado quando o cenário de venda aplicável permitir.

Isso permite que o AtlasCommerce represente operações comerciais legítimas, como uma compra em loja física sem identificação do cliente, sem criar artificialmente uma identidade de Customer.

A ausência de um relacionamento com Customer nesse cenário é, portanto, um estado de negócio válido, e não automaticamente um dado ausente.

---

### 10.2 Identidade da Transaction

Transaction possui uma identidade técnica estável dentro do domínio de vendas.

Como a arquitetura de vendas implementada utiliza particionamento baseado em tempo, a definição relacional completa de Transaction também inclui seu timestamp da transação quando exigido pelo projeto de chaves compatível com o particionamento.

Conceitualmente:

```text
Transaction
│
├── Identidade da Transaction
└── Momento da Transaction
        │
        ▼
Chave Completa Compatível
com Particionamento
```

O identificador técnico da Transaction permanece como a principal identidade da linha.

O componente temporal participa da arquitetura de chaves implementada em razão do projeto físico de particionamento.

Ele não deve ser interpretado como uma segunda identidade de negócio independente.

Essa distinção é importante para relacionamentos downstream que referenciam Transaction.

Um domínio consumidor pode, portanto, exigir tanto o identificador da Transaction quanto seu componente temporal correspondente para estabelecer o relacionamento completo de chave estrangeira implementado.

---

### 10.3 TransactionChannel

`sales.TransactionChannel` representa o canal controlado pelo qual uma Transaction se origina.

Conceitualmente:

```text
TransactionChannel
        │
        └── 1:N ──► Transaction
```

O domínio controlado implementado distingue os canais de venda suportados pelo AtlasCommerce.

O canal identifica a origem comercial da transação, e não seu estado de ciclo de vida.

Por exemplo, o AtlasCommerce pode distinguir entre transações originadas por:

```text
ONLINE
STORE
```

Esses valores devem permanecer controlados em vez de serem representados por descrições de texto livre sem restrição.

TransactionChannel permite que diferentes cenários de venda coexistam dentro do mesmo modelo de transação comercial sem exigir entidades Transaction separadas para cada canal.

---

### 10.4 Transações Online e em Loja

Transações online e em loja física compartilham a mesma responsabilidade fundamental de transação comercial.

Conceitualmente:

```text
                    Transaction
                    /         \
                   /           \
                  ▼             ▼
              ONLINE           STORE
```

O canal pode influenciar processos de negócio posteriores, mas não altera a identidade fundamental da transação comercial.

Uma transação online exige processo de entrega por meio do domínio de shipping.

Uma transação em loja física representa a entrega imediata do produto na loja e, portanto, não gera um Shipment.

Conceitualmente:

```text
Transaction ONLINE
       │
       └── Exige Shipment

Transaction STORE
       │
       └── Entrega imediata do produto
           sem Shipment
```

A existência de uma Transaction, portanto, não implica universalmente a existência de um Shipment, pois o processo de entrega depende do TransactionChannel.

Para o modelo atual do AtlasCommerce:

```text
ONLINE
   │
   └── exatamente um Shipment

STORE
   │
   └── nenhum Shipment
```

Considerando todas as Transactions, o relacionamento genérico permanece:

```text
Transaction
    │
    └── 0..1 Shipment
```

Essa distinção permite que vendas online e em loja física compartilhem o mesmo modelo comercial de Transaction, preservando as regras de entrega aplicáveis a cada canal.

---

### 10.5 TransactionStatus

`sales.TransactionStatus` representa o estado controlado de alto nível do ciclo de vida comercial de uma Transaction.

Conceitualmente:

```text
TransactionStatus
        │
        └── 1:N ──► Transaction
```

O status da Transaction comunica o estado comercial da compra.

Ele deve permanecer distinto dos estados especializados de ciclo de vida pertencentes a outros domínios.

Conceitualmente:

```text
sales.TransactionStatus
        │
        └── Ciclo de vida comercial

payment.PaymentStatus
        │
        └── Ciclo de vida financeiro

inventory.InventoryReservationStatus
        │
        └── Ciclo de vida da reserva

shipping.ShipmentStatus
        │
        └── Ciclo de vida logístico
```

Esses estados podem influenciar uns aos outros por meio dos processos de negócio, mas não são intercambiáveis.

O status da Transaction não deve se tornar um substituto consolidado para os estados detalhados de pagamento, reserva ou Shipment.

Da mesma forma, o status de outro domínio não deve substituir o ciclo de vida comercial representado por TransactionStatus.

---

### 10.6 Ciclo de Vida Comercial

O ciclo de vida comercial de uma Transaction representa o estado de alto nível da compra, e não todos os eventos operacionais que podem ocorrer após sua criação.

O ciclo de vida implementado inclui os seguintes estados controlados:

```text
PENDING

CONFIRMED

COMPLETED

CANCELLED

FAILED
```

Esses valores comunicam a interpretação comercial da Transaction.

Seus significados devem permanecer sincronizados com a documentação de negócio do AtlasCommerce e com os dados controlados implementados.

Conceitualmente:

```text
PENDING
   │
   ├────────► FAILED
   │
   ▼
CONFIRMED
   │
   ├────────► CANCELLED
   │
   ▼
COMPLETED
```

Esse diagrama é conceitual e não deve ser interpretado como um mecanismo completo e obrigatório de transição de estados.

O comportamento válido do ciclo de vida é definido pelas regras de negócio aplicáveis.

`PENDING` representa uma Transaction que foi criada, mas cuja venda comercial ainda não foi confirmada.

`CONFIRMED` representa uma Transaction cuja venda comercial foi estabelecida com sucesso.

`COMPLETED` representa uma Transaction cujo ciclo de vida comercial aplicável foi concluído.

`CANCELLED` representa uma Transaction cujo ciclo de vida comercial foi cancelado de acordo com as regras de negócio aplicáveis.

`FAILED` representa uma Transaction cujo processamento comercial falhou antes da confirmação bem-sucedida.

TransactionStatus registra o estado comercial atual.

Ele não substitui os fatos históricos detalhados preservados pelos domínios responsáveis pelos eventos operacionais que causaram esse estado.

---

### 10.7 TransactionItem

`sales.TransactionItem` representa uma Product Variant adquirida como parte de uma Transaction.

Conceitualmente:

```text
Transaction
    │
    └── 1:N ──► TransactionItem
                     │
                     └──► catalog.ProductVariant
```

Uma Transaction pode conter múltiplos TransactionItems.

Cada TransactionItem preserva os fatos comerciais associados à Product Variant específica adquirida nessa transação.

O item identifica:

- A Product Variant vendida.

- A quantidade adquirida.

- O preço unitário aplicado.

- O desconto unitário aplicado.

TransactionItem referencia ProductVariant, e não Product, porque ProductVariant representa a identidade específica e comercializável do catálogo.

O domínio de catálogo permanece responsável por ProductVariant.

O domínio de vendas permanece responsável pelo fato de que a variante foi vendida sob as condições comerciais preservadas por TransactionItem.

---

### 10.8 Identidade do TransactionItem

TransactionItem possui sua própria identidade técnica estável.

Assim como Transaction, sua definição relacional completa implementada participa da arquitetura de particionamento baseada em tempo.

Conceitualmente:

```text
TransactionItem
│
├── Identidade do TransactionItem
└── Momento da Transaction
        │
        ▼
Chave Completa Compatível
com Particionamento
```

O componente temporal preserva a compatibilidade com o projeto físico e relacional implementado e compatível com particionamento.

Ele não representa uma identidade comercial separada para o item.

Os domínios que referenciam TransactionItem podem, portanto, exigir a chave completa implementada, incluindo o componente temporal aplicável.

Por exemplo:

```text
sales.TransactionItem
          │
          ├──► inventory.InventoryReservation
          │
          └──► inventory.InventoryMovement
                   quando aplicável
```

O componente temporal adicional da chave existe em razão da arquitetura de particionamento, e não porque o negócio exige duas identidades independentes para um item vendido.

---

### 10.9 Precificação do TransactionItem

TransactionItem preserva as condições comerciais de preço aplicadas quando a Product Variant foi vendida.

Conceitualmente:

```text
TransactionItem
│
├── Quantity
├── UnitPrice
└── UnitDiscount
```

`UnitPrice` representa o preço unitário de venda aplicável preservado para a transação.

`UnitDiscount` representa o desconto unitário aplicado a esse item.

O valor resultante do item pode ser derivado desses fatos comerciais persistidos.

Conceitualmente:

```text
Quantity × (UnitPrice - UnitDiscount)
```

O total derivado não precisa se tornar um fato persistido separado quando puder ser reconstruído deterministicamente a partir dos componentes autoritativos.

Isso preserva os fatos comerciais fundamentais enquanto evita duplicação desnecessária de valores determinísticos.

---

### 10.10 Preço Histórico de Venda

O histórico de preços do catálogo e o preço histórico de venda preservado por TransactionItem atendem a responsabilidades distintas.

Conceitualmente:

```text
catalog.ProductVariant
        │
        ▼
catalog.ProductVariantPrice
        │
        └── Histórico de preços do catálogo
            e validade temporal

sales.TransactionItem
        │
        └── Preço efetivamente aplicado
            à venda
```

`catalog.ProductVariantPrice` preserva os períodos de preços de catálogo associados a uma ProductVariant.

`sales.TransactionItem` preserva o preço unitário e o desconto unitário efetivamente aplicados à transação comercial específica.

Uma alteração posterior no preço de catálogo não deve modificar as condições financeiras preservadas por um TransactionItem existente.

Por exemplo:

```text
No momento da compra

Preço de catálogo aplicável : 50.00
UnitPrice do TransactionItem : 50.00

Preço de catálogo posterior

ProductVariantPrice          : 55.00
UnitPrice do TransactionItem : 50.00
```

O TransactionItem continua representando as condições sob as quais a transação comercial efetivamente ocorreu.

O preço aplicado a uma venda também pode diferir do preço de catálogo aplicável em razão das condições comerciais representadas pela transação.

O histórico de preços do catálogo, portanto, não deve ser reconstruído exclusivamente a partir de TransactionItem, e as condições históricas de venda não devem ser reconstruídas exclusivamente a partir de ProductVariantPrice.

Essa separação permite que os preços de catálogo evoluam enquanto os fatos financeiros exatos registrados por vendas permanecem preservados.

---

### 10.11 Unit Discount

O desconto aplicado a um TransactionItem é normalizado para um valor por unidade.

Conceitualmente:

```text
TransactionItem
│
├── Quantity      : 3
├── UnitPrice     : 20.00
└── UnitDiscount  : 2.00
```

O valor comercial pode, portanto, ser reconstruído de forma consistente a partir da quantidade e dos componentes financeiros unitários.

Um desconto zero é um estado inicial legítimo.

O banco de dados implementado pode, portanto, definir um valor inicial padrão explícito de:

```text
0.00
```

para a coluna de desconto unitário aplicável.

O domínio de vendas persiste o fato comercial resultante.

Ele não exige que o modelo de banco de dados reproduza a lógica de cálculo promocional que determinou por que um determinado desconto foi concedido.

Elegibilidade e cálculo promocional pertencem à responsabilidade de negócio ou da aplicação aplicável, a menos que sejam explicitamente introduzidos no modelo persistente do AtlasCommerce.

---

### 10.12 Imutabilidade do TransactionItem

Depois que a transação comercial aplicável alcança o estado no qual suas condições comerciais são estabelecidas, os fatos históricos preservados por TransactionItem não devem ser reescritos de forma destrutiva para representar eventos operacionais posteriores.

Conceitualmente:

```text
Venda Original
    │
    ▼
TransactionItem
    │
    ├── Quantity
    ├── UnitPrice
    └── UnitDiscount
          │
          └── Fatos comerciais históricos
```

Eventos posteriores, como:

- Ajustes de estoque.

- Problemas de Shipment.

- Devoluções.

- Reembolsos.

- Outros eventos operacionais pós-venda.

devem ser representados pelos domínios responsáveis por esses eventos, em vez de reescrever a venda original.

Isso preserva a distinção entre:

```text
O que foi vendido
      │
      └── sales.TransactionItem

O que aconteceu posteriormente
      │
      └── Domínio operacional responsável
```

O fato comercial original permanece rastreável mesmo quando eventos posteriores alteram o resultado operacional ou financeiro.

---

### 10.13 Vendas e Customer

Uma Transaction pode referenciar um Customer quando o comprador é identificado por meio do domínio de cliente.

Conceitualmente:

```text
customer.Customer
        │
        └── 1:N ──► sales.Transaction
```

O domínio de cliente é responsável pela identidade de Customer e pelos dados mestres relacionados ao cliente.

O domínio de vendas consome essa identidade para estabelecer quem participou da transação comercial, quando aplicável.

O relacionamento é opcional porque o AtlasCommerce permite transações legítimas sem um Customer registrado identificado.

Conceitualmente:

```text
Transaction
    │
    ├── Customer identificado
    │
    └── Customer não identificado
```

Um comprador não identificado não deve exigir um registro Customer genérico artificial apenas para satisfazer o relacionamento.

A ausência de uma identidade de Customer deve permanecer distinguível de um Customer conhecido.

---

### 10.14 Vendas e Catálogo

TransactionItem consome a identidade de ProductVariant do domínio de catálogo.

Conceitualmente:

```text
catalog.Product
       │
       ▼
catalog.ProductVariant
       │
       ▼
sales.TransactionItem
```

O relacionamento identifica exatamente qual variante comercializável participou da transação comercial.

O domínio de vendas não duplica a propriedade do catálogo.

Ele preserva apenas os fatos comerciais que devem permanecer historicamente estáveis mesmo que o estado atual do catálogo seja alterado posteriormente.

Isso permite que:

```text
Catálogo
   │
   └── Definição comercializável atual

Vendas
   │
   └── Fato comercial histórico
```

evoluam de acordo com suas responsabilidades independentes.

---

### 10.15 Vendas e Estoque

Vendas e estoque representam responsabilidades relacionadas, porém separadas.

Conceitualmente:

```text
sales.TransactionItem
          │
          ▼
      inventory
       /      \
      ▼        ▼
 Reservation  Movement
```

Um TransactionItem pode fazer com que o estoque seja reservado.

Um evento de negócio aplicável posterior pode fazer com que o estoque físico seja alterado.

O domínio de vendas registra o que foi comercialmente adquirido.

O domínio de estoque registra a alocação e as consequências sobre o estoque físico decorrentes desse fato comercial.

TransactionItem não deve conter o estado de reserva ou de movimentação de estoque apenas porque esses processos se originam de uma venda.

Isso preserva a propriedade explícita dos domínios enquanto mantém a rastreabilidade entre os fatos operacionais relacionados.

---

### 10.16 Vendas e Pagamento

Payment consome a identidade de Transaction para associar eventos financeiros à compra comercial.

Conceitualmente:

```text
sales.Transaction
       │
       └── 1:N ──► payment.Payment
```

O domínio de vendas estabelece a obrigação comercial.

O domínio de pagamento registra os eventos financeiros associados a essa obrigação.

Essas responsabilidades devem permanecer separadas.

Conceitualmente:

```text
Transaction
    │
    └── O que foi comercialmente adquirido

Payment
    │
    └── O que aconteceu financeiramente
```

Uma Transaction comercial confirmada e um Payment aprovado representam fatos relacionados, porém distintos.

Da mesma forma, um reembolso não deve reescrever a Transaction ou o TransactionItem original apenas porque o resultado financeiro foi posteriormente alterado.

---

### 10.17 Vendas e Shipping

O domínio de shipping representa o processo de entrega física de uma Transaction ONLINE.

Conceitualmente:

```text
sales.Transaction
       │
       ├── ONLINE
       │      │
       │      └──► shipping.Shipment
       │
       └── STORE
              │
              └── nenhum Shipment
```

No modelo de negócio atual do AtlasCommerce, uma Transaction ONLINE exige um Shipment.

Uma Transaction STORE representa a entrega imediata do produto na loja física e, portanto, não gera um Shipment.

O relacionamento genérico entre Transaction e Shipment permanece:

```text
sales.Transaction
       │
       └── 0..1 ──► shipping.Shipment
```

porque o modelo de Transaction suporta ambos os canais.

O canal determina qual cardinalidade se aplica ao cenário comercial individual:

```text
ONLINE → exatamente 1 Shipment
STORE  → 0 Shipments
```

A ausência de um Shipment é, portanto, válida para uma Transaction STORE.

Ela não é o estado esperado do processo de entrega de uma Transaction ONLINE.

Vendas e shipping permanecem responsabilidades separadas.

O domínio de vendas é responsável pela Transaction comercial.

O domínio de shipping é responsável pelo processo logístico de entrega exigido por uma Transaction ONLINE.

O estado de shipping não deve substituir o estado comercial representado por Transaction.

---

### 10.18 Estado Comercial e Estado Operacional

O resultado mais amplo de uma transação comercial pode depender de fatos pertencentes a vários domínios.

Conceitualmente:

```text
                    Transaction
                     Comercial
                       State
                     /   |   \
                    /    |    \
                   ▼     ▼     ▼
              payment inventory shipping
              Financeiro Estoque Logístico
                State    State    State
```

Esses estados não devem ser consolidados em um único status universal.

Cada domínio preserva o estado pelo qual é responsável.

Os processos de negócio podem avaliar esses estados em conjunto ao decidir se a transação comercial deve avançar para outro TransactionStatus de alto nível.

Isso permite que o domínio de vendas comunique o ciclo de vida comercial sem duplicar os modelos detalhados de ciclo de vida dos domínios operacionais envolvidos.

---

### 10.19 Arquitetura Particionada de Vendas

Transaction e TransactionItem são estruturas transacionais de alto volume e participam da arquitetura de particionamento do AtlasCommerce.

Conceitualmente:

```text
sales.Transaction
       │
       ├── Identidade da Transaction
       └── Momento da Transaction
                 │
                 ▼
          Particionamento Mensal

sales.TransactionItem
       │
       ├── Identidade do TransactionItem
       └── Momento da Transaction
                 │
                 ▼
          Particionamento Mensal
```

A arquitetura física implementada utiliza a infraestrutura comum de particionamento de vendas definida para essas estruturas transacionais.

O componente baseado em tempo participa, portanto, das definições de chaves, relacionamentos e índices quando necessário para preservar o alinhamento de particionamento e a compatibilidade relacional.

O particionamento permanece uma responsabilidade da arquitetura física.

Ele não redefine o significado de negócio de Transaction ou TransactionItem.

A função de particionamento, o esquema de particionamento, o posicionamento físico e os requisitos de validação detalhados são governados pela Arquitetura e pelos Padrões de Banco de Dados do AtlasCommerce.

---

### 10.20 Consistência do Momento da Transaction

Transaction e TransactionItem preservam o componente temporal exigido pela arquitetura compatível com particionamento.

O valor temporal de TransactionItem deve permanecer semanticamente consistente com a Transaction à qual pertence.

Conceitualmente:

```text
Transaction
   │
   └── transaction_at
            │
            ▼
TransactionItem
   │
   └── transaction_at
```

O valor temporal repetido não pretende representar dois momentos independentes.

Ele suporta a estrutura relacional completa compatível com particionamento.

Um TransactionItem pertence à mesma transação comercial representada pela Transaction à qual está associado e, portanto, participa do contexto temporal correspondente da transação.

Esse relacionamento deve permanecer consistente como parte da arquitetura de integridade de dados implementada.

---

### 10.21 Preservação do Histórico de Vendas

O domínio de vendas preserva fatos comerciais cujo significado histórico deve sobreviver a alterações posteriores em outras partes do AtlasCommerce.

Exemplos incluem:

```text
Transaction
   │
   └── Transação comercial histórica

TransactionItem
   │
   ├── Product Variant vendida
   ├── Quantidade vendida
   ├── Preço unitário
   └── Desconto unitário
```

Alterações posteriores em:

- Dados mestres do Customer.

- Dados do catálogo de produtos.

- Histórico de preços de catálogo de ProductVariantPrice ou preço atualmente aplicável.

- Estado de estoque.

- Estado de Payment.

- Estado de Shipment.

não devem reescrever silenciosamente os fatos comerciais estabelecidos quando a transação ocorreu.

Isso permite que o domínio de vendas permaneça como a representação autoritativa do que foi comercialmente transacionado, mesmo quando o ciclo de vida operacional mais amplo continua posteriormente.

---

### 10.22 Limites do Domínio de Vendas

O domínio de vendas é responsável pelas transações comerciais.

Ele não é responsável por:

- Dados mestres do Customer.

- Identidade do catálogo de produtos.

- Estado de estoque.

- Ciclo de vida da reserva de estoque.

- Ciclo de vida de Payment.

- Eventos de reembolso.

- Ciclo de vida de Shipment.

- Identidades de referência compartilhadas.

Conceitualmente:

```text
customer ──────►
                \
catalog ─────────► sales
                  /  |  \
                 /   |   \
                ▼    ▼    ▼
          inventory payment shipping
```

As setas representam consumo e relacionamentos operacionais, e não transferência da propriedade dos domínios.

O domínio de vendas consome identidades de Customer e ProductVariant para estabelecer fatos comerciais.

Inventory consome identidades de vendas ao representar consequências sobre o estoque.

Payment consome a identidade de Transaction ao representar consequências financeiras.

Shipping consome o contexto da transação comercial quando o atendimento físico é necessário.

Cada domínio permanece autoritativo para o estado persistente pelo qual é responsável.

---

### 10.23 Princípio do Domínio de Vendas

O domínio `sales` representa os fatos autoritativos das transações comerciais do AtlasCommerce.

Para o modelo atual do AtlasCommerce:

- Transaction representa a compra comercial.

- TransactionChannel identifica o canal controlado pelo qual a compra se origina.

- Transações online e em loja compartilham o mesmo modelo fundamental de Transaction.

- Uma transação em loja física não exige um Shipment quando o cliente recebe o produto diretamente.

- TransactionStatus representa o ciclo de vida comercial de alto nível e permanece separado dos status operacionais especializados.

- Uma Transaction pode existir sem um Customer registrado identificado quando o cenário comercial permitir.

- TransactionItem representa a Product Variant específica adquirida como parte de uma Transaction.

- TransactionItem preserva quantidade, preço unitário e desconto unitário como fatos comerciais históricos.

- O preço atual do catálogo não deve reescrever preços históricos de venda.

- Totais de itens derivados deterministicamente não precisam ser duplicados como fatos comerciais persistidos.

- Eventos operacionais pós-venda não devem reescrever de forma destrutiva o TransactionItem original.

- Transaction e TransactionItem participam da arquitetura de vendas compatível com particionamento.

- Componentes temporais de chave exigidos pelo particionamento dão suporte à implementação física e relacional sem criar novas identidades de negócio.

- Vendas consome identidades de Customer e ProductVariant sem assumir a propriedade dessas entidades.

- Inventory, payment e shipping podem consumir identidades de vendas enquanto permanecem responsáveis por seus próprios estados operacionais.

- Os ciclos de vida comercial, financeiro, de estoque e logístico permanecem distintos.

- O histórico de vendas deve permanecer estável mesmo quando estados operacionais relacionados são alterados em outras partes do AtlasCommerce.

O domínio de vendas pode evoluir à medida que novos requisitos comerciais forem introduzidos, mas estruturas futuras devem preservar a distinção entre a transação comercial original e os processos financeiros, de estoque e logísticos que ocorrem ao seu redor.

---

## 11. Domínio de Entregas

O domínio `shipping` é responsável pelo estado persistente do processo logístico e de entrega do AtlasCommerce.

Ele representa o processo logístico necessário quando uma Transaction comercial precisa ser fisicamente entregue a um Customer, em vez de ser concluída por meio da entrega imediata do produto no ponto de venda.

O domínio de entregas é responsável por preservar:

- O Shipment associado à Transaction comercial.

- O endereço de entrega selecionado para esse Shipment.

- O método de envio.

- O estado atual do ciclo de vida do Shipment.

- O valor associado ao envio.

- As informações de rastreamento, quando disponíveis.

- Os timestamps relevantes do processo logístico e as expectativas de entrega.

As principais entidades de shipping podem ser representadas conceitualmente como:

```text
shipping
│
├── ShipmentMethod
├── ShipmentStatus
└── Shipment
```

O domínio de shipping consome identidades e fatos operacionais pertencentes a outros domínios do AtlasCommerce quando exigidos pelo processo logístico.

Esses relacionamentos não transferem a propriedade dessas entidades para `shipping`.

---

### 11.1 Shipment

`shipping.Shipment` representa o registro do processo logístico associado a uma Transaction quando a entrega física é necessária.

Conceitualmente:

```text
sales.Transaction
       │
       └── 0..1 ──► shipping.Shipment
```

O relacionamento genérico permite que uma Transaction não tenha Shipment porque o modelo de Transaction suporta os canais `ONLINE` e `STORE`.

No modelo de negócio atual do AtlasCommerce:

```text
Transaction ONLINE
       │
       └── exatamente um Shipment

Transaction STORE
       │
       └── nenhum Shipment
```

Uma Transaction pode, portanto, ter no máximo um Shipment.

Isso reflete a regra comercial atual:

```text
Uma Transaction ONLINE
      │
      └──► Um destino de entrega
                  │
                  └──► Um Shipment
```

Se uma compra precisar ser entregue em múltiplos destinos, a operação comercial deverá ser representada por meio de múltiplas Transactions, em vez de múltiplos Shipments para a mesma Transaction.

A ausência de um Shipment é válida para uma Transaction `STORE` porque o produto é entregue diretamente ao cliente na loja física.

---

### 11.2 Transactions sem Shipment

Nem toda Transaction do AtlasCommerce exige a participação do domínio de shipping.

No modelo de negócio atual, o TransactionChannel determina se um Shipment é necessário.

Conceitualmente:

```text
sales.Transaction
       │
       ├── ONLINE
       │      │
       │      └── exatamente um Shipment
       │
       └── STORE
              │
              └── entrega imediata do produto
                  sem Shipment
```

Uma Transaction `ONLINE` exige um processo logístico de entrega e, portanto, exige um Shipment.

Uma Transaction `STORE` representa uma compra em loja física na qual o cliente recebe o produto adquirido diretamente na loja e, portanto, não gera um Shipment.

A existência do domínio `shipping` não deve fazer com que o AtlasCommerce crie artificialmente um Shipment para uma Transaction `STORE`.

Da mesma forma, a ausência de um Shipment não deve ser tratada como o estado esperado de uma Transaction `ONLINE`, pois esse canal exige entrega física por meio do domínio de shipping.

Considerando todo o modelo de Transaction, o relacionamento genérico permanece `0..1` porque ambos os canais são representados pela mesma entidade Transaction.

---

### 11.3 Shipment e Identidade da Transaction

Shipment consome a identidade de Transaction do domínio `sales`.

Como Transaction participa da arquitetura de vendas compatível com particionamento, o relacionamento completo implementado inclui o componente temporal aplicável exigido pela chave referenciada.

Conceitualmente:

```text
sales.Transaction
│
├── Identidade da Transaction
└── Momento da Transaction
        │
        ▼
Chave Referenciada Completa
        │
        ▼
shipping.Shipment
```

O componente temporal não representa uma identidade logística separada.

Ele participa do relacionamento porque a arquitetura física e relacional da Transaction referenciada exige a chave completa compatível com particionamento.

O domínio de vendas permanece autoritativo para a identidade de Transaction.

O domínio de shipping consome essa identidade apenas para estabelecer qual transação comercial o Shipment atende.

---

### 11.4 Uma Transaction, Uma Entrega

O modelo atual de entregas do AtlasCommerce associa intencionalmente uma Transaction a, no máximo, um destino de entrega e um Shipment.

Conceitualmente:

```text
Transaction
    │
    ▼
Necessidade de Entrega
    │
    ▼
Shipment
    │
    ▼
Um Endereço de Entrega
```

Isso simplifica o modelo operacional atual enquanto preserva um relacionamento explícito entre a compra comercial e seu processo de entrega.

Uma Transaction não deve ser dividida entre múltiplos destinos de entrega.

Quando um cliente precisar que produtos sejam entregues em destinos diferentes, essas compras deverão ser representadas como Transactions separadas.

Essa regra pertence ao modelo de negócio atual do AtlasCommerce e deve permanecer sincronizada com a documentação de negócio aplicável.

Requisitos futuros podem introduzir um modelo de entregas diferente, mas tal alteração representaria uma evolução intencional tanto do modelo de negócio quanto do modelo persistente de dados.

---

### 11.5 Endereço de Entrega

Um Shipment referencia o CustomerAddress selecionado como destino daquela operação de entrega.

Conceitualmente:

```text
customer.Customer
       │
       ▼
customer.CustomerAddress
       │
       ▼
shipping.Shipment
```

O domínio de customer é responsável por CustomerAddress.

O domínio de shipping consome a identidade do endereço selecionado para estabelecer onde o Shipment deve ser entregue.

O CustomerAddress referenciado representa o registro exato de endereço selecionado para o Shipment.

Como o histórico de CustomerAddress é preservado por meio do modelo de ciclo de vida do domínio de customer, alterações posteriores nas informações de endereço de um cliente não devem alterar silenciosamente o endereço associado a um Shipment existente.

Conceitualmente:

```text
CustomerAddress Original
          │
          └──► Shipment Existente

Alteração Posterior de Endereço
          │
          ▼
Novo CustomerAddress
```

O Shipment existente continua referenciando o registro de endereço original.

Isso preserva o significado histórico da operação de entrega sem exigir que o domínio de shipping duplique a propriedade dos dados de endereço do cliente.

---

### 11.6 ShipmentMethod

`shipping.ShipmentMethod` representa o método controlado utilizado para realizar um Shipment.

Conceitualmente:

```text
ShipmentMethod
      │
      └── 1:N ──► Shipment
```

O domínio controlado atual inclui métodos implementados como:

```text
PAC
SEDEX
```

Os métodos de envio devem ser representados por dados controlados gerenciados pelo processo de implantação, e não por valores irrestritos de texto livre.

O método comunica como se pretende realizar o Shipment.

Ele não representa o estado atual do ciclo de vida do Shipment.

ShipmentMethod e ShipmentStatus, portanto, possuem responsabilidades independentes.

---

### 11.7 ShipmentStatus

`shipping.ShipmentStatus` representa o estado logístico atual e controlado de um Shipment.

Conceitualmente:

```text
ShipmentStatus
      │
      └── 1:N ──► Shipment
```

O domínio controlado implementado inclui estados como:

```text
PENDING
POSTED
DELIVERED
CANCELLED
RETURNED
```

Esses valores descrevem o ciclo de vida logístico do Shipment.

Eles não devem ser confundidos com o ciclo de vida comercial representado por `sales.TransactionStatus`.

Conceitualmente:

```text
sales.TransactionStatus
        │
        └── Ciclo de vida comercial

shipping.ShipmentStatus
        │
        └── Ciclo de vida logístico
```

Um Shipment que se torna `DELIVERED` representa um fato logístico.

O ciclo de vida da Transaction correspondente pode responder a esse fato de acordo com as regras de negócio aplicáveis, mas os dois status permanecem sob responsabilidades independentes.

---

### 11.8 Ciclo de Vida do Shipment

O ciclo de vida do Shipment representa o estado logístico atual de alto nível da operação de entrega.

Conceitualmente:

```text
PENDING
   │
   ▼
POSTED
   │
   ├────────► DELIVERED
   │
   ├────────► RETURNED
   │
   └────────► CANCELLED
```

Essa representação é conceitual e não deve ser interpretada como um mecanismo completo e obrigatório de transição de estados.

As regras de negócio aplicáveis definem quais transições são legítimas em cada cenário operacional.

ShipmentStatus preserva o estado logístico atual.

Outros timestamps e fatos operacionais fornecem contexto adicional sobre o ciclo de vida da entrega.

O domínio de shipping não deve utilizar TransactionStatus como substituto desse estado específico de logística.

---

### 11.9 Valor do Envio

Shipment preserva o valor monetário associado ao envio de acordo com o modelo comercial implementado do AtlasCommerce.

Conceitualmente:

```text
Shipment
   │
   └── Valor do Envio
```

O valor deve permanecer distinguível do valor dos produtos vendidos.

Um valor de envio igual a zero é um estado comercial legítimo.

Por exemplo, um Shipment pode não possuir cobrança de envio em razão de:

- Uma política comercial de frete grátis.
- Uma promoção.
- Outra condição comercial legítima.

A ausência de cobrança deve, portanto, ser representada como um valor monetário válido igual a zero, e não como informação ausente quando existe um Shipment.

O domínio de shipping persiste o fato monetário resultante.

Ele não precisa reproduzir a lógica de cálculo comercial que determinou por que o valor foi cobrado ou dispensado.

---

### 11.10 Previsão de Entrega

Shipment preserva a data prevista de entrega aplicável exigida pelo modelo logístico atual.

Conceitualmente:

```text
Momento da Transaction
      │
      ▼
Shipment
      │
      └── Data Prevista de Entrega
```

A data prevista de entrega representa uma expectativa, e não uma comprovação de que a entrega ocorreu.

Ela deve, portanto, permanecer conceitualmente distinta do timestamp real de entrega.

Conceitualmente:

```text
Data Prevista de Entrega
        │
        └── Entrega esperada

Delivered At
        │
        └── Fato real de entrega
```

A data prevista de entrega não deve preceder a data aplicável da Transaction, de acordo com as regras de integridade implementadas.

Um requisito futuro para rastreamento histórico de múltiplas previsões de entrega exigiria uma evolução explícita do modelo, em vez de alterar silenciosamente o significado do atributo atual de Shipment.

---

### 11.11 Código de Rastreamento

Shipment pode preservar um código de rastreamento quando o processo de envio aplicável fornecer um.

Conceitualmente:

```text
Shipment
   │
   └── Código de Rastreamento
```

As informações de rastreamento pertencem à responsabilidade logística porque identificam a operação de entrega, e não a Transaction comercial propriamente dita.

A ausência de um código de rastreamento pode ser legítima durante estágios do ciclo de vida nos quais as informações de rastreamento ainda não tenham sido atribuídas.

TrackingCode, portanto, não deve ser interpretado independentemente do ciclo de vida do Shipment e do método de envio aplicável.

O modelo atual preserva o identificador de rastreamento necessário à operação logística sem introduzir um histórico separado de eventos logísticos que não faz parte do modelo implementado do AtlasCommerce.

---

### 11.12 Timestamps do Shipment

Shipment preserva os timestamps necessários para representar fatos importantes do ciclo de vida logístico.

O modelo implementado inclui informações temporais como:

```text
Momento da Transaction
      │
      ▼
Shipment
│
├── Posted At
└── Delivered At
```

`posted_at` representa quando o Shipment foi postado no processo logístico aplicável.

`delivered_at` representa quando a entrega foi concluída.

Esses valores descrevem eventos distintos do ciclo de vida e devem permanecer temporalmente coerentes.

Conceitualmente:

```text
Transaction
    │
    ▼
Postado
    │
    ▼
Entregue
```

Quando os valores correspondentes existirem:

- `posted_at` não deve preceder o momento aplicável da Transaction.
- `delivered_at` não deve preceder `posted_at`.

A ausência de um timestamp de um evento futuro é legítima quando o Shipment ainda não atingiu esse evento.

O banco de dados, portanto, distingue entre um evento que ainda não ocorreu e uma sequência temporal inválida.

---

### 11.13 Shipping e Customer

O domínio de shipping consome a identidade de CustomerAddress do domínio de customer.

Ele não é responsável pelos dados mestres de Customer ou CustomerAddress.

Conceitualmente:

```text
customer.Customer
       │
       ▼
customer.CustomerAddress
       │
       └──► shipping.Shipment
```

O relacionamento existe porque a entrega exige um destino.

A propriedade permanece explícita:

```text
customer
   │
   └── Responsável por CustomerAddress

shipping
   │
   └── Referencia o endereço selecionado
       para entrega
```

Alterações nos dados mestres do cliente não devem reescrever fatos históricos de entrega.

Da mesma forma, o domínio de shipping não deve manter uma representação independente e concorrente da mesma identidade de CustomerAddress apenas para evitar um relacionamento entre domínios.

---

### 11.14 Shipping e Sales

Shipping consome o contexto da Transaction comercial estabelecido pelo domínio `sales`.

Conceitualmente:

```text
sales.Transaction
       │
       └──► shipping.Shipment
                 quando necessário
```

O domínio de vendas responde:

```text
Qual compra comercial ocorreu?
```

O domínio de shipping responde:

```text
Como essa compra está sendo fisicamente entregue?
```

Essas responsabilidades permanecem separadas mesmo quando seus estados de ciclo de vida influenciam uns aos outros.

Um Shipment não deve substituir a Transaction como representação da compra comercial.

Da mesma forma, Transaction não deve absorver o estado logístico detalhado apenas porque a entrega ocorre como consequência da venda.

---

### 11.15 Shipping e Inventory

Shipping e inventory representam responsabilidades operacionais diferentes.

Conceitualmente:

```text
sales.Transaction
       │
       ├──► inventory
       │      └── Responsabilidade de estoque
       │
       └──► shipping
              └── Responsabilidade logística
```

Inventory determina e preserva o estado de estoque e as consequências de estoque aplicáveis às operações comerciais.

Shipping representa o processo logístico necessário para entregar a compra comercial.

Um Shipment não deve ser tratado como uma movimentação de estoque.

Da mesma forma, uma movimentação de estoque não deve ser tratada como evidência de que a entrega física ocorreu.

Os dois domínios podem participar do mesmo processo mais amplo de entrega enquanto preservam fatos persistentes distintos.

---

### 11.16 Shipping e Payment

Shipping e payment representam consequências operacionais independentes de uma Transaction comercial.

Conceitualmente:

```text
                 sales.Transaction
                  /             \
                 ▼               ▼
         payment.Payment   shipping.Shipment
         Estado Financeiro Estado Logístico
```

Payment responde às questões financeiras relacionadas à compra comercial.

Shipment responde às questões logísticas relacionadas à entrega.

Um pagamento bem-sucedido não estabelece, por si só, que um Shipment tenha sido postado ou entregue.

Da mesma forma, um estado logístico não substitui o estado financeiro representado por Payment.

Os processos de negócio podem coordenar esses domínios, mas suas responsabilidades persistentes permanecem separadas.

---

### 11.17 Entrega e Conclusão Comercial

Um Shipment entregue representa a conclusão bem-sucedida da responsabilidade logística associada àquele Shipment.

Conceitualmente:

```text
Shipment
   │
   ▼
DELIVERED
   │
   └── Obrigação logística concluída
```

A interpretação comercial mais ampla pertence ao ciclo de vida de vendas.

No modelo atual, a entrega do Shipment pode fornecer o evento de negócio necessário para que a Transaction correspondente alcance seu estado comercial de entrega aplicável.

Entretanto:

```text
ShipmentStatus.DELIVERED
        ≠
TransactionStatus propriamente dito
```

Os dois estados controlados podem utilizar terminologia semanticamente relacionada enquanto permanecem responsabilidades persistentes distintas.

Isso evita que o estado logístico seja duplicado ou tenha propriedade ambígua entre os domínios.

---

### 11.18 Shipments Retornados

Um Shipment pode entrar em um estado logístico de retorno quando o processo de entrega física resulta no retorno da remessa.

Conceitualmente:

```text
Shipment
   │
   ▼
RETURNED
```

Esse estado representa um fato logístico.

Ele não deve ser automaticamente interpretado como todas as demais consequências de negócio que possam resultar do retorno.

Por exemplo, um Shipment retornado não define, por si só:

- O resultado do reembolso financeiro.
- A movimentação de estoque resultante.
- O estado comercial final da Transaction.

Essas consequências pertencem aos domínios responsáveis por elas e devem ser representadas por meio dos processos operacionais apropriados.

Conceitualmente:

```text
Shipment Retornado
      │
      ├──► sales
      │      Consequência comercial
      │
      ├──► payment
      │      Consequência financeira
      │
      └──► inventory
             Consequência de estoque
```

O fato logístico permanece preservado independentemente por `shipping`.

---

### 11.19 Shipments Cancelados

Um Shipment pode ser cancelado quando a operação logística aplicável é encerrada antes da entrega bem-sucedida.

Conceitualmente:

```text
Shipment
   │
   ▼
CANCELLED
```

O cancelamento do Shipment representa o cancelamento da operação logística.

Ele não deve ser automaticamente interpretado como cancelamento da própria Transaction comercial.

Conceitualmente:

```text
Shipment CANCELLED
        │
        └── Estado logístico

Transaction CANCELLED
        │
        └── Estado comercial
```

O processo de negócio determina se um Shipment cancelado também exige um cancelamento comercial, outra ação logística, correção financeira, ação de estoque ou outra resposta operacional.

O domínio de shipping preserva apenas o estado logístico pelo qual é autoritativo.

---

### 11.20 Preservação do Histórico de Entrega

Fatos de shipping com relevância histórica devem permanecer estáveis após serem estabelecidos.

Exemplos incluem:

```text
Shipment
│
├── Transaction Relacionada
├── Endereço de Entrega
├── ShipmentMethod
├── Valor do Envio
├── Código de Rastreamento
├── Posted At
└── Delivered At
```

Alterações posteriores em:

- Dados mestres do Customer.
- Endereços atuais do Customer.
- Estado da Transaction.
- Estado de Payment.
- Estado de Inventory.
- Dados de referência de shipping.

não devem reescrever silenciosamente os fatos históricos associados a um Shipment existente.

Quando o ciclo de vida do domínio de customer preserva um registro CustomerAddress previamente selecionado, Shipment deve continuar referenciando a identidade exata do endereço selecionado para entrega.

Alterações posteriores de endereço são representadas de acordo com o ciclo de vida de CustomerAddress, sem alterar a identidade de CustomerAddress já referenciada pelo Shipment existente.

Isso permite que o domínio de shipping preserve o relacionamento histórico de entrega sem duplicar desnecessariamente dados autoritativos pertencentes a outro domínio.

---

### 11.21 Integridade de Shipping

O modelo de shipping exige integridade persistente entre a transação comercial, o destino de entrega, os domínios controlados de shipping e os fatos do ciclo de vida logístico.

Conceitualmente:

```text
Shipment
│
├──► sales.Transaction
├──► customer.CustomerAddress
├──► shipping.ShipmentMethod
└──► shipping.ShipmentStatus
```

O banco de dados deve proteger os relacionamentos e invariantes exigidos para um Shipment persistido válido.

A integridade aplicável inclui:

- A Transaction referenciada deve existir.
- O CustomerAddress referenciado deve existir.
- O ShipmentMethod referenciado deve existir.
- O ShipmentStatus referenciado deve existir.
- Uma Transaction não deve possuir múltiplos Shipments quando o modelo atual permite no máximo um.
- O valor do envio deve representar um valor monetário válido e não negativo.
- As previsões de entrega devem respeitar o relacionamento temporal aplicável com a Transaction.
- Os timestamps de postagem e entrega devem preservar uma ordenação temporal válida quando presentes.

As definições físicas detalhadas das constraints permanecem governadas pelos Padrões de Banco de Dados do AtlasCommerce e pelo modelo de banco de dados implementado.

---

### 11.22 Limites do Domínio de Shipping

O domínio de shipping é responsável pela logística de entrega e pelo Shipment.

Ele não é responsável por:

- Identidade do Customer.
- Ciclo de vida dos dados mestres de endereço do Customer.
- Identidade do catálogo de produtos.
- Identidade da Transaction comercial.
- Fatos comerciais de TransactionItem.
- Posição de estoque.
- Movimentações de estoque.
- Reservas de estoque.
- Ciclo de vida de Payment.
- Reembolsos financeiros.
- Dados geográficos de referência compartilhados.

Conceitualmente:

```text
customer ───────►
                  \
sales ─────────────► shipping
                  /
reference ───────►
```

As setas representam o consumo de identidades e relacionamentos, e não a transferência de propriedade.

O domínio de shipping consome as identidades da Transaction comercial e do endereço de entrega necessárias para representar a operação logística.

Outros domínios podem reagir aos resultados logísticos enquanto permanecem autoritativos para seus próprios estados persistentes.

---

### 11.23 Princípio do Domínio de Shipping

O domínio `shipping` representa o estado autoritativo de logística e entrega do AtlasCommerce.

Para o modelo atual do AtlasCommerce:

- Shipment existe para uma Transaction `ONLINE` porque esse canal exige entrega logística.
- Uma Transaction `STORE` em loja física é concluída por meio da entrega imediata do produto e não gera um Shipment.
- Considerando todo o modelo de Transaction, uma Transaction pode ter no máximo um Shipment.
- Múltiplos destinos de entrega exigem Transactions separadas.
- Shipment referencia o CustomerAddress selecionado para entrega.
- Alterações posteriores no endereço do cliente não devem alterar a identidade de CustomerAddress associada a um Shipment existente.
- ShipmentMethod representa o método controlado de envio.
- ShipmentStatus representa o ciclo de vida logístico atual e permanece separado de TransactionStatus.
- `PAC` e `SEDEX` são métodos de envio controlados implementados.
- `PENDING`, `POSTED`, `DELIVERED`, `CANCELLED` e `RETURNED` representam o domínio implementado de ShipmentStatus.
- O valor do envio permanece separado do valor dos produtos vendidos e pode legitimamente ser zero.
- A previsão de entrega representa uma expectativa e permanece distinta da entrega efetiva.
- As informações de rastreamento pertencem à responsabilidade logística.
- Os timestamps de postagem e entrega preservam fatos distintos do ciclo de vida logístico.
- Estados de Shipment retornado ou cancelado não determinam automaticamente consequências financeiras, de estoque ou comerciais.
- Shipping consome identidades de Transaction e CustomerAddress sem assumir a propriedade dessas entidades.
- Os estados logístico, comercial, financeiro e de estoque permanecem representados independentemente.
- Fatos históricos de entrega não devem ser silenciosamente reescritos por alterações posteriores em outras partes do AtlasCommerce.
- O relacionamento completo com Transaction preserva o componente temporal exigido pela arquitetura de vendas compatível com particionamento.

O domínio de shipping pode evoluir quando requisitos futuros de entrega justificarem estruturas logísticas adicionais, mas essas estruturas devem ser introduzidas em razão de requisitos explícitos de negócio ou operacionais, e não pela suposição de uma complexidade que o modelo atual do AtlasCommerce não exige.

---

## 12. Relacionamentos entre Domínios

O AtlasCommerce é implementado como um único banco de dados relacional transacional, cujas responsabilidades de negócio e técnicas são separadas em domínios explícitos.

Esses limites de domínio estabelecem propriedade.

Eles não isolam as entidades umas das outras quando o modelo operacional persistente exige relacionamentos entre domínios.

Os relacionamentos entre domínios permitem que um domínio consuma a identidade ou o estado pertencente a outro domínio sem duplicar essas informações ou transferir a propriedade da entidade referenciada.

Os principais relacionamentos entre domínios podem ser representados conceitualmente como:

```text
                         reference
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
             customer                  shared
                 │                   reference
                 │                     data
                 ▼
               sales ◄──────────── catalog
          ┌──────┼──────┐
          │      │      │
          ▼      ▼      ▼
     inventory payment shipping
```

Esse diagrama representa a interação persistente entre os domínios.

Ele não representa uma ordem obrigatória de execução nem um fluxo de negócio completo.

---

### 12.1 Propriedade e Consumo

Toda entidade persistente pertence a um domínio principal do AtlasCommerce.

Um domínio consumidor pode referenciar essa entidade quando isso for necessário para sua própria responsabilidade.

Conceitualmente:

```text
Domínio Proprietário
     │
     └── Possui a Identidade e o
         Ciclo de Vida da Entidade
                  │
                  ▼
           Domínio Consumidor
                  │
                  └── Possui o Relacionamento ou
                      Fato Operacional Dependente
```

O consumo entre domínios deve preservar os limites de propriedade.

Por exemplo:

- `catalog` é responsável por ProductVariant.

- `sales` consome ProductVariant ao registrar um TransactionItem.

- `inventory` consome ProductVariant ao manter o estado de estoque, o histórico de movimentações ou as reservas.

- `customer` é responsável por Customer e CustomerAddress.

- `sales` pode consumir a identidade de Customer.

- `shipping` consome CustomerAddress quando um Shipment exige entrega.

- `reference` é responsável por Address e ContactType.

- `customer` consome Address por meio de CustomerAddress.

- `customer` consome ContactType por meio de CustomerContact.

- `sales` é responsável por Transaction e TransactionItem.

- `payment`, `inventory` e `shipping` consomem as identidades aplicáveis de sales sem assumir a propriedade delas.

A existência de um relacionamento não deve ser interpretada como transferência de responsabilidade sobre a entidade.

---

### 12.2 Customer e Sales

Os domínios de customer e sales interagem quando uma Transaction comercial é associada a um Customer registrado e identificado.

Conceitualmente:

```text
customer.Customer
        │
        └── 1:N ──► sales.Transaction
```

O relacionamento é opcional sob a perspectiva de Transaction.

Uma Transaction pode existir legitimamente sem um Customer registrado quando o cenário de negócio permite um comprador não identificado ou convidado.

O domínio de customer permanece responsável pela identidade e pelos dados mestres de Customer.

O domínio de sales permanece responsável pela Transaction comercial.

As informações de Customer não devem ser duplicadas dentro do domínio de sales apenas para evitar o relacionamento entre domínios quando a identidade autoritativa de Customer estiver disponível.

Da mesma forma, a ausência de um relacionamento com Customer não deve exigir a criação de um Customer genérico artificial.

---

### 12.3 Catalog e Sales

Os domínios de catalog e sales interagem por meio de ProductVariant.

Conceitualmente:

```text
catalog.Product
       │
       ▼
catalog.ProductVariant
       │
       └── 1:N ──► sales.TransactionItem
```

ProductVariant representa a identidade específica e comercializável do catálogo.

TransactionItem representa o fato comercial histórico de que a variante foi vendida.

O domínio de sales consome a identidade de ProductVariant, mas preserva seus próprios fatos específicos da transação, como quantidade, preço unitário e desconto unitário.

Essa distinção permite que o catálogo evolua sem alterar fatos históricos de vendas.

Conceitualmente:

```text
catalog
   │
   └── Identidade do produto,
       características,
       mídia e preços

sales
   │
   └── Fato comercial histórico
```

Uma alteração posterior de ProductVariant, atributo, mídia ou preço de catálogo não deve reescrever as condições comerciais já preservadas por TransactionItem.

---

### 12.4 Catalog e Inventory

O domínio de inventory consome a identidade de ProductVariant.

Conceitualmente:

```text
catalog.ProductVariant
          │
          ├──► inventory.Inventory
          │
          ├──► inventory.InventoryMovement
          │
          └──► inventory.InventoryReservation
```

Esses relacionamentos existem porque a responsabilidade de estoque se aplica à variante específica comercializável, e não apenas à identidade mais ampla de Product.

O domínio de catalog permanece autoritativo para ProductVariant.

O domínio de inventory permanece autoritativo por:

- Estado atual do estoque.

- Histórico de movimentações de estoque.

- Estado das reservas de estoque.

Uma alteração nas informações de catalog não deve reescrever eventos históricos de inventory.

Da mesma forma, o estado de estoque não deve ser armazenado em ProductVariant apenas porque inventory consome essa identidade do catálogo.

---

### 12.5 Sales e Inventory

Os domínios de sales e inventory interagem quando uma atividade de estoque precisa ser associada a um TransactionItem comercial.

Conceitualmente:

```text
sales.TransactionItem
        │
        ├──► inventory.InventoryReservation
        │
        └──► inventory.InventoryMovement
             quando aplicável
```

InventoryReservation associa o estoque reservado ao TransactionItem para o qual a reserva existe.

O modelo implementado atual permite, no máximo, um InventoryReservation para um TransactionItem.

InventoryMovement pode referenciar TransactionItem quando o evento de estoque estiver associado àquele item comercial.

O relacionamento é opcional quando a movimentação não possui uma origem de vendas aplicável.

O domínio de sales permanece responsável pelo item adquirido.

O domínio de inventory permanece responsável pela reserva de estoque e pela movimentação física do estoque.

Um fato comercial não deve ser reescrito para representar um evento de estoque.

Da mesma forma, uma movimentação de estoque não deve ser inferida exclusivamente a partir de uma alteração no estado da Transaction quando um evento persistente de inventory for necessário.

---

### 12.6 Sales e Payment

O domínio de payment consome a identidade de Transaction ao registrar atividades financeiras.

Conceitualmente:

```text
sales.Transaction
        │
        └── 1:N ──► payment.Payment
                         │
                         └── 1:N ──► payment.PaymentRefund
```

Uma Transaction pode possuir múltiplos registros de Payment porque tentativas de pagamento e eventos financeiros possuem seu próprio ciclo de vida.

Payment preserva o fato financeiro associado à Transaction.

PaymentRefund preserva o dinheiro devolvido em relação a um Payment previamente registrado.

O domínio de sales permanece responsável pela Transaction comercial.

O domínio de payment permanece responsável pelo ciclo de vida financeiro.

O estado financeiro não deve ser representado exclusivamente por TransactionStatus.

Da mesma forma, um reembolso não deve reescrever a Transaction ou o fato original de Payment apenas para representar a correção financeira resultante.

---

### 12.7 Sales e Shipping

O domínio de shipping consome a identidade de Transaction quando o cenário comercial exige atendimento físico.

Conceitualmente:

```text
sales.Transaction
        │
        └── 0..1 ──► shipping.Shipment
```

Uma Transaction não exige necessariamente um Shipment.

Uma Transaction de loja física pode ser legitimamente concluída sem um registro de shipping.

No modelo atual do AtlasCommerce, uma Transaction pode ter no máximo um Shipment.

Múltiplos destinos de entrega, portanto, exigem Transactions separadas.

O domínio de sales permanece responsável pela Transaction comercial.

O domínio de shipping permanece responsável pelo ciclo de vida logístico.

ShipmentStatus não deve substituir TransactionStatus, e TransactionStatus não deve ser utilizado como substituto do estado logístico detalhado pertencente a shipping.

---

### 12.8 Customer e Shipping

O domínio de shipping consome CustomerAddress quando um Shipment exige um destino de entrega.

Conceitualmente:

```text
customer.Customer
        │
        ▼
customer.CustomerAddress
        │
        └── 1:N ──► shipping.Shipment
```

CustomerAddress representa o relacionamento pertencente ao customer com a identidade compartilhada de Address selecionada para uso comercial.

Shipment referencia o CustomerAddress selecionado para aquela operação de atendimento.

O domínio de customer permanece responsável por CustomerAddress.

O domínio de shipping permanece responsável por Shipment.

Alterações posteriores nos relacionamentos atuais de endereço do cliente não devem reescrever o relacionamento histórico com o endereço de entrega já referenciado por um Shipment existente.

---

### 12.9 Reference e Customer

O domínio de customer consome identidades e classificações compartilhadas pertencentes a `reference`.

Os principais relacionamentos implementados são:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        ▼
customer.Customer
```

e:

```text
reference.ContactType
        │
        ▼
customer.CustomerContact
        │
        ▼
customer.Customer
```

`reference.Address` fornece a identidade compartilhada de endereço.

`customer.CustomerAddress` é responsável pelo relacionamento específico do cliente com esse endereço.

`reference.ContactType` fornece a classificação controlada de contato telefônico.

`customer.CustomerContact` é responsável pelo valor de contato e por seu relacionamento com Customer.

Email é representado independentemente por `customer.CustomerEmail` e não consome ContactType.

O domínio de customer não deve duplicar identidades compartilhadas de reference apenas porque as consome.

Da mesma forma, o domínio de reference não deve assumir a propriedade do estado de ciclo de vida específico do cliente.

---

### 12.10 Reference e Outros Domínios

O domínio `reference` pode ser consumido por outros domínios quando informações compartilhadas forem necessárias.

O princípio é:

```text
reference
   │
   └── Identidade compartilhada autoritativa
                │
                ▼
          Domínio consumidor
```

O fato de múltiplos domínios utilizarem um valor controlado não transforma automaticamente esse valor em uma entidade do domínio de reference.

Classificações controladas específicas de um domínio permanecem sob responsabilidade de seus respectivos domínios.

Exemplos incluem:

```text
customer.CustomerType
customer.CustomerDocumentType
sales.TransactionStatus
sales.TransactionChannel
payment.PaymentStatus
payment.PaymentMethod
payment.PaymentRefundReason
inventory.InventoryMovementReason
inventory.InventoryReservationStatus
shipping.ShipmentMethod
shipping.ShipmentStatus
```

Essas estruturas podem se comportar fisicamente como tabelas de consulta, mas sua propriedade semântica permanece específica de cada domínio.

O AtlasCommerce, portanto, não utiliza `reference` como um contêiner genérico para todos os valores controlados.

---

### 12.11 Relacionamentos entre Domínios Compatíveis com Particionamento

Alguns relacionamentos entre domínios referenciam entidades de sales que participam da arquitetura do AtlasCommerce compatível com particionamento.

Nesses casos, o relacionamento completo implementado pode exigir tanto o identificador técnico estável quanto o componente temporal correspondente.

Conceitualmente:

```text
Identidade da Entidade de Sales
        +
Componente Temporal
        │
        ▼
Chave Referenciada Completa
        │
        ▼
Relacionamento entre Domínios
```

Exemplos incluem relacionamentos de:

```text
payment.Payment
        │
        └──► sales.Transaction

inventory.InventoryReservation
        │
        └──► sales.TransactionItem

shipping.Shipment
        │
        └──► sales.Transaction
```

Quando aplicável, InventoryMovement também pode preservar o relacionamento completo com TransactionItem exigido pela definição relacional implementada.

O componente temporal existe para preservar a compatibilidade com a arquitetura relacional completa e compatível com particionamento.

Ele não cria uma segunda identidade de negócio independente.

O relacionamento lógico permanece entre a entidade consumidora e a entidade de sales correspondente.

---

### 12.12 Integridade Referencial entre Domínios

Os relacionamentos entre domínios que fazem parte do modelo operacional persistente devem preservar a integridade referencial quando exigido pelo projeto relacional implementado.

Conceitualmente:

```text
Entidade Proprietária
     │
     └── Relacionamento de Foreign Key
                  │
                  ▼
          Entidade Referenciada
```

Um limite de schema não enfraquece o requisito de integridade.

Por exemplo, um relacionamento de `payment.Payment` com `sales.Transaction` permanece uma dependência relacional persistente mesmo que as entidades pertençam a schemas diferentes.

A integridade referencial entre domínios garante que:

- As identidades referenciadas existam.

- Os relacionamentos não apontem para entidades inexistentes.

- Relacionamentos obrigatórios permaneçam obrigatórios.

- Relacionamentos opcionais permaneçam explicitamente opcionais.

- Relacionamentos compostos compatíveis com particionamento preservem sua identidade referenciada completa.

- A propriedade dos domínios permaneça rastreável.

As definições detalhadas de Foreign Keys são governadas pelo banco de dados implementado e pelos Padrões de Banco de Dados do AtlasCommerce.

---

### 12.13 Independência de Ciclo de Vida entre Domínios

Entidades relacionadas podem possuir estados de ciclo de vida independentes.

Um relacionamento entre domínios não implica que seus status devam sempre mudar em conjunto.

Conceitualmente:

```text
                  sales.Transaction
                     Comercial
                       Estado
                      /  |  \
                     /   |   \
                    ▼    ▼    ▼
              payment inventory shipping
              Financeiro Estoque Logístico
                Estado   Estado   Estado
```

Por exemplo:

- Um Payment pode estar `APPROVED` enquanto Shipment permanece `PENDING`.

- Um Shipment pode estar `DELIVERED` enquanto o histórico de Payment ainda contém tentativas anteriores `DECLINED`.

- Um InventoryReservation pode estar encerrado enquanto a Transaction permanece comercialmente ativa.

- Um Shipment retornado pode criar consequências posteriores em payment ou inventory sem reescrever o fato logístico original.

Cada domínio deve preservar o estado de ciclo de vida pelo qual é responsável.

Os processos de negócio podem avaliar estados de múltiplos domínios em conjunto, mas o modelo persistente não deve colapsá-los em um único status universal.

---

### 12.14 Preservação Histórica entre Domínios

Os relacionamentos entre domínios devem preservar seu significado histórico quando os dados mestres referenciados ou o estado operacional forem alterados posteriormente.

Conceitualmente:

```text
Fato Operacional Histórico
          │
          └── Referencia identidade estável
                    │
                    ▼
             Domínio Referenciado
```

Exemplos incluem:

- TransactionItem preservando o ProductVariant vendido mesmo após alterações no catálogo.

- TransactionItem preservando o preço e o desconto aplicados à venda independentemente de alterações posteriores no preço de catálogo.

- Shipment preservando o CustomerAddress selecionado para entrega mesmo após alterações posteriores nos endereços do cliente.

- InventoryMovement preservando seu relacionamento com o TransactionItem aplicável quando a movimentação se originou de um evento comercial.

- Payment preservando seu relacionamento com a Transaction original mesmo após a ocorrência de reembolsos.

Fatos históricos não devem ser reescritos apenas porque o estado atual de outro domínio foi alterado.

Isso é essencial para preservar a rastreabilidade em todo o modelo transacional.

---

### 12.15 Consequências de Eventos entre Domínios

Um único evento de negócio pode produzir consequências persistentes em múltiplos domínios.

Conceitualmente:

```text
Evento de Negócio
      │
      ├──► consequência em sales
      ├──► consequência em inventory
      ├──► consequência em payment
      └──► consequência em shipping
```

Essas consequências permanecem fatos separados.

Por exemplo, uma devolução de cliente pode produzir:

```text
Consequência Comercial
        │
        └── sales

Consequência Financeira
        │
        └── payment.PaymentRefund

Consequência de Estoque
        │
        └── inventory.InventoryMovement

Consequência de Atendimento
        │
        └── shipping
             quando aplicável
```

A existência de uma consequência não deve ser utilizada como substituto de outra quando ambas forem exigidas pelo modelo operacional.

Cada domínio registra o fato pelo qual é responsável.

Os processos de negócio entre domínios coordenam esses fatos sem destruir sua independência semântica.

---

### 12.16 Sem Duplicação de Autoridade entre Domínios

Os relacionamentos entre domínios não devem criar cópias autoritativas concorrentes da mesma entidade.

Conceitualmente:

```text
Entidade Autoritativa
       │
       ├──► Domínio A consome
       ├──► Domínio B consome
       └──► Domínio C consome
```

O AtlasCommerce, portanto, favorece relacionamentos em vez de duplicação quando uma identidade persistente autoritativa já existe.

Por exemplo:

- ProductVariant permanece em `catalog`.

- Customer permanece em `customer`.

- CustomerAddress permanece em `customer`.

- Address permanece em `reference`.

- ContactType permanece em `reference`.

- Transaction permanece em `sales`.

- TransactionItem permanece em `sales`.

Domínios consumidores podem preservar fatos específicos da transação ou fatos operacionais derivados dessas identidades quando exigidos por suas próprias responsabilidades, mas não devem silenciosamente se tornar fontes concorrentes de dados mestres.

---

### 12.17 Propriedade do Relacionamento

Um relacionamento entre domínios pertence, sob a perspectiva da dependência, à entidade que necessita desse relacionamento.

Conceitualmente:

```text
Domínio Referenciado
      │
      └── Possui a entidade referenciada

Domínio Consumidor
      │
      └── Possui o relacionamento dependente
```

Por exemplo:

```text
catalog.ProductVariant
      │
      └── pertencente a catalog

sales.TransactionItem
      │
      └── possui seu relacionamento
          com ProductVariant
```

Da mesma forma:

```text
sales.Transaction
      │
      └── pertencente a sales

payment.Payment
      │
      └── possui seu relacionamento
          com Transaction
```

E:

```text
reference.ContactType
      │
      └── pertencente a reference

customer.CustomerContact
      │
      └── possui seu relacionamento
          com ContactType
```

Essa distinção evita ambiguidade ao determinar qual domínio é responsável por manter um relacionamento e qual permanece responsável pela entidade referenciada.

---

### 12.18 Coordenação de Alterações entre Domínios

Uma alteração em uma entidade ou relacionamento pode afetar consumidores de outros domínios.

Essas alterações devem ser avaliadas de acordo com os contratos estabelecidos entre os domínios.

Exemplos incluem alterações em:

- Identidade persistente.

- Composição de chave.

- Semântica do ciclo de vida.

- Comportamento de preservação histórica.

- Opcionalidade.

- Relacionamentos referenciais.

- Estruturas de referência compartilhadas.

Uma alteração em um domínio não deve invalidar silenciosamente os relacionamentos persistentes de outro domínio.

Conceitualmente:

```text
Alteração no Domínio
     │
     ▼
Análise de Impacto nos Relacionamentos
     │
     ├── Sem impacto entre domínios
     │
     └── Com impacto entre domínios
              │
              ▼
        Alteração Coordenada
```

Quando forem necessárias alterações de implementação, elas deverão seguir os princípios controlados de migração e implantação definidos pela Arquitetura e pelos Padrões de Banco de Dados do AtlasCommerce.

---

### 12.19 Resumo dos Relacionamentos entre Domínios

Os principais relacionamentos entre domínios implementados podem ser resumidos como:

| Entidade Proprietária | Entidade Referenciada | Significado do Relacionamento |
|---|---|---|
| `sales.Transaction` | `customer.Customer` | Customer registrado e identificado associado à Transaction comercial quando aplicável |
| `sales.TransactionItem` | `catalog.ProductVariant` | Variante comercializável adquirida na Transaction |
| `inventory.Inventory` | `catalog.ProductVariant` | Estado atual de estoque da variante comercializável |
| `inventory.InventoryMovement` | `catalog.ProductVariant` | ProductVariant afetado pela movimentação de estoque |
| `inventory.InventoryMovement` | `sales.TransactionItem` | Item comercial associado à movimentação quando aplicável |
| `inventory.InventoryReservation` | `sales.TransactionItem` | Item comercial para o qual o estoque está reservado |
| `inventory.InventoryReservation` | `catalog.ProductVariant` | Variante comercializável cujo estoque está reservado |
| `payment.Payment` | `sales.Transaction` | Payment financeiro associado à Transaction comercial |
| `shipping.Shipment` | `sales.Transaction` | Registro de atendimento associado à Transaction quando shipping é necessário |
| `shipping.Shipment` | `customer.CustomerAddress` | Relacionamento de endereço do Customer selecionado para entrega |
| `customer.CustomerAddress` | `reference.Address` | Identidade compartilhada de Address associada ao Customer |
| `customer.CustomerContact` | `reference.ContactType` | Classificação controlada de contato telefônico utilizada pelo CustomerContact |
| `reference.AdministrativeDivision` | `reference.Country` | Country que contém a divisão administrativa |
| `reference.City` | `reference.AdministrativeDivision` | Divisão administrativa que contém a City |
| `reference.Address` | `reference.City` | City associada ao Address |

Essa tabela é um resumo lógico.

Ela não substitui o inventário implementado de Foreign Keys nem reproduz todos os relacionamentos com domínios controlados.

---

### 12.20 Princípio dos Relacionamentos entre Domínios

O AtlasCommerce utiliza relacionamentos entre domínios para preservar um único modelo relacional autoritativo enquanto mantém explícita a propriedade de cada domínio.

Para o modelo atual:

- Os limites de domínio definem responsabilidade, e não isolamento.

- Referenciar uma entidade não transfere a propriedade dessa entidade.

- Identidades autoritativas não devem ser duplicadas apenas para evitar relacionamentos entre domínios.

- Customer pode ser consumido por sales sem fazer com que toda Transaction exija um Customer registrado e identificado.

- ProductVariant é consumido por sales e inventory enquanto permanece pertencente a catalog.

- Address é consumido por meio de CustomerAddress enquanto permanece pertencente a reference.

- ContactType é consumido por CustomerContact enquanto permanece pertencente a reference.

- CustomerAddress é consumido por shipping enquanto permanece pertencente a customer.

- Transaction e TransactionItem são consumidos por outros domínios operacionais enquanto permanecem pertencentes a sales.

- Os estados de ciclo de vida de payment, inventory, shipping e sales permanecem independentes.

- Fatos históricos entre domínios devem preservar seu significado original quando o estado atual for alterado em outras partes do sistema.

- Relacionamentos compatíveis com particionamento preservam a chave relacional completa exigida pela arquitetura física implementada sem alterar a identidade semântica.

- Um evento de negócio pode criar consequências em múltiplos domínios, mas cada consequência permanece pertencente ao domínio responsável por aquele fato.

- Alterações que afetem contratos entre domínios exigem avaliação coordenada.

- A integridade referencial protege os relacionamentos persistentes entre domínios quando exigido pelo modelo implementado.

O princípio central é:

> **O AtlasCommerce integra seus domínios por meio de relacionamentos explícitos enquanto preserva um único proprietário autoritativo para cada identidade e responsabilidade persistente.**

---

## 13. Princípios Históricos e de Ciclo de Vida

O AtlasCommerce distingue o estado operacional atual dos fatos históricos de negócio.

Nem toda alteração em dados operacionais possui o mesmo significado de ciclo de vida.

Algumas entidades representam o estado atual e podem legitimamente ser atualizadas à medida que esse estado se altera.

Outras entidades representam eventos, transações, relacionamentos históricos ou versões cujo significado original deve permanecer preservado após sua criação.

O comportamento apropriado do ciclo de vida depende da responsabilidade da entidade.

Conceitualmente:

```text
Dados Operacionais Persistidos
          │
          ├── Estado Atual
          │       └── Pode evoluir de acordo com
          │           o ciclo de vida da entidade
          │
          └── Fato Histórico
                  └── Preservado de acordo com
                      sua semântica histórica
```

O AtlasCommerce não aplica comportamento exclusivamente de inclusão a todas as entidades.

Da mesma forma, não trata todos os dados persistidos como livremente alteráveis.

A estratégia de ciclo de vida deve preservar o significado dos dados representados por cada entidade.

---

### 13.1 Estado Atual e Fatos Históricos

Entidades de estado atual representam o estado operacional válido no momento presente.

Entidades históricas representam fatos que ocorreram ou versões que foram válidas em determinado momento do ciclo de vida de negócio.

Exemplos de responsabilidades de estado atual incluem:

- Estado atual do ciclo de vida de Product.
- Estado atual do ciclo de vida de ProductVariant.
- Posição atual do estoque.
- Estado atual do ciclo de vida de Payment.
- Estado atual do ciclo de vida de InventoryReservation.
- Estado atual do ciclo de vida de Shipment.
- Relacionamentos atuais ativos ou principais de contato do Customer.

Exemplos de fatos históricos incluem:

- Uma Transaction comercial concluída.
- O ProductVariant vendido em um TransactionItem.
- A quantidade e as condições financeiras registradas em um TransactionItem.
- Um InventoryMovement.
- Uma tentativa de Payment ou evento financeiro registrado.
- Um PaymentRefund.
- Uma versão histórica de ProductVariantPrice.
- Um Shipment associado a uma Transaction.

O fato de uma entidade de estado atual sofrer alterações não autoriza que fatos históricos que a referenciaram ou resultaram de seu estado anterior sejam reescritos.

---

### 13.2 Preservação da Transaction Comercial

Uma Transaction comercial confirmada representa um fato histórico de negócio.

As condições comerciais registradas por seus TransactionItems devem permanecer interpretáveis independentemente de alterações posteriores em outras partes do AtlasCommerce.

Conceitualmente:

```text
catalog.ProductVariant
          │
          ▼
sales.TransactionItem
          │
          ├── Quantidade
          ├── Preço Unitário
          └── Desconto Unitário
```

TransactionItem preserva os fatos comerciais aplicáveis à venda.

Alterações posteriores em:

- Informações de Product.
- Informações de ProductVariant.
- Atributos de Product.
- Mídias do catálogo.
- Precificação do catálogo.
- Estado de estoque.

não devem reescrever as condições comerciais já persistidas pelo TransactionItem.

Essa separação permite que o catálogo represente informações atuais e históricas do catálogo enquanto `sales` preserva o que efetivamente ocorreu na transação comercial.

---

### 13.3 Histórico de Preços do Catálogo

O AtlasCommerce preserva o histórico de preços de ProductVariant por meio de `catalog.ProductVariantPrice`.

Conceitualmente:

```text
catalog.ProductVariant
          │
          └── 1:N ──► catalog.ProductVariantPrice
```

ProductVariantPrice representa o ciclo de vida da precificação de catálogo de um ProductVariant.

Um novo período de preço é representado de acordo com o modelo temporal de precificação implementado, em vez de tratar a linha atual de ProductVariant como o registro histórico de todos os preços que já existiram.

Isso permite ao AtlasCommerce distinguir:

```text
Histórico de Preços do Catálogo
          │
          └── ProductVariantPrice

Condição Efetiva da Venda
          │
          └── sales.TransactionItem
```

Essas responsabilidades são relacionadas, mas não intercambiáveis.

ProductVariantPrice responde a questões sobre o preço de catálogo aplicável de acordo com o ciclo de vida da precificação.

TransactionItem preserva o preço e o desconto efetivamente aplicados a uma transação comercial específica.

Um preço histórico de catálogo não deve ser inferido exclusivamente a partir de TransactionItem porque o preço efetivamente cobrado pode ser diferente do preço de catálogo aplicável.

Da mesma forma, alterações na precificação do catálogo não devem modificar TransactionItems históricos.

---

### 13.4 Ciclo de Vida das Mídias do Catálogo

As mídias do catálogo seguem o ciclo de vida definido pelo modelo implementado de `catalog.ProductImage`.

`ProductImage` é separado de Product porque o conteúdo de mídia possui uma responsabilidade distinta da identidade principal de Product.

Conceitualmente:

```text
catalog.Product
      │
      └── ProductImage
```

Essa separação evita que informações de mídia do produto sejam tratadas como atributos intrínsecos da identidade de Product.

O comportamento histórico deve seguir o ciclo de vida efetivamente implementado por `ProductImage`.

A existência de uma tabela separada não significa automaticamente que toda alteração de mídia deva criar uma versão histórica exclusivamente de inclusão.

Da mesma forma, um estado de ciclo de vida não deve ser criado no Modelo de Domínio quando a estrutura implementada não define esse estado.

---

### 13.5 Ciclo de Vida dos Relacionamentos do Customer

A identidade de Customer e as informações relacionadas ao cliente possuem responsabilidades independentes de ciclo de vida.

Conceitualmente:

```text
customer.Customer
        │
        ├── CustomerDocument
        ├── CustomerContact
        ├── CustomerEmail
        └── CustomerAddress
```

A alteração de um relacionamento associado ao cliente não exige a substituição da identidade de Customer.

CustomerContact e CustomerEmail preservam seus próprios ciclos de vida operacionais, incluindo estados ativo e principal quando aplicáveis.

CustomerAddress preserva o ciclo de vida do relacionamento entre um Customer e uma identidade compartilhada de `reference.Address`.

CustomerDocument preserva as informações de identificação associadas ao Customer de acordo com o modelo de documentos implementado.

A preservação histórica deve ocorrer quando exigida pela semântica de ciclo de vida da entidade ou do relacionamento aplicável.

O AtlasCommerce não deve criar versões históricas artificiais de Customer apenas porque um contato, e-mail, documento ou relacionamento de endereço associado foi alterado.

---

### 13.6 Significado Histórico do Endereço

A identidade geográfica de Address e o relacionamento do Customer com esse Address possuem responsabilidades distintas.

Conceitualmente:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        ▼
shipping.Shipment
```

`reference.Address` é responsável pela identidade compartilhada do endereço.

`customer.CustomerAddress` é responsável pelo relacionamento entre um Customer e esse Address.

`shipping.Shipment` consome o CustomerAddress selecionado para a operação de entrega.

Depois que um Shipment referencia o CustomerAddress aplicável, alterações posteriores nos relacionamentos de endereço atuais do Customer não devem modificar silenciosamente o significado histórico do Shipment existente.

A entrega histórica deve permanecer rastreável ao relacionamento entre Customer e endereço utilizado por aquele Shipment.

---

### 13.7 Estado Atual e Histórico de Movimentações de Estoque

Inventory separa intencionalmente o estado operacional atual do histórico de movimentações.

Conceitualmente:

```text
inventory.Inventory
        │
        └── Estado atual do estoque

inventory.InventoryMovement
        │
        └── Evento histórico de estoque
```

Inventory fornece o estado necessário para o gerenciamento operacional eficiente do estoque.

InventoryMovement explica os eventos de estoque que afetaram esse estado.

Uma movimentação que já ocorreu não deve ser reescrita simplesmente porque um evento posterior reverte ou compensa seu efeito.

Quando o modelo de negócio exigir um evento compensatório de estoque, o evento posterior deve ser representado independentemente para que a movimentação original permaneça historicamente compreensível.

InventoryMovementNote amplia as informações contextuais de um InventoryMovement sem alterar o significado da própria movimentação.

O estado atual de Inventory e o histórico de movimentações devem permanecer consistentes de acordo com as operações de estoque que os produzem.

---

### 13.8 Ciclo de Vida de InventoryReservation

InventoryReservation representa a alocação temporária de estoque para um TransactionItem.

Seu ciclo de vida é distinto tanto do estoque físico atual quanto do histórico permanente de movimentações de estoque.

Conceitualmente:

```text
sales.TransactionItem
        │
        ▼
inventory.InventoryReservation
        │
        ├── reserva criada
        ├── reserva ativa
        └── reserva encerrada
```

O ciclo de vida da reserva deve permanecer distinguível da movimentação física de estoque.

A criação de uma reserva não representa, por si só, o mesmo fato de negócio que um InventoryMovement.

Da mesma forma, o encerramento de uma reserva não apaga o fato de que essa reserva existiu.

O estado da reserva deve, portanto, evoluir de acordo com o ciclo de vida implementado de reservas enquanto preserva o relacionamento histórico com o TransactionItem para o qual o estoque foi reservado.

---

### 13.9 Histórico de Payment e Correções Financeiras

Registros de Payment preservam eventos financeiros associados a uma Transaction.

Conceitualmente:

```text
sales.Transaction
        │
        ▼
payment.Payment
        │
        └── payment.PaymentRefund
```

Um Payment pode evoluir pelo ciclo de vida representado por PaymentStatus.

Entretanto, uma correção financeira posterior não deve apagar o fato de que o Payment original ocorreu.

PaymentRefund representa, portanto, o valor devolvido referente a um Payment como um fato financeiro separado.

Conceitualmente:

```text
Payment Original
      │
      └── preservado
             │
             ▼
       PaymentRefund
             │
             └── fato financeiro posterior
```

Um reembolso não deve ser representado pela exclusão do Payment, pela alteração do valor do Payment de forma a ocultar a transação original ou pela criação de um Payment negativo artificial quando o modelo implementado fornece uma entidade específica para reembolso.

Isso preserva a rastreabilidade financeira.

---

### 13.10 Ciclo de Vida de Shipment

Shipment representa a responsabilidade logística associada a uma Transaction quando a entrega física é necessária.

Conceitualmente:

```text
sales.Transaction
        │
        └── 0..1 ──► shipping.Shipment
```

O ciclo de vida de Shipment é representado independentemente do ciclo de vida comercial da Transaction.

ShipmentStatus representa o estado logístico pertencente ao domínio de shipping.

Uma alteração em ShipmentStatus não deve reescrever os fatos comerciais originais registrados por `sales`.

Da mesma forma, uma alteração em TransactionStatus não deve substituir o estado logístico mantido por Shipment.

No modelo atual, uma Transaction pode ter no máximo um Shipment.

Shipment permanece como a entidade persistente de entrega daquela Transaction quando shipping é necessário.

Transactions concluídas diretamente em uma loja física não exigem a criação artificial de um Shipment apenas para representar sua conclusão.

---

### 13.11 Ciclos de Vida Independentes entre Domínios

Um único processo de negócio pode criar entidades relacionadas cujos estados de ciclo de vida evoluem independentemente.

Conceitualmente:

```text
                  sales.Transaction
                         │
             ┌───────────┼───────────┐
             │           │           │
             ▼           ▼           ▼
         inventory    payment     shipping
             │           │           │
             ▼           ▼           ▼
      Estado de      Estado      Estado
       Estoque      Financeiro   Logístico
```

Por exemplo, em determinado momento:

- Uma Transaction pode estar comercialmente confirmada.
- Seu Payment pode estar aprovado.
- Sua InventoryReservation pode já estar encerrada.
- A movimentação de estoque resultante pode já ter ocorrido.
- Seu Shipment pode ainda estar pendente.

Esses estados não são contraditórios.

Eles representam responsabilidades diferentes dentro do mesmo processo de negócio mais amplo.

O AtlasCommerce não deve, portanto, introduzir um status universal destinado a substituir o estado de ciclo de vida pertencente a cada domínio.

---

### 13.12 Valores Controlados e Significado do Ciclo de Vida

Valores controlados de domínio frequentemente descrevem estados de ciclo de vida, mas o significado desses valores permanece restrito ao domínio proprietário.

Exemplos incluem:

```text
sales.TransactionStatus

payment.PaymentStatus

inventory.InventoryReservationStatus

shipping.ShipmentStatus
```

Essas estruturas não devem ser interpretadas como intercambiáveis apenas porque todas contêm valores semelhantes a status.

Por exemplo:

```text
CONFIRMED
```

em um ciclo de vida comercial não possui necessariamente o mesmo significado de um estado financeiro aprovado ou de um estado logístico concluído.

A semântica do ciclo de vida pertence ao domínio proprietário da classificação controlada.

Por esse motivo, o AtlasCommerce não exige uma abstração universal `reference.Status` para ciclos de vida não relacionados entre si.

---

### 13.13 Dados Temporais Não Significam Automaticamente Histórico

O AtlasCommerce contém valores temporais para diversas finalidades.

Um timestamp pode representar:

- Momento de criação.
- Momento da última atualização.
- Momento da Transaction.
- Momento da tentativa de Payment.
- Momento da aprovação.
- Momento do cancelamento.
- Momento da reserva.
- Expiração da reserva.
- Encerramento da reserva.
- Momento da movimentação de estoque.
- Momento da postagem do Shipment.
- Momento da entrega do Shipment.
- Validade do preço de catálogo.
- Outro evento de ciclo de vida implementado.

A existência de um timestamp não transforma automaticamente uma entidade em uma tabela histórica exclusivamente de inclusão.

Da mesma forma, os metadados `created_at` e `updated_at` não constituem uma trilha completa de auditoria histórica.

A semântica temporal deve ser interpretada de acordo com a responsabilidade da coluna e da entidade específicas.

---

### 13.14 Metadados de Auditoria e Histórico de Negócio

Os metadados padrão de criação e última atualização fornecem rastreabilidade técnica dos registros persistidos.

Conceitualmente:

```text
created_at

updated_at
```

Esses valores respondem a questões técnicas sobre o ciclo de vida da linha.

Eles não respondem automaticamente a questões de histórico de negócio, como:

- Qual preço era válido antes do preço atual?
- Qual evento de estoque alterou o saldo?
- Qual Payment foi reembolsado?
- Qual relacionamento de endereço do Customer foi utilizado por um Shipment?
- Quais condições comerciais foram aplicadas a um TransactionItem?

Essas questões exigem as entidades e os relacionamentos de negócio aplicáveis.

O AtlasCommerce, portanto, distingue metadados técnicos da linha de histórico de negócio.

---

### 13.15 Preservação Histórica e Integridade Referencial

A preservação histórica depende de significado relacional estável.

Quando um fato histórico referencia outra entidade, alterações posteriores de ciclo de vida não devem fazer com que esse relacionamento se torne semanticamente enganoso.

Conceitualmente:

```text
Fato Histórico
      │
      └──► Identidade Referenciada
```

A identidade referenciada pode posteriormente alterar seu estado operacional atual sem invalidar o relacionamento histórico.

Exemplos incluem:

- TransactionItem referenciando o ProductVariant que foi vendido.
- InventoryMovement referenciando o ProductVariant afetado pela movimentação.
- InventoryMovement referenciando o TransactionItem aplicável quando necessário.
- Payment referenciando a Transaction à qual o evento financeiro pertence.
- PaymentRefund referenciando o Payment que está sendo reembolsado.
- Shipment referenciando a Transaction que atende.
- Shipment referenciando o CustomerAddress selecionado para entrega.

A integridade referencial e o projeto do ciclo de vida devem, portanto, atuar em conjunto para preservar a interpretação histórica.

---

### 13.16 Correções e Fatos Compensatórios

Quando um fato histórico de negócio já ocorreu, uma correção posterior normalmente deve preservar o fato original e representar separadamente o evento corretivo quando o modelo de domínio implementado fornece esse mecanismo.

Conceitualmente:

```text
Fato Original
      │
      └── preservado
             │
             ▼
       Fato Corretivo
```

Exemplos incluem:

- InventoryMovement seguido por uma movimentação compensatória de estoque.
- Payment seguido por PaymentRefund.
- Um período posterior de preço de catálogo sucedendo um período anterior de ProductVariantPrice.

Esse princípio não significa que toda correção de dados exija um registro compensatório.

Dados técnicos incorretos que nunca representaram um fato legítimo de negócio podem exigir correção controlada.

A distinção depende de a informação persistida representar um evento histórico real ou apenas um estado incorreto.

Correções que afetem dados persistidos em produção devem seguir os controles operacionais e de migração aplicáveis.

---

### 13.17 Exclusão e Responsabilidade Histórica

A exclusão física deve ser avaliada de acordo com o ciclo de vida e a responsabilidade histórica da entidade.

O AtlasCommerce não impõe uma regra universal segundo a qual nenhuma linha possa ser excluída.

Entretanto, dados que representam fatos históricos de negócio ou relacionamentos necessários não devem ser fisicamente excluídos apenas porque deixaram de representar o estado atual.

Antes que uma exclusão seja considerada, o modelo deve determinar se a linha representa:

- Estado atual substituível.
- Um fato histórico de negócio.
- Uma identidade referenciada.
- Um relacionamento de ciclo de vida.
- Dados controlados gerenciados pelo processo de implantação.
- Metadados técnicos.
- Outra responsabilidade persistida sujeita a requisitos de retenção.

O comportamento de exclusão deve preservar a integridade referencial, a interpretação histórica e os requisitos de negócio aplicáveis.

---

### 13.18 Histórico Operacional vs. Histórico Analítico

O AtlasCommerce preserva o histórico exigido pelo modelo operacional de negócio.

Ele não cria toda forma de histórico que possa futuramente ser útil para fins analíticos.

Conceitualmente:

```text
Histórico Operacional
      │
      └── Exigido pela semântica
          do sistema de origem

Histórico Analítico
      │
      └── Exigido pela análise downstream
```

Exemplos operacionais podem incluir:

- Fatos de Transaction e TransactionItem.
- Histórico de ProductVariantPrice.
- Histórico de InventoryMovement.
- Histórico de Payment e PaymentRefund.
- Relacionamentos históricos de Customer exigidos pelo modelo operacional.

Requisitos analíticos futuros podem exigir adicionalmente:

- Snapshots periódicos.
- Histórico dimensional.
- Dimensões lentamente mutáveis.
- Eventos derivados.
- Transições analíticas de status.
- Agregações históricas.
- Integração histórica entre fontes.

Essas estruturas pertencem à arquitetura downstream de engenharia de dados e análise, a menos que sua semântica também seja necessária ao sistema transacional de origem.

---

### 13.19 Alterações de Ciclo de Vida entre Domínios

Uma alteração de ciclo de vida em um domínio pode gerar consequências em outro domínio sem transferir a propriedade de nenhum dos ciclos de vida.

Conceitualmente:

```text
Evento de Ciclo de Vida
      │
      ├──► Alteração de estado
      │    no domínio proprietário
      │
      └──► Consequência entre domínios
```

Por exemplo, um evento comercial, financeiro, de estoque ou logístico pode exigir que outro domínio registre um fato relacionado.

Os registros resultantes devem permanecer semanticamente independentes.

Um evento de Payment não se torna um evento de Inventory.

Um evento de Inventory não se torna um status comercial.

Um evento de Shipment não se torna um estado de Payment.

O processo de negócio coordena essas responsabilidades enquanto cada domínio preserva o estado e o histórico pelos quais é responsável.

---

### 13.20 Princípio Histórico e de Ciclo de Vida

O AtlasCommerce preserva a distinção entre estado operacional atual e fato histórico de negócio.

Para o modelo atual:

- Entidades de estado atual podem evoluir de acordo com seu ciclo de vida implementado.
- Fatos comerciais históricos devem permanecer interpretáveis após alterações posteriores nos dados mestres.
- TransactionItem preserva as condições financeiras efetivamente aplicadas a uma venda.
- ProductVariantPrice preserva o histórico de preços do catálogo.
- Histórico de preços do catálogo e preço efetivamente praticado na venda são responsabilidades distintas.
- ProductImage segue o ciclo de vida definido por sua estrutura implementada e não deve ser considerado exclusivamente de inclusão apenas por ser representado separadamente de Product.
- A identidade de Customer permanece separada do ciclo de vida de contatos, e-mails, documentos e relacionamentos de endereço.
- CustomerContact e CustomerEmail preservam seus próprios estados ativo e principal.
- Inventory preserva o estado atual do estoque.
- InventoryMovement preserva o histórico de eventos de estoque.
- InventoryReservation preserva seu ciclo de vida independentemente da movimentação física de estoque.
- Payment preserva eventos financeiros.
- PaymentRefund preserva eventos posteriores de devolução de valores sem reescrever o Payment original.
- Shipment preserva a responsabilidade logística independentemente do ciclo de vida da Transaction.
- Uma Transaction pode ter no máximo um Shipment no modelo atualmente implementado.
- Transactions realizadas em loja física não exigem registros artificiais de Shipment.
- Status específicos de cada domínio preservam significados independentes de ciclo de vida.
- Timestamps técnicos de auditoria não substituem o histórico de negócio.
- Colunas temporais devem ser interpretadas de acordo com sua semântica específica de negócio ou técnica.
- Correções de fatos históricos legítimos devem preservar o fato original quando o modelo implementado fornecer um mecanismo compensatório.
- O histórico operacional pertence ao AtlasCommerce quando exigido pela semântica do sistema de origem.
- O histórico analítico pertence às camadas downstream quando existir exclusivamente para atender a requisitos analíticos.

O princípio central é:

> **O estado atual pode evoluir, mas um fato de negócio que precisa explicar o que realmente ocorreu deve preservar seu significado histórico.**

---

## 14. Modelo Implementado vs. Extensões Futuras

O Modelo de Domínio do AtlasCommerce distingue explicitamente entre capacidades representadas pelo modelo de banco de dados atualmente validado e capacidades que podem ser introduzidas em versões futuras.

A existência de um conceito de negócio, possibilidade técnica ou requisito previsto não significa que a estrutura correspondente pertença à implementação atual.

Da mesma forma, uma capacidade que já passou a fazer parte do modelo validado do AtlasCommerce não deve continuar sendo descrita como uma extensão futura.

Conceitualmente:

```text
Modelo de Domínio do AtlasCommerce
          │
          ├── Modelo Implementado
          │       └── Estrutura persistente
          │           atualmente validada
          │
          └── Extensão Futura
                  └── Introduzida somente quando
                      justificada por requisitos
```

Essa distinção protege o modelo atual contra complexidade especulativa enquanto preserva um caminho claro para evolução controlada.

---

### 14.1 Modelo Implementado

O modelo implementado representa as estruturas persistentes atualmente estabelecidas e validadas como parte do AtlasCommerce.

No nível de domínio, o modelo implementado inclui:

```text
metadata

catalog

customer

inventory

payment

reference

sales

shipping
```

Esses domínios representam coletivamente o modelo atual do sistema transacional de origem.

O modelo implementado inclui as entidades, relacionamentos, domínios controlados, estruturas de ciclo de vida, regras de integridade e características físicas aplicáveis representadas pelo banco de dados validado do AtlasCommerce.

A documentação que descreve capacidades implementadas deve permanecer sincronizada com essa implementação validada.

---

### 14.2 Capacidades Implementadas de Catalog

O domínio Catalog atual inclui as estruturas persistentes necessárias para representar:

- Brand.

- Product.

- ProductVariant.

- Hierarquia de Category.

- Relacionamentos entre Product e Category.

- Imagens de Product.

- Atributos de Product.

- Valores controlados de atributos de Product.

- Relacionamentos entre ProductVariant e valores de atributos.

- Histórico de preços de ProductVariant.

Conceitualmente:

```text
catalog

│

├── Brand

├── Category

├── Product

├── ProductCategory

├── ProductImage

├── ProductVariant

├── ProductAttribute

├── ProductAttributeValue

├── ProductVariantAttributeValue

└── ProductVariantPrice
```

As capacidades representadas por essas entidades fazem parte do modelo atual e não devem ser descritas apenas como funcionalidades futuras planejadas.

Em particular:

- Imagens de Product fazem parte do modelo de catalog implementado.

- O histórico de preços de ProductVariant faz parte do modelo de catalog implementado.

- Características variáveis de ProductVariant são representadas pelo modelo de atributos implementado.

- `ProductVariantAttributeValue` associa ProductVariant a registros controlados de `ProductAttributeValue`.

Capacidades futuras de catalog devem, portanto, estender essa estrutura existente em vez de serem descritas como se essas responsabilidades ainda estivessem ausentes.

---

### 14.3 Capacidades Implementadas de Customer

O domínio Customer atual inclui:

- CustomerType.

- Customer.

- CustomerDocument.

- CustomerDocumentType.

- CustomerContact.

- CustomerEmail.

- CustomerAddress.

Conceitualmente:

```text
customer

│

├── CustomerType

├── Customer

├── CustomerDocument

├── CustomerDocumentType

├── CustomerContact

├── CustomerEmail

└── CustomerAddress
```

O modelo atual não utiliza uma entidade Contact independente e reutilizável.

Informações de contato telefônico são representadas por CustomerContact.

Informações de email são representadas independentemente por CustomerEmail.

CustomerContact consome `reference.ContactType`.

CustomerAddress consome `reference.Address`.

Essas estruturas representam o modelo de customer atualmente implementado e não devem ser substituídas na documentação por alternativas conceituais anteriores.

---

### 14.4 Capacidades Implementadas de Reference

O domínio Reference atual inclui:

- Country.

- AdministrativeDivision.

- City.

- Address.

- ContactType.

Conceitualmente:

```text
reference

│

├── Country

│      │

│      ▼

│   AdministrativeDivision

│      │

│      ▼

│     City

│      │

│      ▼

│   Address

│

└── ContactType
```

O modelo atual não exige uma entidade genérica `reference.Status` para responsabilidades de ciclo de vida não relacionadas.

Classificações de ciclo de vida específicas de domínio permanecem dentro do domínio responsável por seu significado.

O modelo geográfico pode tecnicamente representar localidades além do escopo comercial atual sem implicar que o comércio internacional esteja atualmente implementado.

---

### 14.5 Capacidades Implementadas de Sales

O domínio Sales atual inclui:

- Transaction.

- TransactionItem.

- TransactionChannel.

- TransactionStatus.

Conceitualmente:

```text
sales

│

├── TransactionChannel

├── TransactionStatus

├── Transaction

└── TransactionItem
```

Transaction representa a compra comercial.

TransactionItem representa o ProductVariant, a quantidade, o preço unitário e o desconto unitário associados ao item comprado.

O modelo atual permite uma Transaction sem um Customer registrado identificado quando o cenário de negócio aplicável permitir.

O modelo atual de sales não deve ser documentado utilizando estruturas conceituais obsoletas como Order, OrderItem ou OrderItemCancellation quando essas entidades não fazem parte do banco de dados AtlasCommerce implementado.

Requisitos futuros envolvendo eventos comerciais adicionais devem ser avaliados em relação ao modelo implementado de Transaction e TransactionItem, em vez de restaurar automaticamente entidades conceituais anteriores.

---

### 14.6 Capacidades Implementadas de Inventory

O domínio Inventory atual inclui:

- Inventory.

- InventoryMovementReason.

- InventoryMovement.

- InventoryMovementNote.

- InventoryReservationStatus.

- InventoryReservation.

Conceitualmente:

```text
inventory

│

├── Inventory

├── InventoryMovementReason

├── InventoryMovement

├── InventoryMovementNote

├── InventoryReservationStatus

└── InventoryReservation
```

O modelo implementado distingue:

- Estado atual de estoque.

- Histórico de movimentações de estoque.

- Contexto das movimentações de estoque.

- Estado temporário das reservas de estoque.

Inventory opera diretamente em relação a ProductVariant.

Quando aplicável, reservas e movimentações de estoque preservam relacionamentos com TransactionItem de acordo com o modelo relacional implementado.

A implementação atual não exige uma entidade Warehouse para representar o estado de estoque.

Um requisito futuro para múltiplas localizações físicas de estoque deve, portanto, ser tratado como uma extensão arquitetural, e não presumido como existente no modelo atual.

---

### 14.7 Capacidades Implementadas de Payment

O domínio Payment atual inclui:

- PaymentMethod.

- PaymentStatus.

- PaymentRefundReason.

- Payment.

- PaymentRefund.

Conceitualmente:

```text
payment

│

├── PaymentMethod

├── PaymentStatus

├── PaymentRefundReason

├── Payment

└── PaymentRefund
```

Payment representa a atividade financeira associada a uma Transaction.

PaymentRefund representa o dinheiro devolvido em relação a um Payment previamente registrado.

O modelo atual, portanto, já oferece suporte à persistência explícita de reembolsos.

A funcionalidade de reembolso não deve ser descrita como uma capacidade futura quando a referência for o modelo atual validado do AtlasCommerce.

Capacidades financeiras futuras devem estender as responsabilidades existentes de Payment e PaymentRefund em vez de substituí-las por estruturas conceituais obsoletas.

---

### 14.8 Capacidades Implementadas de Shipping

O domínio Shipping atual inclui:

- ShipmentMethod.

- ShipmentStatus.

- Shipment.

Conceitualmente:

```text
shipping

│

├── ShipmentMethod

├── ShipmentStatus

└── Shipment
```

Shipment representa o atendimento físico quando uma Transaction exige entrega.

O modelo atual permite no máximo um Shipment por Transaction.

Uma Transaction concluída diretamente em uma loja física não exige um Shipment.

O modelo atual não implementa:

- ShipmentItem.

- ShipmentEvent.

- ShipmentEventNote.

- ShipmentDeliveryEstimate.

- Carrier como uma entidade independente.

- Múltiplos Shipments para uma única Transaction.

- Divisão de Shipments baseada em Warehouse.

Esses conceitos, portanto, não devem ser descritos como capacidades atuais do AtlasCommerce.

Caso requisitos futuros de atendimento os justifiquem, eles devem ser introduzidos por meio de evolução controlada do modelo.

---

### 14.9 Conceitos Removidos do Modelo Atual

Alguns conceitos podem ter aparecido durante etapas anteriores da modelagem sem terem se tornado parte do modelo final implementado.

Esses conceitos não devem permanecer documentados como se fossem entidades atuais.

Exemplos incluem:

- Order.

- OrderItem.

- OrderItemCancellation.

- Warehouse.

- ShipmentItem.

- ShipmentEvent.

- ShipmentEventNote.

- ShipmentDeliveryEstimate.

- Contact independente e reutilizável.

- Status genérico compartilhado.

- Modelos anteriores de atendimento que permitiam múltiplos Shipments por transação comercial.

Esses conceitos permanecem úteis como evidência da exploração de design, mas não definem o modelo persistente atual do AtlasCommerce.

A documentação destinada a descrever o sistema atual deve utilizar a terminologia e os relacionamentos implementados.

Conceitualmente:

```text
Exploração Anterior de Design
          │
          └── Não se torna automaticamente
              arquitetura atual

Implementação Validada
          │
          └── Define o modelo atual
```

Um conceito removido não deve ser reintroduzido apenas porque existia em uma versão anterior.

Sua reintrodução exige um requisito atual e uma nova decisão de design.

---

### 14.10 Extensões Futuras São Orientadas por Requisitos

O AtlasCommerce pode evoluir para oferecer suporte a capacidades adicionais de negócio e técnicas.

Possíveis extensões futuras podem incluir requisitos relacionados a:

- Múltiplas localizações de estoque.

- Gerenciamento de Warehouse.

- Atendimento mais complexo.

- Divisão de Shipments.

- Múltiplos destinos de entrega.

- Integração com transportadoras.

- Histórico detalhado de eventos logísticos.

- Histórico de estimativas de entrega.

- Métodos de pagamento adicionais.

- Fluxos adicionais de reembolso.

- Classificações adicionais de Customer.

- Tipos adicionais de documentos.

- Classificações adicionais de contato.

- Operação comercial internacional.

- Capacidades adicionais de catalog.

- Requisitos adicionais de preços.

- Histórico operacional adicional.

- Integrações adicionais do sistema de origem.

Essa lista representa possíveis áreas de evolução.

Ela não representa um roteiro de implementação comprometido.

Uma capacidade futura deve ser introduzida somente quando um requisito concreto de negócio, operação, integração, conformidade, escalabilidade ou análise justificar sua adição ao modelo transacional.

---

### 14.11 Warehouse e Estoque em Múltiplas Localizações no Futuro

O modelo atual de Inventory não introduz Warehouse como parte da identidade de estoque implementada.

Caso o AtlasCommerce futuramente exija posições independentes de estoque em múltiplas localizações físicas, o modelo poderá precisar evoluir.

Conceitualmente, um requisito futuro poderia introduzir responsabilidades como:

```text
ProductVariant

      │

      ▼

Localização de Estoque

      │

      ▼

Estoque Específico da Localização
```

Entretanto, o design final deve ser avaliado quando o requisito existir.

O modelo atual não deve ser prematuramente projetado em torno de uma abstração Warehouse ainda não implementada.

A introdução de múltiplas localizações de estoque poderia afetar:

- Identidade de Inventory.

- InventoryMovement.

- InventoryReservation.

- Atendimento.

- Transferências.

- Relacionamentos referenciais.

- Unicidade.

- Indexação.

- Migração de dados.

- Semântica analítica downstream.

Essa mudança exigiria, portanto, uma evolução coordenada da arquitetura e do modelo de dados.

---

### 14.12 Complexidade Futura de Fulfillment

O modelo atual de atendimento oferece suporte a no máximo um Shipment por Transaction.

Caso requisitos futuros introduzam:

- Múltiplas localizações de origem.

- Atendimento parcial.

- Divisão de Shipments.

- Shipments de substituição.

- Shipments complementares.

- Múltiplos destinos de entrega.

- Alocação de itens no nível de Shipment.

o modelo atual de shipping poderá exigir extensão.

Conceitualmente:

```text
Modelo Atual

Transaction

    │

    └── 0..1 Shipment


Possível Requisito Futuro

Transaction

    │

    ├── Shipment

    ├── Shipment

    └── Shipment

          │

          └── Alocação de Itens
```

Essa possível estrutura futura não faz parte do modelo atual.

Sua implementação exigiria decisões explícitas relacionadas a:

- Identidade de Shipment.

- Cardinalidade entre Transaction e Shipment.

- Alocação de itens.

- Responsabilidade de Inventory.

- Conclusão do atendimento.

- Custo de shipping.

- Relacionamentos de endereço.

- Atendimento de substituição.

- Preservação histórica.

O modelo atual não deve carregar essa complexidade antes que o requisito exista.

---

### 14.13 Internacionalização Futura

O modelo geográfico atual pode representar Country, AdministrativeDivision, City e Address.

Isso não significa que o AtlasCommerce implemente atualmente comércio internacional.

A expansão da operação comercial além do escopo atual poderia exigir alterações envolvendo:

- Documentos de Customer.

- Requisitos de endereço.

- Códigos postais.

- Divisões administrativas.

- Moeda.

- Tributação.

- Métodos de pagamento.

- Processamento de pagamentos.

- Shipping.

- Preços.

- Localização.

- Requisitos regulatórios.

Conceitualmente:

```text
Capacidade Geográfica

        ≠

Capacidade de Comércio Internacional
```

A operação internacional deve, portanto, ser tratada como uma extensão mais ampla de negócio e arquitetura, e não inferida a partir da existência de Country no modelo de reference.

---

### 14.14 Requisitos Analíticos Futuros

Requisitos analíticos futuros não devem expandir automaticamente o modelo transacional do AtlasCommerce.

A plataforma downstream do Atlas Engineering poderá exigir:

- Dimensões históricas.

- Snapshots.

- Eventos derivados.

- Classificações analíticas.

- Agregações.

- Estruturas de qualidade de dados.

- Identidades entre fontes.

- Interpretações analíticas de preços.

- Segmentação de clientes.

- Métricas de atendimento.

- Análises de estoque.

Esses requisitos pertencem ao ambiente downstream quando existem exclusivamente para oferecer suporte ao consumo analítico.

Conceitualmente:

```text
Requisito Operacional
        │
        └── Pode justificar alteração
            no AtlasCommerce

Requisito Analítico
        │
        └── Normalmente implementado downstream
            a menos que a semântica da fonte o exija
```

O modelo transacional deve ser estendido para fins analíticos somente quando a informação necessária também representar uma responsabilidade operacional legítima do sistema de origem.

---

### 14.15 Capacidades Futuras de Extração e Integração

O AtlasCommerce é o sistema transacional de origem.

Os mecanismos utilizados para extrair seus dados para componentes downstream do Atlas Engineering não são definidos pelo Modelo de Domínio.

Fases futuras de engenharia de dados podem introduzir:

- Ingestão incremental.

- Cargas completas ou iniciais.

- Extração baseada em alterações.

- Réplicas ou cópias dedicadas para leitura.

- Mecanismos baseados no log de transações.

- Orquestração.

- Limites reiniciáveis de ingestão.

- Validação de qualidade de dados.

- Observabilidade.

- Integração adicional de sistemas de origem.

Essas capacidades pertencem à arquitetura de engenharia de dados.

Elas podem impor requisitos de consumo da fonte, mas não devem redefinir o modelo transacional do AtlasCommerce apenas por conveniência de implementação.

---

### 14.16 Evolução das Capacidades Implementadas

Uma extensão futura torna-se parte do modelo implementado somente depois de ter sido:

```text
Requerida

   │

   ▼

Projetada

   │

   ▼

Revisada

   │

   ▼

Implementada

   │

   ▼

Validada

   │

   ▼

Documentada como Implementada
```

Até que esse processo seja concluído, a capacidade permanece como direção futura, e não como comportamento atual do AtlasCommerce.

Depois de implementada e validada, a documentação deve ser atualizada para que a capacidade deixe de ser descrita apenas como futura.

Isso impede que a documentação se desvie nas duas direções:

- Descrever capacidades inexistentes como implementadas.

- Descrever capacidades implementadas como trabalho futuro.

---

### 14.17 Princípio de Simplificação do Modelo

O AtlasCommerce evita intencionalmente estruturas especulativas.

Uma possível necessidade futura não é motivo suficiente para introduzir hoje uma entidade, relacionamento, coluna, status ou estrutura física.

Conceitualmente:

```text
Possível Necessidade Futura

        │

        ▼

Não modelar automaticamente

        │

        ▼

Aguardar requisito concreto

        │

        ▼

Projetar com evidências
```

Esse princípio reduz:

- Entidades não utilizadas.

- Relacionamentos desnecessários.

- Estados artificiais de ciclo de vida.

- Abstrações prematuras.

- Complexidade de deployment.

- Complexidade de integridade.

- Carga de documentação.

- Carga de migração causada por suposições incorretas.

O objetivo não é tornar o modelo mínimo a qualquer custo.

O objetivo é tornar justificável cada estrutura implementada.

---

### 14.18 Compatibilidade com Evolução Futura

Evitar design especulativo não significa ignorar a evolução futura.

As estruturas atuais devem preservar extensibilidade razoável quando isso puder ser alcançado sem introduzir complexidade desnecessária.

Por exemplo:

- A propriedade dos domínios permanece explícita.

- Valores controlados utilizam estruturas específicas de domínio quando justificadas.

- Identidades geográficas compartilhadas permanecem separadas dos domínios consumidores.

- Características de Product utilizam um modelo extensível de atributos.

- Preços de catalog utilizam uma estrutura temporal dedicada.

- PaymentRefund permanece separado de Payment.

- O estado atual de Inventory permanece separado do histórico de movimentações.

- Shipping permanece como um domínio distinto de sales.

Essas decisões permitem evolução futura sem exigir que o modelo atual implemente antecipadamente todas as capacidades futuras possíveis.

---

### 14.19 Evolução da Documentação

À medida que o modelo evolui, a documentação deve evoluir com ele.

Quando uma capacidade futura se torna implementada:

- O Modelo de Domínio deve descrevê-la como atual.

- A documentação de arquitetura deve refletir os limites afetados.

- A Documentação de Negócio deve refletir o comportamento de negócio aplicável.

- Os Padrões de Banco de Dados devem ser atualizados caso novas convenções de implementação sejam introduzidas.

- O deployment deve implementar as estruturas necessárias.

- A Validação Final deve validar o estado esperado resultante.

Quando uma capacidade anteriormente proposta for abandonada, a documentação atual não deve continuar apresentando-a como planejada apenas porque apareceu em um artefato de design anterior.

A documentação deve representar a direção atual intencional, em vez de preservar todas as possibilidades históricas de design.

---

### 14.20 Princípio do Modelo Implementado vs. Extensões Futuras

O AtlasCommerce distingue a implementação validada da possível evolução futura.

Para o modelo atual:

- O banco de dados implementado define a estrutura persistente atual após sua validação.

- Catalog inclui ProductImage e ProductVariantPrice.

- O histórico de preços de catalog está implementado.

- As características de ProductVariant são associadas por meio de ProductVariantAttributeValue.

- CustomerEmail está implementado.

- CustomerContact existe sem uma entidade Contact independente e reutilizável.

- ContactType pertence a `reference`.

- Uma entidade genérica `reference.Status` não faz parte do modelo atual.

- PaymentRefund está implementado.

- InventoryReservation está implementado.

- InventoryMovement e InventoryMovementNote estão implementados.

- Warehouse não faz parte do modelo atual.

- Inventory não é atualmente modelado por Warehouse.

- Uma Transaction pode ter no máximo um Shipment.

- Transactions de loja física podem legitimamente não possuir Shipment.

- ShipmentItem e estruturas detalhadas de eventos de Shipment não fazem parte do modelo atual.

- Entidades conceituais anteriores não definem a arquitetura atual apenas porque apareceram durante a exploração de design.

- Possíveis capacidades futuras não representam compromissos.

- Novas estruturas transacionais exigem justificativa concreta.

- Requisitos analíticos permanecem downstream, a menos que também representem responsabilidades operacionais do sistema de origem.

- Depois que uma capacidade futura é implementada e validada, a documentação deve promovê-la de direção futura para modelo implementado.

- Alternativas conceituais obsoletas não devem permanecer misturadas à documentação da implementação atual.

O princípio central é:

> **O AtlasCommerce implementa o que o modelo operacional atual exige, preserva espaço para evolução justificada e não transforma requisitos futuros hipotéticos em complexidade presente.**

---

## Princípio de Encerramento

O AtlasCommerce é o sistema transacional de origem da plataforma Atlas Engineering.

Seu Modelo de Domínio representa a estrutura operacional persistente necessária para sustentar o modelo de negócio atual de varejo, preservando propriedade explícita, integridade relacional, significado histórico e evolução controlada.

O modelo implementado está organizado nos seguintes domínios:

```text
AtlasCommerce
│
├── metadata
├── catalog
├── customer
├── inventory
├── payment
├── reference
├── sales
└── shipping