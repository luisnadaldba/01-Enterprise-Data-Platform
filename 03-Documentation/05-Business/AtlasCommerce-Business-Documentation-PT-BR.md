# Documentação de Negócio do AtlasCommerce

## Informações do Documento

- **Sistema:** AtlasCommerce
- **Tipo de Documento:** Documentação de Negócio
- **Idioma:** Português (Brasil)
- **Status:** Final
- **Objetivo:** Descrever como o AtlasCommerce funciona sob a perspectiva de negócio.

---

## Índice

[1. Visão Geral do AtlasCommerce](#1-visão-geral-do-atlascommerce)

[2. Escopo de Negócio e Modelo Operacional](#2-escopo-de-negócio-e-modelo-operacional)

[3. Catálogo de Produtos e Comercialização](#3-catálogo-de-produtos-e-comercialização)
   - [3.1 Produtos e Marcas](#31-produtos-e-marcas)
   - [3.2 Variantes de Produto](#32-variantes-de-produto)
   - [3.3 Atributos de Produto](#33-atributos-de-produto)
   - [3.4 Categorias de Produto](#34-categorias-de-produto)
   - [3.5 Imagens de Produto](#35-imagens-de-produto)
   - [3.6 Preços de Produto](#36-preços-de-produto)

[4. Gestão de Clientes](#4-gestão-de-clientes)
   - [4.1 Clientes Identificados e Não Identificados](#41-clientes-identificados-e-não-identificados)
   - [4.2 Tipos de Cliente](#42-tipos-de-cliente)
   - [4.3 Documentos do Cliente](#43-documentos-do-cliente)
   - [4.4 Contatos Telefônicos](#44-contatos-telefônicos)
   - [4.5 Endereços de E-mail](#45-endereços-de-e-mail)
   - [4.6 Endereços do Cliente](#46-endereços-do-cliente)

[5. Vendas e Ciclo de Vida da Transação](#5-vendas-e-ciclo-de-vida-da-transação)
   - [5.1 Transação](#51-transação)
   - [5.2 Canais de Venda](#52-canais-de-venda)
   - [5.3 Status da Transação](#53-status-da-transação)
   - [5.4 Itens da Transação](#54-itens-da-transação)
   - [5.5 Valores da Transação](#55-valores-da-transação)

[6. Gestão de Estoque](#6-gestão-de-estoque)
   - [6.1 Posição Atual do Estoque](#61-posição-atual-do-estoque)
   - [6.2 Movimentações de Estoque](#62-movimentações-de-estoque)
   - [6.3 Motivos de Movimentação de Estoque](#63-motivos-de-movimentação-de-estoque)

[7. Ciclo de Vida da Reserva de Estoque](#7-ciclo-de-vida-da-reserva-de-estoque)
   - [7.1 Finalidade de uma Reserva](#71-finalidade-de-uma-reserva)
   - [7.2 Período de Reserva](#72-período-de-reserva)
   - [7.3 Status da Reserva](#73-status-da-reserva)

[8. Processamento de Pagamentos](#8-processamento-de-pagamentos)
   - [8.1 Pagamentos e Tentativas de Pagamento](#81-pagamentos-e-tentativas-de-pagamento)
   - [8.2 Métodos de Pagamento](#82-métodos-de-pagamento)
   - [8.3 Parcelamento](#83-parcelamento)
   - [8.4 Status do Pagamento](#84-status-do-pagamento)

[9. Processamento de Estornos](#9-processamento-de-estornos)
   - [9.1 Eventos de Estorno](#91-eventos-de-estorno)
   - [9.2 Estornos Parciais e Totais](#92-estornos-parciais-e-totais)
   - [9.3 Motivos de Estorno](#93-motivos-de-estorno)

[10. Entrega e Expedição](#10-entrega-e-expedição)
    - [10.1 Quando Existe Entrega](#101-quando-existe-entrega)
    - [10.2 Uma Transação, Uma Entrega](#102-uma-transação-uma-entrega)
    - [10.3 Endereço de Entrega](#103-endereço-de-entrega)
    - [10.4 Métodos de Envio](#104-métodos-de-envio)
    - [10.5 Valor do Frete](#105-valor-do-frete)
    - [10.6 Previsão de Entrega e Rastreamento](#106-previsão-de-entrega-e-rastreamento)
    - [10.7 Status da Entrega](#107-status-da-entrega)

[11. Regras de Negócio entre Domínios](#11-regras-de-negócio-entre-domínios)
    - [11.1 Status da Transação Não É Status do Pagamento](#111-status-da-transação-não-é-status-do-pagamento)
    - [11.2 Status da Transação Não É Status da Reserva](#112-status-da-transação-não-é-status-da-reserva)
    - [11.3 Status da Transação Não É Status da Entrega](#113-status-da-transação-não-é-status-da-entrega)
    - [11.4 Status do Pagamento Não É Histórico de Estornos](#114-status-do-pagamento-não-é-histórico-de-estornos)
    - [11.5 Estoque Atual Não É Histórico de Estoque](#115-estoque-atual-não-é-histórico-de-estoque)

[12. Informações Históricas de Negócio](#12-informações-históricas-de-negócio)
    - [12.1 Histórico de Preços de Venda](#121-histórico-de-preços-de-venda)
    - [12.2 Histórico de Preços de Catálogo](#122-histórico-de-preços-de-catálogo)
    - [12.3 Histórico de Endereços do Cliente](#123-histórico-de-endereços-do-cliente)
    - [12.4 Histórico de Eventos de Estoque](#124-histórico-de-eventos-de-estoque)
    - [12.5 Histórico de Pagamentos e Estornos](#125-histórico-de-pagamentos-e-estornos)
    - [12.6 Por Que a Verdade Histórica É Importante](#126-por-que-a-verdade-histórica-é-importante)

[13. Cenários de Negócio Ponta a Ponta](#13-cenários-de-negócio-ponta-a-ponta)
    - [13.1 Compra Online Entregue com Sucesso](#131-compra-online-entregue-com-sucesso)
    - [13.2 Compra em Loja com Retirada Imediata](#132-compra-em-loja-com-retirada-imediata)
    - [13.3 Tentativa de Pagamento Recusada e Repetida](#133-tentativa-de-pagamento-recusada-e-repetida)
    - [13.4 Reserva Liberada Antes da Expiração](#134-reserva-liberada-antes-da-expiração)
    - [13.5 Reserva Expira](#135-reserva-expira)
    - [13.6 Estorno Parcial Seguido de Outro Estorno](#136-estorno-parcial-seguido-de-outro-estorno)
    - [13.7 Cliente Altera um Endereço Após uma Compra](#137-cliente-altera-um-endereço-após-uma-compra)

[14. Resumo das Regras de Negócio](#14-resumo-das-regras-de-negócio)

[15. Limites do Escopo Atual](#15-limites-do-escopo-atual)

---

# 1. Visão Geral do AtlasCommerce

O AtlasCommerce é uma plataforma de comércio varejista focada em produtos de beleza e cuidados pessoais.

O negócio oferece suporte a dois canais de venda:

- **ONLINE**, para compras realizadas por meio do canal de vendas online.

- **STORE (LOJA)**, para compras realizadas diretamente na loja física.

A plataforma gerencia a jornada comercial desde o catálogo de produtos até a conclusão de uma venda, incluindo informações de clientes, disponibilidade e reserva de estoque, processamento de pagamentos, estornos e entrega quando necessária.

Nem toda venda segue exatamente o mesmo fluxo operacional.

Uma compra online exige um processo de entrega, enquanto um cliente que compra diretamente na loja física leva os produtos imediatamente e não necessita de envio.

As diferentes partes do negócio também possuem seus próprios ciclos de vida. Uma venda, um pagamento, uma reserva de estoque e uma entrega não compartilham um único status. Cada um representa um processo de negócio diferente e, portanto, pode evoluir de forma independente, permanecendo associado à mesma transação comercial.

O AtlasCommerce também preserva informações históricas relevantes para o negócio. Alterações nos preços atuais, nas informações dos clientes, nos endereços, no estoque ou em outros dados operacionais não devem modificar os fatos que descrevem transações que já ocorreram.

---

# 2. Escopo de Negócio e Modelo Operacional

O AtlasCommerce representa uma operação de varejo deliberadamente focada.

Seu escopo atual inclui:

- gestão de produtos e suas variantes comercializáveis;

- categorização de produtos e apresentação comercial;

- compras com clientes identificados e não identificados;

- vendas online e em loja física;

- preços e descontos no nível da transação e de seus itens;

- disponibilidade de estoque;

- reservas de estoque;

- movimentações de estoque;

- múltiplas tentativas ou operações de pagamento associadas a uma venda;

- estornos de pagamentos;

- entrega para compras que exigem envio;

- preservação de informações comerciais históricas.

O modelo de negócio atual evita intencionalmente complexidade desnecessária.

O AtlasCommerce opera com um único contexto de estoque. A distribuição de estoque entre múltiplas lojas e múltiplos depósitos está fora do escopo atual.

Uma transação que exige entrega possui, no máximo, uma entrega. A divisão de uma única compra entre múltiplos destinos de entrega também está fora do modelo atual. Quando os produtos precisam ser enviados para destinos diferentes, eles devem ser representados por transações separadas.

O objetivo é representar um negócio de varejo coerente sem modelar possibilidades operacionais para as quais não existe uma necessidade de negócio atual.

---

# 3. Catálogo de Produtos e Comercialização

## 3.1 Produtos e Marcas

Um produto representa a identidade comercial de um item oferecido pelo AtlasCommerce.

Os produtos podem estar associados a uma marca, permitindo que o catálogo organize as mercadorias de forma consistente de acordo com o fabricante ou a identidade comercial da marca.

O produto, por si só, não representa necessariamente o item exato comprado por um cliente. Os produtos podem possuir múltiplas variantes comercializáveis.

Por exemplo, um batom pode representar o produto comercial de forma geral, enquanto diferentes cores representam as variantes específicas disponíveis para compra.

Um exemplo simplificado seria:

- **Produto:** Batom

- **Variante:** Bege

- **Variante:** Vermelho

- **Variante:** Rosa

O produto define o que está sendo vendido comercialmente, enquanto as variantes identificam as versões específicas que o cliente pode efetivamente comprar.

---

## 3.2 Variantes de Produto

Uma variante de produto representa uma versão específica e comercializável de um produto.

As variantes permitem que o AtlasCommerce diferencie variações comerciais como cor, tamanho, volume, acabamento ou outras características relevantes para determinado produto.

Cada variante comercializável possui seu próprio SKU e é tratada de forma independente quando necessário para preços, estoque, reservas e vendas.

Essa distinção permite que duas variantes do mesmo produto tenham preços e disponibilidades de estoque diferentes.

Portanto, os clientes compram variantes de produto, e não uma definição abstrata do produto.

Por exemplo, considere um batom oferecido em diferentes cores e tamanhos:

- **Produto:** Batom

- **Variante:** Bege / 10 g

- **Variante:** Vermelho / 10 g

- **Variante:** Bege / 5 g

Cada uma dessas variantes representa um item comercializável distinto. Elas podem possuir seu próprio SKU, preço e disponibilidade de estoque, embora todas pertençam ao mesmo produto.

Isso significa que a variante Bege / 10 g pode estar disponível em estoque enquanto a variante Vermelho / 10 g está esgotada, ou uma variante pode ter um preço diferente das demais.

---

## 3.3 Atributos de Produto

O AtlasCommerce utiliza atributos de produto reutilizáveis para descrever características que variam entre produtos e variantes.

Um atributo representa uma característica como cor, volume, tamanho ou acabamento.

Cada atributo pode possuir um conjunto controlado de valores possíveis, e as variantes comercializáveis podem ser associadas aos valores que as descrevem.

Essa abordagem permite que o catálogo represente diferentes tipos de produtos de beleza e cuidados pessoais sem exigir que todos os produtos compartilhem as mesmas características fixas.

Por exemplo, considere a variante de batom **Bege / 10 g** apresentada anteriormente.

Ela pode ser descrita utilizando atributos e seus respectivos valores:

- **Cor:** Bege

- **Peso:** 10 g

Outra variante do mesmo batom poderia ser:

- **Cor:** Vermelho

- **Peso:** 10 g

Ambas as variantes pertencem ao mesmo produto, mas os valores de seus atributos descrevem o que torna cada versão comercializável distinta.

O mesmo atributo, como **Cor**, também pode ser reutilizado para descrever variantes de outros produtos quando essa característica for relevante.

---

## 3.4 Categorias de Produto

Os produtos podem ser classificados em categorias para apoiar a organização do catálogo.

As categorias podem formar uma hierarquia, permitindo que classificações mais amplas contenham classificações mais específicas.

Um produto pode participar de mais de uma categoria quando apropriado.

A estrutura de categorias descreve, portanto, como os produtos são apresentados e organizados comercialmente sem alterar a identidade do próprio produto.

Por exemplo, o batom utilizado nos exemplos anteriores poderia aparecer em duas hierarquias de categorias diferentes:

**Por tipo de produto:**

- **Maquiagem**
  - **Lábios**
    - **Batom**

**Por coleção comercial:**

- **Maquiagem**
  - **Longa Duração**
    - **Batom**

Ambas as classificações se referem ao mesmo produto. O produto não precisa ser duplicado simplesmente porque os clientes podem encontrá-lo por diferentes áreas do catálogo.

As categorias fornecem, portanto, diferentes formas de organizar e navegar pelo catálogo enquanto o produto mantém uma única identidade comercial.

---

## 3.5 Imagens de Produto

Os produtos podem possuir múltiplas imagens utilizadas para apresentação no catálogo.

As imagens podem ter uma ordem de apresentação definida, e uma imagem ativa pode ser designada como a imagem principal de um produto.

A imagem principal representa a apresentação visual preferencial do produto, enquanto imagens adicionais podem fornecer visualizações alternativas ou materiais complementares de apresentação.

Imagens inativas podem permanecer historicamente registradas sem participar da apresentação atual do catálogo.

---

## 3.6 Preços de Produto

Os preços pertencem às variantes comercializáveis dos produtos.

O AtlasCommerce mantém o histórico de preços em vez de tratar o preço atual como o único preço que já existiu.

Um preço é aplicável durante um período de validade definido. Dessa forma, um novo preço comercial pode entrar em vigor sem sobrescrever o preço anterior.

Os períodos históricos de preço não devem se sobrepor para a mesma variante.

Isso permite que o AtlasCommerce diferencie entre:

- o preço atualmente oferecido no catálogo; e

- os preços que foram comercialmente válidos no passado.

O preço registrado em uma venda efetivamente realizada é preservado separadamente como parte dessa venda e não se altera quando o preço do catálogo muda posteriormente.

Ao preservar esses preços históricos, o AtlasCommerce também pode determinar qual preço de catálogo era válido para uma variante de produto durante um período específico.

Isso cria um histórico real de como o valor comercial de uma variante mudou ao longo do tempo, permitindo responder a perguntas como:

- Qual era o preço desta variante seis meses atrás?

- Quando seu preço aumentou ou diminuiu?

- Como seu valor comercial mudou ao longo do tempo?

Combinado com o preço preservado em cada venda efetivamente realizada, isso também permite distinguir entre o preço que era oferecido no catálogo e o preço que o cliente realmente pagou em determinado momento.

---

# 4. Gestão de Clientes

## 4.1 Clientes Identificados e Não Identificados

Os requisitos de identificação do cliente dependem do canal de venda.

Para compras **ONLINE**, o cliente deve estar cadastrado e identificado. O processo de venda online exige informações do cliente e um endereço válido para entrega.

Para compras **STORE (LOJA)**, a identificação do cliente é opcional. Um cliente pode comprar produtos diretamente na loja física e levá-los imediatamente sem fornecer informações pessoais ou possuir um perfil de cliente cadastrado.

Por exemplo, um cliente que entra na loja, compra um batom, realiza o pagamento e sai com o produto pode concluir a transação sem estar cadastrado no AtlasCommerce.

Se o cliente optar por se identificar durante uma compra em loja física, a transação poderá ser associada ao seu perfil de cliente existente.

Essa distinção permite que o AtlasCommerce atenda aos diferentes requisitos do varejo online e físico sem criar cadastros de clientes quando o processo de negócio não exige isso.

Manter um histórico de compras identificadas pode permitir que o AtlasCommerce ofereça suporte a iniciativas comerciais voltadas ao cliente definidas pela empresa. Por exemplo, a empresa pode optar por oferecer promoções ou descontos com base no histórico de compras, preferências do cliente, aniversários ou outros critérios comerciais.

Essas iniciativas são estratégias de negócio opcionais, e não benefícios garantidos pela identificação do cliente. O AtlasCommerce não pressupõe que um cliente identificado sempre receberá promoções, descontos ou outras vantagens.

---

## 4.2 Tipos de Cliente

Os clientes identificados podem atualmente ser classificados como:

- **INDIVIDUAL (PESSOA FÍSICA)**

- **COMPANY (PESSOA JURÍDICA)**

Um indivíduo representa uma pessoa física.

Uma empresa representa uma pessoa jurídica.

As informações aplicáveis a um cliente podem depender de seu tipo. Por exemplo, uma data de nascimento é relevante para um indivíduo, mas não é utilizada como data de fundação de uma empresa.

---

## 4.3 Documentos do Cliente

Um cliente identificado pode possuir um ou mais documentos de identificação.

Os tipos de documentos atualmente suportados dependem do tipo de cliente:

**INDIVIDUAL (PESSOA FÍSICA)**

- **CPF**

- **RG**

- **CNH**

- **PASSPORT (PASSAPORTE)**

**COMPANY (PESSOA JURÍDICA)**

- **CNPJ**

Os documentos são mantidos separadamente da identidade principal do cliente porque um cliente pode possuir mais de um tipo de documento.

O valor de um documento não pode ser duplicado para o mesmo tipo de documento entre diferentes clientes.

Isso permite que o AtlasCommerce mantenha a identificação dos clientes de forma controlada sem incorporar todos os possíveis documentos diretamente ao perfil do cliente.

---

## 4.4 Contatos Telefônicos

Um cliente identificado pode possuir informações de contato telefônico.

As classificações de contato atualmente suportadas são:

- **PHONE (TELEFONE)**

- **MOBILE (TELEFONE CELULAR)**

Um cliente pode possuir múltiplos contatos telefônicos, mas no máximo um pode ser designado como seu contato principal.

---

## 4.5 Endereços de E-mail

Um cliente identificado pode possuir múltiplos endereços de e-mail, mas no máximo um pode ser designado como seu e-mail principal.

O mesmo endereço de e-mail pode legitimamente estar associado a diferentes clientes. Isso permite situações como membros de uma família ou dependentes compartilhando um endereço de e-mail em comum.

---

## 4.6 Endereços do Cliente

Um cliente identificado pode manter múltiplos endereços, mas no máximo um pode ser designado como seu endereço principal.

O cliente também pode manter outros endereços para diferentes finalidades, como a entrega em outro local.

O histórico de endereços é preservado.

Quando ocorre uma alteração relevante em um endereço, o endereço histórico utilizado por operações de negócio anteriores não deve ser transformado retroativamente no novo endereço.

Em vez disso, o vínculo anterior entre o cliente e o endereço pode se tornar inativo, enquanto o novo endereço passa a estar disponível para operações futuras.

Essa distinção é especialmente importante para entregas, pois uma entrega realizada no passado deve continuar representando o destino que foi efetivamente selecionado naquele momento.

---

# 5. Vendas e Ciclo de Vida da Transação

## 5.1 Transação

Uma Transação representa uma venda comercial processada pelo AtlasCommerce.

Cada transação registra quando o evento comercial ocorreu, como ele se originou, seu status de negócio atual e seus valores monetários.

A necessidade de identificação do cliente depende do canal de venda. Transações ONLINE exigem um cliente identificado, enquanto a identificação do cliente é opcional para transações STORE (LOJA).

Cada transação pode conter um ou mais itens comprados.

Por exemplo, considere duas vendas diferentes:

**Venda online identificada**

Um cliente cadastrado compra um batom pelo canal ONLINE. A transação é associada a esse cliente e preserva os detalhes comerciais da compra. Por ser uma venda online, o cliente é identificado e a compra segue o processo de entrega.

**Venda em loja física sem identificação**

Um cliente entra na loja física, compra um batom, realiza o pagamento e leva o produto imediatamente sem fornecer informações pessoais. A transação é registrada normalmente pelo canal STORE (LOJA), mas não é associada a um cliente cadastrado.

Ambas são transações válidas no AtlasCommerce. A identificação do cliente fornece contexto adicional ao negócio quando disponível, mas uma venda em loja física sem identificação continua sendo uma transação comercial completa.

---

## 5.2 Canais de Venda

As transações atualmente se originam por meio de um dos dois canais:

- **ONLINE**

- **STORE (LOJA)**

O canal identifica como a venda se originou.

Uma transação ONLINE representa uma compra realizada pelo canal online.

Uma transação STORE (LOJA) representa uma compra realizada diretamente na loja física.

No escopo atual do AtlasCommerce, uma compra STORE (LOJA) é tratada como retirada imediata: o cliente compra os produtos e os leva diretamente da loja.

Consequentemente, transações STORE (LOJA) não exigem um processo de entrega.

---

## 5.3 Status da Transação

O ciclo de vida da transação utiliza atualmente os seguintes status:

### PENDING (PENDENTE)

A transação existe, mas ainda não atingiu o ponto em que a venda é considerada confirmada.

### CONFIRMED (CONFIRMADA)

A transação foi confirmada com sucesso após a aprovação do pagamento, mas os produtos ainda não foram entregues ao cliente.

Esse status se aplica às compras ONLINE, nas quais a confirmação do pagamento e a entrega física ocorrem em momentos diferentes. A venda foi comercialmente confirmada e pode prosseguir pelo processo de atendimento e entrega, mas seu ciclo de vida ainda não foi concluído.

Compras STORE (LOJA) não exigem esse estado intermediário porque o cliente recebe os produtos imediatamente como parte do processo de venda na loja física.

### COMPLETED (CONCLUÍDA)

A transação atingiu o final de seu ciclo de vida comercial e o cliente recebeu os produtos comprados.

Para uma compra ONLINE, a transação chega a COMPLETED (CONCLUÍDA) após os produtos terem sido entregues com sucesso ao cliente.

Para uma compra STORE (LOJA), o pagamento e a entrega dos produtos ao cliente ocorrem como parte do mesmo processo de venda na loja física. A transação pode, portanto, chegar a COMPLETED (CONCLUÍDA) sem exigir o estado intermediário CONFIRMED (CONFIRMADA) utilizado pelas compras online.

### CANCELLED (CANCELADA)

A transação foi intencionalmente cancelada e não continuará por seu ciclo de vida comercial normal.

### FAILED (FALHA)

A transação não pôde ser concluída com sucesso porque o processo de venda falhou.

Uma transação com falha é diferente de um cancelamento deliberado.

---

## 5.4 Itens da Transação

Cada transação contém as variantes de produto incluídas na compra.

Para cada item, o AtlasCommerce preserva:

- a variante comprada;

- a quantidade;

- o preço unitário aplicado à venda;

- o desconto unitário aplicado à venda.

Essas informações representam as condições financeiras efetivamente aplicadas quando a transação ocorreu.

Uma alteração posterior no preço de catálogo, portanto, não modifica o preço histórico de uma transação existente.

O mesmo princípio se aplica aos descontos: o desconto registrado na venda representa aquele que foi efetivamente concedido naquele momento.

---

## 5.5 Valores da Transação

O AtlasCommerce diferencia o valor bruto de uma transação do desconto concedido.

O valor bruto representa o valor comercial antes dos descontos aplicados no nível da transação.

O valor do desconto representa a redução monetária aplicada à transação.

O valor do frete não é tratado como parte do valor principal da transação. Quando a entrega é necessária, seu custo pertence ao processo de entrega.

Isso mantém o valor das mercadorias e o custo da entrega como conceitos de negócio distintos.

---

# 6. Gestão de Estoque

## 6.1 Posição Atual do Estoque

O estoque é gerenciado por variante comercializável de produto.

Para cada variante, o AtlasCommerce diferencia:

- a quantidade fisicamente disponível em estoque utilizável;

- a quantidade atualmente reservada para vendas.

A quantidade reservada não pode exceder a quantidade disponível em estoque.

O componente de reserva permite que o negócio diferencie o estoque que existe fisicamente daquele que já foi comprometido com um processo de venda ativo.

O estoque representa mercadorias utilizáveis. Produtos danificados, perdidos ou que, por qualquer outro motivo, não estejam disponíveis para venda não devem permanecer representados como estoque utilizável.

---

## 6.2 Movimentações de Estoque

As alterações no estoque são registradas como movimentações de negócio.

Cada movimentação identifica:

- a variante de produto afetada;

- a quantidade que entra ou sai do estoque;

- o motivo da movimentação;

- quando a movimentação ocorreu.

Quantidades positivas representam entradas no estoque.

Quantidades negativas representam saídas do estoque.

Quando uma movimentação se origina de um item específico comprado, ela pode permanecer associada a esse item da venda.

Por exemplo, um cliente compra duas unidades da variante de batom Bege / 10 g.

Quando os produtos deixam o estoque utilizável como parte dessa venda, a movimentação de estoque correspondente pode permanecer associada ao item específico da transação que continha essas duas unidades.

Essa relação permite compreender não apenas que o estoque diminuiu, mas também qual venda causou essa redução.

Isso permite que o AtlasCommerce preserve não apenas a posição atual do estoque, mas também os eventos de negócio que fizeram com que o estoque se alterasse.

---

## 6.3 Motivos de Movimentação de Estoque

O AtlasCommerce reconhece atualmente os seguintes motivos de movimentação de estoque, organizados de acordo com o aumento ou a redução do estoque utilizável.

### Entradas de Estoque

#### PURCHASE_RECEIPT (RECEBIMENTO DE COMPRA)

Mercadoria utilizável entrou no estoque como resultado do recebimento de produtos adquiridos.

#### CUSTOMER_RETURN (DEVOLUÇÃO DO CLIENTE)

Mercadoria devolvida por um cliente retornou ao estoque utilizável.

#### FOUND_INTERNAL (LOCALIZADO INTERNAMENTE)

Mercadoria anteriormente indisponível foi encontrada internamente e retornou ao estoque utilizável.

#### INVENTORY_ADJUSTMENT_IN (AJUSTE DE ENTRADA DE ESTOQUE)

Um ajuste controlado de estoque aumentou o estoque utilizável.

### Saídas de Estoque

#### SALE (VENDA)

Mercadoria deixou o estoque utilizável como resultado de uma venda ao cliente.

#### DAMAGED_IN_TRANSIT (DANIFICADO EM TRÂNSITO)

Mercadoria tornou-se indisponível por ter sido danificada durante o transporte.

#### DAMAGED_INTERNAL (DANIFICADO INTERNAMENTE)

Mercadoria tornou-se indisponível por ter sido danificada internamente.

#### LOSS_IN_TRANSIT (PERDA EM TRÂNSITO)

Mercadoria tornou-se indisponível por ter sido perdida durante o transporte.

#### LOSS_INTERNAL (PERDA INTERNA)

Mercadoria tornou-se indisponível devido a uma perda interna.

#### INVENTORY_ADJUSTMENT_OUT (AJUSTE DE SAÍDA DE ESTOQUE)

Um ajuste controlado de estoque reduziu o estoque utilizável.

Esses motivos diferenciam a causa de negócio de uma alteração no estoque da própria alteração de quantidade.

Contexto operacional adicional pode ser registrado quando uma movimentação exigir uma explicação além de seu motivo padronizado.

---

# 7. Ciclo de Vida da Reserva de Estoque

## 7.1 Finalidade de uma Reserva

Uma reserva representa o estoque comprometido com um item específico de uma transação.

Sua finalidade é diferenciar mercadorias que permanecem fisicamente presentes no estoque, mas que já foram alocadas a um processo de venda ativo.

Cada item da transação pode possuir, no máximo, uma reserva de estoque.

A variante reservada deve ser a mesma variante representada pelo item da transação.

Uma reserva sempre representa uma quantidade positiva.

---

## 7.2 Período de Reserva

Uma reserva de estoque é criada por um período limitado.

Enquanto a reserva estiver válida, a quantidade reservada permanece comprometida com o item correspondente da transação e não é considerada disponível para outra venda.

Cada reserva possui, portanto, um horário de expiração que define por quanto tempo o estoque pode permanecer reservado.

Por exemplo, se duas unidades do batom Bege / 10 g estiverem reservadas até 14h30, essas duas unidades permanecerão comprometidas com aquela transação até que a reserva seja consumida, liberada ou atinja seu horário de expiração.

Se a venda prosseguir com sucesso, a reserva poderá ser consumida.

Se o estoque reservado não for mais necessário antes do horário de expiração, a reserva poderá ser liberada.

Se nenhuma dessas situações ocorrer antes do término do período de reserva, a reserva expirará.

Isso evita que o estoque permaneça indefinidamente comprometido com um processo de venda que não foi concluído.

---

## 7.3 Status da Reserva

As reservas utilizam atualmente quatro status:

### ACTIVE (ATIVA)

O estoque permanece reservado para o item da transação.

Uma reserva ativa ainda não foi encerrada.

### CONSUMED (CONSUMIDA)

A reserva cumpriu sua finalidade e o estoque reservado foi consumido pelo processo de venda.

### RELEASED (LIBERADA)

O estoque não é mais necessário para o item da transação e foi liberado da reserva.

O estoque liberado pode voltar a ficar disponível de acordo com o processo de estoque.

### EXPIRED (EXPIRADA)

A reserva permaneceu sem resolução além do período permitido e expirou.

Reservas expiradas são preservadas como eventos de negócio, em vez de serem tratadas como liberações comuns.

Essa distinção é importante porque uma reserva EXPIRED (EXPIRADA) indica que o estoque permaneceu comprometido até o término do período permitido sem que o processo de venda fosse resolvido.

Uma reserva RELEASED (LIBERADA), por outro lado, indica que o estoque foi intencionalmente disponibilizado novamente antes da expiração porque não era mais necessário.

Manter esses resultados separados permite que o AtlasCommerce identifique com que frequência as reservas expiram, compreenda situações em que o estoque permaneceu comprometido desnecessariamente e ofereça suporte a análises futuras de casos em que as vendas não foram concluídas dentro do período esperado de reserva.

---

# 8. Processamento de Pagamentos

## 8.1 Pagamentos e Tentativas de Pagamento

O processamento de pagamentos possui seu próprio ciclo de vida e é separado do ciclo de vida da transação.

Uma transação pode possuir múltiplos registros de pagamento associados a ela. Cada pagamento representa uma operação financeira individual e preserva seu próprio método de pagamento, valor, status e eventos de negócio relevantes.

Isso permite que o AtlasCommerce preserve o histórico completo de pagamentos de uma venda, em vez de manter apenas seu resultado financeiro final.

Por exemplo, um cliente pode tentar pagar uma compra ONLINE utilizando um cartão de crédito:

1. A primeira tentativa de pagamento com CREDIT_CARD (CARTÃO DE CRÉDITO) é recusada.

2. O cliente tenta novamente utilizando outro cartão de crédito.

3. O segundo pagamento é aprovado.

Ambas as tentativas de pagamento permanecem no histórico da transação. O pagamento aprovado não substitui nem apaga a tentativa recusada.

Múltiplos pagamentos também podem representar uma venda paga utilizando mais de um método de pagamento quando o processo de negócio permitir.

Por exemplo, uma compra em loja física poderia ser paga utilizando:

- parte do valor em CASH (DINHEIRO); e

- o valor restante utilizando CREDIT_CARD (CARTÃO DE CRÉDITO).

Cada pagamento é registrado separadamente, permanecendo associado à mesma transação.

Essa distinção permite que o AtlasCommerce represente o que realmente aconteceu financeiramente durante uma venda, incluindo tentativas sem sucesso e múltiplas operações de pagamento bem-sucedidas quando aplicável.

---

## 8.2 Métodos de Pagamento

O AtlasCommerce atualmente oferece suporte aos seguintes métodos de pagamento:

- **PIX**

- **CREDIT_CARD (CARTÃO DE CRÉDITO)**

- **DEBIT_CARD (CARTÃO DE DÉBITO)**

- **CASH (DINHEIRO)**

O método de pagamento identifica como cada pagamento individual associado a uma transação foi realizado.

Quando uma transação utiliza mais de um método de pagamento, cada pagamento preserva o método e o valor utilizados naquela parte da venda.

---

## 8.3 Parcelamento

Quando aplicável, um pagamento pode ser dividido em múltiplas parcelas.

Por exemplo, um pagamento de R$ 600,00 utilizando CREDIT_CARD (CARTÃO DE CRÉDITO) poderia ser realizado em seis parcelas de R$ 100,00.

Para pagamentos realizados em um único valor, nenhuma informação de parcelamento é necessária.

---

## 8.4 Status do Pagamento

Cada operação de pagamento possui seu próprio status.

Os status atualmente suportados são:

### PENDING (PENDENTE)

A tentativa de pagamento existe, mas ainda não atingiu um estado final de aprovação ou recusa.

### APPROVED (APROVADO)

O pagamento foi aprovado com sucesso.

### DECLINED (RECUSADO)

A tentativa de pagamento foi recusada.

Um pagamento recusado não significa necessariamente que a própria transação falhou, pois outra tentativa de pagamento pode ser realizada.

### CANCELLED (CANCELADO)

A operação de pagamento foi cancelada.

### PARTIALLY_REFUNDED (PARCIALMENTE ESTORNADO)

Parte do valor anteriormente pago foi estornada, enquanto outra parte permanece sem estorno.

### REFUNDED (ESTORNADO)

O valor aplicável do pagamento foi totalmente estornado.

Esses status descrevem apenas o processamento do pagamento. Eles não substituem nem duplicam o status da própria venda.

---

# 9. Processamento de Estornos

## 9.1 Eventos de Estorno

Os estornos são associados aos pagamentos, e não diretamente à transação.

Um pagamento pode possuir múltiplos eventos de estorno.

Isso permite que um pagamento seja estornado de forma incremental, sem exigir que todo estorno devolva o valor integral de uma única vez.

Cada estorno identifica:

- o valor estornado;

- o motivo;

- quando o estorno ocorreu.

Um estorno não pode ocorrer antes da tentativa de pagamento que o originou.

O valor acumulado dos estornos associados a um pagamento não pode exceder o valor desse pagamento.

---

## 9.2 Estornos Parciais e Totais

Como múltiplos eventos de estorno podem estar associados ao mesmo pagamento, o AtlasCommerce oferece suporte a cenários de estorno parcial e total.

Por exemplo, um pagamento pode receber inicialmente um estorno parcial e, posteriormente, receber outro estorno.

O conjunto de eventos de estorno preserva o que realmente aconteceu, em vez de substituir as atividades de estorno anteriores apenas pelo total mais recente.

O ciclo de vida do pagamento pode, portanto, diferenciar um pagamento que foi parcialmente estornado de outro que foi totalmente estornado.

---

## 9.3 Motivos de Estorno

O AtlasCommerce reconhece atualmente os seguintes motivos de estorno:

### CUSTOMER_RETURN (DEVOLUÇÃO DO CLIENTE)

Um estorno foi realizado porque a mercadoria foi devolvida pelo cliente.

### DUPLICATE_CHARGE (COBRANÇA DUPLICADA)

Um estorno foi realizado para corrigir uma cobrança duplicada.

### FRAUD (FRAUDE)

Um estorno foi realizado como resultado de um evento relacionado a fraude.

### OPERATIONAL_ERROR (ERRO OPERACIONAL)

Um estorno foi necessário devido a um erro operacional.

### ORDER_CANCELLATION (CANCELAMENTO DO PEDIDO)

Um estorno foi realizado porque a transação comercial relacionada foi cancelada.

O motivo do estorno descreve por que o dinheiro foi devolvido. Ele é diferente tanto do status do pagamento quanto do status da transação.

---

# 10. Entrega e Expedição

## 10.1 Quando Existe Entrega

Uma entrega representa o processo de envio para transações que exigem transporte físico até um endereço do cliente.

Nem toda transação possui uma entrega.

No modelo de negócio atual:

- **Transações ONLINE exigem um processo de entrega.**

- **Transações STORE (LOJA) representam retirada imediata e não geram uma entrega.**

Essa distinção evita que uma compra realizada em loja física crie um processo logístico artificial simplesmente porque a entrega existe em outras partes do negócio.

---

## 10.2 Uma Transação, Uma Entrega

Uma transação pode possuir, no máximo, uma entrega.

O AtlasCommerce atualmente não divide uma transação entre múltiplos destinos ou múltiplos processos de entrega.

Se um cliente precisar que produtos sejam entregues em destinos diferentes, essas compras deverão ser representadas como transações separadas.

Essa é uma simplificação deliberada do modelo de negócio atual.

---

## 10.3 Endereço de Entrega

Uma entrega utiliza o endereço do cliente selecionado para aquele envio.

Depois que uma entrega é associada a um destino, essa informação passa a fazer parte do histórico da compra.

Mesmo que o cliente posteriormente se mude ou remova aquele local de sua lista atual de endereços, o destino utilizado na entrega original permanece preservado.

Isso garante que o AtlasCommerce sempre possa determinar para onde uma compra anterior foi efetivamente enviada, independentemente de alterações posteriores nas informações atuais do cliente.

---

## 10.4 Métodos de Envio

O AtlasCommerce atualmente oferece suporte a:

- **PAC**

- **SEDEX**

O método de envio selecionado representa o serviço de entrega escolhido para a transação.

---

## 10.5 Valor do Frete

O valor do frete pertence à entrega.

Ele não faz parte do valor das mercadorias registrado como valor principal da transação.

Essa separação permite que o AtlasCommerce diferencie o que o cliente pagou pelas mercadorias do que foi cobrado pela entrega.

---

## 10.6 Previsão de Entrega e Rastreamento

Uma entrega pode preservar a data estimada apresentada para o processo de entrega.

Quando as informações de rastreamento estiverem disponíveis, um código de rastreamento também poderá ser associado à entrega.

O AtlasCommerce também pode diferenciar quando a entrega foi postada junto ao prestador do serviço e quando foi efetivamente entregue.

---

## 10.7 Status da Entrega

As entregas utilizam atualmente os seguintes status:

### PENDING (PENDENTE)

O processo de entrega existe, mas o envio ainda não foi postado junto ao prestador do serviço.

### POSTED (POSTADO)

O envio foi entregue ao prestador responsável pelo transporte.

### DELIVERED (ENTREGUE)

O envio foi entregue com sucesso ao destinatário.

### CANCELLED (CANCELADO)

O processo de entrega foi cancelado.

### RETURNED (DEVOLVIDO)

O envio foi devolvido em vez de concluir seu ciclo de entrega previsto.

O status da entrega representa apenas o processo logístico. Uma entrega com status DELIVERED (ENTREGUE) não representa, por si só, o mesmo conceito de uma transação CONFIRMED (CONFIRMADA) ou COMPLETED (CONCLUÍDA).

---

# 11. Regras de Negócio entre Domínios

O AtlasCommerce mantém intencionalmente separado o ciclo de vida de cada processo de negócio.

Esse é um dos conceitos centrais da plataforma.

## 11.1 Status da Transação Não É Status do Pagamento

Uma Transação descreve a venda comercial.

Um Pagamento descreve uma operação financeira individual associada a essa venda.

Uma tentativa de pagamento recusada não significa automaticamente que a transação deva ser tratada como falha, pois outra tentativa de pagamento pode ocorrer posteriormente.

Da mesma forma, um pagamento estornado e uma transação cancelada descrevem fatos de negócio diferentes, mesmo quando podem ocorrer como parte do mesmo cenário.

Por exemplo, considere uma compra ONLINE em que a primeira tentativa de pagamento com CREDIT_CARD (CARTÃO DE CRÉDITO) seja recusada.

O pagamento é registrado como DECLINED (RECUSADO), mas a transação pode permanecer PENDING (PENDENTE) enquanto o cliente tenta outro método de pagamento. Se um pagamento posterior via PIX for aprovado, a transação poderá continuar normalmente e se tornar CONFIRMED (CONFIRMADA).

Portanto, o pagamento recusado descreve o que aconteceu com aquela tentativa financeira específica, enquanto o status da transação descreve o estado da venda como um todo.

Como outro exemplo, considere uma venda concluída que posteriormente exija um estorno parcial.

O Pagamento pode se tornar PARTIALLY_REFUNDED (PARCIALMENTE ESTORNADO) enquanto a Transação permanece COMPLETED (CONCLUÍDA), pois o cliente recebeu os produtos e a venda original foi concluída com sucesso.

O estorno altera o histórico financeiro da venda, mas não reescreve automaticamente o que ocorreu na transação comercial.

---

## 11.2 Status da Transação Não É Status da Reserva

Uma reserva descreve o estoque temporariamente comprometido com um item da transação.

Seu ciclo de vida responde a uma questão diferente daquela respondida pelo ciclo de vida da transação.

Uma reserva pode estar como ACTIVE (ATIVA), CONSUMED (CONSUMIDA), RELEASED (LIBERADA) ou EXPIRED (EXPIRADA). Esses estados não devem ser determinados apenas pelo status da transação.

Por exemplo, considere uma compra ONLINE enquanto o cliente ainda está concluindo o processo de pagamento.

A Transação pode permanecer PENDING (PENDENTE) enquanto o estoque necessário para um de seus itens já está protegido por uma reserva ACTIVE (ATIVA).

Nessa situação:

- **Transação:** PENDING (PENDENTE)

- **Reserva:** ACTIVE (ATIVA)

A transação ainda não foi confirmada, mas o estoque está temporariamente comprometido para que a mesma quantidade não seja considerada disponível para outra venda.

Como outro exemplo, considere uma transação que não prossegue dentro do período permitido para a reserva.

A reserva pode se tornar EXPIRED (EXPIRADA) porque o estoque permaneceu comprometido até o término do período de reserva. A Transação, entretanto, não se torna EXPIRED (EXPIRADA), pois expiração não é um status de transação.

Nessa situação:

- **Transação:** PENDING (PENDENTE)

- **Reserva:** EXPIRED (EXPIRADA)

A reserva expirada descreve o que aconteceu com o comprometimento do estoque. O status da transação continua descrevendo o que aconteceu com a própria venda.

Da mesma forma, quando uma venda prossegue com sucesso, sua reserva pode se tornar CONSUMED (CONSUMIDA) enquanto a Transação continua seguindo seu próprio ciclo de vida.

Esses exemplos demonstram por que o status da reserva e o status da transação devem permanecer separados: um descreve o comprometimento do estoque, enquanto o outro descreve a venda comercial.

---

## 11.3 Status da Transação Não É Status da Entrega

Uma Transação descreve o ciclo de vida comercial de uma venda, enquanto uma Entrega descreve o ciclo de vida logístico necessário para entregar uma compra ONLINE.

Embora esses processos estejam relacionados, seus status representam eventos de negócio diferentes e não devem ser interpretados como o mesmo estado.

Por exemplo, considere uma compra ONLINE após a aprovação do pagamento, mas antes de os produtos terem sido entregues:

- **Transação:** CONFIRMED (CONFIRMADA)

- **Entrega:** PENDING (PENDENTE)

A venda foi comercialmente confirmada, mas o processo de entrega ainda não avançou para o transporte.

Posteriormente, após o pacote ser entregue ao prestador responsável pela entrega:

- **Transação:** CONFIRMED (CONFIRMADA)

- **Entrega:** POSTED (POSTADO)

O processo logístico avançou, mas o ciclo de vida comercial da transação ainda aguarda que o cliente receba os produtos.

Quando a entrega é concluída com sucesso:

- **Entrega:** DELIVERED (ENTREGUE)

- **Transação:** COMPLETED (CONCLUÍDA)

Em uma compra ONLINE, a entrega bem-sucedida é o evento de negócio que permite que a transação alcance o final de seu ciclo de vida comercial.

As compras STORE (LOJA) demonstram essa distinção por outra perspectiva.

Uma transação STORE (LOJA) não possui uma Entrega porque o cliente recebe os produtos imediatamente na loja física. Portanto, a transação pode chegar a COMPLETED (CONCLUÍDA) sem que exista qualquer status de entrega.

Esses cenários demonstram por que Transação e Entrega precisam de ciclos de vida separados: a Transação descreve a venda como um todo, enquanto a Entrega descreve apenas o processo logístico quando ele é necessário.

---

## 11.4 Status do Pagamento Não É Histórico de Estornos

O status de um Pagamento representa o estado financeiro atual desse pagamento.

Os eventos de estorno preservam as ocorrências individuais nas quais dinheiro foi devolvido ao cliente.

Embora os eventos de estorno possam afetar o status atual do Pagamento, eles representam informações de negócio diferentes e devem ser preservados separadamente.

Por exemplo, considere um pagamento aprovado de R$ 500,00 que posteriormente recebe um estorno de R$ 100,00:

- **Pagamento Original:** R$ 500,00

- **Estorno:** R$ 100,00

- **Status do Pagamento:** PARTIALLY_REFUNDED (PARCIALMENTE ESTORNADO)

O status do Pagamento indica que apenas parte do valor original foi estornada.

O histórico de Estornos fornece as informações adicionais sobre quanto foi devolvido, quando isso ocorreu e por qual motivo.

Agora considere que o mesmo pagamento receba posteriormente outro estorno:

- **Pagamento Original:** R$ 500,00

- **Primeiro Estorno:** R$ 100,00

- **Segundo Estorno:** R$ 400,00

- **Status do Pagamento:** REFUNDED (ESTORNADO)

O status atual do Pagamento agora indica que o pagamento foi totalmente estornado, mas não substitui os dois eventos individuais de estorno que produziram esse resultado.

Preservar ambos os eventos permite compreender que os R$ 500,00 não foram devolvidos em uma única operação, mas por meio de dois estornos separados que podem ter ocorrido em momentos diferentes e por motivos diferentes.

Essa distinção permite que o AtlasCommerce responda a duas perguntas de negócio diferentes:

- **Status do pagamento:** Qual é o estado financeiro atual deste pagamento?

- **Histórico de estornos:** Como, quando e por que o dinheiro foi devolvido ao cliente?

---

## 11.5 Estoque Atual Não É Histórico de Estoque

A posição atual do estoque responde:

> Quanto estoque utilizável temos agora e quanto dele está reservado?

As movimentações de estoque respondem:

> Quais eventos de negócio fizeram com que o estoque aumentasse ou diminuísse?

As reservas respondem:

> Quais itens de transação possuem atualmente, ou possuíram anteriormente, estoque comprometido com eles?

Essas são visões complementares do processo de negócio de estoque e não devem ser tratadas como intercambiáveis.

---

# 12. Informações Históricas de Negócio

O AtlasCommerce preserva informações históricas sempre que uma alteração no estado atual pudesse modificar o significado de um evento de negócio ocorrido no passado.

Esse princípio se aplica a diversas áreas do negócio.

## 12.1 Histórico de Preços de Venda

Um item da transação preserva o preço unitário e o desconto efetivamente aplicados quando o cliente comprou o produto.

Alterar o preço atual do catálogo não modifica vendas anteriores.

---

## 12.2 Histórico de Preços de Catálogo

Os preços das variantes de produto possuem seus próprios períodos de validade.

A definição de um novo preço não exige que o preço comercial anterior desapareça do histórico.

---

## 12.3 Histórico de Endereços do Cliente

Uma entrega deve continuar representando o endereço selecionado para aquele envio.

Uma alteração posterior no endereço do cliente não deve reescrever o destino de uma entrega anterior.

---

## 12.4 Histórico de Eventos de Estoque

A quantidade atual em estoque, isoladamente, não é suficiente para explicar como o estoque chegou ao seu estado atual.

As movimentações de estoque preservam os eventos que alteraram o estoque.

As reservas preservam o ciclo de vida do estoque que foi comprometido com vendas.

---

## 12.5 Histórico de Pagamentos e Estornos

Múltiplas tentativas de pagamento podem permanecer associadas à mesma transação.

Uma tentativa que falhou ou foi recusada não precisa desaparecer quando uma tentativa posterior é bem-sucedida.

Da mesma forma, os eventos individuais de estorno permanecem disponíveis mesmo quando o estado atual do pagamento eventualmente se torna totalmente estornado.

---

## 12.6 Por Que a Verdade Histórica É Importante

O objetivo não é simplesmente manter dados antigos.

O objetivo é preservar os fatos de negócio da forma como eram quando um evento ocorreu.

Um processo analítico futuro deve ser capaz de responder a perguntas como:

- Qual preço foi efetivamente cobrado?

- Qual desconto foi concedido?

- Qual variante foi comprada?

- Qual movimentação de estoque resultou da operação?

- Quais tentativas de pagamento ocorreram?

- Quanto foi estornado e por qual motivo?

- Qual endereço recebeu a entrega?

- Qual método de envio foi utilizado?

- Quanto tempo levaram os processos de reserva, pagamento ou entrega?

Essas respostas não devem mudar simplesmente porque o catálogo, o perfil do cliente, o preço ou o estado operacional atual são diferentes hoje.

---

# 13. Cenários de Negócio Ponta a Ponta

Os cenários a seguir ilustram como os diferentes processos de negócio do AtlasCommerce podem participar da mesma jornada comercial.

Eles descrevem as relações entre os processos sem definir regras de orquestração da aplicação que ainda não tenham sido estabelecidas.

## 13.1 Compra Online Entregue com Sucesso

Um cliente compra uma ou mais variantes de produto por meio do canal ONLINE.

A transação registra as condições comerciais da venda, incluindo os produtos, quantidades, preços e descontos aplicáveis naquele momento.

O estoque necessário para os itens da transação pode ser comprometido por meio de reservas.

O processamento do pagamento ocorre de forma independente e pode conter uma ou mais tentativas de pagamento até que o processo financeiro alcance o resultado apropriado.

Quando o estoque reservado é utilizado com sucesso pela venda, a reserva pode ser consumida e a alteração correspondente no estoque pode ser representada por uma movimentação SALE (VENDA).

Como a compra é online, uma entrega é associada à transação.

A entrega preserva o endereço selecionado, o método de envio, o valor do frete, a previsão de entrega e, posteriormente, as informações disponíveis de rastreamento e os eventos relacionados à entrega.

A entrega progride de forma independente por seu ciclo de vida logístico até a entrega ao destinatário ou outro resultado final.

A própria transação progride por seu ciclo de vida. Após a aprovação do pagamento, a transação ONLINE pode se tornar CONFIRMED (CONFIRMADA) enquanto aguarda a entrega.

Quando a entrega é concluída com sucesso ao cliente, a transação pode chegar a COMPLETED (CONCLUÍDA), representando o final de seu ciclo de vida comercial.

---

## 13.2 Compra em Loja com Retirada Imediata

Um cliente compra produtos diretamente por meio do canal STORE (LOJA).

O cliente pode ser identificado, mas a identificação não é obrigatória.

A transação preserva as variantes compradas, as quantidades, os preços e os descontos.

O pagamento é processado utilizando o método de pagamento aplicável.

Os produtos deixam o estoque utilizável como parte da venda.

O cliente leva os produtos imediatamente.

Nenhuma entrega é criada porque não existe um processo separado de envio.

A ausência de uma entrega é, portanto, uma condição de negócio esperada, e não uma informação ausente.

---

## 13.3 Tentativa de Pagamento Recusada e Repetida

Uma transação chega ao processamento de pagamento.

A primeira tentativa de pagamento é recusada.

A tentativa recusada permanece como parte do histórico financeiro da transação.

Como uma transação pode possuir múltiplas operações de pagamento, outra tentativa pode ocorrer posteriormente.

A nova tentativa possui seu próprio método de pagamento, valor, status e momentos dos eventos.

Uma tentativa posterior bem-sucedida não apaga a tentativa recusada.

Isso preserva a jornada de pagamento que realmente ocorreu durante a venda.

---

## 13.4 Reserva Liberada Antes da Expiração

O estoque é reservado para um item da transação.

Antes que a reserva atinja seu horário de expiração, o estoque deixa de ser necessário para aquele processo de venda.

A reserva é liberada e seu ciclo de vida é encerrado.

O evento permanece distinto de uma reserva expirada porque o estoque foi explicitamente liberado, em vez de permanecer comprometido até o término do período de reserva.

---

## 13.5 Reserva Expira

O estoque é reservado para um item da transação, mas a reserva não é consumida nem liberada dentro do período permitido.

A reserva atinge seu horário de expiração e é posteriormente encerrada como EXPIRED (EXPIRADA).

A expiração permanece como parte do histórico da reserva.

Isso permite diferenciar reservas expiradas de reservas consumidas com sucesso ou liberadas explicitamente.

---

## 13.6 Estorno Parcial Seguido de Outro Estorno

Um pagamento anteriormente aprovado exige um estorno parcial.

O AtlasCommerce registra o evento individual de estorno, seu valor, motivo e momento em que ocorreu.

O pagamento pode então representar um estado de estorno parcial.

Se outro estorno for necessário posteriormente, um segundo evento de estorno poderá ser registrado.

O valor acumulado dos estornos nunca pode exceder o valor do pagamento original.

Quando o valor aplicável do pagamento tiver sido totalmente estornado, o pagamento poderá representar o estado de estorno total, preservando cada evento individual de estorno que levou a esse resultado.

---

## 13.7 Cliente Altera um Endereço Após uma Compra

Um cliente conclui uma compra online utilizando um de seus endereços como destino da entrega.

A entrega mantém esse destino como parte do contexto histórico da compra.

Posteriormente, o cliente realiza uma alteração relevante em seu endereço.

O endereço histórico anterior é preservado, em vez de ser reescrito.

O novo endereço passa a estar disponível para operações comerciais futuras sem alterar o destino registrado para a entrega anterior.

---

# 14. Resumo das Regras de Negócio

O modelo de negócio atual do AtlasCommerce é regido pelos seguintes princípios fundamentais:

### Vendas e Clientes

- O AtlasCommerce oferece suporte a vendas **ONLINE** e **STORE (LOJA)**.

- Compras ONLINE exigem um cliente identificado.

- Compras STORE (LOJA) podem ser concluídas sem identificar ou cadastrar o cliente.

- Clientes identificados podem ser **INDIVIDUAL (PESSOA FÍSICA)** ou **COMPANY (PESSOA JURÍDICA)**.

- Clientes identificados podem manter múltiplos contatos telefônicos, endereços de e-mail e endereços, com no máximo um registro principal de cada tipo.

- Identificar um cliente em uma compra realizada na loja física permite que seu histórico de compras seja associado ao seu perfil e pode oferecer suporte a iniciativas comerciais opcionais definidas pela empresa.

### Produtos e Preços

- Produtos podem possuir múltiplas variantes comercializáveis.

- As variantes de produto representam os itens específicos que os clientes compram.

- Os preços são mantidos por variante de produto.

- Os preços históricos de catálogo são preservados em vez de serem sobrescritos.

- As vendas preservam os preços e descontos efetivamente aplicados no momento da compra.

### Transações

- Uma Transação representa a venda comercial e possui seu próprio ciclo de vida.

- Uma transação PENDING (PENDENTE) representa uma venda que ainda não foi confirmada.

- Para compras ONLINE, uma transação se torna CONFIRMED (CONFIRMADA) após a aprovação bem-sucedida do pagamento, enquanto os produtos ainda aguardam entrega.

- Uma transação ONLINE se torna COMPLETED (CONCLUÍDA) após os produtos terem sido entregues com sucesso ao cliente.

- Compras STORE (LOJA) não exigem o estado intermediário CONFIRMED (CONFIRMADA) porque o pagamento e a entrega dos produtos ao cliente ocorrem como parte do processo de venda na loja física.

- Uma transação STORE (LOJA) pode, portanto, chegar a COMPLETED (CONCLUÍDA) sem exigir uma Entrega.

### Estoque

- O estoque é controlado por variante de produto.

- O estoque diferencia a quantidade utilizável da quantidade reservada.

- O estoque reservado não pode exceder o estoque utilizável.

- As alterações no estoque são classificadas por motivos padronizados de movimentação.

- As movimentações de estoque preservam os eventos de negócio que fizeram com que o estoque aumentasse ou diminuísse.

- Produtos danificados, perdidos ou que, por qualquer outro motivo, não estejam disponíveis para venda não devem permanecer representados como estoque utilizável.

### Reservas de Estoque

- Cada item da transação pode possuir, no máximo, uma reserva de estoque.

- Uma reserva deve se referir à mesma variante de produto de seu item da transação.

- As reservas existem por um período limitado e impedem que o estoque comprometido seja considerado disponível para outra venda.

- As reservas podem estar como **ACTIVE (ATIVA)**, **CONSUMED (CONSUMIDA)**, **RELEASED (LIBERADA)** ou **EXPIRED (EXPIRADA)**.

- RELEASED (LIBERADA) e EXPIRED (EXPIRADA) representam resultados de negócio diferentes e permanecem distinguíveis no histórico das reservas.

### Pagamentos

- Uma transação pode possuir múltiplas tentativas ou operações de pagamento.

- Múltiplos pagamentos podem representar tentativas sucessivas ou, quando aplicável, uma venda dividida entre mais de um método de pagamento.

- Os métodos de pagamento suportados são **PIX**, **CREDIT_CARD (CARTÃO DE CRÉDITO)**, **DEBIT_CARD (CARTÃO DE DÉBITO)** e **CASH (DINHEIRO)**.

- Os pagamentos mantêm um ciclo de vida independente do ciclo de vida da transação.

- Um pagamento recusado não significa necessariamente que a transação falhou, pois outra tentativa de pagamento pode ocorrer.

- Quando aplicável, um pagamento pode ser dividido em múltiplas parcelas.

### Estornos

- Os estornos pertencem a pagamentos individuais, e não diretamente à transação.

- Um pagamento pode possuir múltiplos eventos de estorno.

- Os estornos podem ser parciais ou totais.

- O valor total dos estornos associados a um pagamento não pode exceder o valor desse pagamento.

- Os eventos individuais de estorno permanecem preservados mesmo quando o pagamento eventualmente se torna totalmente estornado.

- O status do pagamento representa seu estado financeiro atual, enquanto o histórico de estornos preserva como, quando e por que o dinheiro foi devolvido.

### Entrega e Expedição

- Compras ONLINE exigem um processo de entrega no modelo de negócio atual.

- Compras STORE (LOJA) representam retirada imediata e não geram uma Entrega.

- Uma transação pode possuir, no máximo, uma Entrega.

- Múltiplos destinos de entrega exigem transações separadas.

- Os métodos de envio suportados são **PAC** e **SEDEX**.

- Os valores de frete pertencem ao processo de entrega, e não ao valor das mercadorias da transação.

- Os destinos históricos de entrega permanecem preservados mesmo que o cliente posteriormente se mude ou remova aquele local de sua lista atual de endereços.

- Para uma compra ONLINE, a entrega bem-sucedida permite que a Transação alcance COMPLETED (CONCLUÍDA).

### Ciclos de Vida de Negócio Independentes

- Os status de Transação, Pagamento, Reserva de Estoque e Entrega representam processos de negócio diferentes e não devem ser tratados como intercambiáveis.

- Uma alteração em um ciclo de vida não implica automaticamente a mesma alteração de estado em outro.

- As relações entre esses processos preservam como ocorreu a jornada comercial completa.

### Verdade Histórica do Negócio

- O AtlasCommerce preserva os fatos históricos do negócio em vez de reescrevê-los quando as informações atuais são alteradas.

- Preços históricos, condições da venda, movimentações de estoque, reservas, tentativas de pagamento, estornos e destinos de entrega permanecem interpretáveis após o evento de negócio original.

- Informações operacionais atuais e informações históricas de negócio possuem finalidades diferentes e são preservadas de acordo com essas finalidades.

---

# 15. Limites do Escopo Atual

O AtlasCommerce intencionalmente não tenta representar todos os recursos que poderiam existir em uma grande plataforma de varejo.

O modelo atual não define:

- múltiplas lojas ou depósitos com posições de estoque independentes;

- divisão de uma única transação em múltiplas entregas;

- múltiplos destinos de entrega dentro de uma única transação;

- processos de entrega para compras realizadas em loja física;

- identificação obrigatória do cliente para todas as vendas;

- uma matriz fixa de compatibilidade entre canais de venda e métodos de pagamento;

- orquestração detalhada da aplicação para todas as transições entre os status de transação, reserva, pagamento e entrega.

Esses limites são deliberados.

Novas capacidades de negócio devem ser introduzidas quando uma necessidade operacional ou analítica concreta as justificar, em vez de serem adicionadas apenas porque poderiam existir em uma plataforma de comércio mais complexa.

---

## Princípio de Encerramento

O AtlasCommerce trata uma venda como um conjunto de processos de negócio relacionados, porém distintos.

A transação comercial descreve a venda.

Seus itens preservam o que foi comprado e sob quais condições financeiras.

O estoque descreve o que está disponível e como suas quantidades se alteram.

As reservas descrevem o estoque comprometido com itens específicos de uma venda.

Os pagamentos descrevem as tentativas e os resultados financeiros associados à venda.

Os estornos descrevem o dinheiro devolvido após o pagamento.

A entrega descreve o processo logístico quando o envio é necessário.

As informações de clientes e do catálogo fornecem o contexto de negócio no qual esses eventos ocorrem.

Manter esses conceitos distintos, preservando ao mesmo tempo suas relações, permite que o AtlasCommerce represente tanto o estado operacional atual quanto a verdade histórica dos eventos de negócio que o produziram.