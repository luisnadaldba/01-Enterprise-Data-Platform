# AtlasCommerce — Dicionário de Dados

## Índice

- [1. Objetivo](#1-objetivo)
- [2. Referência Oficial](#2-referência-oficial)
- [3. Visão Geral do Banco de Dados](#3-visão-geral-do-banco-de-dados)
- [4. Escopo de Recursos do Banco de Dados](#4-escopo-de-recursos-do-banco-de-dados)
- [5. Estrutura do Dicionário](#5-estrutura-do-dicionário)
- [6. Descrições das Tabelas](#6-descrições-das-tabelas)
  - [6.1. `catalog`](#61-catalog)
  - [6.2. `customer`](#62-customer)
  - [6.3. `inventory`](#63-inventory)
  - [6.4. `metadata`](#64-metadata)
  - [6.5. `payment`](#65-payment)
  - [6.6. `reference`](#66-reference)
  - [6.7. `sales`](#67-sales)
  - [6.8. `shipping`](#68-shipping)

- [7. *Schemas*](#7-schemas)
  - [7.1. `catalog`](#71-catalog)
    - [7.1.1. `catalog.Brand`](#711-catalogbrand)
    - [7.1.2. `catalog.Category`](#712-catalogcategory)
    - [7.1.3. `catalog.Product`](#713-catalogproduct)
    - [7.1.4. `catalog.ProductAttribute`](#714-catalogproductattribute)
    - [7.1.5. `catalog.ProductAttributeValue`](#715-catalogproductattributevalue)
    - [7.1.6. `catalog.ProductCategory`](#716-catalogproductcategory)
    - [7.1.7. `catalog.ProductImage`](#717-catalogproductimage)
    - [7.1.8. `catalog.ProductVariant`](#718-catalogproductvariant)
    - [7.1.9. `catalog.ProductVariantAttributeValue`](#719-catalogproductvariantattributevalue)
    - [7.1.10. `catalog.ProductVariantPrice`](#7110-catalogvariantprice)
  - [7.2. `customer`](#72-customer)
    - [7.2.1. `customer.Customer`](#721-customercustomer)
    - [7.2.2. `customer.CustomerAddress`](#722-customercustomeraddress)
    - [7.2.3. `customer.CustomerContact`](#723-customercustomercontact)
    - [7.2.4. `customer.CustomerDocument`](#724-customercustomerdocument)
    - [7.2.5. `customer.CustomerDocumentType`](#725-customercustomerdocumenttype)
    - [7.2.6. `customer.CustomerEmail`](#726-customercustomeremail)
    - [7.2.7. `customer.CustomerType`](#727-customercustomertype)
  - [7.3. `inventory`](#73-inventory)
    - [7.3.1. `inventory.Inventory`](#731-inventoryinventory)
    - [7.3.2. `inventory.InventoryMovement`](#732-inventoryinventorymovement)
    - [7.3.3. `inventory.InventoryMovementNote`](#733-inventoryinventorymovementnote)
    - [7.3.4. `inventory.InventoryMovementReason`](#734-inventoryinventorymovementreason)
    - [7.3.5. `inventory.InventoryReservation`](#735-inventoryinventoryreservation)
    - [7.3.6. `inventory.InventoryReservationStatus`](#736-inventoryinventoryreservationstatus)
  - [7.4. `metadata`](#74-metadata)
    - [7.4.1. `metadata.TablePrefix`](#741-metadatatableprefix)
  - [7.5. `payment`](#75-payment)
    - [7.5.1. `payment.Payment`](#751-paymentpayment)
    - [7.5.2. `payment.PaymentMethod`](#752-paymentpaymentmethod)
    - [7.5.3. `payment.PaymentRefund`](#753-paymentpaymentrefund)
    - [7.5.4. `payment.PaymentRefundReason`](#754-paymentpaymentrefundreason)
    - [7.5.5. `payment.PaymentStatus`](#755-paymentpaymentstatus)
  - [7.6. `reference`](#76-reference)
    - [7.6.1. `reference.Address`](#761-referenceaddress)
    - [7.6.2. `reference.AdministrativeDivision`](#762-referenceadministrativedivision)
    - [7.6.3. `reference.City`](#763-referencecity)
    - [7.6.4. `reference.ContactType`](#764-referencecontacttype)
    - [7.6.5. `reference.Country`](#765-referencecountry)
  - [7.7. `sales`](#77-sales)
    - [7.7.1. `sales.Transaction`](#771-salestransaction)
    - [7.7.2. `sales.TransactionChannel`](#772-salestransactionchannel)
    - [7.7.3. `sales.TransactionItem`](#773-salestransactionitem)
    - [7.7.4. `sales.TransactionStatus`](#774-salestransactionstatus)
  - [7.8. `shipping`](#78-shipping)
    - [7.8.1. `shipping.Shipment`](#781-shippingshipment)
    - [7.8.2. `shipping.ShipmentMethod`](#782-shipmentmethod)
    - [7.8.3. `shipping.ShipmentStatus`](#783-shipmentstatus)

- [8. Valores Controlados e Dados Iniciais](#8-valores-controlados-e-dados-iniciais)
  - [8.1. `customer.CustomerDocumentType`](#81-customercustomerdocumenttype)
  - [8.2. `customer.CustomerType`](#82-customercustomertype)
  - [8.3. `inventory.InventoryMovementReason`](#83-inventoryinventorymovementreason)
  - [8.4. `inventory.InventoryReservationStatus`](#84-inventoryinventoryreservationstatus)
  - [8.5. `payment.PaymentMethod`](#85-paymentpaymentmethod)
  - [8.6. `payment.PaymentRefundReason`](#86-paymentpaymentrefundreason)
  - [8.7. `payment.PaymentStatus`](#87-paymentpaymentstatus)
  - [8.8. `reference.ContactType`](#88-referencecontacttype)
  - [8.9. `sales.TransactionChannel`](#89-salestransactionchannel)
  - [8.10. `sales.TransactionStatus`](#810-salestransactionstatus)
  - [8.11. `shipping.ShipmentMethod`](#811-shippingshipmentmethod)
  - [8.12. `shipping.ShipmentStatus`](#812-shipmentstatus)

- [9. Dados Iniciais de Governança Técnica](#9-dados-iniciais-de-governança-técnica)
  - [9.1. `metadata.TablePrefix`](#91-metadatatableprefix)

- [10. Metadados Estruturais](#10-metadados-estruturais)
  - [10.1. *Primary Keys*](#101-primary-keys)
    - [10.1.1. `catalog`](#1011-catalog)
    - [10.1.2. `customer`](#1012-customer)
    - [10.1.3. `inventory`](#1013-inventory)
    - [10.1.4. `metadata`](#1014-metadata)
    - [10.1.5. `payment`](#1015-payment)
    - [10.1.6. `reference`](#1016-reference)
    - [10.1.7. `sales`](#1017-sales)
    - [10.1.8. `shipping`](#1018-shipping)
  - [10.2. *UNIQUE Constraints*](#102-unique-constraints)
    - [10.2.1. `catalog`](#1021-catalog)
    - [10.2.2. `customer`](#1022-customer)
    - [10.2.3. `inventory`](#1023-inventory)
    - [10.2.4. `metadata`](#1024-metadata)
    - [10.2.5. `payment`](#1025-payment)
    - [10.2.6. `reference`](#1026-reference)
    - [10.2.7. `sales`](#1027-sales)
    - [10.2.8. `shipping`](#1028-shipping)
  - [10.3. *CHECK Constraints*](#103-check-constraints)
    - [10.3.1. `catalog`](#1031-catalog)
    - [10.3.2. `customer`](#1032-customer)
    - [10.3.3. `inventory`](#1033-inventory)
    - [10.3.4. `metadata`](#1034-metadata)
    - [10.3.5. `payment`](#1035-payment)
    - [10.3.6. `reference`](#1036-reference)
    - [10.3.7. `sales`](#1037-sales)
    - [10.3.8. `shipping`](#1038-shipping)
  - [10.4. *FOREIGN KEY Constraints*](#104-foreign-key-constraints)
    - [10.4.1. `catalog`](#1041-catalog)
    - [10.4.2. `customer`](#1042-customer)
    - [10.4.3. `inventory`](#1043-inventory)
    - [10.4.4. `payment`](#1044-payment)
    - [10.4.5. `reference`](#1045-reference)
    - [10.4.6. `sales`](#1046-sales)
    - [10.4.7. `shipping`](#1047-shipping)
  - [10.5. Índices](#105-índices)
    - [10.5.1. `catalog`](#1051-catalog)
    - [10.5.2. `customer`](#1052-customer)
    - [10.5.3. `inventory`](#1053-inventory)
    - [10.5.4. `payment`](#1054-payment)
    - [10.5.5. `sales`](#1055-sales)
      - [Índices Alinhados ao Particionamento](#índices-alinhados-ao-particionamento)
    - [10.5.6. `shipping`](#1056-shipping)
  - [10.6. Particionamento](#106-particionamento)
    - [10.6.1. Mapeamento de Partições](#1061-mapeamento-de-partições)
    - [10.6.2. Estruturas Alinhadas ao Particionamento](#1062-estruturas-alinhadas-ao-particionamento)
    - [10.6.3. Próximo Filegroup Utilizado](#1063-próximo-filegroup-utilizado)
  - [10.7. *DEFAULT Constraints*](#107-default-constraints)
    - [10.7.1. `catalog`](#1071-catalog)
    - [10.7.2. `customer`](#1072-customer)
    - [10.7.3. `inventory`](#1073-inventory)
    - [10.7.4. `metadata`](#1074-metadata)
    - [10.7.5. `payment`](#1075-payment)
    - [10.7.6. `reference`](#1076-reference)
    - [10.7.7. `sales`](#1077-sales)
    - [10.7.8. `shipping`](#1078-shipping)
  - [10.8. *Triggers*](#108-triggers)

---

## 1. Objetivo

Este documento fornece o dicionário de dados técnico do banco de dados transacional AtlasCommerce.

Ele documenta os objetos de banco de dados implementados diretamente a partir de metadados validados do SQL Server e fornece uma referência estruturada para *schemas* (esquemas), tabelas, colunas, tipos de dados, nulabilidade, propriedades de *IDENTITY* (identidade), *DEFAULT Constraints*, dados controlados de *seed* (carga inicial), chaves, *constraints*, relacionamentos de *FOREIGN KEY*, índices, particionamento, *triggers*, descrições de objetos e metadados técnicos de governança.

O documento destina-se a complementar o Modelo de Domínio do AtlasCommerce, a Documentação de Negócio, a documentação de arquitetura e os Diagramas do Modelo de Dados, fornecendo uma visão técnica detalhada do modelo relacional implementado.

---

## 2. Referência Oficial

A implementação do banco de dados AtlasCommerce é a referência oficial para os metadados técnicos documentados neste Dicionário de Dados.

Os metadados são extraídos diretamente dos catálogos de sistema e das propriedades estendidas do SQL Server e são validados incrementalmente antes de serem incorporados a este documento.

O Dicionário de Dados deve descrever o modelo de banco de dados implementado e validado, e não versões conceituais obsoletas ou definições reconstruídas manualmente.

---

## 3. Visão Geral do Banco de Dados

Atualmente, o AtlasCommerce contém 41 tabelas de aplicação distribuídas entre oito *schemas*.

| *Schema* | Tabelas |
|---|---:|
| `catalog` | 10 |
| `customer` | 7 |
| `inventory` | 6 |
| `metadata` | 1 |
| `payment` | 5 |
| `reference` | 5 |
| `sales` | 4 |
| `shipping` | 3 |
| **Total** | **41** |

---

## 4. Escopo de Recursos do Banco de Dados

A implementação atual do banco de dados AtlasCommerce não utiliza os seguintes recursos ou componentes operacionais do SQL Server:

- *SQL Server Agent jobs* (tarefas do SQL Server Agent);
- *Change Data Capture* (Captura de Alterações de Dados — CDC);
- *Change Tracking* (Rastreamento de Alterações);
- replicação transacional, de *snapshot* (instantâneo) ou de mesclagem;
- *Always On Availability Groups* (Grupos de Disponibilidade Always On);
- espelhamento de banco de dados;
- *Log Shipping* (Envio de Logs);
- *Service Broker* (Agente de Serviços);
- tabelas temporais versionadas pelo sistema;
- tabelas otimizadas para memória;
- integração com CLR.

Esses recursos estão intencionalmente ausentes da implementação atual do banco de dados transacional AtlasCommerce, a menos que sejam introduzidos por uma necessidade arquitetural futura.

A ausência desses recursos não deve ser interpretada como infraestrutura não documentada.

---

## 5. Estrutura do Dicionário

O Dicionário de Dados detalhado está organizado por *schema* e tabela.

O Dicionário de Dados documenta as seguintes categorias de metadados:

- descrição da tabela;
- colunas em sua ordem física;
- tipo de dados;
- nulabilidade;
- propriedade *IDENTITY*;
- *DEFAULT Constraint*;
- *PRIMARY KEY*;
- *UNIQUE Constraints*;
- *CHECK Constraints*;
- relacionamentos de *FOREIGN KEY*;
- índices;
- *triggers*;
- descrições das propriedades estendidas do SQL Server.

As categorias de metadados são incorporadas somente após os respectivos metadados do banco de dados terem sido extraídos e validados.

---

## 6. Descrições das Tabelas

Cada tabela do AtlasCommerce contém uma descrição no nível do objeto que define sua principal responsabilidade dentro do modelo de dados.

Essas descrições complementam os metadados no nível das colunas, apresentando a finalidade de negócio ou técnica de cada entidade antes da análise de sua estrutura interna.

### 6.1. `catalog`

| Tabela | Descrição |
|---|---|
| `catalog.Brand` | Maintains the controlled set of commercial brands used to consistently classify products in the Atlas Commerce catalog. |
| `catalog.Category` | Maintains the hierarchical category structure used to organize products in the Atlas Commerce catalog. |
| `catalog.Product` | Maintains the commercial identity of products available in the Atlas Commerce catalog independently from their sellable variants. |
| `catalog.ProductAttribute` | Maintains the controlled set of reusable product attributes used to describe characteristics of products and their sellable variants. |
| `catalog.ProductAttributeValue` | Maintains the controlled set of values available for reusable product attributes. |
| `catalog.ProductCategory` | Associates products with the catalog categories in which they are classified. |
| `catalog.ProductImage` | Maintains references and presentation metadata for images associated with products in the Atlas Commerce catalog while keeping binary image content outside the relational database. |
| `catalog.ProductVariant` | Maintains the sellable variants associated with products in the Atlas Commerce catalog. |
| `catalog.ProductVariantAttributeValue` | Associates sellable product variants with the controlled product attribute values that define their catalog characteristics. |
| `catalog.ProductVariantPrice` | Maintains the price history and temporal validity of sellable product variants in the Atlas Commerce catalog without overwriting prior commercial prices. |

### 6.2. `customer`

| Tabela | Descrição |
|---|---|
| `customer.Customer` | Maintains the core identity and lifecycle information of identified customers in Atlas Commerce. |
| `customer.CustomerAddress` | Maintains the association between customers and their current or historical addresses while storing customer-specific address information. |
| `customer.CustomerContact` | Maintains telephone contact information associated with identified customers in Atlas Commerce. |
| `customer.CustomerDocument` | Maintains document identifiers associated with identified customers while keeping document information separated from the core Customer entity. |
| `customer.CustomerDocumentType` | Maintains the controlled set of document types that may be associated with customers in Atlas Commerce. |
| `customer.CustomerEmail` | Maintains email addresses associated with identified customers while allowing shared email addresses across multiple customers. |
| `customer.CustomerType` | Maintains the controlled customer types supported by Atlas Commerce. |

### 6.3. `inventory`

| Tabela | Descrição |
|---|---|
| `inventory.Inventory` | Maintains the current usable and reserved inventory quantities for each product variant in Atlas Commerce. |
| `inventory.InventoryMovement` | Maintains the historical inventory movements for each product variant in Atlas Commerce. |
| `inventory.InventoryMovementNote` | Maintains optional free-text notes associated with inventory movement events in Atlas Commerce. |
| `inventory.InventoryMovementReason` | Maintains the controlled reasons used to classify inventory movements in Atlas Commerce. |
| `inventory.InventoryReservation` | Maintains the current inventory reservation associated with each sales transaction item and its lifecycle in Atlas Commerce. |
| `inventory.InventoryReservationStatus` | Defines the controlled statuses used to represent the lifecycle of inventory reservations in Atlas Commerce. |

### 6.4. `metadata`

| Tabela | Descrição |
|---|---|
| `metadata.TablePrefix` | Maintains the authoritative registry of table prefixes used to enforce naming consistency, prevent prefix reuse, and preserve prefix assignment history across Atlas Commerce. |

### 6.5. `payment`

| Tabela | Descrição |
|---|---|
| `payment.Payment` | Records payment attempts associated with Atlas Commerce sales transactions, including payment method, status, amount, installment information and relevant business-event timestamps. |
| `payment.PaymentMethod` | Defines the controlled payment methods available for Atlas Commerce transactions. |
| `payment.PaymentRefund` | Records full and partial refund events associated with Atlas Commerce payments, including the refunded amount, standardized refund reason and refund business-event timestamp. |
| `payment.PaymentRefundReason` | Defines the controlled reasons used to classify payment refunds in Atlas Commerce. |
| `payment.PaymentStatus` | Defines the controlled payment statuses used to represent the lifecycle of payment attempts in Atlas Commerce. |

### 6.6. `reference`

| Tabela | Descrição |
|---|---|
| `reference.Address` | Maintains reusable physical street address references associated with controlled cities in Atlas Commerce. |
| `reference.AdministrativeDivision` | Maintains controlled Brazilian administrative divisions associated with countries in Atlas Commerce. |
| `reference.City` | Maintains controlled Brazilian cities associated with administrative divisions in Atlas Commerce. |
| `reference.ContactType` | Maintains reusable telephone contact type values shared across Atlas Commerce domains. |
| `reference.Country` | Maintains controlled countries used by Atlas Commerce. |

### 6.7. `sales`

| Tabela | Descrição |
|---|---|
| `sales.Transaction` | Maintains the core sales transaction records processed by Atlas Commerce, including customer, status, channel, monetary amounts, and the transaction business timestamp. |
| `sales.TransactionChannel` | Maintains the controlled transaction channels used to classify how sales transactions are originated in Atlas Commerce. |
| `sales.TransactionItem` | Maintains the individual product items associated with sales transactions in Atlas Commerce, including product variant, quantity, unit price, unit discount, and the originating transaction timestamp. |
| `sales.TransactionStatus` | Maintains the controlled transaction statuses used by the Atlas Commerce sales transactional model. |

### 6.8. `shipping`

| Tabela | Descrição |
|---|---|
| `shipping.Shipment` | Records the delivery process associated with Atlas Commerce sales transactions that require shipment, including destination, shipment method, status, shipping amount, delivery estimate, tracking information, and relevant business-event timestamps. |
| `shipping.ShipmentMethod` | Defines the controlled shipment methods available for Atlas Commerce deliveries. |
| `shipping.ShipmentStatus` | Defines the controlled statuses used to represent the operational lifecycle of Atlas Commerce shipments. |

---

## 7. *Schemas*

### 7.1. `catalog`

#### 7.1.1. `catalog.Brand`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `BRD_id` | `smallint` | NO | YES | — | Primary key of `catalog.Brand`. |
| 2 | `BRD_name` | `nvarchar(150)` | NO | NO | — | Stores the commercial name used to identify the brand associated with catalog products. |
| 3 | `BRD_is_active` | `bit` | NO | NO | `DF_BRD_is_active` → `((1))` | Indicates whether the brand is currently available for use in catalog operations while preserving inactive brands for historical integrity. |
| 4 | `BRD_created_at` | `datetime2(0)` | NO | NO | `DF_BRD_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 5 | `BRD_updated_at` | `datetime2(0)` | NO | NO | `DF_BRD_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.1.2. `catalog.Category`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CTG_id` | `smallint` | NO | YES | — | Primary key of `catalog.Category`. |
| 2 | `CTG_CTG_id` | `smallint` | YES | NO | — | Foreign key referencing `catalog.Category`. NULL indicates a root category. |
| 3 | `CTG_name` | `nvarchar(150)` | NO | NO | — | Stores the business name used to identify the category within the catalog hierarchy. |
| 4 | `CTG_is_active` | `bit` | NO | NO | `DF_CTG_is_active` → `((1))` | Indicates whether the category is currently available for use in catalog operations while preserving inactive categories for historical integrity. |
| 5 | `CTG_created_at` | `datetime2(0)` | NO | NO | `DF_CTG_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `CTG_updated_at` | `datetime2(0)` | NO | NO | `DF_CTG_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.1.3. `catalog.Product`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PRD_id` | `int` | NO | YES | — | Primary key of `catalog.Product`. |
| 2 | `PRD_BRD_id` | `smallint` | NO | NO | — | Foreign key referencing `catalog.Brand`. |
| 3 | `PRD_name` | `nvarchar(200)` | NO | NO | — | Stores the commercial name used to identify the product in the catalog. |
| 4 | `PRD_is_active` | `bit` | NO | NO | `DF_PRD_is_active` → `((1))` | Indicates whether the product is currently available for use in catalog operations while preserving inactive products for historical integrity. |
| 5 | `PRD_created_at` | `datetime2(0)` | NO | NO | `DF_PRD_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `PRD_updated_at` | `datetime2(0)` | NO | NO | `DF_PRD_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.1.4. `catalog.ProductAttribute`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PAT_id` | `int` | NO | YES | — | Primary key of `catalog.ProductAttribute`. |
| 2 | `PAT_name` | `nvarchar(100)` | NO | NO | — | Stores the name used to identify the product attribute in the catalog. |
| 3 | `PAT_is_active` | `bit` | NO | NO | `DF_PAT_is_active` → `((1))` | Indicates whether the product attribute is currently available for use in catalog operations while preserving inactive attributes for historical integrity. |
| 4 | `PAT_created_at` | `datetime2(0)` | NO | NO | `DF_PAT_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 5 | `PAT_updated_at` | `datetime2(0)` | NO | NO | `DF_PAT_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.1.5. `catalog.ProductAttributeValue`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PATVL_id` | `int` | NO | YES | — | Primary key of `catalog.ProductAttributeValue`. |
| 2 | `PATVL_PAT_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductAttribute`. |
| 3 | `PATVL_value` | `nvarchar(100)` | NO | NO | — | Stores the value used to identify a valid option for the associated product attribute. |
| 4 | `PATVL_is_active` | `bit` | NO | NO | `DF_PATVL_is_active` → `((1))` | Indicates whether the product attribute value is currently available for use in catalog operations while preserving inactive values for historical integrity. |
| 5 | `PATVL_created_at` | `datetime2(0)` | NO | NO | `DF_PATVL_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `PATVL_updated_at` | `datetime2(0)` | NO | NO | `DF_PATVL_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.1.6. `catalog.ProductCategory`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PRDCT_PRD_id` | `int` | NO | NO | — | Foreign key referencing `catalog.Product`. |
| 2 | `PRDCT_CTG_id` | `smallint` | NO | NO | — | Foreign key referencing `catalog.Category`. |

#### 7.1.7. `catalog.ProductImage`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PRDIM_id` | `int` | NO | YES | — | Primary key of `catalog.ProductImage`. |
| 2 | `PRDIM_PRD_id` | `int` | NO | NO | — | Foreign key referencing `catalog.Product`. |
| 3 | `PRDIM_path` | `nvarchar(1000)` | NO | NO | — | Stores the external path or object reference used to locate the product image while keeping binary image content outside the relational database. |
| 4 | `PRDIM_display_order` | `smallint` | NO | NO | — | Defines the presentation sequence of the image within the collection of images associated with the product. |
| 5 | `PRDIM_is_primary` | `bit` | NO | NO | `DF_PRDIM_is_primary` → `((0))` | Indicates whether the image is the primary image used to represent the product in catalog presentation. |
| 6 | `PRDIM_is_active` | `bit` | NO | NO | `DF_PRDIM_is_active` → `((1))` | Indicates whether the image is currently available for use in catalog presentation while preserving inactive image records for historical integrity. |
| 7 | `PRDIM_created_at` | `datetime2(0)` | NO | NO | `DF_PRDIM_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 8 | `PRDIM_updated_at` | `datetime2(0)` | NO | NO | `DF_PRDIM_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.1.8. `catalog.ProductVariant`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PRDVA_id` | `int` | NO | YES | — | Primary key of `catalog.ProductVariant`. |
| 2 | `PRDVA_PRD_id` | `int` | NO | NO | — | Foreign key referencing `catalog.Product`. |
| 3 | `PRDVA_sku` | `nvarchar(100)` | NO | NO | — | Stores the stock keeping unit (SKU) used to uniquely identify the sellable product variant. |
| 4 | `PRDVA_barcode` | `nvarchar(50)` | YES | NO | — | Stores the optional barcode associated with the sellable product variant. |
| 5 | `PRDVA_is_active` | `bit` | NO | NO | `DF_PRDVA_is_active` → `((1))` | Indicates whether the product variant is currently available for use in catalog operations while preserving inactive variants for historical integrity. |
| 6 | `PRDVA_created_at` | `datetime2(0)` | NO | NO | `DF_PRDVA_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 7 | `PRDVA_updated_at` | `datetime2(0)` | NO | NO | `DF_PRDVA_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.1.9. `catalog.ProductVariantAttributeValue`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PRDAV_PRDVA_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductVariant`. |
| 2 | `PRDAV_PATVL_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductAttributeValue`. |

#### 7.1.10. `catalog.ProductVariantPrice`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PRDVP_id` | `bigint` | NO | YES | — | Primary key of `catalog.ProductVariantPrice`. |
| 2 | `PRDVP_PRDVA_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductVariant`. |
| 3 | `PRDVP_price` | `decimal(19,2)` | NO | NO | — | Stores the commercial price applicable to the product variant during the validity interval represented by the row. |
| 4 | `PRDVP_valid_from` | `datetime2(0)` | NO | NO | — | Defines the inclusive lower boundary of the period during which the price becomes applicable to the product variant. |
| 5 | `PRDVP_valid_to` | `datetime2(0)` | YES | NO | — | Defines the exclusive upper boundary of the price validity interval. NULL represents an open-ended period with no defined end date. |
| 6 | `PRDVP_created_at` | `datetime2(0)` | NO | NO | `DF_PRDVP_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |

### 7.2. `customer`

#### 7.2.1. `customer.Customer`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CST_id` | `int` | NO | YES | — | Primary key of `customer.Customer`. |
| 2 | `CST_CSTCT_id` | `smallint` | NO | NO | — | Foreign key referencing `customer.CustomerType`. |
| 3 | `CST_name` | `nvarchar(200)` | NO | NO | — | Stores the customer name, representing the full name for individuals or the company name for legal entities. |
| 4 | `CST_birth_date` | `date` | YES | NO | — | Stores the birth date of an individual customer when provided and applicable. |
| 5 | `CST_is_active` | `bit` | NO | NO | `DF_CST_is_active` → `((1))` | Indicates whether the customer is currently active while preserving inactive customers for historical integrity. |
| 6 | `CST_created_at` | `datetime2(0)` | NO | NO | `DF_CST_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 7 | `CST_updated_at` | `datetime2(0)` | NO | NO | `DF_CST_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.2.2. `customer.CustomerAddress`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CSTAD_id` | `int` | NO | YES | — | Primary key of `customer.CustomerAddress`. |
| 2 | `CSTAD_CST_id` | `int` | NO | NO | — | Foreign key referencing `customer.Customer`. |
| 3 | `CSTAD_ADR_id` | `int` | NO | NO | — | Foreign key referencing `reference.Address`. |
| 4 | `CSTAD_number` | `nvarchar(20)` | NO | NO | — | Stores the street number associated with the customer at the referenced address. |
| 5 | `CSTAD_complement` | `nvarchar(100)` | YES | NO | — | Stores optional address information that identifies a unit, apartment, block, suite, or similar location detail. |
| 6 | `CSTAD_is_primary` | `bit` | NO | NO | `DF_CSTAD_is_primary` → `((0))` | Indicates whether the address is the primary address currently designated for the customer. |
| 7 | `CSTAD_is_active` | `bit` | NO | NO | `DF_CSTAD_is_active` → `((1))` | Indicates whether the customer currently maintains an active association with the address while preserving inactive associations for historical integrity. |
| 8 | `CSTAD_created_at` | `datetime2(0)` | NO | NO | `DF_CSTAD_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 9 | `CSTAD_updated_at` | `datetime2(0)` | NO | NO | `DF_CSTAD_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.2.3. `customer.CustomerContact`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CSTCN_id` | `int` | NO | YES | — | Primary key of `customer.CustomerContact`. |
| 2 | `CSTCN_CST_id` | `int` | NO | NO | — | Foreign key referencing `customer.Customer`. |
| 3 | `CSTCN_CTP_id` | `tinyint` | NO | NO | — | Foreign key referencing `reference.ContactType`. |
| 4 | `CSTCN_value` | `varchar(20)` | NO | NO | — | Stores the telephone number without presentation formatting. |
| 5 | `CSTCN_is_primary` | `bit` | NO | NO | `DF_CSTCN_is_primary` → `((0))` | Indicates whether the contact is the primary active telephone contact for the customer. |
| 6 | `CSTCN_is_active` | `bit` | NO | NO | `DF_CSTCN_is_active` → `((1))` | Indicates whether the customer contact is currently active and available for use. |
| 7 | `CSTCN_created_at` | `datetime2(0)` | NO | NO | `DF_CSTCN_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 8 | `CSTCN_updated_at` | `datetime2(0)` | NO | NO | `DF_CSTCN_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.2.4. `customer.CustomerDocument`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CSTCD_id` | `int` | NO | YES | — | Primary key of `customer.CustomerDocument`. |
| 2 | `CSTCD_CST_id` | `int` | NO | NO | — | Foreign key referencing `customer.Customer`. |
| 3 | `CSTCD_DTP_id` | `smallint` | NO | NO | — | Foreign key referencing `customer.CustomerDocumentType`. |
| 4 | `CSTCD_value` | `varchar(30)` | NO | NO | — | Stores the normalized document identifier value without presentation formatting. |
| 5 | `CSTCD_created_at` | `datetime2(0)` | NO | NO | `DF_CSTCD_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `CSTCD_updated_at` | `datetime2(0)` | NO | NO | `DF_CSTCD_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.2.5. `customer.CustomerDocumentType`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `DTP_id` | `smallint` | NO | YES | — | Primary key of `customer.CustomerDocumentType`. |
| 2 | `DTP_name` | `nvarchar(100)` | NO | NO | — | Stores the controlled name used to identify a customer document type. |
| 3 | `DTP_created_at` | `datetime2(0)` | NO | NO | `DF_DTP_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `DTP_updated_at` | `datetime2(0)` | NO | NO | `DF_DTP_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.2.6. `customer.CustomerEmail`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CSTEM_id` | `int` | NO | YES | — | Primary key of `customer.CustomerEmail`. |
| 2 | `CSTEM_CST_id` | `int` | NO | NO | — | Foreign key referencing `customer.Customer`. |
| 3 | `CSTEM_email` | `varchar(254)` | NO | NO | — | Stores the email address associated with the customer. |
| 4 | `CSTEM_is_primary` | `bit` | NO | NO | `DF_CSTEM_is_primary` → `((0))` | Indicates whether the email is the primary active email address for the customer. |
| 5 | `CSTEM_is_active` | `bit` | NO | NO | `DF_CSTEM_is_active` → `((1))` | Indicates whether the customer email address is currently active and available for use. |
| 6 | `CSTEM_created_at` | `datetime2(0)` | NO | NO | `DF_CSTEM_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 7 | `CSTEM_updated_at` | `datetime2(0)` | NO | NO | `DF_CSTEM_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.2.7. `customer.CustomerType`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CSTCT_id` | `smallint` | NO | YES | — | Primary key of `customer.CustomerType`. |
| 2 | `CSTCT_code` | `varchar(30)` | NO | NO | — | Stores the stable system code that uniquely identifies the customer type. |
| 3 | `CSTCT_name` | `nvarchar(100)` | NO | NO | — | Stores the human-readable name of the customer type for presentation purposes. |
| 4 | `CSTCT_created_at` | `datetime2(0)` | NO | NO | `DF_CSTCT_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 5 | `CSTCT_updated_at` | `datetime2(0)` | NO | NO | `DF_CSTCT_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

### 7.3. `inventory`

#### 7.3.1. `inventory.Inventory`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `INV_id` | `int` | NO | YES | — | Primary key of `inventory.Inventory`. |
| 2 | `INV_PRDVA_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductVariant`. |
| 3 | `INV_quantity_on_hand` | `int` | NO | NO | `DF_INV_quantity_on_hand` → `((0))` | Stores the current quantity of usable units physically available in inventory for the product variant. |
| 4 | `INV_quantity_reserved` | `int` | NO | NO | `DF_INV_quantity_reserved` → `((0))` | Stores the quantity of usable inventory units already reserved and therefore unavailable for new sales. |
| 5 | `INV_created_at` | `datetime2(0)` | NO | NO | `DF_INV_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `INV_updated_at` | `datetime2(0)` | NO | NO | `DF_INV_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.3.2. `inventory.InventoryMovement`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `INVMV_id` | `bigint` | NO | YES | — | Primary key of `inventory.InventoryMovement`. |
| 2 | `INVMV_PRDVA_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductVariant`. |
| 3 | `INVMV_INVMR_id` | `smallint` | NO | NO | — | Foreign key referencing `inventory.InventoryMovementReason`. |
| 4 | `INVMV_TRNIT_id` | `bigint` | YES | NO | — | Optional identifier component of the composite foreign key referencing `sales.TransactionItem` when the inventory movement originates from a sales transaction item. |
| 5 | `INVMV_TRNIT_transaction_at` | `datetime2(0)` | YES | NO | — | Optional transaction timestamp component of the composite foreign key referencing `sales.TransactionItem` when the inventory movement originates from a sales transaction item. |
| 6 | `INVMV_quantity` | `int` | NO | NO | — | Stores the signed inventory quantity moved. Positive values represent entries and negative values represent exits. |
| 7 | `INVMV_movement_at` | `datetime2(0)` | NO | NO | `DF_INVMV_movement_at` → `(sysdatetime())` | Records the date and time when the inventory movement actually occurred. |
| 8 | `INVMV_created_at` | `datetime2(0)` | NO | NO | `DF_INVMV_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 9 | `INVMV_updated_at` | `datetime2(0)` | NO | NO | `DF_INVMV_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.3.3. `inventory.InventoryMovementNote`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `INVMN_id` | `bigint` | NO | YES | — | Primary key of `inventory.InventoryMovementNote`. |
| 2 | `INVMN_INVMV_id` | `bigint` | NO | NO | — | Foreign key referencing `inventory.InventoryMovement`. |
| 3 | `INVMN_note` | `nvarchar(1000)` | NO | NO | — | Stores optional free-text operational context associated with the inventory movement without replacing its structured reason classification. |
| 4 | `INVMN_created_at` | `datetime2(0)` | NO | NO | `DF_INVMN_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 5 | `INVMN_updated_at` | `datetime2(0)` | NO | NO | `DF_INVMN_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.3.4. `inventory.InventoryMovementReason`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `INVMR_id` | `smallint` | NO | YES | — | Primary key of `inventory.InventoryMovementReason`. |
| 2 | `INVMR_name` | `nvarchar(100)` | NO | NO | — | Stores the controlled business name of the inventory movement reason. |
| 3 | `INVMR_created_at` | `datetime2(0)` | NO | NO | `DF_INVMR_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `INVMR_updated_at` | `datetime2(0)` | NO | NO | `DF_INVMR_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.3.5. `inventory.InventoryReservation`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `INVRE_id` | `bigint` | NO | YES | — | Primary key of `inventory.InventoryReservation`. |
| 2 | `INVRE_TRNIT_id` | `bigint` | NO | NO | — | Identifier component of the composite foreign key referencing `sales.TransactionItem` that owns the reservation. |
| 3 | `INVRE_TRNIT_transaction_at` | `datetime2(0)` | NO | NO | — | Transaction timestamp component of the composite foreign key referencing `sales.TransactionItem`. |
| 4 | `INVRE_PRDVA_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductVariant`. |
| 5 | `INVRE_INVRS_id` | `tinyint` | NO | NO | — | Foreign key referencing `inventory.InventoryReservationStatus`. |
| 6 | `INVRE_quantity` | `int` | NO | NO | — | Stores the quantity of usable inventory units committed to the reservation. |
| 7 | `INVRE_reserved_at` | `datetime2(0)` | NO | NO | — | Records the date and time when the inventory reservation became effective. |
| 8 | `INVRE_expires_at` | `datetime2(0)` | NO | NO | — | Records the date and time when the reservation is expected to expire if it is not consumed or released earlier. |
| 9 | `INVRE_closed_at` | `datetime2(0)` | YES | NO | — | Records the date and time when the reservation was consumed, released, or expired; NULL while the reservation remains active. |
| 10 | `INVRE_created_at` | `datetime2(0)` | NO | NO | `DF_INVRE_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 11 | `INVRE_updated_at` | `datetime2(0)` | NO | NO | `DF_INVRE_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.3.6. `inventory.InventoryReservationStatus`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `INVRS_id` | `tinyint` | NO | YES | — | Primary key of `inventory.InventoryReservationStatus`. |
| 2 | `INVRS_name` | `nvarchar(50)` | NO | NO | — | Stores the controlled name of the inventory reservation status used by Atlas Commerce. |
| 3 | `INVRS_created_at` | `datetime2(0)` | NO | NO | `DF_INVRS_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `INVRS_updated_at` | `datetime2(0)` | NO | NO | `DF_INVRS_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

### 7.4. `metadata`

#### 7.4.1. `metadata.TablePrefix`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PFX_id` | `smallint` | NO | YES | — | Primary key of `metadata.TablePrefix`. |
| 2 | `PFX_schema_name` | `sysname` | NO | NO | — | Stores the schema name of the table associated with the registered prefix. |
| 3 | `PFX_table_name` | `sysname` | NO | NO | — | Stores the table name associated with the registered prefix within its owning schema. |
| 4 | `PFX_prefix` | `nvarchar(5)` | NO | NO | — | Stores the unique and permanently reserved prefix assigned to the registered table and used by its column naming convention. |
| 5 | `PFX_is_active` | `bit` | NO | NO | `DF_PFX_is_active` → `((1))` | Indicates whether the registered table prefix is currently active while preserving inactive assignments for historical governance and preventing prefix reuse. |
| 6 | `PFX_created_at` | `datetime2(0)` | NO | NO | — | Records the date and time when the row was created. |
| 7 | `PFX_updated_at` | `datetime2(0)` | NO | NO | — | Records the date and time when the row was last updated. |

### 7.5. `payment`

#### 7.5.1. `payment.Payment`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PAY_id` | `bigint` | NO | YES | — | Primary key of `payment.Payment`. |
| 2 | `PAY_TRN_id` | `bigint` | NO | NO | — | Foreign key referencing `sales.Transaction`. |
| 3 | `PAY_transaction_at` | `datetime2(0)` | NO | NO | — | Stores the originating sales transaction timestamp and participates with `PAY_TRN_id` in the composite foreign key to `sales.Transaction`. |
| 4 | `PAY_PAYME_id` | `tinyint` | NO | NO | — | Foreign key referencing `payment.PaymentMethod`. |
| 5 | `PAY_PAYST_id` | `tinyint` | NO | NO | — | Foreign key referencing `payment.PaymentStatus`. |
| 6 | `PAY_amount` | `decimal(19,2)` | NO | NO | — | Stores the monetary amount associated with the individual payment attempt or payment operation. |
| 7 | `PAY_installment_count` | `tinyint` | YES | NO | — | Stores the number of installments when the payment is installment-based; NULL when installments do not apply. |
| 8 | `PAY_attempted_at` | `datetime2(0)` | NO | NO | — | Records the date and time when the payment attempt occurred. |
| 9 | `PAY_approved_at` | `datetime2(0)` | YES | NO | — | Records the date and time when the payment was approved, when applicable. |
| 10 | `PAY_cancelled_at` | `datetime2(0)` | YES | NO | — | Records the date and time when the payment was cancelled, when applicable. |
| 11 | `PAY_created_at` | `datetime2(0)` | NO | NO | `DF_PAY_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 12 | `PAY_updated_at` | `datetime2(0)` | NO | NO | `DF_PAY_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.5.2. `payment.PaymentMethod`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PAYME_id` | `tinyint` | NO | YES | — | Primary key of `payment.PaymentMethod`. |
| 2 | `PAYME_name` | `varchar(30)` | NO | NO | — | Stores the controlled name of the payment method used by Atlas Commerce. |
| 3 | `PAYME_created_at` | `datetime2(0)` | NO | NO | `DF_PAYME_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `PAYME_updated_at` | `datetime2(0)` | NO | NO | `DF_PAYME_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.5.3. `payment.PaymentRefund`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PAYRF_id` | `bigint` | NO | YES | — | Primary key of `payment.PaymentRefund`. |
| 2 | `PAYRF_PAY_id` | `bigint` | NO | NO | — | Foreign key referencing `payment.Payment`. |
| 3 | `PAYRF_PAYRR_id` | `tinyint` | NO | NO | — | Foreign key referencing `payment.PaymentRefundReason`. |
| 4 | `PAYRF_amount` | `decimal(19,2)` | NO | NO | — | Stores the monetary amount associated with the individual refund event. |
| 5 | `PAYRF_refunded_at` | `datetime2(0)` | NO | NO | — | Records the date and time when the refund event occurred. |
| 6 | `PAYRF_created_at` | `datetime2(0)` | NO | NO | `DF_PAYRF_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 7 | `PAYRF_updated_at` | `datetime2(0)` | NO | NO | `DF_PAYRF_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.5.4. `payment.PaymentRefundReason`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PAYRR_id` | `tinyint` | NO | YES | — | Primary key of `payment.PaymentRefundReason`. |
| 2 | `PAYRR_name` | `varchar(40)` | NO | NO | — | Stores the controlled name of the reason associated with a payment refund. |
| 3 | `PAYRR_created_at` | `datetime2(0)` | NO | NO | `DF_PAYRR_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `PAYRR_updated_at` | `datetime2(0)` | NO | NO | `DF_PAYRR_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.5.5. `payment.PaymentStatus`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `PAYST_id` | `tinyint` | NO | YES | — | Primary key of `payment.PaymentStatus`. |
| 2 | `PAYST_name` | `varchar(30)` | NO | NO | — | Stores the controlled name of the payment status used by Atlas Commerce. |
| 3 | `PAYST_created_at` | `datetime2(0)` | NO | NO | `DF_PAYST_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `PAYST_updated_at` | `datetime2(0)` | NO | NO | `DF_PAYST_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

### 7.6. `reference`

#### 7.6.1. `reference.Address`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `ADR_id` | `int` | NO | YES | — | Primary key of `reference.Address`. |
| 2 | `ADR_CTY_id` | `int` | NO | NO | — | Foreign key referencing `reference.City`. |
| 3 | `ADR_postal_code` | `varchar(8)` | NO | NO | — | Stores the eight-digit Brazilian postal code without presentation formatting. |
| 4 | `ADR_street` | `nvarchar(200)` | NO | NO | — | Stores the street or public-place name associated with the address reference. |
| 5 | `ADR_created_at` | `datetime2(0)` | NO | NO | `DF_ADR_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `ADR_updated_at` | `datetime2(0)` | NO | NO | `DF_ADR_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.6.2. `reference.AdministrativeDivision`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `ADV_id` | `tinyint` | NO | YES | — | Primary key of `reference.AdministrativeDivision`. |
| 2 | `ADV_CTR_id` | `tinyint` | NO | NO | — | Foreign key referencing `reference.Country`. |
| 3 | `ADV_code` | `char(2)` | NO | NO | — | Stores the official two-character abbreviation of the administrative division. |
| 4 | `ADV_name` | `nvarchar(100)` | NO | NO | — | Stores the official name used to identify the administrative division. |
| 5 | `ADV_created_at` | `datetime2(0)` | NO | NO | `DF_ADV_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `ADV_updated_at` | `datetime2(0)` | NO | NO | `DF_ADV_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.6.3. `reference.City`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CTY_id` | `int` | NO | YES | — | Primary key of `reference.City`. |
| 2 | `CTY_ADV_id` | `tinyint` | NO | NO | — | Foreign key referencing `reference.AdministrativeDivision`. |
| 3 | `CTY_name` | `nvarchar(150)` | NO | NO | — | Stores the official name used to identify the city. |
| 4 | `CTY_created_at` | `datetime2(0)` | NO | NO | `DF_CTY_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 5 | `CTY_updated_at` | `datetime2(0)` | NO | NO | `DF_CTY_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.6.4. `reference.ContactType`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CTP_id` | `tinyint` | NO | YES | — | Primary key of `reference.ContactType`. |
| 2 | `CTP_name` | `nvarchar(100)` | NO | NO | — | Stores the controlled name used to identify the telephone contact type. |
| 3 | `CTP_created_at` | `datetime2(0)` | NO | NO | `DF_CTP_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `CTP_updated_at` | `datetime2(0)` | NO | NO | `DF_CTP_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.6.5. `reference.Country`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `CTR_id` | `tinyint` | NO | YES | — | Primary key of `reference.Country`. |
| 2 | `CTR_name` | `nvarchar(100)` | NO | NO | — | Stores the official name used to identify the country. |
| 3 | `CTR_created_at` | `datetime2(0)` | NO | NO | `DF_CTR_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `CTR_updated_at` | `datetime2(0)` | NO | NO | `DF_CTR_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

### 7.7. `sales`

#### 7.7.1. `sales.Transaction`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `TRN_id` | `bigint` | NO | YES | — | Primary key of `sales.Transaction`. |
| 2 | `TRN_transaction_at` | `datetime2(0)` | NO | NO | — | Records the date and time when the transaction occurred. |
| 3 | `TRN_CST_id` | `int` | YES | NO | — | Foreign key referencing `customer.Customer`. |
| 4 | `TRN_TRNST_id` | `tinyint` | NO | NO | — | Foreign key referencing `sales.TransactionStatus`. |
| 5 | `TRN_TRNCH_id` | `tinyint` | NO | NO | — | Foreign key referencing `sales.TransactionChannel`. |
| 6 | `TRN_gross_amount` | `decimal(19,2)` | NO | NO | — | Stores the gross monetary amount of the transaction before discounts. |
| 7 | `TRN_discount_amount` | `decimal(19,2)` | NO | NO | `DF_TRN_discount_amount` → `((0.00))` | Stores the total monetary discount amount applied to the transaction. |
| 8 | `TRN_created_at` | `datetime2(0)` | NO | NO | `DF_TRN_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 9 | `TRN_updated_at` | `datetime2(0)` | NO | NO | `DF_TRN_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.7.2. `sales.TransactionChannel`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `TRNCH_id` | `tinyint` | NO | YES | — | Primary key of `sales.TransactionChannel`. |
| 2 | `TRNCH_code` | `varchar(30)` | NO | NO | — | Stores the stable system code that uniquely identifies the transaction channel. |
| 3 | `TRNCH_name` | `varchar(100)` | NO | NO | — | Provides the business description associated with the transaction channel code. |
| 4 | `TRNCH_is_active` | `bit` | NO | NO | `DF_TRNCH_is_active` → `((1))` | Indicates whether the transaction channel is currently available for operational use while preserving inactive channels for historical integrity. |
| 5 | `TRNCH_created_at` | `datetime2(0)` | NO | NO | `DF_TRNCH_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `TRNCH_updated_at` | `datetime2(0)` | NO | NO | `DF_TRNCH_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.7.3. `sales.TransactionItem`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `TRNIT_id` | `bigint` | NO | YES | — | Primary key of `sales.TransactionItem`. |
| 2 | `TRNIT_transaction_at` | `datetime2(0)` | NO | NO | — | Records the date and time of the parent sales transaction and supports aligned partitioning with `sales.Transaction`. |
| 3 | `TRNIT_TRN_id` | `bigint` | NO | NO | — | Foreign key referencing `sales.Transaction`. |
| 4 | `TRNIT_PRDVA_id` | `int` | NO | NO | — | Foreign key referencing `catalog.ProductVariant`. |
| 5 | `TRNIT_quantity` | `int` | NO | NO | — | Stores the quantity of the product variant included in the transaction item. |
| 6 | `TRNIT_unit_price` | `decimal(19,2)` | NO | NO | — | Stores the unit price of the product variant recorded for the transaction item. |
| 7 | `TRNIT_unit_discount` | `decimal(19,2)` | NO | NO | `DF_TRNIT_unit_discount` → `((0.00))` | Stores the unit discount applied to the product variant for the transaction item. |
| 8 | `TRNIT_created_at` | `datetime2(0)` | NO | NO | `DF_TRNIT_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 9 | `TRNIT_updated_at` | `datetime2(0)` | NO | NO | `DF_TRNIT_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.7.4. `sales.TransactionStatus`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `TRNST_id` | `tinyint` | NO | YES | — | Primary key of `sales.TransactionStatus`. |
| 2 | `TRNST_code` | `varchar(30)` | NO | NO | — | Stores the stable system code that uniquely identifies the transaction status. |
| 3 | `TRNST_name` | `varchar(100)` | NO | NO | — | Stores the human-readable name of the transaction status for presentation purposes. |
| 4 | `TRNST_is_active` | `bit` | NO | NO | `DF_TRNST_is_active` → `((1))` | Indicates whether the transaction status is currently available for operational use while preserving inactive statuses for historical integrity. |
| 5 | `TRNST_created_at` | `datetime2(0)` | NO | NO | `DF_TRNST_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 6 | `TRNST_updated_at` | `datetime2(0)` | NO | NO | `DF_TRNST_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

### 7.8. `shipping`

#### 7.8.1. `shipping.Shipment`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `SHP_id` | `bigint` | NO | YES | — | Primary key of `shipping.Shipment`. |
| 2 | `SHP_TRN_id` | `bigint` | NO | NO | — | Foreign key referencing `sales.Transaction`. |
| 3 | `SHP_transaction_at` | `datetime2(0)` | NO | NO | — | Records the date and time of the parent sales transaction and participates with `SHP_TRN_id` in the composite foreign key to `sales.Transaction`. |
| 4 | `SHP_CSTAD_id` | `int` | NO | NO | — | Foreign key referencing `customer.CustomerAddress`. |
| 5 | `SHP_SHPMT_id` | `tinyint` | NO | NO | — | Foreign key referencing `shipping.ShipmentMethod`. |
| 6 | `SHP_SHPST_id` | `tinyint` | NO | NO | — | Foreign key referencing `shipping.ShipmentStatus`. |
| 7 | `SHP_shipping_amount` | `decimal(19,2)` | NO | NO | — | Stores the shipping amount charged to the customer for this shipment. |
| 8 | `SHP_estimated_delivery_date` | `date` | NO | NO | — | Stores the estimated delivery date presented to the customer when the shipment method was selected. |
| 9 | `SHP_tracking_code` | `varchar(30)` | YES | NO | — | Stores the tracking code assigned to the shipment when available. |
| 10 | `SHP_posted_at` | `datetime2(0)` | YES | NO | — | Records the date and time when the shipment was handed over to the delivery provider. |
| 11 | `SHP_delivered_at` | `datetime2(0)` | YES | NO | — | Records the date and time when the shipment was successfully delivered to the recipient. |
| 12 | `SHP_created_at` | `datetime2(0)` | NO | NO | `DF_SHP_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 13 | `SHP_updated_at` | `datetime2(0)` | NO | NO | `DF_SHP_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.8.2. `shipping.ShipmentMethod`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `SHPMT_id` | `tinyint` | NO | YES | — | Primary key of `shipping.ShipmentMethod`. |
| 2 | `SHPMT_name` | `varchar(30)` | NO | NO | — | Stores the controlled shipment method selected for Atlas Commerce deliveries. |
| 3 | `SHPMT_created_at` | `datetime2(0)` | NO | NO | `DF_SHPMT_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `SHPMT_updated_at` | `datetime2(0)` | NO | NO | `DF_SHPMT_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

#### 7.8.3. `shipping.ShipmentStatus`

| # | Coluna | Tipo de Dados | Aceita NULL | *IDENTITY* | *DEFAULT* | Descrição |
|---:|---|---|:---:|:---:|---|---|
| 1 | `SHPST_id` | `tinyint` | NO | YES | — | Primary key of `shipping.ShipmentStatus`. |
| 2 | `SHPST_name` | `varchar(30)` | NO | NO | — | Stores the controlled shipment status representing the current operational state of a shipment. |
| 3 | `SHPST_created_at` | `datetime2(0)` | NO | NO | `DF_SHPST_created_at` → `(sysdatetime())` | Records the date and time when the row was created. |
| 4 | `SHPST_updated_at` | `datetime2(0)` | NO | NO | `DF_SHPST_updated_at` → `(sysdatetime())` | Records the date and time when the row was last updated. |

---

## 8. Valores Controlados e Dados Iniciais

O AtlasCommerce utiliza dados iniciais controlados para estabelecer classificações de negócio, status, métodos, canais e outros valores necessários ao modelo transacional.

Os valores documentados nesta seção representam os dados iniciais atualmente implementados, extraídos diretamente do banco de dados AtlasCommerce.

Os identificadores e valores controlados são documentados exatamente como estão armazenados no banco de dados.

Os dados de governança técnica mantidos em `metadata.TablePrefix` são documentados separadamente, pois representam a governança da nomenclatura do banco de dados, e não valores controlados de negócio.

### 8.1. `customer.CustomerDocumentType`

| ID | Nome |
|---:|---|
| 1 | `CPF` |
| 2 | `CNPJ` |
| 3 | `RG` |
| 4 | `CNH` |
| 5 | `PASSPORT` |

### 8.2. `customer.CustomerType`

| ID | Código | Nome |
|---:|---|---|
| 1 | `INDIVIDUAL` | Pessoa Física |
| 2 | `COMPANY` | Pessoa Jurídica |

### 8.3. `inventory.InventoryMovementReason`

| ID | Nome |
|---:|---|
| 1 | `PURCHASE_RECEIPT` |
| 2 | `SALE` |
| 3 | `CUSTOMER_RETURN` |
| 4 | `DAMAGED_IN_TRANSIT` |
| 5 | `DAMAGED_INTERNAL` |
| 6 | `LOSS_IN_TRANSIT` |
| 7 | `LOSS_INTERNAL` |
| 8 | `FOUND_INTERNAL` |
| 9 | `INVENTORY_ADJUSTMENT_IN` |
| 10 | `INVENTORY_ADJUSTMENT_OUT` |

### 8.4. `inventory.InventoryReservationStatus`

| ID | Nome |
|---:|---|
| 1 | `ACTIVE` |
| 2 | `CONSUMED` |
| 3 | `RELEASED` |
| 4 | `EXPIRED` |

### 8.5. `payment.PaymentMethod`

| ID | Nome |
|---:|---|
| 1 | `PIX` |
| 2 | `CREDIT_CARD` |
| 3 | `DEBIT_CARD` |
| 4 | `CASH` |

### 8.6. `payment.PaymentRefundReason`

| ID | Nome |
|---:|---|
| 1 | `CUSTOMER_RETURN` |
| 2 | `DUPLICATE_CHARGE` |
| 3 | `FRAUD` |
| 4 | `OPERATIONAL_ERROR` |
| 5 | `ORDER_CANCELLATION` |

### 8.7. `payment.PaymentStatus`

| ID | Nome |
|---:|---|
| 1 | `PENDING` |
| 2 | `APPROVED` |
| 3 | `DECLINED` |
| 4 | `CANCELLED` |
| 5 | `PARTIALLY_REFUNDED` |
| 6 | `REFUNDED` |

### 8.8. `reference.ContactType`

| ID | Nome |
|---:|---|
| 1 | `PHONE` |
| 2 | `MOBILE` |

### 8.9. `sales.TransactionChannel`

| ID | Código | Nome |
|---:|---|---|
| 1 | `ONLINE` | Online transaction |
| 2 | `STORE` | Physical store transaction |

### 8.10. `sales.TransactionStatus`

| ID | Código | Nome |
|---:|---|---|
| 1 | `PENDING` | Pending |
| 2 | `CONFIRMED` | Confirmed |
| 3 | `COMPLETED` | Completed |
| 4 | `CANCELLED` | Cancelled |
| 5 | `FAILED` | Failed |

### 8.11. `shipping.ShipmentMethod`

| ID | Nome |
|---:|---|
| 1 | `PAC` |
| 2 | `SEDEX` |

### 8.12. `shipping.ShipmentStatus`

| ID | Nome |
|---:|---|
| 1 | `PENDING` |
| 2 | `POSTED` |
| 3 | `DELIVERED` |
| 4 | `CANCELLED` |
| 5 | `RETURNED` |

---

## 9. Dados Iniciais de Governança Técnica

Diferentemente dos valores controlados de negócio documentados anteriormente, `metadata.TablePrefix` contém dados de governança técnica utilizados pelo modelo de banco de dados AtlasCommerce.

O registro estabelece a relação oficial entre cada tabela e o prefixo de coluna atribuído a ela.

No momento desta documentação:

- 41 tabelas de usuário estão implementadas;

- 41 atribuições de prefixos de tabela estão registradas;

- cada tabela de usuário implementada possui uma atribuição de prefixo correspondente;

- todas as atribuições de prefixos registradas estão ativas.

Portanto, o registro fornece cobertura completa de prefixos para o modelo relacional do AtlasCommerce atualmente implementado.

### 9.1. `metadata.TablePrefix`

| ID | *Schema* | Tabela | Prefixo | Ativo |
|---:|---|---|---|:---:|
| 2 | `catalog` | `Brand` | `BRD` | YES |
| 3 | `catalog` | `Category` | `CTG` | YES |
| 4 | `catalog` | `Product` | `PRD` | YES |
| 5 | `catalog` | `ProductAttribute` | `PAT` | YES |
| 6 | `catalog` | `ProductAttributeValue` | `PATVL` | YES |
| 7 | `catalog` | `ProductCategory` | `PRDCT` | YES |
| 8 | `catalog` | `ProductImage` | `PRDIM` | YES |
| 9 | `catalog` | `ProductVariant` | `PRDVA` | YES |
| 10 | `catalog` | `ProductVariantAttributeValue` | `PRDAV` | YES |
| 11 | `catalog` | `ProductVariantPrice` | `PRDVP` | YES |
| 12 | `customer` | `Customer` | `CST` | YES |
| 13 | `customer` | `CustomerAddress` | `CSTAD` | YES |
| 14 | `customer` | `CustomerContact` | `CSTCN` | YES |
| 15 | `customer` | `CustomerDocument` | `CSTCD` | YES |
| 16 | `customer` | `CustomerDocumentType` | `DTP` | YES |
| 17 | `customer` | `CustomerEmail` | `CSTEM` | YES |
| 18 | `customer` | `CustomerType` | `CSTCT` | YES |
| 19 | `inventory` | `Inventory` | `INV` | YES |
| 20 | `inventory` | `InventoryMovement` | `INVMV` | YES |
| 21 | `inventory` | `InventoryMovementNote` | `INVMN` | YES |
| 22 | `inventory` | `InventoryMovementReason` | `INVMR` | YES |
| 23 | `inventory` | `InventoryReservation` | `INVRE` | YES |
| 24 | `inventory` | `InventoryReservationStatus` | `INVRS` | YES |
| 1 | `metadata` | `TablePrefix` | `PFX` | YES |
| 25 | `payment` | `Payment` | `PAY` | YES |
| 26 | `payment` | `PaymentMethod` | `PAYME` | YES |
| 27 | `payment` | `PaymentRefund` | `PAYRF` | YES |
| 28 | `payment` | `PaymentRefundReason` | `PAYRR` | YES |
| 29 | `payment` | `PaymentStatus` | `PAYST` | YES |
| 30 | `reference` | `Address` | `ADR` | YES |
| 31 | `reference` | `AdministrativeDivision` | `ADV` | YES |
| 32 | `reference` | `City` | `CTY` | YES |
| 33 | `reference` | `ContactType` | `CTP` | YES |
| 34 | `reference` | `Country` | `CTR` | YES |
| 35 | `sales` | `Transaction` | `TRN` | YES |
| 36 | `sales` | `TransactionChannel` | `TRNCH` | YES |
| 37 | `sales` | `TransactionItem` | `TRNIT` | YES |
| 38 | `sales` | `TransactionStatus` | `TRNST` | YES |
| 39 | `shipping` | `Shipment` | `SHP` | YES |
| 40 | `shipping` | `ShipmentMethod` | `SHPMT` | YES |
| 41 | `shipping` | `ShipmentStatus` | `SHPST` | YES |

O registro é a referência oficial para a atribuição de prefixos às tabelas.

Os valores dos prefixos são restritos a caracteres alfabéticos maiúsculos, com comprimento entre dois e cinco caracteres. As regras de unicidade impedem tanto a reutilização de prefixos quanto registros duplicados de *schema*/tabela.

As atribuições de prefixos são mantidas como metadados de governança técnica, permitindo que a consistência da nomenclatura seja validada independentemente das definições individuais das tabelas.

---

## 10. Metadados Estruturais

### 10.1. *Primary Keys*

Atualmente, o AtlasCommerce contém uma *primary key* para cada uma de suas 41 tabelas de aplicação.

Todas as *primary keys* implementadas utilizam estruturas físicas *clustered*.

As *primary keys* compostas preservam a ordem das colunas conforme implementada no SQL Server.

#### 10.1.1. `catalog`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `catalog.Brand` | `PK_BRD` | CLUSTERED | `BRD_id` |
| `catalog.Category` | `PK_CTG` | CLUSTERED | `CTG_id` |
| `catalog.Product` | `PK_PRD` | CLUSTERED | `PRD_id` |
| `catalog.ProductAttribute` | `PK_PAT` | CLUSTERED | `PAT_id` |
| `catalog.ProductAttributeValue` | `PK_PATVL` | CLUSTERED | `PATVL_id` |
| `catalog.ProductCategory` | `PK_PRDCT` | CLUSTERED | `PRDCT_PRD_id`, `PRDCT_CTG_id` |
| `catalog.ProductImage` | `PK_PRDIM` | CLUSTERED | `PRDIM_id` |
| `catalog.ProductVariant` | `PK_PRDVA` | CLUSTERED | `PRDVA_id` |
| `catalog.ProductVariantAttributeValue` | `PK_PRDAV` | CLUSTERED | `PRDAV_PRDVA_id`, `PRDAV_PATVL_id` |
| `catalog.ProductVariantPrice` | `PK_PRDVP` | CLUSTERED | `PRDVP_id` |

#### 10.1.2. `customer`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `customer.Customer` | `PK_CST` | CLUSTERED | `CST_id` |
| `customer.CustomerAddress` | `PK_CSTAD` | CLUSTERED | `CSTAD_id` |
| `customer.CustomerContact` | `PK_CSTCN` | CLUSTERED | `CSTCN_id` |
| `customer.CustomerDocument` | `PK_CSTCD` | CLUSTERED | `CSTCD_id` |
| `customer.CustomerDocumentType` | `PK_DTP` | CLUSTERED | `DTP_id` |
| `customer.CustomerEmail` | `PK_CSTEM` | CLUSTERED | `CSTEM_id` |
| `customer.CustomerType` | `PK_CSTCT` | CLUSTERED | `CSTCT_id` |

#### 10.1.3. `inventory`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `inventory.Inventory` | `PK_INV` | CLUSTERED | `INV_id` |
| `inventory.InventoryMovement` | `PK_INVMV` | CLUSTERED | `INVMV_id` |
| `inventory.InventoryMovementNote` | `PK_INVMN` | CLUSTERED | `INVMN_id` |
| `inventory.InventoryMovementReason` | `PK_INVMR` | CLUSTERED | `INVMR_id` |
| `inventory.InventoryReservation` | `PK_INVRE` | CLUSTERED | `INVRE_id` |
| `inventory.InventoryReservationStatus` | `PK_INVRS` | CLUSTERED | `INVRS_id` |

#### 10.1.4. `metadata`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `metadata.TablePrefix` | `PK_PFX` | CLUSTERED | `PFX_id` |

#### 10.1.5. `payment`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `payment.Payment` | `PK_PAY` | CLUSTERED | `PAY_id` |
| `payment.PaymentMethod` | `PK_PAYME` | CLUSTERED | `PAYME_id` |
| `payment.PaymentRefund` | `PK_PAYRF` | CLUSTERED | `PAYRF_id` |
| `payment.PaymentRefundReason` | `PK_PAYRR` | CLUSTERED | `PAYRR_id` |
| `payment.PaymentStatus` | `PK_PAYST` | CLUSTERED | `PAYST_id` |

#### 10.1.6. `reference`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `reference.Address` | `PK_ADR` | CLUSTERED | `ADR_id` |
| `reference.AdministrativeDivision` | `PK_ADV` | CLUSTERED | `ADV_id` |
| `reference.City` | `PK_CTY` | CLUSTERED | `CTY_id` |
| `reference.ContactType` | `PK_CTP` | CLUSTERED | `CTP_id` |
| `reference.Country` | `PK_CTR` | CLUSTERED | `CTR_id` |

#### 10.1.7. `sales`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `sales.Transaction` | `PK_TRN` | CLUSTERED | `TRN_id`, `TRN_transaction_at` |
| `sales.TransactionChannel` | `PK_TRNCH` | CLUSTERED | `TRNCH_id` |
| `sales.TransactionItem` | `PK_TRNIT` | CLUSTERED | `TRNIT_id`, `TRNIT_transaction_at` |
| `sales.TransactionStatus` | `PK_TRNST` | CLUSTERED | `TRNST_id` |

#### 10.1.8. `shipping`

| Tabela | *Primary Key* | Tipo | Colunas |
|---|---|---|---|
| `shipping.Shipment` | `PK_SHP` | CLUSTERED | `SHP_id` |
| `shipping.ShipmentMethod` | `PK_SHPMT` | CLUSTERED | `SHPMT_id` |
| `shipping.ShipmentStatus` | `PK_SHPST` | CLUSTERED | `SHPST_id` |

### 10.2. *UNIQUE Constraints*

O AtlasCommerce utiliza *UNIQUE Constraints* para aplicar regras de unicidade de negócio e estruturais que devem ser garantidas pelo modelo relacional.

Todas as *UNIQUE Constraints* atualmente implementadas utilizam estruturas físicas *nonclustered*.

As *UNIQUE Constraints* compostas preservam a ordem das colunas conforme implementada no SQL Server.

### 10.2.1. `catalog`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `catalog.Brand` | `UQ_BRD_name` | NONCLUSTERED | `BRD_name` |
| `catalog.Category` | `UQ_CTG_parent_name` | NONCLUSTERED | `CTG_CTG_id`, `CTG_name` |
| `catalog.Product` | `UQ_PRD_brand_name` | NONCLUSTERED | `PRD_BRD_id`, `PRD_name` |
| `catalog.ProductAttribute` | `UQ_PAT_name` | NONCLUSTERED | `PAT_name` |
| `catalog.ProductAttributeValue` | `UQ_PATVL_attribute_value` | NONCLUSTERED | `PATVL_PAT_id`, `PATVL_value` |
| `catalog.ProductVariant` | `UQ_PRDVA_sku` | NONCLUSTERED | `PRDVA_sku` |

### 10.2.2. `customer`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `customer.CustomerDocument` | `UQ_CSTCD_document` | NONCLUSTERED | `CSTCD_DTP_id`, `CSTCD_value` |
| `customer.CustomerDocumentType` | `UQ_DTP_name` | NONCLUSTERED | `DTP_name` |
| `customer.CustomerType` | `UQ_CSTCT_code` | NONCLUSTERED | `CSTCT_code` |

### 10.2.3. `inventory`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `inventory.Inventory` | `UQ_INV_PRDVA` | NONCLUSTERED | `INV_PRDVA_id` |
| `inventory.InventoryMovementReason` | `UQ_INVMR_name` | NONCLUSTERED | `INVMR_name` |
| `inventory.InventoryReservation` | `UQ_INVRE_TRNIT` | NONCLUSTERED | `INVRE_TRNIT_id`, `INVRE_TRNIT_transaction_at` |
| `inventory.InventoryReservationStatus` | `UQ_INVRS_name` | NONCLUSTERED | `INVRS_name` |

### 10.2.4. `metadata`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `metadata.TablePrefix` | `UQ_PFX_prefix` | NONCLUSTERED | `PFX_prefix` |
| `metadata.TablePrefix` | `UQ_PFX_table` | NONCLUSTERED | `PFX_schema_name`, `PFX_table_name` |

### 10.2.5. `payment`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `payment.PaymentMethod` | `UQ_PAYME_name` | NONCLUSTERED | `PAYME_name` |
| `payment.PaymentRefundReason` | `UQ_PAYRR_name` | NONCLUSTERED | `PAYRR_name` |
| `payment.PaymentStatus` | `UQ_PAYST_name` | NONCLUSTERED | `PAYST_name` |

### 10.2.6. `reference`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `reference.Address` | `UQ_ADR_city_postal_code_street` | NONCLUSTERED | `ADR_CTY_id`, `ADR_postal_code`, `ADR_street` |
| `reference.AdministrativeDivision` | `UQ_ADV_country_code` | NONCLUSTERED | `ADV_CTR_id`, `ADV_code` |
| `reference.City` | `UQ_CTY_administrative_division_name` | NONCLUSTERED | `CTY_ADV_id`, `CTY_name` |
| `reference.ContactType` | `UQ_CTP_name` | NONCLUSTERED | `CTP_name` |
| `reference.Country` | `UQ_CTR_name` | NONCLUSTERED | `CTR_name` |

### 10.2.7. `sales`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `sales.TransactionChannel` | `UQ_TRNCH_code` | NONCLUSTERED | `TRNCH_code` |
| `sales.TransactionStatus` | `UQ_TRNST_code` | NONCLUSTERED | `TRNST_code` |

### 10.2.8. `shipping`

| Tabela | *UNIQUE Constraint* | Tipo | Colunas |
|---|---|---|---|
| `shipping.Shipment` | `UQ_SHP_TRN` | NONCLUSTERED | `SHP_TRN_id`, `SHP_transaction_at` |
| `shipping.ShipmentMethod` | `UQ_SHPMT_name` | NONCLUSTERED | `SHPMT_name` |
| `shipping.ShipmentStatus` | `UQ_SHPST_name` | NONCLUSTERED | `SHPST_name` |

### 10.3. *CHECK Constraints*

O AtlasCommerce utiliza *CHECK Constraints* para impor regras de domínio, consistência, integridade temporal e integridade entre colunas diretamente no modelo relacional.

A coluna identifica a coluna à qual a *constraint* está associada quando o SQL Server vincula a *constraint* a uma única coluna. O valor `—` indica que a *constraint* representa uma regra no nível da tabela envolvendo múltiplas colunas ou expressões.

Todas as *CHECK Constraints* atualmente implementadas estão habilitadas e são confiáveis.

#### 10.3.1. `catalog`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `catalog.ProductImage` | `CK_PRDIM_display_order` | `PRDIM_display_order` | `([PRDIM_display_order]>=(1))` | YES | YES |
| `catalog.ProductImage` | `CK_PRDIM_path` | `PRDIM_path` | `(len(ltrim(rtrim([PRDIM_path])))>(0))` | YES | YES |
| `catalog.ProductImage` | `CK_PRDIM_primary_active` | — | `([PRDIM_is_primary]=(0) OR [PRDIM_is_active]=(1))` | YES | YES |
| `catalog.ProductVariantPrice` | `CK_PRDVP_price` | `PRDVP_price` | `([PRDVP_price]>(0.00))` | YES | YES |
| `catalog.ProductVariantPrice` | `CK_PRDVP_valid_period` | — | `([PRDVP_valid_to] IS NULL OR [PRDVP_valid_to]>[PRDVP_valid_from])` | YES | YES |

#### 10.3.2. `customer`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `customer.Customer` | `CK_CST_birth_date` | `CST_birth_date` | `([CST_birth_date] IS NULL OR [CST_birth_date]<=CONVERT([date],sysdatetime()))` | YES | YES |
| `customer.CustomerAddress` | `CK_CSTAD_primary_active` | — | `([CSTAD_is_primary]=(0) OR [CSTAD_is_active]=(1))` | YES | YES |
| `customer.CustomerContact` | `CK_CSTCN_primary_active` | — | `([CSTCN_is_primary]=(0) OR [CSTCN_is_active]=(1))` | YES | YES |
| `customer.CustomerEmail` | `CK_CSTEM_primary_active` | — | `([CSTEM_is_primary]=(0) OR [CSTEM_is_active]=(1))` | YES | YES |

#### 10.3.3. `inventory`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `inventory.Inventory` | `CK_INV_quantity_on_hand` | `INV_quantity_on_hand` | `([INV_quantity_on_hand]>=(0))` | YES | YES |
| `inventory.Inventory` | `CK_INV_quantity_reserved` | — | `([INV_quantity_reserved]>=(0) AND [INV_quantity_reserved]<=[INV_quantity_on_hand])` | YES | YES |
| `inventory.InventoryMovement` | `CK_INVMV_quantity` | `INVMV_quantity` | `([INVMV_quantity]<>(0))` | YES | YES |
| `inventory.InventoryMovement` | `CK_INVMV_TRNIT_reference` | — | `([INVMV_TRNIT_id] IS NULL AND [INVMV_TRNIT_transaction_at] IS NULL OR [INVMV_TRNIT_id] IS NOT NULL AND [INVMV_TRNIT_transaction_at] IS NOT NULL)` | YES | YES |
| `inventory.InventoryReservation` | `CK_INVRE_closed_at` | — | `([INVRE_closed_at] IS NULL OR [INVRE_closed_at]>=[INVRE_reserved_at])` | YES | YES |
| `inventory.InventoryReservation` | `CK_INVRE_expires_at` | — | `([INVRE_expires_at]>[INVRE_reserved_at])` | YES | YES |
| `inventory.InventoryReservation` | `CK_INVRE_quantity` | `INVRE_quantity` | `([INVRE_quantity]>(0))` | YES | YES |

#### 10.3.4. `metadata`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `metadata.TablePrefix` | `CK_PFX_prefix_format` | `PFX_prefix` | `(NOT ([PFX_prefix]) collate Latin1_General_100_BIN2 like N'%[^A-Z]%')` | YES | YES |
| `metadata.TablePrefix` | `CK_PFX_prefix_length` | `PFX_prefix` | `(len([PFX_prefix])>=(2) AND len([PFX_prefix])<=(5))` | YES | YES |

#### 10.3.5. `payment`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `payment.Payment` | `CK_PAY_amount` | `PAY_amount` | `([PAY_amount]>(0))` | YES | YES |
| `payment.Payment` | `CK_PAY_approved_at` | — | `([PAY_approved_at] IS NULL OR [PAY_approved_at]>=[PAY_attempted_at])` | YES | YES |
| `payment.Payment` | `CK_PAY_attempted_at` | — | `([PAY_attempted_at]>=[PAY_transaction_at])` | YES | YES |
| `payment.Payment` | `CK_PAY_cancelled_at` | — | `([PAY_cancelled_at] IS NULL OR [PAY_cancelled_at]>=[PAY_attempted_at])` | YES | YES |
| `payment.Payment` | `CK_PAY_installment_count` | `PAY_installment_count` | `([PAY_installment_count] IS NULL OR [PAY_installment_count]>(1))` | YES | YES |
| `payment.PaymentRefund` | `CK_PAYRF_amount` | `PAYRF_amount` | `([PAYRF_amount]>(0))` | YES | YES |

#### 10.3.6. `reference`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `reference.Address` | `CK_ADR_postal_code` | `ADR_postal_code` | `(len([ADR_postal_code])=(8) AND NOT [ADR_postal_code] like '%[^0-9]%')` | YES | YES |

#### 10.3.7. `sales`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `sales.Transaction` | `CK_TRN_discount_amount` | `TRN_discount_amount` | `([TRN_discount_amount]>=(0.00))` | YES | YES |
| `sales.Transaction` | `CK_TRN_discount_not_greater_than_gross_amount` | — | `([TRN_discount_amount]<=[TRN_gross_amount])` | YES | YES |
| `sales.Transaction` | `CK_TRN_gross_amount` | `TRN_gross_amount` | `([TRN_gross_amount]>=(0.00))` | YES | YES |
| `sales.TransactionItem` | `CK_TRNIT_discount_not_greater_than_price` | — | `([TRNIT_unit_discount]<=[TRNIT_unit_price])` | YES | YES |
| `sales.TransactionItem` | `CK_TRNIT_quantity` | `TRNIT_quantity` | `([TRNIT_quantity]>(0))` | YES | YES |
| `sales.TransactionItem` | `CK_TRNIT_unit_discount` | `TRNIT_unit_discount` | `([TRNIT_unit_discount]>=(0.00))` | YES | YES |
| `sales.TransactionItem` | `CK_TRNIT_unit_price` | `TRNIT_unit_price` | `([TRNIT_unit_price]>=(0.00))` | YES | YES |

#### 10.3.8. `shipping`

| Tabela | *CHECK Constraint* | Coluna | Definição | Habilitada | Confiável |
|---|---|---|---|---|---|
| `shipping.Shipment` | `CK_SHP_delivered_at` | — | `([SHP_delivered_at] IS NULL OR [SHP_posted_at] IS NOT NULL AND [SHP_delivered_at]>=[SHP_posted_at])` | YES | YES |
| `shipping.Shipment` | `CK_SHP_estimated_delivery_date` | — | `([SHP_estimated_delivery_date]>=CONVERT([date],[SHP_transaction_at]))` | YES | YES |
| `shipping.Shipment` | `CK_SHP_posted_at` | — | `([SHP_posted_at] IS NULL OR [SHP_posted_at]>=[SHP_transaction_at])` | YES | YES |
| `shipping.Shipment` | `CK_SHP_shipping_amount` | `SHP_shipping_amount` | `([SHP_shipping_amount]>=(0))` | YES | YES |

### 10.4. *FOREIGN KEY Constraints*

O AtlasCommerce utiliza *FOREIGN KEY* para preservar a integridade referencial dentro dos domínios do banco de dados e entre eles.

As definições das *FOREIGN KEY* são documentadas utilizando o mapeamento completo das colunas implementadas. Os relacionamentos compostos preservam a ordem das colunas definida no SQL Server.

Todas as *FOREIGN KEY* atualmente implementadas estão habilitadas e são confiáveis.

Salvo indicação em contrário, as *FOREIGN KEY* utilizam `ON DELETE NO ACTION` e `ON UPDATE NO ACTION`.

#### 10.4.1. `catalog`

| Tabela de Origem | *FOREIGN KEY* | Colunas de Origem | Tabela Referenciada | Colunas Referenciadas | *ON DELETE* | *ON UPDATE* | Habilitada | Confiável |
|---|---|---|---|---|---|---|:---:|:---:|
| `catalog.Category` | `FK_CTG_CTG` | `CTG_CTG_id` | `catalog.Category` | `CTG_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.Product` | `FK_PRD_BRD` | `PRD_BRD_id` | `catalog.Brand` | `BRD_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductAttributeValue` | `FK_PATVL_PAT` | `PATVL_PAT_id` | `catalog.ProductAttribute` | `PAT_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductCategory` | `FK_PRDCT_CTG` | `PRDCT_CTG_id` | `catalog.Category` | `CTG_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductCategory` | `FK_PRDCT_PRD` | `PRDCT_PRD_id` | `catalog.Product` | `PRD_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductImage` | `FK_PRDIM_PRD` | `PRDIM_PRD_id` | `catalog.Product` | `PRD_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductVariant` | `FK_PRDVA_PRD` | `PRDVA_PRD_id` | `catalog.Product` | `PRD_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductVariantAttributeValue` | `FK_PRDAV_PATVL` | `PRDAV_PATVL_id` | `catalog.ProductAttributeValue` | `PATVL_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductVariantAttributeValue` | `FK_PRDAV_PRDVA` | `PRDAV_PRDVA_id` | `catalog.ProductVariant` | `PRDVA_id` | NO ACTION | NO ACTION | YES | YES |
| `catalog.ProductVariantPrice` | `FK_PRDVP_PRDVA` | `PRDVP_PRDVA_id` | `catalog.ProductVariant` | `PRDVA_id` | NO ACTION | NO ACTION | YES | YES |

#### 10.4.2. `customer`

| Tabela de Origem | *FOREIGN KEY* | Colunas de Origem | Tabela Referenciada | Colunas Referenciadas | *ON DELETE* | *ON UPDATE* | Habilitada | Confiável |
|---|---|---|---|---|---|---|:---:|:---:|
| `customer.Customer` | `FK_CST_CSTCT` | `CST_CSTCT_id` | `customer.CustomerType` | `CSTCT_id` | NO ACTION | NO ACTION | YES | YES |
| `customer.CustomerAddress` | `FK_CSTAD_ADR` | `CSTAD_ADR_id` | `reference.Address` | `ADR_id` | NO ACTION | NO ACTION | YES | YES |
| `customer.CustomerAddress` | `FK_CSTAD_CST` | `CSTAD_CST_id` | `customer.Customer` | `CST_id` | NO ACTION | NO ACTION | YES | YES |
| `customer.CustomerContact` | `FK_CSTCN_CST` | `CSTCN_CST_id` | `customer.Customer` | `CST_id` | NO ACTION | NO ACTION | YES | YES |
| `customer.CustomerContact` | `FK_CSTCN_CTP` | `CSTCN_CTP_id` | `reference.ContactType` | `CTP_id` | NO ACTION | NO ACTION | YES | YES |
| `customer.CustomerDocument` | `FK_CSTCD_CST` | `CSTCD_CST_id` | `customer.Customer` | `CST_id` | NO ACTION | NO ACTION | YES | YES |
| `customer.CustomerDocument` | `FK_CSTCD_DTP` | `CSTCD_DTP_id` | `customer.CustomerDocumentType` | `DTP_id` | NO ACTION | NO ACTION | YES | YES |
| `customer.CustomerEmail` | `FK_CSTEM_CST` | `CSTEM_CST_id` | `customer.Customer` | `CST_id` | NO ACTION | NO ACTION | YES | YES |

#### 10.4.3. `inventory`

| Tabela de Origem | *FOREIGN KEY* | Colunas de Origem | Tabela Referenciada | Colunas Referenciadas | *ON DELETE* | *ON UPDATE* | Habilitada | Confiável |
|---|---|---|---|---|---|---|:---:|:---:|
| `inventory.Inventory` | `FK_INV_PRDVA` | `INV_PRDVA_id` | `catalog.ProductVariant` | `PRDVA_id` | NO ACTION | NO ACTION | YES | YES |
| `inventory.InventoryMovement` | `FK_INVMV_INVMR` | `INVMV_INVMR_id` | `inventory.InventoryMovementReason` | `INVMR_id` | NO ACTION | NO ACTION | YES | YES |
| `inventory.InventoryMovement` | `FK_INVMV_PRDVA` | `INVMV_PRDVA_id` | `catalog.ProductVariant` | `PRDVA_id` | NO ACTION | NO ACTION | YES | YES |
| `inventory.InventoryMovement` | `FK_INVMV_TRNIT` | `INVMV_TRNIT_id`, `INVMV_TRNIT_transaction_at` | `sales.TransactionItem` | `TRNIT_id`, `TRNIT_transaction_at` | NO ACTION | NO ACTION | YES | YES |
| `inventory.InventoryMovementNote` | `FK_INVMN_INVMV` | `INVMN_INVMV_id` | `inventory.InventoryMovement` | `INVMV_id` | NO ACTION | NO ACTION | YES | YES |
| `inventory.InventoryReservation` | `FK_INVRE_INVRS` | `INVRE_INVRS_id` | `inventory.InventoryReservationStatus` | `INVRS_id` | NO ACTION | NO ACTION | YES | YES |
| `inventory.InventoryReservation` | `FK_INVRE_PRDVA` | `INVRE_PRDVA_id` | `catalog.ProductVariant` | `PRDVA_id` | NO ACTION | NO ACTION | YES | YES |
| `inventory.InventoryReservation` | `FK_INVRE_TRNIT` | `INVRE_TRNIT_id`, `INVRE_TRNIT_transaction_at` | `sales.TransactionItem` | `TRNIT_id`, `TRNIT_transaction_at` | NO ACTION | NO ACTION | YES | YES |

#### 10.4.4. `payment`

| Tabela de Origem | *FOREIGN KEY* | Colunas de Origem | Tabela Referenciada | Colunas Referenciadas | *ON DELETE* | *ON UPDATE* | Habilitada | Confiável |
|---|---|---|---|---|---|---|:---:|:---:|
| `payment.Payment` | `FK_PAY_PAYME` | `PAY_PAYME_id` | `payment.PaymentMethod` | `PAYME_id` | NO ACTION | NO ACTION | YES | YES |
| `payment.Payment` | `FK_PAY_PAYST` | `PAY_PAYST_id` | `payment.PaymentStatus` | `PAYST_id` | NO ACTION | NO ACTION | YES | YES |
| `payment.Payment` | `FK_PAY_TRN` | `PAY_TRN_id`, `PAY_transaction_at` | `sales.Transaction` | `TRN_id`, `TRN_transaction_at` | NO ACTION | NO ACTION | YES | YES |
| `payment.PaymentRefund` | `FK_PAYRF_PAY` | `PAYRF_PAY_id` | `payment.Payment` | `PAY_id` | NO ACTION | NO ACTION | YES | YES |
| `payment.PaymentRefund` | `FK_PAYRF_PAYRR` | `PAYRF_PAYRR_id` | `payment.PaymentRefundReason` | `PAYRR_id` | NO ACTION | NO ACTION | YES | YES |

#### 10.4.5. `reference`

| Tabela de Origem | *FOREIGN KEY* | Colunas de Origem | Tabela Referenciada | Colunas Referenciadas | *ON DELETE* | *ON UPDATE* | Habilitada | Confiável |
|---|---|---|---|---|---|---|:---:|:---:|
| `reference.Address` | `FK_ADR_CTY` | `ADR_CTY_id` | `reference.City` | `CTY_id` | NO ACTION | NO ACTION | YES | YES |
| `reference.AdministrativeDivision` | `FK_ADV_CTR` | `ADV_CTR_id` | `reference.Country` | `CTR_id` | NO ACTION | NO ACTION | YES | YES |
| `reference.City` | `FK_CTY_ADV` | `CTY_ADV_id` | `reference.AdministrativeDivision` | `ADV_id` | NO ACTION | NO ACTION | YES | YES |

#### 10.4.6. `sales`

| Tabela de Origem | *FOREIGN KEY* | Colunas de Origem | Tabela Referenciada | Colunas Referenciadas | *ON DELETE* | *ON UPDATE* | Habilitada | Confiável |
|---|---|---|---|---|---|---|:---:|:---:|
| `sales.Transaction` | `FK_TRN_CST` | `TRN_CST_id` | `customer.Customer` | `CST_id` | NO ACTION | NO ACTION | YES | YES |
| `sales.Transaction` | `FK_TRN_TRNCH` | `TRN_TRNCH_id` | `sales.TransactionChannel` | `TRNCH_id` | NO ACTION | NO ACTION | YES | YES |
| `sales.Transaction` | `FK_TRN_TRNST` | `TRN_TRNST_id` | `sales.TransactionStatus` | `TRNST_id` | NO ACTION | NO ACTION | YES | YES |
| `sales.TransactionItem` | `FK_TRNIT_PRDVA` | `TRNIT_PRDVA_id` | `catalog.ProductVariant` | `PRDVA_id` | NO ACTION | NO ACTION | YES | YES |
| `sales.TransactionItem` | `FK_TRNIT_TRN` | `TRNIT_TRN_id`, `TRNIT_transaction_at` | `sales.Transaction` | `TRN_id`, `TRN_transaction_at` | CASCADE | NO ACTION | YES | YES |

#### 10.4.7. `shipping`

| Tabela de Origem | *FOREIGN KEY* | Colunas de Origem | Tabela Referenciada | Colunas Referenciadas | *ON DELETE* | *ON UPDATE* | Habilitada | Confiável |
|---|---|---|---|---|---|---|:---:|:---:|
| `shipping.Shipment` | `FK_SHP_CSTAD` | `SHP_CSTAD_id` | `customer.CustomerAddress` | `CSTAD_id` | NO ACTION | NO ACTION | YES | YES |
| `shipping.Shipment` | `FK_SHP_SHPMT` | `SHP_SHPMT_id` | `shipping.ShipmentMethod` | `SHPMT_id` | NO ACTION | NO ACTION | YES | YES |
| `shipping.Shipment` | `FK_SHP_SHPST` | `SHP_SHPST_id` | `shipping.ShipmentStatus` | `SHPST_id` | NO ACTION | NO ACTION | YES | YES |
| `shipping.Shipment` | `FK_SHP_TRN` | `SHP_TRN_id`, `SHP_transaction_at` | `sales.Transaction` | `TRN_id`, `TRN_transaction_at` | NO ACTION | NO ACTION | YES | YES |

### 10.5. Índices

O AtlasCommerce utiliza índices adicionais para dar suporte aos padrões de acesso das consultas, às regras de unicidade de negócio que não podem ser representadas por *UNIQUE Constraints* e aos requisitos de alinhamento físico das tabelas particionadas.

Os índices de *primary key* e *UNIQUE Constraint* estão documentados em suas respectivas seções e, portanto, não são repetidos aqui.

Os índices relacionados abaixo representam índices de banco de dados definidos de forma independente.

*Filtered unique indexes* (índices únicos filtrados) são utilizados quando a unicidade se aplica apenas a um subconjunto de linhas.

Para tabelas particionadas, `PS_SALES_MONTHLY` identifica os índices alinhados à arquitetura de particionamento mensal de vendas. As colunas de particionamento incluídas automaticamente pelo SQL Server são identificadas separadamente das colunas-chave explicitamente definidas no índice.

#### 10.5.1. `catalog`

| Tabela | Índice | Tipo | Único | Colunas-Chave | Colunas Incluídas | Filtro | Espaço de Dados |
|---|---|---|:---:|---|---|---|---|
| `catalog.ProductImage` | `UX_PRDIM_primary_product` | NONCLUSTERED | YES | `PRDIM_PRD_id` | — | `PRDIM_is_primary = 1` | `FG_CORE` |
| `catalog.ProductImage` | `UX_PRDIM_product_display_order_active` | NONCLUSTERED | YES | `PRDIM_PRD_id`, `PRDIM_display_order` | — | `PRDIM_is_active = 1` | `FG_CORE` |
| `catalog.ProductVariant` | `UX_PRDVA_barcode` | NONCLUSTERED | YES | `PRDVA_barcode` | — | `PRDVA_barcode IS NOT NULL` | `FG_CORE` |
| `catalog.ProductVariantPrice` | `IX_PRDVP_PRDVA_valid_from` | NONCLUSTERED | NO | `PRDVP_PRDVA_id`, `PRDVP_valid_from` | `PRDVP_valid_to`, `PRDVP_price` | — | `FG_CORE` |
| `catalog.ProductVariantPrice` | `UX_PRDVP_open_period` | NONCLUSTERED | YES | `PRDVP_PRDVA_id` | — | `PRDVP_valid_to IS NULL` | `FG_CORE` |

#### 10.5.2. `customer`

| Tabela | Índice | Tipo | Único | Colunas-Chave | Colunas Incluídas | Filtro | Espaço de Dados |
|---|---|---|:---:|---|---|---|---|
| `customer.Customer` | `IX_CST_name` | NONCLUSTERED | NO | `CST_name` | — | — | `FG_CORE` |
| `customer.CustomerAddress` | `UX_CSTAD_primary_active` | NONCLUSTERED | YES | `CSTAD_CST_id` | — | `CSTAD_is_primary = 1 AND CSTAD_is_active = 1` | `FG_CORE` |
| `customer.CustomerContact` | `UX_CSTCN_primary_active` | NONCLUSTERED | YES | `CSTCN_CST_id` | — | `CSTCN_is_primary = 1 AND CSTCN_is_active = 1` | `FG_CORE` |
| `customer.CustomerEmail` | `UX_CSTEM_primary_active` | NONCLUSTERED | YES | `CSTEM_CST_id` | — | `CSTEM_is_primary = 1 AND CSTEM_is_active = 1` | `FG_CORE` |

#### 10.5.3. `inventory`

| Tabela | Índice | Tipo | Único | Colunas-Chave | Colunas Incluídas | Filtro | Espaço de Dados |
|---|---|---|:---:|---|---|---|---|
| `inventory.InventoryMovement` | `IX_INVMV_PRDVA_movement_at` | NONCLUSTERED | NO | `INVMV_PRDVA_id`, `INVMV_movement_at` | — | — | `FG_CORE` |
| `inventory.InventoryMovementNote` | `IX_INVMN_INVMV` | NONCLUSTERED | NO | `INVMN_INVMV_id` | — | — | `FG_CORE` |
| `inventory.InventoryReservation` | `IX_INVRE_INVRS_expires_at` | NONCLUSTERED | NO | `INVRE_INVRS_id`, `INVRE_expires_at` | — | — | `FG_CORE` |
| `inventory.InventoryReservation` | `IX_INVRE_PRDVA_INVRS` | NONCLUSTERED | NO | `INVRE_PRDVA_id`, `INVRE_INVRS_id` | — | — | `FG_CORE` |

#### 10.5.4. `payment`

| Tabela | Índice | Tipo | Único | Colunas-Chave | Colunas Incluídas | Filtro | Espaço de Dados |
|---|---|---|:---:|---|---|---|---|
| `payment.Payment` | `IX_PAY_TRN` | NONCLUSTERED | NO | `PAY_TRN_id`, `PAY_transaction_at` | — | — | `FG_CORE` |
| `payment.Payment` | `IX_PAY_updated_at` | NONCLUSTERED | NO | `PAY_updated_at` | — | — | `FG_CORE` |
| `payment.PaymentRefund` | `IX_PAYRF_PAY` | NONCLUSTERED | NO | `PAYRF_PAY_id`, `PAYRF_refunded_at` | `PAYRF_amount` | — | `FG_CORE` |
| `payment.PaymentRefund` | `IX_PAYRF_updated_at` | NONCLUSTERED | NO | `PAYRF_updated_at` | — | — | `FG_CORE` |

#### 10.5.5. `sales`

| Tabela | Índice | Tipo | Único | Colunas-Chave | Coluna de Particionamento | Colunas Incluídas | Filtro | Espaço de Dados |
|---|---|---|:---:|---|---|---|---|---|
| `sales.Transaction` | `IX_TRN_CST_transaction_at` | NONCLUSTERED | NO | `TRN_CST_id`, `TRN_transaction_at` | — | — | — | `PS_SALES_MONTHLY` |
| `sales.Transaction` | `IX_TRN_transaction_at` | NONCLUSTERED | NO | `TRN_transaction_at` | — | — | — | `PS_SALES_MONTHLY` |
| `sales.Transaction` | `IX_TRN_updated_at` | NONCLUSTERED | NO | `TRN_updated_at` | `TRN_transaction_at` | — | — | `PS_SALES_MONTHLY` |
| `sales.TransactionItem` | `IX_TRNIT_PRDVA` | NONCLUSTERED | NO | `TRNIT_PRDVA_id` | `TRNIT_transaction_at` | — | — | `PS_SALES_MONTHLY` |
| `sales.TransactionItem` | `IX_TRNIT_TRN_transaction_at` | NONCLUSTERED | NO | `TRNIT_TRN_id`, `TRNIT_transaction_at` | — | — | — | `PS_SALES_MONTHLY` |
| `sales.TransactionItem` | `IX_TRNIT_updated_at` | NONCLUSTERED | NO | `TRNIT_updated_at` | `TRNIT_transaction_at` | — | — | `PS_SALES_MONTHLY` |

##### Índices Alinhados ao Particionamento

`sales.Transaction` e `sales.TransactionItem` são particionadas por meio de `PS_SALES_MONTHLY`.

Seus índices adicionais estão alinhados ao mesmo *partition scheme* (esquema de particionamento).

Para índices particionados não únicos, o SQL Server pode incluir automaticamente a coluna de particionamento na estrutura do índice, mesmo quando essa coluna não tiver sido explicitamente declarada como uma coluna-chave do índice.

Isso ocorre na implementação atual para:

| Tabela | Índice | Chave Explícita | Coluna de Particionamento |
|---|---|---|---|
| `sales.Transaction` | `IX_TRN_updated_at` | `TRN_updated_at` | `TRN_transaction_at` |
| `sales.TransactionItem` | `IX_TRNIT_PRDVA` | `TRNIT_PRDVA_id` | `TRNIT_transaction_at` |
| `sales.TransactionItem` | `IX_TRNIT_updated_at` | `TRNIT_updated_at` | `TRNIT_transaction_at` |

A coluna de particionamento, portanto, faz parte da estrutura física do índice necessária para o alinhamento ao particionamento, mas não deve ser interpretada como uma coluna-chave adicional declarada explicitamente.

#### 10.5.6. `shipping`

| Tabela | Índice | Tipo | Único | Colunas-Chave | Colunas Incluídas | Filtro | Espaço de Dados |
|---|---|---|:---:|---|---|---|---|
| `shipping.Shipment` | `IX_SHP_updated_at` | NONCLUSTERED | NO | `SHP_updated_at` | — | — | `FG_CORE` |
| `shipping.Shipment` | `UX_SHP_tracking_code` | NONCLUSTERED | YES | `SHP_tracking_code` | — | `SHP_tracking_code IS NOT NULL` | `FG_CORE` |

### 10.6. Particionamento

O AtlasCommerce utiliza particionamento baseado em tempo para as estruturas transacionais de alto volume do *schema* `sales`.

A arquitetura de particionamento implementada é compartilhada por:

- `sales.Transaction`;
- `sales.TransactionItem`.

Ambas as tabelas e seus índices alinhados ao particionamento utilizam:

- *Partition Function* (função de particionamento): `PF_SALES_MONTHLY`;
- *Partition Scheme* (esquema de particionamento): `PS_SALES_MONTHLY`;
- direção dos limites: `RANGE RIGHT`;
- coluna de particionamento em `sales.Transaction`: `TRN_transaction_at`;
- coluna de particionamento em `sales.TransactionItem`: `TRNIT_transaction_at`.

A função de particionamento define limites mensais de janeiro de 2025 até janeiro de 2028.

Como a função de particionamento utiliza `RANGE RIGHT`, cada valor de limite pertence à partição à sua direita.

Conceitualmente:

```text
Partição 1
    valores < 2025-01-01

Partição 2
    valores >= 2025-01-01
    e       < 2025-02-01

...

Partição 37
    valores >= 2027-12-01
    e       < 2028-01-01

Partição 38
    valores >= 2028-01-01
```

#### 10.6.1. Mapeamento de Partições

| Partição | Limite Inferior | Limite Superior | *Filegroup* |
|---:|---|---|---|
| 1 | — | `2025-01-01` | `FG_SALES_LEGACY` |
| 2 | `2025-01-01` | `2025-02-01` | `FG_SALES_PART_01` |
| 3 | `2025-02-01` | `2025-03-01` | `FG_SALES_PART_02` |
| 4 | `2025-03-01` | `2025-04-01` | `FG_SALES_PART_03` |
| 5 | `2025-04-01` | `2025-05-01` | `FG_SALES_PART_04` |
| 6 | `2025-05-01` | `2025-06-01` | `FG_SALES_PART_05` |
| 7 | `2025-06-01` | `2025-07-01` | `FG_SALES_PART_06` |
| 8 | `2025-07-01` | `2025-08-01` | `FG_SALES_PART_07` |
| 9 | `2025-08-01` | `2025-09-01` | `FG_SALES_PART_08` |
| 10 | `2025-09-01` | `2025-10-01` | `FG_SALES_PART_09` |
| 11 | `2025-10-01` | `2025-11-01` | `FG_SALES_PART_10` |
| 12 | `2025-11-01` | `2025-12-01` | `FG_SALES_PART_11` |
| 13 | `2025-12-01` | `2026-01-01` | `FG_SALES_PART_12` |
| 14 | `2026-01-01` | `2026-02-01` | `FG_SALES_PART_13` |
| 15 | `2026-02-01` | `2026-03-01` | `FG_SALES_PART_14` |
| 16 | `2026-03-01` | `2026-04-01` | `FG_SALES_PART_15` |
| 17 | `2026-04-01` | `2026-05-01` | `FG_SALES_PART_16` |
| 18 | `2026-05-01` | `2026-06-01` | `FG_SALES_PART_17` |
| 19 | `2026-06-01` | `2026-07-01` | `FG_SALES_PART_18` |
| 20 | `2026-07-01` | `2026-08-01` | `FG_SALES_PART_19` |
| 21 | `2026-08-01` | `2026-09-01` | `FG_SALES_PART_20` |
| 22 | `2026-09-01` | `2026-10-01` | `FG_SALES_PART_21` |
| 23 | `2026-10-01` | `2026-11-01` | `FG_SALES_PART_22` |
| 24 | `2026-11-01` | `2026-12-01` | `FG_SALES_PART_23` |
| 25 | `2026-12-01` | `2027-01-01` | `FG_SALES_PART_24` |
| 26 | `2027-01-01` | `2027-02-01` | `FG_SALES_PART_25` |
| 27 | `2027-02-01` | `2027-03-01` | `FG_SALES_PART_26` |
| 28 | `2027-03-01` | `2027-04-01` | `FG_SALES_PART_27` |
| 29 | `2027-04-01` | `2027-05-01` | `FG_SALES_PART_28` |
| 30 | `2027-05-01` | `2027-06-01` | `FG_SALES_PART_29` |
| 31 | `2027-06-01` | `2027-07-01` | `FG_SALES_PART_30` |
| 32 | `2027-07-01` | `2027-08-01` | `FG_SALES_PART_31` |
| 33 | `2027-08-01` | `2027-09-01` | `FG_SALES_PART_32` |
| 34 | `2027-09-01` | `2027-10-01` | `FG_SALES_PART_33` |
| 35 | `2027-10-01` | `2027-11-01` | `FG_SALES_PART_34` |
| 36 | `2027-11-01` | `2027-12-01` | `FG_SALES_PART_35` |
| 37 | `2027-12-01` | `2028-01-01` | `FG_SALES_PART_36` |
| 38 | `2028-01-01` | — | `FG_SALES_FUTURE` |

A primeira e a última partições representam intervalos sem limite em uma das extremidades.

`FG_SALES_LEGACY` recebe valores anteriores ao primeiro limite mensal definido.

`FG_SALES_FUTURE` recebe valores iguais ou posteriores ao último limite atualmente definido.

Os *filegroups* numerados `FG_SALES_PART_*` representam posições estruturais de armazenamento e seus nomes não vinculam permanentemente cada *filegroup* a um período específico de negócio.

#### 10.6.2. Estruturas Alinhadas ao Particionamento

As seguintes estruturas atualmente implementadas estão alinhadas a `PS_SALES_MONTHLY`:

| Tabela | Estrutura | Tipo |
|---|---|---|
| `sales.Transaction` | `PK_TRN` | CLUSTERED PRIMARY KEY |
| `sales.Transaction` | `IX_TRN_CST_transaction_at` | NONCLUSTERED INDEX |
| `sales.Transaction` | `IX_TRN_transaction_at` | NONCLUSTERED INDEX |
| `sales.Transaction` | `IX_TRN_updated_at` | NONCLUSTERED INDEX |
| `sales.TransactionItem` | `PK_TRNIT` | CLUSTERED PRIMARY KEY |
| `sales.TransactionItem` | `IX_TRNIT_TRN_transaction_at` | NONCLUSTERED INDEX |
| `sales.TransactionItem` | `IX_TRNIT_PRDVA` | NONCLUSTERED INDEX |
| `sales.TransactionItem` | `IX_TRNIT_updated_at` | NONCLUSTERED INDEX |

Todas essas estruturas utilizam a mesma *partition function* (função de particionamento), o mesmo *partition scheme* (esquema de particionamento), os mesmos limites de partição e o mesmo mapeamento das partições para os *filegroups* de destino.

#### 10.6.3. Próximo Filegroup Utilizado

`PS_SALES_MONTHLY` contém atualmente um destino adicional além das 38 partições definidas por `PF_SALES_MONTHLY`.

O destino adicional é:

| ID do Destino | Filegroup | Função Atual |
|---:|---|---|
| 39 | `FG_SALES_PART_37` | NEXT USED (PRÓXIMO A SER UTILIZADO) / destino preparado para o próximo *split* (divisão) de partição |

`FG_SALES_PART_37` faz, portanto, parte da arquitetura de particionamento implementada, embora atualmente não esteja associado a uma partição ativa.

Ele fornece o destino físico previamente preparado necessário para o próximo limite de partição introduzido por meio do ciclo de manutenção do particionamento.

Essa distinção é intencional:

```text
Partições atuais

    1 a 38

Filegroups atualmente mapeados

    FG_SALES_LEGACY

    FG_SALES_PART_01 ... FG_SALES_PART_36

    FG_SALES_FUTURE

Próximo destino preparado

    FG_SALES_PART_37
```

### 10.7. *DEFAULT Constraints*

O AtlasCommerce utiliza *DEFAULT Constraints* para fornecer valores iniciais determinísticos às colunas cujo valor pode ser estabelecido automaticamente quando uma linha é criada.

As *DEFAULT Constraints* são nomeadas explicitamente de acordo com a convenção de nomenclatura do banco de dados.

#### 10.7.1. `catalog`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `catalog.Brand` | `DF_BRD_is_active` | `BRD_is_active` | `((1))` |
| `catalog.Brand` | `DF_BRD_created_at` | `BRD_created_at` | `(sysdatetime())` |
| `catalog.Brand` | `DF_BRD_updated_at` | `BRD_updated_at` | `(sysdatetime())` |
| `catalog.Category` | `DF_CTG_is_active` | `CTG_is_active` | `((1))` |
| `catalog.Category` | `DF_CTG_created_at` | `CTG_created_at` | `(sysdatetime())` |
| `catalog.Category` | `DF_CTG_updated_at` | `CTG_updated_at` | `(sysdatetime())` |
| `catalog.Product` | `DF_PRD_is_active` | `PRD_is_active` | `((1))` |
| `catalog.Product` | `DF_PRD_created_at` | `PRD_created_at` | `(sysdatetime())` |
| `catalog.Product` | `DF_PRD_updated_at` | `PRD_updated_at` | `(sysdatetime())` |
| `catalog.ProductAttribute` | `DF_PAT_is_active` | `PAT_is_active` | `((1))` |
| `catalog.ProductAttribute` | `DF_PAT_created_at` | `PAT_created_at` | `(sysdatetime())` |
| `catalog.ProductAttribute` | `DF_PAT_updated_at` | `PAT_updated_at` | `(sysdatetime())` |
| `catalog.ProductAttributeValue` | `DF_PATVL_is_active` | `PATVL_is_active` | `((1))` |
| `catalog.ProductAttributeValue` | `DF_PATVL_created_at` | `PATVL_created_at` | `(sysdatetime())` |
| `catalog.ProductAttributeValue` | `DF_PATVL_updated_at` | `PATVL_updated_at` | `(sysdatetime())` |
| `catalog.ProductImage` | `DF_PRDIM_is_primary` | `PRDIM_is_primary` | `((0))` |
| `catalog.ProductImage` | `DF_PRDIM_is_active` | `PRDIM_is_active` | `((1))` |
| `catalog.ProductImage` | `DF_PRDIM_created_at` | `PRDIM_created_at` | `(sysdatetime())` |
| `catalog.ProductImage` | `DF_PRDIM_updated_at` | `PRDIM_updated_at` | `(sysdatetime())` |
| `catalog.ProductVariant` | `DF_PRDVA_is_active` | `PRDVA_is_active` | `((1))` |
| `catalog.ProductVariant` | `DF_PRDVA_created_at` | `PRDVA_created_at` | `(sysdatetime())` |
| `catalog.ProductVariant` | `DF_PRDVA_updated_at` | `PRDVA_updated_at` | `(sysdatetime())` |
| `catalog.ProductVariantPrice` | `DF_PRDVP_created_at` | `PRDVP_created_at` | `(sysdatetime())` |

#### 10.7.2. `customer`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `customer.Customer` | `DF_CST_is_active` | `CST_is_active` | `((1))` |
| `customer.Customer` | `DF_CST_created_at` | `CST_created_at` | `(sysdatetime())` |
| `customer.Customer` | `DF_CST_updated_at` | `CST_updated_at` | `(sysdatetime())` |
| `customer.CustomerAddress` | `DF_CSTAD_is_primary` | `CSTAD_is_primary` | `((0))` |
| `customer.CustomerAddress` | `DF_CSTAD_is_active` | `CSTAD_is_active` | `((1))` |
| `customer.CustomerAddress` | `DF_CSTAD_created_at` | `CSTAD_created_at` | `(sysdatetime())` |
| `customer.CustomerAddress` | `DF_CSTAD_updated_at` | `CSTAD_updated_at` | `(sysdatetime())` |
| `customer.CustomerContact` | `DF_CSTCN_is_primary` | `CSTCN_is_primary` | `((0))` |
| `customer.CustomerContact` | `DF_CSTCN_is_active` | `CSTCN_is_active` | `((1))` |
| `customer.CustomerContact` | `DF_CSTCN_created_at` | `CSTCN_created_at` | `(sysdatetime())` |
| `customer.CustomerContact` | `DF_CSTCN_updated_at` | `CSTCN_updated_at` | `(sysdatetime())` |
| `customer.CustomerDocument` | `DF_CSTCD_created_at` | `CSTCD_created_at` | `(sysdatetime())` |
| `customer.CustomerDocument` | `DF_CSTCD_updated_at` | `CSTCD_updated_at` | `(sysdatetime())` |
| `customer.CustomerDocumentType` | `DF_DTP_created_at` | `DTP_created_at` | `(sysdatetime())` |
| `customer.CustomerDocumentType` | `DF_DTP_updated_at` | `DTP_updated_at` | `(sysdatetime())` |
| `customer.CustomerEmail` | `DF_CSTEM_is_primary` | `CSTEM_is_primary` | `((0))` |
| `customer.CustomerEmail` | `DF_CSTEM_is_active` | `CSTEM_is_active` | `((1))` |
| `customer.CustomerEmail` | `DF_CSTEM_created_at` | `CSTEM_created_at` | `(sysdatetime())` |
| `customer.CustomerEmail` | `DF_CSTEM_updated_at` | `CSTEM_updated_at` | `(sysdatetime())` |
| `customer.CustomerType` | `DF_CSTCT_created_at` | `CSTCT_created_at` | `(sysdatetime())` |
| `customer.CustomerType` | `DF_CSTCT_updated_at` | `CSTCT_updated_at` | `(sysdatetime())` |

#### 10.7.3. `inventory`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `inventory.Inventory` | `DF_INV_quantity_on_hand` | `INV_quantity_on_hand` | `((0))` |
| `inventory.Inventory` | `DF_INV_quantity_reserved` | `INV_quantity_reserved` | `((0))` |
| `inventory.Inventory` | `DF_INV_created_at` | `INV_created_at` | `(sysdatetime())` |
| `inventory.Inventory` | `DF_INV_updated_at` | `INV_updated_at` | `(sysdatetime())` |
| `inventory.InventoryMovement` | `DF_INVMV_movement_at` | `INVMV_movement_at` | `(sysdatetime())` |
| `inventory.InventoryMovement` | `DF_INVMV_created_at` | `INVMV_created_at` | `(sysdatetime())` |
| `inventory.InventoryMovement` | `DF_INVMV_updated_at` | `INVMV_updated_at` | `(sysdatetime())` |
| `inventory.InventoryMovementNote` | `DF_INVMN_created_at` | `INVMN_created_at` | `(sysdatetime())` |
| `inventory.InventoryMovementNote` | `DF_INVMN_updated_at` | `INVMN_updated_at` | `(sysdatetime())` |
| `inventory.InventoryMovementReason` | `DF_INVMR_created_at` | `INVMR_created_at` | `(sysdatetime())` |
| `inventory.InventoryMovementReason` | `DF_INVMR_updated_at` | `INVMR_updated_at` | `(sysdatetime())` |
| `inventory.InventoryReservation` | `DF_INVRE_created_at` | `INVRE_created_at` | `(sysdatetime())` |
| `inventory.InventoryReservation` | `DF_INVRE_updated_at` | `INVRE_updated_at` | `(sysdatetime())` |
| `inventory.InventoryReservationStatus` | `DF_INVRS_created_at` | `INVRS_created_at` | `(sysdatetime())` |
| `inventory.InventoryReservationStatus` | `DF_INVRS_updated_at` | `INVRS_updated_at` | `(sysdatetime())` |

#### 10.7.4. `metadata`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `metadata.TablePrefix` | `DF_PFX_is_active` | `PFX_is_active` | `((1))` |

#### 10.7.5. `payment`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `payment.Payment` | `DF_PAY_created_at` | `PAY_created_at` | `(sysdatetime())` |
| `payment.Payment` | `DF_PAY_updated_at` | `PAY_updated_at` | `(sysdatetime())` |
| `payment.PaymentMethod` | `DF_PAYME_created_at` | `PAYME_created_at` | `(sysdatetime())` |
| `payment.PaymentMethod` | `DF_PAYME_updated_at` | `PAYME_updated_at` | `(sysdatetime())` |
| `payment.PaymentRefund` | `DF_PAYRF_created_at` | `PAYRF_created_at` | `(sysdatetime())` |
| `payment.PaymentRefund` | `DF_PAYRF_updated_at` | `PAYRF_updated_at` | `(sysdatetime())` |
| `payment.PaymentRefundReason` | `DF_PAYRR_created_at` | `PAYRR_created_at` | `(sysdatetime())` |
| `payment.PaymentRefundReason` | `DF_PAYRR_updated_at` | `PAYRR_updated_at` | `(sysdatetime())` |
| `payment.PaymentStatus` | `DF_PAYST_created_at` | `PAYST_created_at` | `(sysdatetime())` |
| `payment.PaymentStatus` | `DF_PAYST_updated_at` | `PAYST_updated_at` | `(sysdatetime())` |

#### 10.7.6. `reference`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `reference.Address` | `DF_ADR_created_at` | `ADR_created_at` | `(sysdatetime())` |
| `reference.Address` | `DF_ADR_updated_at` | `ADR_updated_at` | `(sysdatetime())` |
| `reference.AdministrativeDivision` | `DF_ADV_created_at` | `ADV_created_at` | `(sysdatetime())` |
| `reference.AdministrativeDivision` | `DF_ADV_updated_at` | `ADV_updated_at` | `(sysdatetime())` |
| `reference.City` | `DF_CTY_created_at` | `CTY_created_at` | `(sysdatetime())` |
| `reference.City` | `DF_CTY_updated_at` | `CTY_updated_at` | `(sysdatetime())` |
| `reference.ContactType` | `DF_CTP_created_at` | `CTP_created_at` | `(sysdatetime())` |
| `reference.ContactType` | `DF_CTP_updated_at` | `CTP_updated_at` | `(sysdatetime())` |
| `reference.Country` | `DF_CTR_created_at` | `CTR_created_at` | `(sysdatetime())` |
| `reference.Country` | `DF_CTR_updated_at` | `CTR_updated_at` | `(sysdatetime())` |

#### 10.7.7. `sales`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `sales.Transaction` | `DF_TRN_discount_amount` | `TRN_discount_amount` | `((0.00))` |
| `sales.Transaction` | `DF_TRN_created_at` | `TRN_created_at` | `(sysdatetime())` |
| `sales.Transaction` | `DF_TRN_updated_at` | `TRN_updated_at` | `(sysdatetime())` |
| `sales.TransactionChannel` | `DF_TRNCH_is_active` | `TRNCH_is_active` | `((1))` |
| `sales.TransactionChannel` | `DF_TRNCH_created_at` | `TRNCH_created_at` | `(sysdatetime())` |
| `sales.TransactionChannel` | `DF_TRNCH_updated_at` | `TRNCH_updated_at` | `(sysdatetime())` |
| `sales.TransactionItem` | `DF_TRNIT_unit_discount` | `TRNIT_unit_discount` | `((0.00))` |
| `sales.TransactionItem` | `DF_TRNIT_created_at` | `TRNIT_created_at` | `(sysdatetime())` |
| `sales.TransactionItem` | `DF_TRNIT_updated_at` | `TRNIT_updated_at` | `(sysdatetime())` |
| `sales.TransactionStatus` | `DF_TRNST_is_active` | `TRNST_is_active` | `((1))` |
| `sales.TransactionStatus` | `DF_TRNST_created_at` | `TRNST_created_at` | `(sysdatetime())` |
| `sales.TransactionStatus` | `DF_TRNST_updated_at` | `TRNST_updated_at` | `(sysdatetime())` |

#### 10.7.8. `shipping`

| Tabela | *DEFAULT Constraint* | Coluna | Definição *DEFAULT* |
|---|---|---|---|
| `shipping.Shipment` | `DF_SHP_created_at` | `SHP_created_at` | `(sysdatetime())` |
| `shipping.Shipment` | `DF_SHP_updated_at` | `SHP_updated_at` | `(sysdatetime())` |
| `shipping.ShipmentMethod` | `DF_SHPMT_created_at` | `SHPMT_created_at` | `(sysdatetime())` |
| `shipping.ShipmentMethod` | `DF_SHPMT_updated_at` | `SHPMT_updated_at` | `(sysdatetime())` |
| `shipping.ShipmentStatus` | `DF_SHPST_created_at` | `SHPST_created_at` | `(sysdatetime())` |
| `shipping.ShipmentStatus` | `DF_SHPST_updated_at` | `SHPST_updated_at` | `(sysdatetime())` |

### 10.8. *Triggers*

O AtlasCommerce utiliza *DML triggers* seletivamente quando uma regra de integridade exige uma validação que não pode ser representada adequadamente apenas por *constraints* declarativas.

Os *triggers* documentados abaixo fazem parte do modelo de integridade implementado no banco de dados.

Todos os *triggers* atualmente implementados estão habilitados e são executados como *AFTER triggers*.

| Tabela | *Trigger* | Tipo | *INSERT* | *UPDATE* | *DELETE* | Habilitado |
|---|---|---|:---:|:---:|:---:|:---:|
| `catalog.ProductVariantPrice` | `TR_PRDVP_no_overlap` | AFTER | YES | YES | NO | YES |
| `inventory.InventoryReservation` | `TR_INVRE_reservation_temporal_integrity` | AFTER | YES | YES | NO | YES |
| `payment.Payment` | `TR_PAY_refund_integrity` | AFTER | NO | YES | NO | YES |
| `payment.PaymentRefund` | `TR_PAYRF_refund_integrity` | AFTER | YES | YES | NO | YES |