# Atlas Engineering — Observabilidade

## Índice

- [1. Propósito e Escopo](#1-proposito-e-escopo)

- [2. Princípios de Observabilidade](#2-principios-de-observabilidade)
  - [2.1 A Observabilidade É Projetada na Plataforma](#21-a-observabilidade-e-projetada-na-plataforma)
  - [2.2 As Evidências Devem Sustentar o Diagnóstico](#22-as-evidencias-devem-sustentar-o-diagnostico)
  - [2.3 A Observabilidade Deve Seguir os Limites de Processamento](#23-a-observabilidade-deve-seguir-os-limites-de-processamento)
  - [2.4 A Correlação Deve Preservar o Contexto *End-to-End*](#24-a-correlacao-deve-preservar-o-contexto-end-to-end)
  - [2.5 As Métricas Exigem Contexto](#25-as-metricas-exigem-contexto)
  - [2.6 A Visibilidade de Falhas Deve Ser Explícita](#26-a-visibilidade-de-falhas-deve-ser-explicita)
  - [2.7 A Recuperação Deve Ser Observável](#27-a-recuperacao-deve-ser-observavel)
  - [2.8 A Observabilidade Deve Sustentar Evidências](#28-a-observabilidade-deve-sustentar-evidencias)
  - [2.9 A Telemetria Deve Ser Proporcional](#29-a-telemetria-deve-ser-proporcional)
  - [2.10 A Observabilidade Não Deve Alterar a Semântica de Processamento](#210-a-observabilidade-nao-deve-alterar-a-semantica-de-processamento)

- [3. Modelo de Observabilidade](#3-modelo-de-observabilidade)
  - [3.1 Eventos Operacionais](#31-eventos-operacionais)
  - [3.2 *Logs*](#32-logs)
  - [3.3 Métricas](#33-metricas)
  - [3.4 Estado de Execução](#34-estado-de-execucao)
  - [3.5 Progresso do Processamento](#35-progresso-do-processamento)
  - [3.6 Atualidade dos Dados e Latência](#36-atualidade-dos-dados-e-latencia)
  - [3.7 *Backlog* e *Lag*](#37-backlog-e-lag)
  - [3.8 Erros e Rejeições](#38-erros-e-rejeicoes)
  - [3.9 Atividades de Recuperação](#39-atividades-de-recuperacao)
  - [3.10 Interpretação Combinada](#310-interpretacao-combinada)

- [4. Observabilidade ao Longo do Fluxo de Dados](#4-observabilidade-ao-longo-do-fluxo-de-dados)
  - [4.1 Ingestão da Origem](#41-ingestao-da-origem)
  - [4.2 Transporte pelo Kafka](#42-transporte-pelo-kafka)
  - [4.3 Processamento da Bronze](#43-processamento-da-bronze)
  - [4.4 Processamento da Silver](#44-processamento-da-silver)
  - [4.5 Processamento Dimensional da Gold](#45-processamento-dimensional-da-gold)
  - [4.6 Certificação e Validação](#46-certificacao-e-validacao)
  - [4.7 Orquestração e Execução Agendada](#47-orquestracao-e-execucao-agendada)
  - [4.8 Disponibilidade *Downstream*](#48-disponibilidade-downstream)
  - [4.9 Visibilidade do Processamento *End-to-End*](#49-visibilidade-do-processamento-end-to-end)

- [5. Correlação e Rastreabilidade](#5-correlacao-e-rastreabilidade)
  - [5.1 Contexto de Correlação](#51-contexto-de-correlacao)
  - [5.2 Identificação da Execução](#52-identificacao-da-execucao)
  - [5.3 Escopo de Processamento](#53-escopo-de-processamento)
  - [5.4 Correlação entre Etapas](#54-correlacao-entre-etapas)
  - [5.5 Correlação Temporal](#55-correlacao-temporal)
  - [5.6 Correlação no Kafka](#56-correlacao-no-kafka)
  - [5.7 Correlação da Recuperação](#57-correlacao-da-recuperacao)
  - [5.8 Correlação de Falhas](#58-correlacao-de-falhas)
  - [5.9 Correlação e Linhagem](#59-correlacao-e-linhagem)
  - [5.10 A Correlação Não É uma Fonte da Verdade Independente](#510-a-correlacao-nao-e-uma-fonte-da-verdade-independente)

- [6. Métricas e Medições](#6-metricas-e-medicoes)
  - [6.1 Métricas de Processamento](#61-metricas-de-processamento)
  - [6.2 Métricas de Duração](#62-metricas-de-duracao)
  - [6.3 *Throughput*](#63-throughput)
  - [6.4 Latência de Processamento](#64-latencia-de-processamento)
  - [6.5 Atualidade dos Dados](#65-atualidade-dos-dados)
  - [6.6 *Backlog* e *Lag* do Consumidor](#66-backlog-e-lag-do-consumidor)
  - [6.7 Métricas de Erros e Rejeições](#67-metricas-de-erros-e-rejeicoes)
  - [6.8 Métricas de Recuperação](#68-metricas-de-recuperacao)
  - [6.9 Métricas de Recursos](#69-metricas-de-recursos)
  - [6.10 Linhas de Base](#610-linhas-de-base)
  - [6.11 Limites](#611-limites)
  - [6.12 Qualidade das Medições](#612-qualidade-das-medicoes)

- [7. *Logs* e Eventos Operacionais](#7-logs-e-eventos-operacionais)
  - [7.1 *Logging* Estruturado](#71-logging-estruturado)
  - [7.2 Níveis de *Log*](#72-niveis-de-log)
  - [7.3 Eventos do Ciclo de Vida](#73-eventos-do-ciclo-de-vida)
  - [7.4 Eventos de Falha](#74-eventos-de-falha)
  - [7.5 Eventos de Nova Tentativa](#75-eventos-de-nova-tentativa)
  - [7.6 Eventos de Recuperação](#76-eventos-de-recuperacao)
  - [7.7 Eventos de Rejeição no Nível dos Dados](#77-eventos-de-rejeicao-no-nivel-dos-dados)
  - [7.8 Informações Sensíveis](#78-informacoes-sensiveis)
  - [7.9 Volume de *Logs*](#79-volume-de-logs)
  - [7.10 Retenção de *Logs*](#710-retencao-de-logs)
  - [7.11 Disponibilidade dos *Logs* Durante Falhas](#711-disponibilidade-dos-logs-durante-falhas)
  - [7.12 *Logs* São Evidências, Não Autoridade](#712-logs-sao-evidencias-nao-autoridade)

- [8. Alertas e Sinais Operacionais](#8-alertas-e-sinais-operacionais)
  - [8.1 Princípios de Alertas](#81-principios-de-alertas)
  - [8.2 Alertas Acionáveis](#82-alertas-acionaveis)
  - [8.3 Sintoma e Causa](#83-sintoma-e-causa)
  - [8.4 Severidade](#84-severidade)
  - [8.5 Alertas Baseados em Limites](#85-alertas-baseados-em-limites)
  - [8.6 Alertas Baseados em Estado](#86-alertas-baseados-em-estado)
  - [8.7 Sinais Compostos](#87-sinais-compostos)
  - [8.8 Ausência de Atividade](#88-ausencia-de-atividade)
  - [8.9 Desduplicação e Supressão de Alertas](#89-desduplicacao-e-supressao-de-alertas)
  - [8.10 Ciclo de Vida dos Alertas](#810-ciclo-de-vida-dos-alertas)
  - [8.11 Roteamento de Alertas](#811-roteamento-de-alertas)
  - [8.12 Fadiga de Alertas](#812-fadiga-de-alertas)
  - [8.13 Alertas São Sinais Operacionais](#813-alertas-sao-sinais-operacionais)

- [9. *Dashboards* e Visões Operacionais](#9-dashboards-e-visoes-operacionais)
  - [9.1 Visão Geral Operacional](#91-visao-geral-operacional)
  - [9.2 Visões de Progresso do Processamento](#92-visoes-de-progresso-do-processamento)
  - [9.3 Visões de Atualidade e Latência](#93-visoes-de-atualidade-e-latencia)
  - [9.4 Visões de *Backlog* e *Lag*](#94-visoes-de-backlog-e-lag)
  - [9.5 Visões de Falhas](#95-visoes-de-falhas)
  - [9.6 Visões de Qualidade de Dados e Certificação](#96-visoes-de-qualidade-de-dados-e-certificacao)
  - [9.7 Visões de Recuperação](#97-visoes-de-recuperacao)
  - [9.8 Visões Históricas](#98-visoes-historicas)
  - [9.9 Detalhamento Progressivo](#99-detalhamento-progressivo)
  - [9.10 Público e Propósito](#910-publico-e-proposito)
  - [9.11 O Status dos *Dashboards* Deve Ter Semântica Definida](#911-o-status-dos-dashboards-deve-ter-semantica-definida)
  - [9.12 *Dashboards* São Navegação, Não Diagnóstico](#912-dashboards-sao-navegacao-nao-diagnostico)

- [10. Observabilidade das Operações de Recuperação](#10-observabilidade-das-operacoes-de-recuperacao)
  - [10.1 Identificação da Recuperação](#101-identificacao-da-recuperacao)
  - [10.2 Tipos de Recuperação](#102-tipos-de-recuperacao)
  - [10.3 Acionamento da Recuperação](#103-acionamento-da-recuperacao)
  - [10.4 Escopo da Recuperação](#104-escopo-da-recuperacao)
  - [10.5 Progresso da Recuperação](#105-progresso-da-recuperacao)
  - [10.6 Recuperação e Novo Processamento](#106-recuperacao-e-novo-processamento)
  - [10.7 Falhas de Recuperação](#107-falhas-de-recuperacao)
  - [10.8 Conclusão da Recuperação](#108-conclusao-da-recuperacao)
  - [10.9 Validação Pós-Recuperação](#109-validacao-pos-recuperacao)
  - [10.10 Duração e Objetivos da Recuperação](#1010-duracao-e-objetivos-da-recuperacao)
  - [10.11 Histórico de Recuperação](#1011-historico-de-recuperacao)
  - [10.12 Evidências de Recuperação](#1012-evidencias-de-recuperacao)

- [11. Retenção, Evidências e Validação](#11-retencao-evidencias-e-validacao)
  - [11.1 Categorias de Retenção](#111-categorias-de-retencao)
  - [11.2 Retenção Operacional](#112-retencao-operacional)
  - [11.3 Retenção Histórica](#113-retencao-historica)
  - [11.4 Retenção de Evidências](#114-retencao-de-evidencias)
  - [11.5 As Evidências Devem Ser Reproduzíveis](#115-as-evidencias-devem-ser-reproduziveis)
  - [11.6 As Evidências Devem Ser Correlacionadas](#116-as-evidencias-devem-ser-correlacionadas)
  - [11.7 Validação da Observabilidade](#117-validacao-da-observabilidade)
  - [11.8 Injeção de Falhas e Cenários Controlados](#118-injecao-de-falhas-e-cenarios-controlados)
  - [11.9 Evidências Esperadas](#119-evidencias-esperadas)
  - [11.10 Completude das Evidências](#1110-completude-das-evidencias)
  - [11.11 Retenção e Segurança](#1111-retencao-e-seguranca)
  - [11.12 Retenção e Custo](#1112-retencao-e-custo)
  - [11.13 Evidências como Entregável Arquitetural](#1113-evidencias-como-entregavel-arquitetural)

- [12. Limites Arquiteturais e Princípios de Encerramento](#12-limites-arquiteturais-e-principios-de-encerramento)
  - [12.1 Limite de Processamento](#121-limite-de-processamento)
  - [12.2 Limite de Confiabilidade e Recuperação](#122-limite-de-confiabilidade-e-recuperacao)
  - [12.3 Limite de Segurança e Governança](#123-limite-de-seguranca-e-governanca)
  - [12.4 Limite de Testes e Evidências](#124-limite-de-testes-e-evidencias)
  - [12.5 Limite de Tecnologia](#125-limite-de-tecnologia)
  - [12.6 Limite entre Laboratório e Ambiente Corporativo](#126-limite-entre-laboratorio-e-ambiente-corporativo)
  - [12.7 Princípios de Encerramento](#127-principios-de-encerramento)

---

## 1. Propósito e Escopo

Este documento define a arquitetura de observabilidade da plataforma de dados Atlas Engineering.

Seu propósito é estabelecer como a plataforma expõe evidências operacionais suficientes para compreender seu estado atual, comportamento de processamento, falhas, atividades de recuperação, movimentação de dados e saúde geral ao longo do fluxo de dados *end-to-end*.

A observabilidade é tratada como uma capacidade arquitetural, e não como uma coleção de ferramentas isoladas de monitoramento. O objetivo não é apenas detectar que um componente falhou, mas fornecer contexto suficiente para determinar o que aconteceu, onde aconteceu, qual escopo de processamento foi afetado e quais evidências estão disponíveis para sustentar o diagnóstico e a recuperação.

O modelo de observabilidade, portanto, abrange os principais limites de processamento da plataforma, incluindo:

- ingestão da origem;
- transporte pelo Kafka;
- processamento da Bronze;
- processamento da Silver;
- processamento dimensional da Gold;
- certificação e validação;
- orquestração e execução agendada;
- operações de *replay*, reprocessamento, *backfill* e *rebuild*;
- falhas operacionais e atividades de recuperação.

A arquitetura deve possibilitar a correlação de eventos operacionais relevantes entre esses limites sem exigir que todos os componentes implementem mecanismos idênticos de observabilidade.

Este documento define os princípios e as responsabilidades arquiteturais para:

- *logs* e eventos operacionais;
- métricas e medições de processamento;
- estado de execução e processamento;
- correlação e rastreabilidade;
- visibilidade de falhas;
- atualidade dos dados e latência de processamento;
- *backlog* e progresso do processamento;
- alertas e sinais operacionais;
- *dashboards* e visões operacionais;
- observabilidade das operações de recuperação;
- retenção de evidências operacionais;
- validação do comportamento da observabilidade.

Este documento não redefine a semântica de processamento estabelecida por **Fluxo e Processamento de Dados**, as garantias de recuperação estabelecidas por **Confiabilidade e Recuperação** ou os controles de segurança e governança estabelecidos por **Segurança e Governança**.

Em vez disso, ele define como esses comportamentos se tornam visíveis e mensuráveis o suficiente para sustentar a operação, a investigação, a validação e as evidências arquiteturais.

A observabilidade não garante, por si só, correção, confiabilidade ou recuperação. Ela fornece as evidências necessárias para determinar se essas garantias estão se comportando conforme projetado.

---

## 2. Princípios de Observabilidade

A arquitetura de observabilidade do Atlas Engineering é baseada em um conjunto de princípios que definem como as evidências operacionais devem ser produzidas, interpretadas e utilizadas em toda a plataforma.

### 2.1 A Observabilidade É Projetada na Plataforma

A observabilidade deve ser considerada durante o projeto de cada componente e fluxo de processamento, em vez de ser adicionada somente após a ocorrência de falhas.

Cada etapa relevante de processamento deve expor informações suficientes para determinar seu estado de execução, escopo de processamento, resultado e relação com atividades *upstream* e *downstream*.

Um componente que executa trabalho sem produzir evidências operacionais suficientes cria um ponto cego na plataforma.

### 2.2 As Evidências Devem Sustentar o Diagnóstico

Os sinais operacionais devem fornecer contexto suficiente para sustentar a investigação.

Saber que um processo falhou não é suficiente quando a plataforma não consegue determinar:

- qual componente falhou;
- qual execução foi afetada;
- quando a falha ocorreu;
- qual escopo de processamento estava envolvido;
- qual etapa já havia sido concluída;
- qual erro ou condição foi observado;
- se o processamento *downstream* foi afetado;
- se uma atividade de recuperação foi iniciada.

O objetivo é reduzir a ambiguidade durante o diagnóstico, em vez de simplesmente aumentar o volume de telemetria produzido pela plataforma.

### 2.3 A Observabilidade Deve Seguir os Limites de Processamento

As evidências operacionais devem refletir os limites arquiteturais definidos pela plataforma.

Ingestão da origem, transporte pelo Kafka, Bronze, Silver, Gold, certificação e operações de recuperação representam responsabilidades distintas de processamento e devem permanecer distinguíveis durante a investigação.

A observabilidade deve possibilitar a identificação de onde o processamento foi concluído com sucesso e onde o progresso foi interrompido ou se tornou inválido.

### 2.4 A Correlação Deve Preservar o Contexto *End-to-End*

Eventos operacionais relevantes devem ser correlacionáveis entre componentes e etapas de processamento.

Quando aplicável, as execuções devem carregar identificadores e metadados contextuais que permitam aos operadores relacionar atividades *upstream*, processamento *downstream*, falhas, novas tentativas, *replay*, reprocessamento, *backfill*, *rebuild* e atividades de certificação.

A correlação não exige que todas as tecnologias exponham telemetria idêntica. Ela exige contexto compartilhado suficiente para reconstruir o caminho de processamento relevante.

### 2.5 As Métricas Exigem Contexto

Uma métrica, por si só, não constitui um diagnóstico.

Duração do processamento, *throughput*, *lag*, contagem de erros, tamanho do *backlog*, consumo de recursos ou atualidade podem indicar comportamento anormal, mas seu significado depende da carga de trabalho, do escopo de processamento, do comportamento histórico, das expectativas arquiteturais e dos sinais relacionados.

A arquitetura de observabilidade deve, portanto, permitir a correlação entre medições, estado de execução, *logs* e contexto de processamento.

### 2.6 A Visibilidade de Falhas Deve Ser Explícita

As falhas não devem desaparecer silenciosamente dentro dos componentes de processamento.

Falhas relevantes devem produzir evidências observáveis que identifiquem a execução ou o escopo de processamento afetado e sustentem a semântica de recuperação definida pela plataforma.

Uma operação com falha que não deixa evidências confiáveis constitui, por si só, uma falha de observabilidade.

### 2.7 A Recuperação Deve Ser Observável

*Replay*, reprocessamento, *backfill*, *rebuild*, novas tentativas e recuperação de *backlog* são atividades operacionais e devem ser observáveis como tais.

A plataforma deve possibilitar distinguir o processamento normal das atividades de recuperação e determinar:

- qual operação de recuperação foi realizada;
- por que ela foi iniciada;
- qual escopo de processamento foi afetado;
- quando ela começou e foi concluída;
- se foi bem-sucedida;
- qual estado resultante foi produzido.

### 2.8 A Observabilidade Deve Sustentar Evidências

As informações operacionais devem sustentar não apenas a investigação em tempo real, mas também a validação do comportamento arquitetural.

Quando forem necessárias evidências para demonstrar que processamento, tratamento de falhas, recuperação, certificação ou outras garantias da plataforma se comportam conforme projetado, a arquitetura de observabilidade deve fornecer informações que possam ser retidas e avaliadas.

A observabilidade, portanto, contribui diretamente para as evidências produzidas pela validação e pelos testes em laboratório.

### 2.9 A Telemetria Deve Ser Proporcional

A produção de informações operacionais possui um custo.

*Logs*, métricas, histórico de execuções retido e outras formas de telemetria consomem armazenamento, capacidade de processamento, recursos de rede e atenção operacional.

A plataforma deve coletar informações suficientes para sustentar seus requisitos operacionais e de validação sem gerar telemetria desnecessária ou tratar o volume máximo de coleta como um objetivo de observabilidade.

### 2.10 A Observabilidade Não Deve Alterar a Semântica de Processamento

Os mecanismos de observabilidade não devem se tornar a fonte autoritativa do estado de negócio ou de processamento quando essa responsabilidade pertencer a outro componente da plataforma.

A telemetria descreve e expõe o comportamento da plataforma. Ela não substitui o estado durável de processamento, *checkpoints*, dados certificados ou outros mecanismos autoritativos definidos em outras partes da arquitetura.

---

## 3. Modelo de Observabilidade

O modelo de observabilidade do Atlas Engineering organiza as evidências operacionais em torno do comportamento de execução e processamento da plataforma.

Em vez de tratar *logs*, métricas, alertas e *dashboards* como preocupações independentes, o modelo os combina para responder a questões operacionais progressivamente mais específicas:

- A plataforma está operando?
- O processamento está progredindo conforme esperado?
- Os dados estão chegando e se tornando disponíveis dentro do tempo esperado?
- Uma etapa de processamento foi concluída com sucesso ou falhou?
- Qual execução ou escopo de processamento foi afetado?
- Onde o processamento foi interrompido?
- Quais evidências explicam o comportamento observado?
- A recuperação é necessária ou já está em andamento?
- A recuperação restaurou o estado esperado?

Não se espera que um único sinal de observabilidade responda a todas essas questões.

### 3.1 Eventos Operacionais

Eventos operacionais descrevem ocorrências relevantes durante a execução da plataforma.

Exemplos incluem:

- processamento iniciado;
- processamento concluído;
- processamento com falha;
- nova tentativa iniciada;
- *checkpoint* avançado;
- certificação concluída;
- *replay* iniciado;
- reprocessamento iniciado;
- *backfill* iniciado;
- *rebuild* iniciado;
- recuperação concluída.

Os eventos devem incluir informações contextuais suficientes para associar a ocorrência ao componente, à execução, ao escopo de processamento e ao momento relevantes.

Os eventos operacionais descrevem o que ocorreu. Eles não substituem o estado autoritativo mantido pela arquitetura de processamento.

### 3.2 *Logs*

Os *logs* fornecem informações contextuais e de diagnóstico sobre o comportamento e a execução dos componentes.

Quando aplicável, os registros de *log* devem, preferencialmente, identificar informações como:

- *timestamp*;
- componente ou serviço;
- identificador da execução;
- etapa de processamento;
- escopo de processamento;
- severidade;
- evento ou operação;
- resultado;
- informações de erro;
- identificadores de correlação relevantes.

Quando viável, os *logs* devem priorizar informações estruturadas e interpretáveis de forma consistente em relação a texto de diagnóstico não estruturado.

Informações sensíveis não devem ser incluídas apenas porque possam ser úteis durante o *troubleshooting*. O *logging* permanece sujeito aos requisitos de segurança, privacidade e governança definidos pela plataforma.

### 3.3 Métricas

As métricas fornecem medições quantitativas do comportamento da plataforma ao longo do tempo.

Medições relevantes podem incluir:

- duração do processamento;
- *throughput* de processamento;
- registros recebidos;
- registros processados;
- registros rejeitados;
- registros pendentes;
- contagem de erros;
- contagem de novas tentativas;
- tamanho do *backlog*;
- *lag* do consumidor;
- atualidade dos dados;
- latência de processamento;
- duração da recuperação;
- utilização de recursos quando operacionalmente relevante.

As métricas devem ser interpretadas em contexto. O aumento ou a redução de um valor não estabelece, por si só, a existência de uma falha ou problema de performance.

### 3.4 Estado de Execução

O estado de execução descreve o ciclo de vida da atividade de processamento.

Quando a arquitetura mantiver estado durável de execução ou processamento, a observabilidade deve expor informações suficientes para determinar se uma execução está:

- pendente;
- em andamento;
- concluída;
- com falha;
- aguardando recuperação;
- sendo recuperada;
- substituída ou, quando aplicável, não mais autoritativa por outro motivo.

O modelo exato de estados pode variar entre os componentes, mas as visões operacionais devem preservar a distinção entre conclusão bem-sucedida, processamento incompleto e falha.

A observabilidade pode expor o estado autoritativo da execução, mas não deve criar um modelo de estados independente e concorrente.

### 3.5 Progresso do Processamento

A plataforma deve expor evidências do progresso do processamento através de seus principais limites arquiteturais.

Os operadores devem ser capazes de determinar, dentro das capacidades de cada componente:

- quais dados chegaram;
- quais dados estão aguardando processamento;
- qual processamento foi iniciado;
- qual processamento foi concluído;
- qual processamento falhou;
- até que ponto *downstream* o escopo relevante progrediu.

Isso permite que a investigação diferencie entre ausência de dados na origem, atraso no transporte, atraso no processamento, falha de processamento, falha de certificação e problemas de disponibilidade *downstream*.

### 3.6 Atualidade dos Dados e Latência

A observabilidade deve tornar mensuráveis os atrasos na disponibilidade dos dados.

Dois conceitos relacionados devem permanecer distinguíveis:

**Latência de processamento** descreve o tempo necessário para que os dados percorram uma etapa relevante de processamento ou uma sequência de etapas.

**Atualidade dos dados** descreve o quão atuais estão os dados disponíveis em relação à origem ou à linha do tempo esperada de processamento de negócio.

Um *pipeline* pode ser executado com sucesso e, ainda assim, produzir dados mais tarde do que o esperado. Portanto, uma execução bem-sucedida não estabelece, por si só, uma atualidade aceitável.

### 3.7 *Backlog* e *Lag*

Quando processamento assíncrono for utilizado, a observabilidade deve expor se o trabalho está se acumulando mais rapidamente do que está sendo consumido.

As informações de *backlog* ou *lag* devem permitir distinguir entre:

- acúmulo temporário normal;
- redução do *throughput* de processamento;
- consumidores interrompidos ou com falha;
- problemas de dependências *downstream*;
- recuperação após uma interrupção;
- incapacidade sustentada de acompanhar a carga de trabalho recebida.

Um *backlog* não representa automaticamente uma falha. Seu significado operacional depende de seu tamanho, duração, padrão de crescimento, carga de trabalho e comportamento esperado de processamento.

### 3.8 Erros e Rejeições

Falhas operacionais e rejeições no nível dos dados devem permanecer distinguíveis.

Um componente de processamento pode permanecer operacional enquanto rejeita registros individuais porque eles violam contratos esperados ou requisitos de qualidade.

Por outro lado, uma falha no nível do componente pode impedir o processamento independentemente da validade dos registros individuais.

A observabilidade deve preservar contexto suficiente para identificar a natureza e o escopo do problema sem tratar incorretamente cada registro rejeitado como uma indisponibilidade da plataforma.

### 3.9 Atividades de Recuperação

As atividades de recuperação devem ser visíveis como parte do modelo operacional normal.

*Replay*, reprocessamento, *backfill*, *rebuild*, novas tentativas e recuperação de *backlog* devem produzir evidências suficientes para determinar seu escopo, progresso, resultado e relação com a atividade de processamento original.

A telemetria de recuperação deve permitir que os operadores distingam o processamento de dados recém-chegados do trabalho que está sendo intencionalmente repetido ou reconstruído.

### 3.10 Interpretação Combinada

O diagnóstico operacional deve se basear na interpretação combinada dos sinais relevantes.

Por exemplo, o aumento do *lag* do consumidor pode ser correlacionado com a duração do processamento, eventos de erro, estado de execução, medições de recursos e disponibilidade *downstream* antes de se determinar a causa provável.

Da mesma forma, uma execução concluída ainda pode exigir investigação quando a atualidade, a contagem de registros, os resultados de certificação ou o estado *downstream* indicarem comportamento inesperado.

O modelo de observabilidade, portanto, trata *logs*, eventos, métricas, estado, progresso e evidências de validação como visões complementares do comportamento da plataforma, e não como fontes da verdade independentes.

---

## 4. Observabilidade ao Longo do Fluxo de Dados

A observabilidade deve acompanhar a movimentação *end-to-end* dos dados pela plataforma Atlas Engineering, preservando as responsabilidades e os limites de cada etapa de processamento.

O objetivo é determinar não apenas se os componentes individuais estão operacionais, mas também se os dados estão progredindo corretamente desde a origem, passando pelo transporte, processamento e certificação, até a disponibilidade *downstream*.

Cada etapa deve expor evidências apropriadas à sua responsabilidade arquitetural.

### 4.1 Ingestão da Origem

A observabilidade da ingestão da origem deve fornecer evidências de que a plataforma está recebendo os dados esperados da origem e de que a ingestão está progredindo de acordo com o modelo de processamento configurado.

Evidências relevantes podem incluir:

- estado da execução da ingestão;
- horário de início e conclusão da ingestão;
- escopo de processamento da origem;
- registros ou unidades de trabalho recebidos;
- registros ou unidades de trabalho ingeridos com sucesso;
- falhas encontradas durante a ingestão;
- novas tentativas, quando aplicável;
- latência entre a origem e a ingestão;
- informações de *checkpoint* ou progresso expostas pelo processo de ingestão.

O modelo de observabilidade deve permitir que os operadores distingam entre:

- ausência de novos dados disponíveis na origem;
- problemas de conectividade ou disponibilidade da origem;
- ingestão não sendo executada;
- ingestão em execução, mas progredindo lentamente;
- falha na ingestão;
- dados ingeridos com sucesso, mas atrasados *downstream*.

A observabilidade da origem não deve exigir exposição irrestrita dos dados da origem. As evidências operacionais permanecem sujeitas ao modelo de segurança e governança da plataforma.

### 4.2 Transporte pelo Kafka

A observabilidade do Kafka deve fornecer evidências sobre o transporte e o consumo de eventos entre produtores e consumidores *downstream*.

Evidências relevantes podem incluir:

- atividade dos produtores;
- falhas na publicação de mensagens;
- atividade de tópicos e partições;
- atividade dos consumidores;
- estado dos grupos de consumidores;
- *lag* dos consumidores;
- progressão dos *offsets*;
- *throughput* de processamento;
- comportamento de novas tentativas ou consumo repetido, quando aplicável.

O *lag* dos consumidores é um sinal operacional importante, mas não deve ser interpretado isoladamente.

Um *lag* temporário pode representar variação normal da carga de trabalho, recuperação após uma interrupção ou processamento assíncrono esperado. Um *lag* persistente ou crescente pode indicar *throughput* de processamento insuficiente, consumidores interrompidos, falhas ou restrições *downstream*.

A observabilidade do transporte pelo Kafka deve, portanto, ser correlacionada com o estado do processamento *downstream* e o comportamento da carga de trabalho.

### 4.3 Processamento da Bronze

A observabilidade da Bronze deve fornecer evidências de que os dados ingeridos da origem estão sendo capturados de forma durável de acordo com o modelo de processamento da Bronze.

Evidências relevantes podem incluir:

- estado da execução da Bronze;
- escopo de processamento;
- registros recebidos do transporte;
- registros persistidos;
- duração do processamento;
- falhas;
- atividades de novas tentativas ou recuperação;
- progressão de *checkpoints*;
- registros rejeitados ou não processáveis, quando aplicável.

Os operadores devem ser capazes de determinar se os dados chegaram com sucesso à Bronze e se o escopo de processamento esperado foi persistido de forma durável.

A observabilidade da Bronze deve preservar contexto suficiente para sustentar posteriormente *replay*, reprocessamento, investigação de linhagem e recuperação, sem tratar a telemetria como a representação armazenada autoritativa dos dados da origem.

### 4.4 Processamento da Silver

A observabilidade da Silver deve expor o comportamento da validação, normalização, transformação, desduplicação e outras responsabilidades de processamento atribuídas à camada Silver.

Evidências relevantes podem incluir:

- estado da execução da Silver;
- escopo de processamento de entrada e saída;
- registros avaliados;
- registros aceitos;
- registros rejeitados;
- registros transformados;
- registros duplicados ou excluídos por outros motivos, quando aplicável;
- duração do processamento;
- falhas de validação;
- falhas de transformação;
- atividades de recuperação.

O modelo de observabilidade deve tornar as rejeições no nível dos dados distinguíveis das falhas no nível da execução.

Um processo da Silver pode ser concluído com sucesso enquanto rejeita registros que não satisfazem os contratos ou as regras de qualidade exigidos. Essas rejeições devem permanecer mensuráveis e diagnosticáveis sem classificar automaticamente toda a execução como falha.

### 4.5 Processamento Dimensional da Gold

A observabilidade da Gold deve fornecer evidências de que o processamento dimensional está progredindo e produzindo as estruturas analíticas esperadas.

Evidências relevantes podem incluir:

- estado da execução da Gold;
- escopo de processamento;
- dimensões processadas;
- fatos processados;
- contagens de registros de entrada e saída;
- duração do processamento;
- falhas de transformação ou carga;
- estado das dependências;
- atividades de recuperação ou *rebuild*.

Quando o processamento da Gold depender de um estado *upstream* previamente concluído ou certificado, a observabilidade deve tornar essas dependências suficientemente visíveis para distinguir um problema de prontidão *upstream* de uma falha no processamento da Gold.

A execução técnica bem-sucedida não estabelece, por si só, que os dados da Gold estão prontos para consumo. A certificação permanece uma responsabilidade arquitetural separada.

### 4.6 Certificação e Validação

A observabilidade da certificação deve expor se os dados necessários para consumo *downstream* satisfizeram os requisitos definidos de validação e certificação.

Evidências relevantes podem incluir:

- estado da execução da certificação;
- escopo de processamento sendo certificado;
- verificações de validação executadas;
- verificações aprovadas;
- verificações reprovadas;
- resultado da certificação;
- horário da certificação;
- motivos da falha de certificação;
- relação com a execução de processamento que produziu os dados avaliados.

A plataforma deve distinguir entre:

- processamento concluído e certificação bem-sucedida;
- processamento concluído, mas certificação com falha;
- processamento concluído, mas certificação ainda não realizada;
- certificação impossibilitada de ser executada porque o processamento *upstream* necessário está incompleto.

Essa distinção impede que a conclusão técnica do *pipeline* seja interpretada automaticamente como prontidão dos dados.

### 4.7 Orquestração e Execução Agendada

Quando o processamento for orquestrado ou agendado, a observabilidade deve expor o estado operacional dessas execuções e de suas dependências.

Evidências relevantes podem incluir:

- horário agendado da execução;
- horário real de início;
- horário de conclusão;
- status da execução;
- estado das dependências;
- novas tentativas;
- duração da execução;
- execução não realizada ou atrasada;
- execução de recuperação, quando aplicável.

A observabilidade da orquestração deve permitir identificar se o processamento falhou dentro de um componente ou se o componente nunca foi acionado porque uma dependência *upstream*, um agendamento ou uma condição de orquestração impediu sua execução.

### 4.8 Disponibilidade *Downstream*

A observabilidade deve se estender o suficiente para determinar se os dados processados e certificados com sucesso se tornaram disponíveis para seus consumidores *downstream* pretendidos.

O mecanismo exato depende da arquitetura de consumo, mas a plataforma deve evitar presumir que o processamento bem-sucedido da Gold, por si só, comprova disponibilidade *downstream* bem-sucedida.

Quando aplicável, as evidências operacionais podem incluir:

- conclusão da publicação ou atualização;
- escopo de processamento certificado mais recente disponível;
- atualidade dos dados;
- falhas de atualização *downstream*;
- atraso entre a certificação e a disponibilidade *downstream*.

Isso permite que a plataforma diferencie entre processamento de dados bem-sucedido e entrega bem-sucedida de dados analíticos utilizáveis.

### 4.9 Visibilidade do Processamento *End-to-End*

O modelo combinado de observabilidade deve possibilitar a reconstrução da progressão relevante de um escopo de processamento através da plataforma.

Para uma determinada execução, lote, janela de tempo ou outro escopo de processamento aplicável, os operadores devem, preferencialmente, ser capazes de determinar, quando houver suporte:

1. se os dados da origem estavam disponíveis;
2. se a ingestão ocorreu;
3. se o transporte progrediu;
4. se a Bronze persistiu os dados;
5. se a Silver processou e validou os dados;
6. se o processamento dimensional da Gold foi concluído;
7. se a certificação foi bem-sucedida;
8. se o resultado certificado se tornou disponível *downstream*.

O objetivo não é criar uma única máquina de estados centralizada para todas as tecnologias.

O objetivo é preservar evidências correlacionadas suficientes entre os limites arquiteturais para determinar onde o progresso esperado foi interrompido, desacelerou, falhou ou produziu um resultado inválido.

---

## 5. Correlação e Rastreabilidade

A observabilidade *end-to-end* exige que as evidências operacionais produzidas por diferentes componentes permaneçam correlacionáveis.

A plataforma Atlas Engineering processa dados através de múltiplas tecnologias e limites arquiteturais. Uma falha observada em uma etapa pode ter origem em uma etapa anterior, afetar uma etapa posterior ou ocorrer durante uma operação de recuperação relacionada a um processamento anterior.

A correlação fornece os vínculos contextuais necessários para reconstruir essas relações.

### 5.1 Contexto de Correlação

As evidências operacionais relevantes devem carregar contexto suficiente para identificar a atividade à qual pertencem.

Dependendo do componente e do modelo de processamento, o contexto de correlação pode incluir:

- identificador da execução;
- escopo de processamento;
- origem ou domínio;
- etapa de processamento;
- componente ou serviço;
- tópico e partição, quando aplicável;
- informações de *offset* ou *checkpoint*, quando aplicável;
- lote, janela ou limite de processamento equivalente;
- identificador da operação de recuperação, quando aplicável;
- *timestamps* relevantes para a atividade observada.

Nem todos os componentes exigem todos os atributos.

O contexto necessário deve refletir a responsabilidade arquitetural e a semântica de processamento do componente que produz as evidências.

### 5.2 Identificação da Execução

Quando o processamento ocorrer como uma execução distinta, essa execução deve ser identificável nas evidências operacionais.

Um identificador de execução permite relacionar, durante a investigação, *logs*, métricas, transições de estado, resultados de validação, falhas e atividades de recuperação associados à mesma execução.

Os identificadores de execução devem identificar atividades operacionais, e não entidades de negócio.

Um identificador de transação, identificador de cliente, identificador de produto ou chave de negócio semelhante não deve ser utilizado como substituto de um identificador de execução apenas por conveniência de observabilidade.

### 5.3 Escopo de Processamento

A correlação deve identificar não apenas qual execução ocorreu, mas também qual escopo de dados a execução pretendia processar.

Dependendo do modelo de processamento, o escopo pode representar:

- um limite de extração da origem;
- um intervalo de *offsets* do Kafka;
- uma janela de tempo;
- um lote;
- uma partição;
- um conjunto de dados;
- um escopo de processamento dimensional;
- outro limite determinístico de processamento definido pela arquitetura.

Essa distinção é importante porque um identificador de execução responde **qual execução**, enquanto o escopo de processamento responde **qual trabalho ou quais dados essa execução representava**.

### 5.4 Correlação entre Etapas

As evidências operacionais devem permitir que atividades relevantes sejam relacionadas entre as etapas de processamento.

Quando houver suporte pela arquitetura de processamento, a investigação deve, preferencialmente, ser capaz de estabelecer relações como:

origem da ingestão  
→ transporte pelo Kafka  
→ Bronze  
→ Silver  
→ Gold  
→ certificação  
→ disponibilidade *downstream*.

Isso não exige que um único identificador seja fisicamente propagado sem alterações por todas as tecnologias.

Diferentes componentes podem utilizar identificadores específicos da tecnologia, desde que existam relações contextuais suficientes para reconstruir o caminho de processamento relevante.

### 5.5 Correlação Temporal

O tempo é uma dimensão importante de correlação, mas não deve ser tratado como o único mecanismo de correlação.

As evidências operacionais devem utilizar *timestamps* suficientemente consistentes para sustentar a ordenação e a investigação entre componentes.

Quando diferentes *timestamps* representarem significados diferentes, esses significados devem permanecer distinguíveis.

Exemplos incluem:

- horário do evento na origem;
- horário da ingestão;
- horário de início do processamento;
- horário de conclusão do processamento;
- horário da persistência;
- horário da certificação;
- horário da disponibilidade *downstream*.

A utilização de um único *timestamp* genérico para eventos semanticamente diferentes pode tornar ambíguas as análises de latência e falhas.

### 5.6 Correlação no Kafka

O Kafka introduz informações de correlação específicas do transporte que podem ser relevantes durante a investigação.

Dependendo do contexto de processamento, informações úteis podem incluir:

- tópico;
- partição;
- *offset*;
- grupo de consumidores;
- contexto de execução do produtor ou consumidor;
- identificador do evento ou da mensagem, quando definido pelo contrato do evento.

Os identificadores específicos do Kafka sustentam a investigação do transporte, mas não substituem o contexto de processamento de nível mais alto.

Um *offset* pode identificar uma posição dentro de uma partição, por exemplo, mas não descreve, por si só, o estado completo do processamento *end-to-end* dos dados correspondentes.

### 5.7 Correlação da Recuperação

As atividades de recuperação devem permanecer relacionadas ao estado de processamento ou à execução que tornou necessária a recuperação.

*Replay*, novas tentativas, reprocessamento, *backfill*, *rebuild* e recuperação de *backlog* devem expor informações suficientes para determinar:

- qual operação de recuperação ocorreu;
- a qual escopo de processamento original ela está relacionada;
- por que a recuperação foi iniciada;
- qual escopo foi repetido ou reconstruído;
- se ocorreram múltiplas tentativas de recuperação;
- qual resultado foi produzido.

Uma execução de recuperação não deve se tornar indistinguível de um processamento normal realizado pela primeira vez.

### 5.8 Correlação de Falhas

As falhas devem preservar contexto de correlação suficiente para determinar seu impacto operacional.

Quando aplicável, a investigação deve ser capaz de associar uma falha a:

- componente afetado;
- execução afetada;
- escopo de processamento afetado;
- estado *upstream* relevante;
- processamento *downstream* esperado;
- atividades de novas tentativas ou recuperação;
- resultado final.

Isso permite que os operadores distingam uma falha isolada de uma falha que interrompeu ou invalidou um caminho de processamento mais amplo.

### 5.9 Correlação e Linhagem

A correlação operacional e a linhagem de dados são capacidades relacionadas, porém distintas.

**Correlação operacional** responde a questões sobre atividades de processamento, como:

- Qual execução processou este escopo?
- Onde o processamento falhou?
- Qual operação de recuperação ocorreu após a falha?
- Quanto tempo levou o caminho de processamento?

**Linhagem de dados** responde a questões sobre a origem e a transformação dos dados, como:

- De onde estes dados se originaram?
- Quais etapas de processamento os transformaram?
- Quais conjuntos de dados *upstream* contribuíram para o conjunto de dados resultante?

A observabilidade pode utilizar informações de linhagem, e a linhagem pode utilizar metadados de processamento, mas nenhuma dessas capacidades substitui a outra.

### 5.10 A Correlação Não É uma Fonte da Verdade Independente

Os metadados de correlação existem para conectar evidências operacionais.

Eles não devem se tornar uma autoridade concorrente para o estado de processamento, *checkpoints*, dados da origem, dados certificados ou estado de recuperação já pertencentes a outros componentes arquiteturais.

Se a telemetria e o estado autoritativo de processamento divergirem, a discrepância deve ser investigada, em vez de ser resolvida presumindo que a representação da observabilidade está correta.

---

## 6. Métricas e Medições

As métricas fornecem evidências quantitativas sobre o comportamento, progresso, performance e saúde da plataforma Atlas Engineering.

A arquitetura de observabilidade deve definir medições que ajudem os operadores a compreender se o processamento está ocorrendo conforme esperado e a identificar condições que exijam investigação.

As métricas devem representar comportamentos significativos da plataforma, em vez de serem coletadas apenas porque uma tecnologia as disponibiliza.

### 6.1 Métricas de Processamento

As métricas de processamento descrevem a quantidade de trabalho realizado por um componente ou etapa de processamento.

Dependendo do componente, medições relevantes podem incluir:

- registros recebidos;
- registros processados;
- registros persistidos;
- registros aceitos;
- registros rejeitados;
- registros submetidos a novas tentativas;
- registros pendentes;
- *throughput* de processamento;
- execuções iniciadas;
- execuções concluídas;
- execuções com falha.

Essas medições devem preservar contexto suficiente para identificar o componente, a etapa de processamento, a execução ou o escopo de processamento ao qual se aplicam.

Não se deve presumir que as contagens de registros de diferentes etapas correspondam automaticamente.

Validação, desduplicação, filtragem, transformação, agregação, processamento dimensional e outros comportamentos legítimos de processamento podem alterar a quantidade de registros entre as etapas.

### 6.2 Métricas de Duração

A plataforma deve medir a duração das atividades de processamento relevantes.

Dependendo do modelo de processamento, isso pode incluir:

- duração da execução;
- duração da ingestão;
- duração do processamento da Bronze;
- duração do processamento da Silver;
- duração do processamento da Gold;
- duração da certificação;
- duração da recuperação;
- duração da publicação ou atualização *downstream*.

As medições de duração permitem a comparação entre execuções e ajudam a identificar alterações no comportamento do processamento.

Uma execução levar mais tempo do que uma execução anterior não estabelece, por si só, um problema de performance. O escopo de processamento, a carga de trabalho, a disponibilidade de recursos, o comportamento *upstream* e os padrões históricos também devem ser considerados.

### 6.3 *Throughput*

*Throughput* descreve a quantidade de trabalho processado dentro de um período de tempo.

Ele pode ser expresso utilizando medições como:

- registros por segundo;
- mensagens por segundo;
- lotes por intervalo;
- escopos de processamento concluídos por intervalo;
- outra unidade apropriada ao componente.

O *throughput* deve ser interpretado em conjunto com a carga de trabalho recebida e o *backlog*.

Um *throughput* elevado não indica necessariamente um processamento saudável se o trabalho recebido estiver se acumulando mais rapidamente do que pode ser processado.

Da mesma forma, um *throughput* baixo pode ser esperado quando houver pouca ou nenhuma atividade na origem.

### 6.4 Latência de Processamento

A latência de processamento mede o tempo necessário para que dados ou trabalho progridam através de um limite de processamento definido.

A latência pode ser medida para etapas individuais ou através de múltiplas etapas quando existirem informações de correlação suficientes.

Exemplos incluem:

- origem até a ingestão;
- ingestão até a persistência na Bronze;
- Bronze até a conclusão da Silver;
- Silver até a conclusão da Gold;
- conclusão da Gold até a certificação;
- certificação até a disponibilidade *downstream*;
- latência *end-to-end* entre a origem e a disponibilidade.

O início e o fim de cada medição de latência devem ser definidos explicitamente.

Sem limites claros, os valores de latência de diferentes componentes ou execuções podem representar conceitos diferentes e se tornar enganosos.

### 6.5 Atualidade dos Dados

A atualidade dos dados mede o quão atuais estão os dados disponíveis em relação à origem relevante ou à linha do tempo esperada de negócio.

A atualidade deve permanecer distinguível da duração do processamento.

Um *pipeline* pode ser executado rapidamente, mas processar dados que já estavam atrasados antes do início da execução.

Por outro lado, uma execução de longa duração ainda pode atender às expectativas de atualidade quando o modelo de processamento e os requisitos de negócio permitirem.

Quando forem definidas expectativas de atualidade, a observabilidade deve fornecer evidências suficientes para determinar se essas expectativas estão sendo atendidas.

### 6.6 *Backlog* e *Lag* do Consumidor

O processamento assíncrono exige medições que indiquem se o trabalho está se acumulando.

Medições relevantes podem incluir:

- trabalho pendente;
- tamanho do *backlog*;
- idade do *backlog*;
- *lag* do consumidor Kafka;
- taxa de crescimento ou redução do *backlog*;
- tempo necessário para recuperar o trabalho acumulado.

O tamanho do *backlog*, por si só, é insuficiente para determinar a severidade operacional.

Um *backlog* grande, mas diminuindo rapidamente, pode representar uma recuperação bem-sucedida, enquanto um *backlog* menor que cresce continuamente pode indicar que o processamento não consegue acompanhar a carga de trabalho recebida.

As medições de *backlog* devem, portanto, ser interpretadas em conjunto com *throughput*, duração, carga de trabalho e estado de processamento.

### 6.7 Métricas de Erros e Rejeições

A plataforma deve medir falhas operacionais relevantes e rejeições no nível dos dados.

Essas medições podem incluir:

- execuções com falha;
- erros de processamento;
- novas tentativas;
- novas tentativas esgotadas;
- registros rejeitados;
- falhas de validação;
- violações de contrato;
- ocorrências de registros venenosos, quando aplicável;
- falhas de certificação.

Tanto contagens absolutas quanto taxas podem ser relevantes.

Por exemplo, cem registros rejeitados podem representar um problema significativo em um lote de cento e dez registros, mas uma condição muito diferente em um escopo de processamento contendo vários milhões de registros.

As métricas devem, portanto, preservar contexto suficiente para uma interpretação significativa.

### 6.8 Métricas de Recuperação

As operações de recuperação devem expor medições que permitam avaliar seu comportamento e sua eficácia.

Medições relevantes podem incluir:

- operações de recuperação iniciadas;
- operações de recuperação concluídas;
- operações de recuperação com falha;
- duração da recuperação;
- registros ou escopos de processamento recuperados;
- novas tentativas;
- escopo submetido a *replay*;
- escopo reprocessado;
- redução do *backlog*;
- tempo necessário para restaurar o progresso esperado do processamento.

Essas medições sustentam tanto a investigação operacional quanto a validação do comportamento de recuperação definido em **Confiabilidade e Recuperação**.

### 6.9 Métricas de Recursos

Medições de recursos da infraestrutura e dos componentes podem ser coletadas quando fornecerem contexto operacional útil.

Dependendo da tecnologia e do modelo de implantação, elas podem incluir:

- utilização de CPU;
- utilização de memória;
- utilização de armazenamento;
- crescimento do armazenamento;
- comportamento da rede;
- consumo de recursos específico do componente.

As métricas de recursos não devem ser interpretadas automaticamente como causa raiz.

Uma utilização elevada de CPU, por exemplo, descreve o uso de recursos. Determinar se isso representa uma carga de trabalho saudável, capacidade insuficiente, processamento ineficiente ou outra condição exige correlação com o comportamento do processamento e outras evidências.

### 6.10 Linhas de Base

Quando útil, as métricas devem, preferencialmente, ser avaliadas em relação ao comportamento histórico observado, e não apenas em relação a limites estáticos.

Uma linha de base fornece contexto para compreender o que é típico para um componente, carga de trabalho, escopo de processamento ou período.

As linhas de base podem ajudar a identificar:

- duração incomum do processamento;
- alterações inesperadas de *throughput*;
- crescimento anormal do *backlog*;
- alterações nas taxas de rejeição;
- degradação da atualidade;
- comportamento de recursos diferente dos padrões estabelecidos.

Uma linha de base descreve o comportamento observado. Ela não define automaticamente o comportamento aceitável.

Requisitos de negócio, expectativas arquiteturais, objetivos de serviço e restrições operacionais conhecidas continuam sendo necessários para determinar se uma condição exige ação.

### 6.11 Limites

Limites podem ser utilizados para identificar condições que merecem atenção operacional.

Os limites devem ser definidos com base em expectativas operacionais ou de negócio significativas, em vez de serem selecionados arbitrariamente.

Quando apropriado, os limites podem ser baseados em:

- objetivos explícitos de serviço;
- requisitos de atualidade;
- prazos de processamento;
- limites de capacidade;
- comportamento de linha de base estabelecido;
- desvio sustentado em relação ao comportamento esperado;
- combinações de múltiplos sinais.

Ultrapassar um limite não estabelece necessariamente a causa raiz.

Isso indica que a condição observada deve, preferencialmente, ser avaliada de acordo com o contexto operacional e a estratégia de alertas.

### 6.12 Qualidade das Medições

A observabilidade depende da qualidade de suas medições.

As métricas devem possuir semântica suficientemente clara para responder:

- o que está sendo medido;
- onde a medição se origina;
- qual unidade é utilizada;
- qual escopo de processamento ela representa;
- quando ela foi medida;
- se ela é instantânea, cumulativa ou calculada ao longo de um período;
- se ela pode ser reiniciada ou desaparecer;
- quais limitações se aplicam à sua interpretação.

Uma métrica cujo significado não possa ser determinado de forma confiável pode criar mais ambiguidade do que valor operacional.

---

## 7. *Logs* e Eventos Operacionais

*Logs* e eventos operacionais fornecem evidências contextuais sobre a execução e o comportamento dos componentes do Atlas Engineering.

Eles complementam as métricas e o estado durável de processamento ao descrever ocorrências relevantes com detalhes suficientes para sustentar investigação, correlação, recuperação e validação.

O objetivo não é registrar cada ação interna executada por todos os componentes. O *logging* deve capturar informações que contribuam com evidências operacionais significativas.

### 7.1 *Logging* Estruturado

Quando viável, os *logs* operacionais devem, preferencialmente, utilizar campos estruturados em vez de depender exclusivamente de texto em formato livre.

Campos relevantes podem incluir:

- *timestamp*;
- severidade;
- componente;
- etapa de processamento;
- identificador da execução;
- escopo de processamento;
- operação ou evento;
- resultado;
- contexto de correlação;
- contexto de recuperação, quando aplicável;
- classificação do erro;
- detalhes do erro apropriados para uso operacional.

O *logging* estruturado melhora a filtragem, correlação, agregação e análise automatizada, ao mesmo tempo que permite mensagens descritivas quando um contexto adicional legível por pessoas for útil.

A estrutura exata pode variar entre as tecnologias, mas conceitos comuns devem utilizar semântica consistente em toda a plataforma.

### 7.2 Níveis de *Log*

A severidade dos *logs* deve comunicar a relevância operacional de um evento, em vez de ser selecionada arbitrariamente pelos componentes individuais.

A plataforma pode utilizar níveis como:

- **DEBUG** — informações detalhadas de diagnóstico, úteis principalmente durante o desenvolvimento ou uma investigação direcionada;
- **INFO** — atividades operacionais esperadas e eventos relevantes do ciclo de vida;
- **WARN** — condições inesperadas ou degradadas que não impedem necessariamente o processamento;
- **ERROR** — falhas que impedem que uma operação, execução ou escopo de processamento seja concluído conforme esperado;
- **FATAL** ou equivalente — condições nas quais um componente não consegue continuar operando, quando houver suporte pela tecnologia.

Nem todos os componentes precisam expor nomes de severidade idênticos, mas significados equivalentes devem, preferencialmente, permanecer compreensíveis em toda a plataforma.

O uso excessivo de níveis de alta severidade reduz seu valor operacional.

### 7.3 Eventos do Ciclo de Vida

Transições relevantes do ciclo de vida do processamento devem produzir evidências observáveis.

Dependendo do componente, elas podem incluir:

- execução iniciada;
- execução concluída;
- execução com falha;
- escopo de processamento identificado;
- *checkpoint* avançado;
- validação concluída;
- certificação concluída;
- nova tentativa iniciada;
- novas tentativas esgotadas;
- recuperação iniciada;
- recuperação concluída.

Os eventos do ciclo de vida permitem que os operadores reconstruam a progressão de uma execução sem exigir *logs* internos detalhados para cada ação de processamento.

### 7.4 Eventos de Falha

As falhas devem produzir evidências suficientes para identificar o que falhou e sustentar a investigação subsequente.

Quando aplicável, as evidências de falha devem, preferencialmente, identificar:

- *timestamp*;
- componente;
- etapa de processamento;
- execução;
- escopo de processamento;
- operação que falhou;
- classificação do erro;
- detalhes relevantes do erro;
- estado das novas tentativas;
- estado da recuperação;
- informações de correlação.

As informações de erro devem preservar detalhes técnicos suficientes para sustentar o diagnóstico sem expor desnecessariamente dados sensíveis.

As falhas não devem permanecer ocultas apenas em mensagens genéricas de conclusão nem ser representadas exclusivamente pela ausência de um evento de sucesso.

### 7.5 Eventos de Nova Tentativa

As novas tentativas devem permanecer observáveis.

Quando uma operação com falha for submetida a uma nova tentativa, as evidências operacionais devem, preferencialmente, possibilitar determinar:

- qual operação está sendo submetida a uma nova tentativa;
- qual execução ou escopo de processamento foi afetado;
- por que a nova tentativa ocorreu;
- qual tentativa está sendo executada;
- se a nova tentativa foi bem-sucedida;
- se as novas tentativas foram esgotadas.

Novas tentativas repetidas sem visibilidade explícita podem fazer com que um componente pareça operacional enquanto o processamento está, na realidade, atrasado ou incapaz de progredir.

### 7.6 Eventos de Recuperação

*Replay*, reprocessamento, *backfill*, *rebuild* e outras operações de recuperação devem produzir eventos operacionais explícitos.

As evidências de recuperação devem, preferencialmente, identificar, quando aplicável:

- tipo da operação de recuperação;
- identificador da recuperação;
- motivo que iniciou a recuperação;
- escopo de processamento original;
- escopo de processamento recuperado;
- horário de início;
- horário de conclusão;
- resultado;
- relação com tentativas anteriores de recuperação.

As atividades de recuperação não devem ser representadas como processamento comum realizado pela primeira vez quando isso tornar ambígua a interpretação operacional.

### 7.7 Eventos de Rejeição no Nível dos Dados

A rejeição de registros individuais deve permanecer distinguível de uma falha do componente ou da execução.

Quando forem necessárias evidências no nível do registro, os *logs* ou mecanismos operacionais relacionados devem fornecer informações suficientes para compreender:

- qual validação ou contrato falhou;
- qual etapa de processamento rejeitou o registro;
- qual execução ou escopo de processamento o continha;
- como o registro rejeitado pode ser investigado por meio do mecanismo controlado apropriado.

A arquitetura de observabilidade deve evitar copiar registros de negócio completos para os *logs* apenas para simplificar o *troubleshooting*.

Quando dados rejeitados detalhados precisarem ser retidos, eles devem, preferencialmente, ser tratados por meio de um mecanismo de dados controlado apropriado, sujeito aos requisitos de segurança e governança, em vez de *logging* operacional irrestrito.

### 7.8 Informações Sensíveis

Os *logs* devem seguir os requisitos de segurança, privacidade e governança da plataforma.

A utilidade operacional não justifica o registro irrestrito de:

- credenciais;
- segredos;
- *tokens* de acesso;
- *connection strings* contendo credenciais;
- dados pessoais desnecessários;
- dados de negócio sensíveis;
- *payloads* completos quando identificadores contextuais forem suficientes.

Quando informações sensíveis forem necessárias para uma investigação controlada, o acesso e a retenção devem seguir o modelo de governança apropriado.

Mascaramento, ocultação, exclusão ou referências controladas devem, preferencialmente, ser utilizados quando apropriado.

### 7.9 Volume de *Logs*

O *logging* deve permanecer proporcional ao valor operacional.

O *logging* excessivo pode:

- aumentar o consumo de armazenamento;
- aumentar o custo de processamento e transporte;
- dificultar a identificação de eventos relevantes;
- criar exposição desnecessária de segurança;
- aumentar os requisitos de retenção;
- gerar ruído durante a investigação.

Caminhos de processamento de alta frequência devem, preferencialmente, evitar a produção de eventos informativos repetitivos quando métricas agregadas ou evidências operacionais resumidas fornecerem visibilidade suficiente.

O *logging* detalhado de diagnóstico pode ser habilitado seletivamente quando houver suporte e justificativa operacional.

### 7.10 Retenção de *Logs*

Os *logs* operacionais devem ser retidos por um período apropriado à sua finalidade, aos requisitos operacionais, ao custo de armazenamento, à classificação de segurança e às necessidades de investigação.

Diferentes categorias de *logs* podem exigir períodos de retenção diferentes.

A retenção deve considerar se as evidências são necessárias para:

- *troubleshooting* imediato;
- comparação histórica;
- investigação de recuperação;
- investigação de segurança;
- auditabilidade;
- validação em laboratório;
- evidências arquiteturais.

Os períodos de retenção não devem ser estendidos indefinidamente apenas porque o armazenamento está tecnicamente disponível.

### 7.11 Disponibilidade dos *Logs* Durante Falhas

As evidências de observabilidade devem permanecer úteis quando o componente que está sendo investigado falhar.

Quando viável, deve-se evitar que evidências operacionais críticas existam exclusivamente em estado local transitório que desapareça quando um processo, contêiner, serviço ou *host* for encerrado.

A arquitetura deve considerar como *logs* e eventos relevantes permanecem acessíveis após as condições de falha que eles se destinam a explicar.

Esse requisito não implica que cada registro de *log* exija armazenamento durável independente. A durabilidade necessária deve ser proporcional à importância operacional das evidências.

### 7.12 *Logs* São Evidências, Não Autoridade

Os *logs* descrevem o que os componentes reportaram durante a execução.

Eles são evidências valiosas para reconstrução e diagnóstico, mas não substituem o estado autoritativo de processamento, *checkpoints*, registros da origem, conjuntos de dados certificados ou metadados de recuperação.

Uma mensagem de sucesso em um *log* não se sobrepõe a um estado autoritativo contraditório.

Da mesma forma, a ausência de uma mensagem de *log* esperada não comprova, por si só, que o processamento não ocorreu.

As conclusões operacionais devem utilizar os *logs* em conjunto com as demais evidências fornecidas pela arquitetura de observabilidade.

---

## 8. Alertas e Sinais Operacionais

Os alertas convertem sinais selecionados de observabilidade em atenção operacional.

O objetivo dos alertas não é notificar os operadores sobre cada evento incomum ou variação de métrica. Os alertas devem identificar condições que possam exigir investigação ou ação porque ameaçam o progresso do processamento, a disponibilidade dos dados, a confiabilidade, a atualidade, a certificação, a recuperação ou outra expectativa operacional definida.

Um alerta que não sustenta uma resposta operacional significativa cria ruído em vez de valor operacional.

### 8.1 Princípios de Alertas

Os alertas devem ser baseados em condições com relevância operacional clara.

Quando viável, um alerta deve, preferencialmente, comunicar:

- qual condição foi detectada;
- qual componente ou etapa de processamento foi afetado;
- qual execução ou escopo de processamento está envolvido;
- quando a condição começou ou foi detectada;
- a severidade da condição;
- as evidências que acionaram o alerta;
- contexto de correlação relevante;
- se o processamento ainda está progredindo;
- se a recuperação já está ocorrendo.

O alerta em si não precisa conter todos os detalhes de diagnóstico, mas deve fornecer contexto suficiente para iniciar a investigação de forma eficiente.

### 8.2 Alertas Acionáveis

Os alertas devem, preferencialmente, representar condições para as quais um operador, mecanismo automatizado de recuperação ou equipe responsável possa determinar razoavelmente uma próxima ação.

Exemplos podem incluir:

- execução de processamento com falha;
- processamento esperado não iniciado;
- processamento excedeu uma janela esperada de conclusão;
- *backlog* continua crescendo;
- *lag* do consumidor permanece elevado além de um período aceitável;
- atualidade dos dados excedeu uma expectativa estabelecida;
- certificação com falha;
- novas tentativas esgotadas;
- recuperação com falha;
- dados *downstream* necessários não se tornaram disponíveis;
- capacidade crítica se aproximou de um limite operacional.

Condições que sejam informativas, mas não exijam atenção, devem, preferencialmente, permanecer disponíveis por meio de métricas, *logs*, eventos ou *dashboards*, sem necessariamente gerar alertas.

### 8.3 Sintoma e Causa

Um alerta pode identificar um sintoma sem identificar a causa raiz.

Por exemplo:

- o crescimento do *lag* do consumidor Kafka pode indicar redução da capacidade de processamento *downstream*;
- dados desatualizados na Gold podem resultar de um problema de ingestão *upstream*;
- uma falha de certificação pode resultar de dados inesperados da origem, e não de uma falha do mecanismo de certificação;
- o aumento da duração do processamento pode refletir aumento da carga de trabalho, e não degradação de performance.

As descrições dos alertas devem, portanto, evitar apresentar causas inferidas como fatos estabelecidos quando as evidências disponíveis identificarem apenas uma condição.

O diagnóstico permanece uma atividade investigativa baseada em evidências correlacionadas.

### 8.4 Severidade

A severidade dos alertas deve representar o impacto operacional e a urgência, e não simplesmente a magnitude de uma métrica individual.

A severidade pode considerar fatores como:

- interrupção do processamento;
- escopo de processamento afetado;
- duração;
- impacto na atualidade dos dados;
- disponibilidade *downstream*;
- capacidade de recuperação;
- estado da certificação;
- crescimento contínuo do *backlog*;
- impacto de negócio ou analítico;
- risco de perda de dados ou incapacidade de atender aos objetivos de recuperação.

O modelo exato de severidade pode evoluir com a maturidade operacional da plataforma.

As definições de severidade devem permanecer suficientemente claras para que diferentes operadores interpretem condições equivalentes de forma consistente.

### 8.5 Alertas Baseados em Limites

Limites podem acionar alertas quando as medições ultrapassarem limites operacionais definidos.

Exemplos podem incluir:

- tamanho do *backlog*;
- idade do *backlog*;
- *lag* do consumidor;
- duração do processamento;
- atualidade dos dados;
- utilização de armazenamento;
- taxa de erros;
- taxa de rejeição.

Os limites devem refletir expectativas operacionais significativas e não devem ser selecionados apenas porque uma tecnologia de monitoramento exige um valor numérico.

Quando apropriado, a duração deve, preferencialmente, ser considerada em conjunto com a magnitude.

Uma ultrapassagem temporária de um limite pode representar variação normal da carga de trabalho, enquanto uma condição sustentada pode exigir investigação.

### 8.6 Alertas Baseados em Estado

Algumas condições operacionais são melhor representadas por estado do que por limites numéricos.

Exemplos incluem:

- execução com falha;
- certificação com falha;
- novas tentativas esgotadas;
- execução esperada ausente;
- consumidor interrompido;
- recuperação com falha;
- dependência necessária indisponível.

Os alertas baseados em estado devem utilizar evidências suficientemente confiáveis para evitar inferir falhas apenas a partir da ausência de telemetria quando o estado autoritativo de processamento ou execução estiver disponível.

### 8.7 Sinais Compostos

Quando útil, os alertas podem combinar múltiplos sinais para melhorar a relevância operacional.

Por exemplo, o crescimento do *lag* do consumidor combinado com redução do *throughput* e uma falha ativa de processamento pode fornecer um sinal operacional mais forte do que o *lag* do consumidor isoladamente.

Da mesma forma, a atualidade dos dados atrasada combinada com processamento *upstream* bem-sucedido pode direcionar a investigação para as etapas *downstream*.

Alertas compostos devem, preferencialmente, reduzir a ambiguidade e o ruído, em vez de criar regras desnecessariamente complexas que os operadores não consigam compreender ou validar.

### 8.8 Ausência de Atividade

A ausência de uma atividade esperada pode, por si só, constituir um sinal operacional importante.

A plataforma pode precisar detectar condições como:

- processamento agendado não iniciado;
- dados esperados da origem não chegaram;
- progressão esperada do *checkpoint* foi interrompida;
- certificação não ocorreu;
- atualização *downstream* não foi concluída;
- telemetria esperada deixou de ser produzida.

A ausência de atividade deve ser avaliada em relação a expectativas explícitas.

A ausência de eventos durante um período no qual nenhum processamento era esperado não deve ser tratada como falha.

### 8.9 Desduplicação e Supressão de Alertas

Um único problema subjacente pode produzir múltiplos sintomas relacionados em toda a plataforma.

Quando viável, os alertas devem, preferencialmente, evitar sobrecarregar os operadores com notificações repetidas que representem a mesma condição contínua.

Os mecanismos podem incluir:

- desduplicação;
- agrupamento;
- supressão temporária;
- alertas conscientes de dependências;
- notificações de transição de estado;
- notificações de recuperação.

A supressão não deve ocultar falhas independentes apenas porque elas ocorrem durante um incidente existente.

### 8.10 Ciclo de Vida dos Alertas

Os alertas operacionais devem, preferencialmente, possuir um ciclo de vida significativo.

Quando houver suporte, é recomendável que seja possível distinguir entre:

- condição recém-detectada;
- condição em andamento;
- condição reconhecida;
- condição em recuperação;
- condição resolvida.

A resolução deve ser baseada em evidências de que a condição relevante não existe mais, e não simplesmente na passagem do tempo ou no encerramento manual do alerta.

Quando a recuperação ocorrer automaticamente, as evidências operacionais resultantes devem, preferencialmente, tornar essa recuperação visível.

### 8.11 Roteamento de Alertas

Os alertas devem chegar à equipe ou responsabilidade operacional capaz de avaliar a condição.

O roteamento pode depender de:

- responsabilidade pelo componente;
- etapa de processamento;
- severidade;
- tipo de falha;
- implicações de segurança;
- responsabilidade pela recuperação;
- impacto de negócio.

O mecanismo detalhado de notificação e escalonamento corporativo é específico da implantação e pode evoluir além da implementação em laboratório.

A arquitetura define o requisito de um contexto significativo de roteamento sem exigir que a plataforma de laboratório reproduza uma organização completa de gerenciamento de incidentes corporativos.

### 8.12 Fadiga de Alertas

Alertas excessivos, repetitivos ou não acionáveis reduzem a eficácia do sistema de observabilidade.

Um alerta que os operadores ignoram rotineiramente é uma evidência de que a estratégia de alertas precisa ser revisada.

A qualidade dos alertas deve, portanto, ser avaliada ao longo do tempo utilizando questões como:

- O alerta identificou uma condição que exigia atenção?
- A severidade era apropriada?
- Havia contexto suficiente disponível?
- Múltiplos alertas representavam o mesmo problema subjacente?
- A condição já estava sendo recuperada automaticamente?
- O alerta levou a uma investigação ou ação significativa?

O objetivo não é maximizar a quantidade de alertas gerados.

O objetivo é tornar condições importantes difíceis de serem ignoradas.

### 8.13 Alertas São Sinais Operacionais

Os alertas são sinais operacionais derivados.

Eles não substituem *logs*, métricas, estado de processamento, *checkpoints*, estado de certificação ou outras evidências autoritativas.

Um alerta indica que uma condição definida foi detectada.

Os operadores devem utilizar as evidências subjacentes e o contexto arquitetural para determinar a causa, o impacto e a resposta apropriada.

---

## 9. *Dashboards* e Visões Operacionais

*Dashboards* e visões operacionais fornecem representações consolidadas das evidências de observabilidade produzidas pela plataforma Atlas Engineering.

Seu propósito é ajudar os operadores a compreender a saúde da plataforma, o progresso do processamento, falhas, atualidade, *backlog*, atividades de recuperação e outras condições operacionais relevantes sem exigir que toda investigação comece diretamente a partir de *logs* brutos ou métricas individuais.

Os *dashboards* resumem evidências. Eles não substituem os dados de observabilidade subjacentes nem o estado autoritativo de processamento.

### 9.1 Visão Geral Operacional

A plataforma deve, preferencialmente, fornecer uma visão geral operacional que comunique o estado atual das principais etapas de processamento.

Quando aplicável, a visão geral pode incluir:

- estado da ingestão da origem;
- estado do transporte pelo Kafka e dos consumidores;
- estado do processamento da Bronze;
- estado do processamento da Silver;
- estado do processamento da Gold;
- estado da certificação;
- disponibilidade *downstream*;
- falhas ativas;
- operações de recuperação ativas;
- atualidade dos dados;
- condições significativas de *backlog* ou *lag*.

O objetivo é fornecer uma resposta concisa à questão operacional inicial:

**A plataforma está processando os dados conforme esperado?**

A visão geral deve, preferencialmente, enfatizar as condições que exigem atenção, em vez de apresentar todas as medições disponíveis com a mesma importância.

### 9.2 Visões de Progresso do Processamento

As visões operacionais devem, preferencialmente, tornar visível o progresso do processamento através dos principais limites arquiteturais.

Quando houver suporte, os operadores devem, preferencialmente, ser capazes de determinar:

- qual processamento está atualmente ativo;
- qual processamento foi concluído;
- qual processamento está pendente;
- qual processamento falhou;
- qual escopo foi afetado;
- onde o progresso foi interrompido;
- se a recuperação está ocorrendo.

Essas visões devem, preferencialmente, preservar os limites de processamento definidos pela arquitetura, em vez de reduzir toda a plataforma a um único status genérico.

### 9.3 Visões de Atualidade e Latência

A atualidade dos dados e a latência de processamento devem ser suficientemente visíveis para identificar se os dados estão se tornando disponíveis dentro dos períodos esperados.

Visões relevantes podem incluir:

- atividade mais recente da origem;
- escopo mais recente ingerido com sucesso;
- processamento mais recente da Bronze;
- processamento mais recente da Silver;
- processamento mais recente da Gold;
- certificação bem-sucedida mais recente;
- disponibilidade *downstream* mais recente;
- latência específica por etapa;
- latência *end-to-end*, quando mensurável.

Um *pipeline* tecnicamente bem-sucedido cujos dados disponíveis estejam inesperadamente desatualizados deve permanecer visível como uma preocupação operacional.

### 9.4 Visões de *Backlog* e *Lag*

Quando existir processamento assíncrono, os *dashboards* devem, preferencialmente, expor o acúmulo e a redução do trabalho pendente.

Informações relevantes podem incluir:

- *backlog* atual;
- idade do *backlog*;
- *lag* do consumidor Kafka;
- crescimento ou redução do *backlog*;
- *throughput* de processamento;
- progresso estimado ou observado da recuperação, quando significativo.

As informações de tendência são particularmente importantes.

Um valor pontual de *backlog* pode fornecer contexto limitado, enquanto sua evolução ao longo do tempo pode mostrar se a plataforma está estável, ficando para trás ou se recuperando.

### 9.5 Visões de Falhas

As visões operacionais devem tornar as falhas ativas e recentes identificáveis.

Informações relevantes podem incluir:

- componente afetado;
- etapa de processamento;
- execução;
- escopo de processamento;
- horário da falha;
- classificação do erro;
- estado das novas tentativas;
- estado da recuperação;
- resultado atual.

O *dashboard* não precisa reproduzir *logs* completos de diagnóstico.

Ele deve, preferencialmente, fornecer contexto suficiente para identificar a atividade afetada e permitir que a investigação prossiga utilizando as evidências detalhadas apropriadas.

### 9.6 Visões de Qualidade de Dados e Certificação

A observabilidade deve fornecer visibilidade dos resultados de validação e certificação quando eles afetarem a prontidão dos dados *downstream*.

Informações relevantes podem incluir:

- status da certificação;
- escopo de processamento certificado mais recente;
- verificações de validação com falha;
- contagens ou taxas de registros rejeitados;
- falhas de certificação;
- certificação pendente;
- relação entre a conclusão do processamento e o estado da certificação.

As informações de qualidade de dados devem ser apresentadas com contexto suficiente para distinguir uma rejeição isolada no nível do registro de uma falha mais ampla de certificação.

### 9.7 Visões de Recuperação

As operações de recuperação devem estar visíveis nas visões operacionais.

Quando aplicável, os operadores devem, preferencialmente, ser capazes de identificar:

- operações de recuperação ativas;
- tipo de recuperação;
- escopo de processamento afetado;
- motivo que iniciou a recuperação;
- horário de início;
- progresso;
- tentativa de nova execução ou recuperação;
- estado de conclusão;
- resultado da recuperação.

Uma plataforma executando *replay*, reprocessamento, *backfill*, *rebuild* ou recuperação de *backlog* não deve parecer indistinguível de um processamento comum realizado pela primeira vez.

### 9.8 Visões Históricas

Quando as evidências retidas permitirem, as visões operacionais devem, preferencialmente, permitir a comparação com o comportamento histórico.

As visões históricas podem ajudar a identificar:

- alterações na duração do processamento;
- padrões de *throughput*;
- falhas recorrentes;
- tendências de rejeição;
- degradação da atualidade;
- comportamento do *backlog*;
- duração da recuperação;
- padrões de consumo de recursos.

As informações históricas sustentam a análise de linhas de base e a investigação de alterações graduais que podem não ser evidentes apenas pelo monitoramento do estado atual.

### 9.9 Detalhamento Progressivo

As visões operacionais devem, preferencialmente, permitir uma investigação progressiva.

Um operador pode começar com uma indicação de alto nível de que uma etapa de processamento está degradada e, em seguida, avançar para evidências mais detalhadas, como:

1. etapa de processamento afetada;
2. execução ou escopo afetado;
3. métricas relacionadas;
4. eventos operacionais relevantes;
5. informações de erro ou rejeição;
6. contexto de correlação;
7. atividade de recuperação;
8. *logs* detalhados, quando necessário.

O objetivo é permitir que a investigação avance do resumo para as evidências sem exigir que o *dashboard* inicial contenha todos os detalhes de diagnóstico.

### 9.10 Público e Propósito

Diferentes visões operacionais podem atender a diferentes públicos e propósitos.

Por exemplo:

- operadores da plataforma podem exigir informações detalhadas sobre execução e falhas;
- engenheiros de dados podem exigir evidências de processamento, *backlog* e transformação;
- consumidores de dados podem exigir informações sobre atualidade e estado da certificação;
- a validação arquitetural pode exigir evidências históricas de execução e recuperação.

Nem todo público exige acesso a todos os detalhes operacionais.

O projeto e o acesso aos *dashboards* devem permanecer consistentes com o modelo de segurança e governança da plataforma.

### 9.11 O Status dos *Dashboards* Deve Ter Semântica Definida

Estados visuais como saudável, degradado, com falha, atrasado, em recuperação ou indisponível devem possuir significados definidos.

Um *dashboard* não deve exibir um componente como saudável apenas porque seu processo está em execução se:

- o processamento não estiver mais progredindo;
- o *backlog* estiver crescendo além das expectativas;
- os dados necessários estiverem desatualizados;
- a certificação tiver falhado;
- a disponibilidade *downstream* não tiver sido alcançada.

Da mesma forma, uma operação de recuperação pode representar um comportamento controlado esperado, e não uma nova falha.

O status deve, portanto, refletir as expectativas operacionais relevantes, e não apenas a disponibilidade do componente.

### 9.12 *Dashboards* São Navegação, Não Diagnóstico

Um *dashboard* é um ponto de entrada para a compreensão operacional.

Ele deve, preferencialmente, ajudar a responder:

- Onde devo investigar?
- O que mudou?
- Qual escopo foi afetado?
- Qual parece ser a severidade da condição?
- O processamento está progredindo ou se recuperando?
- Quais evidências devo investigar em seguida?

Um *dashboard* deve, preferencialmente, evitar criar falsa confiança ao reduzir o comportamento complexo da plataforma a um único indicador visual sem evidências de suporte acessíveis.

O diagnóstico operacional permanece baseado em *logs* correlacionados, métricas, eventos, estado de execução, contexto de processamento e outras evidências autoritativas.

---

## 10. Observabilidade das Operações de Recuperação

As operações de recuperação devem ser observáveis ao longo de todo o seu ciclo de vida.

A semântica de recuperação propriamente dita é definida por **Confiabilidade e Recuperação**. A responsabilidade da observabilidade é expor evidências suficientes para determinar quando a recuperação é necessária, qual operação está sendo realizada, qual escopo de processamento foi afetado, como a recuperação está progredindo e se o estado esperado foi restaurado.

A recuperação não deve se tornar um período cego no qual a visibilidade do processamento normal seja perdida.

### 10.1 Identificação da Recuperação

Cada operação de recuperação relevante deve ser identificável nas evidências operacionais.

Quando aplicável, o contexto de recuperação deve, preferencialmente, incluir:

- identificador da operação de recuperação;
- tipo de recuperação;
- motivo que iniciou a recuperação;
- componente ou etapa de processamento afetado;
- execução ou escopo de processamento original;
- escopo de processamento da recuperação;
- horário de início;
- estado atual;
- horário de conclusão;
- resultado.

Esse contexto deve permitir que as atividades de recuperação permaneçam distinguíveis do processamento normal realizado pela primeira vez.

### 10.2 Tipos de Recuperação

A observabilidade deve preservar a distinção entre os diferentes mecanismos de recuperação definidos pela plataforma.

Eles podem incluir:

- nova tentativa;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- recuperação de *backlog*;
- outros procedimentos controlados de recuperação definidos pela arquitetura.

Diferentes mecanismos de recuperação podem produzir atividades de processamento semelhantes, embora possuam propósitos, escopos e implicações operacionais diferentes.

As evidências operacionais devem, portanto, identificar o tipo de recuperação que está sendo realizada.

### 10.3 Acionamento da Recuperação

Quando for possível determiná-lo, a observabilidade deve expor por que uma operação de recuperação foi iniciada.

Exemplos podem incluir:

- falha transitória de processamento;
- nova tentativa esgotada ou repetida;
- interrupção de componente;
- *backlog* acumulado durante a indisponibilidade;
- correção de qualidade de dados;
- lógica de processamento corrigida;
- processamento histórico incompleto;
- *rebuild* controlado;
- recuperação iniciada por um operador.

O motivo que iniciou a recuperação fornece contexto para interpretar a operação de recuperação, mas não substitui a decisão ou o estado autoritativo da recuperação.

### 10.4 Escopo da Recuperação

As evidências de recuperação devem identificar o escopo que está sendo recuperado.

Dependendo do modelo de processamento, isso pode incluir:

- execução;
- lote;
- janela de tempo;
- intervalo de *offsets* do Kafka;
- partição;
- conjunto de dados;
- escopo de processamento dimensional;
- período histórico;
- outro limite determinístico de recuperação.

O escopo da recuperação deve ser suficientemente explícito para determinar qual trabalho está sendo intencionalmente repetido, reconstruído ou concluído.

### 10.5 Progresso da Recuperação

Os operadores devem ser capazes de determinar se a recuperação está progredindo.

Evidências relevantes podem incluir:

- estado da recuperação;
- escopo de processamento concluído;
- escopo de processamento restante;
- registros ou unidades de trabalho processados;
- redução do *backlog*;
- *throughput*;
- duração;
- novas tentativas;
- progressão de *checkpoints*, quando aplicável.

As informações de progresso são particularmente importantes durante grandes operações de *replay*, *backfill*, *rebuild* ou recuperação de *backlog* que possam permanecer ativas por períodos prolongados.

Um processo de recuperação em execução que não esteja mais progredindo não deve parecer saudável apenas porque o próprio processo permanece ativo.

### 10.6 Recuperação e Novo Processamento

Quando a recuperação e o processamento de dados recém-chegados ocorrerem simultaneamente, a observabilidade deve tornar seus comportamentos distinguíveis.

Os operadores devem, preferencialmente, ser capazes de determinar se:

- o novo processamento continua normalmente;
- a recuperação compete com o processamento normal por capacidade;
- o *backlog* está aumentando ou diminuindo;
- a recuperação está atrasando os dados atuais;
- a recuperação possui prioridade sobre o novo processamento;
- o processamento está intencionalmente pausado de acordo com o procedimento de recuperação.

A arquitetura de observabilidade não define a semântica de agendamento ou priorização. Ela expõe evidências suficientes para avaliar seus efeitos operacionais.

### 10.7 Falhas de Recuperação

Uma operação de recuperação pode, por si só, falhar.

As falhas de recuperação devem produzir evidências explícitas que identifiquem:

- operação de recuperação;
- escopo afetado;
- etapa ou operação que falhou;
- informações de erro;
- estado da tentativa ou nova tentativa;
- escopo restante incompleto;
- estado de processamento resultante.

Uma recuperação com falha não deve ser interpretada como bem-sucedida apenas porque parte do escopo pretendido foi processada.

### 10.8 Conclusão da Recuperação

A conclusão da recuperação deve ser baseada em evidências de que o escopo de recuperação pretendido atingiu o estado esperado.

O encerramento de um processo ou *job* de recuperação não comprova, por si só, uma recuperação bem-sucedida.

Quando aplicável, as evidências de conclusão podem incluir:

- execução da recuperação concluída com sucesso;
- escopo de processamento pretendido concluído;
- *checkpoints* atingiram o estado esperado;
- *backlog* retornou à condição esperada;
- processamento *downstream* retomado;
- validação concluída;
- certificação bem-sucedida;
- dados esperados se tornaram disponíveis.

As evidências de conclusão necessárias dependem do mecanismo de recuperação e do limite arquitetural afetado.

### 10.9 Validação Pós-Recuperação

A recuperação deve ser seguida por validação suficiente para determinar se a plataforma retornou a um estado aceitável.

Questões relevantes podem incluir:

- O escopo pretendido foi recuperado?
- O processamento foi retomado a partir da posição correta?
- Foram introduzidas duplicidades ou omissões não intencionais?
- As etapas *downstream* processaram os dados recuperados?
- A certificação foi bem-sucedida?
- A atualidade dos dados está se recuperando ou foi restaurada?
- O *backlog* continua diminuindo?
- Novas falhas estão ocorrendo?

A observabilidade fornece as evidências necessárias para responder a essas questões.

As regras de validação propriamente ditas podem ser definidas pelas arquiteturas de processamento, confiabilidade, qualidade de dados ou testes.

### 10.10 Duração e Objetivos da Recuperação

A duração da recuperação deve ser mensurável quando contribuir para a avaliação dos objetivos de recuperação definidos pela plataforma.

A observabilidade deve, preferencialmente, fornecer evidências temporais suficientes para comparar o comportamento real da recuperação com as expectativas relevantes de Objetivo de Tempo de Recuperação (RTO), quando essas expectativas forem aplicáveis.

Da mesma forma, evidências relacionadas ao escopo de processamento recuperado podem contribuir para a avaliação do comportamento do Objetivo de Ponto de Recuperação (RPO).

A observabilidade mede e expõe o resultado.

A definição de RPO, RTO, garantias de recuperação e suas limitações arquiteturais permanece sob responsabilidade de **Confiabilidade e Recuperação**.

### 10.11 Histórico de Recuperação

As evidências relevantes de recuperação devem, preferencialmente, ser retidas por tempo suficiente para sustentar:

- investigação;
- comparação entre eventos de recuperação;
- análise de falhas recorrentes;
- análise da performance da recuperação;
- validação dos procedimentos de recuperação;
- testes de resiliência em laboratório;
- evidências arquiteturais.

Informações históricas de recuperação podem revelar padrões difíceis de identificar a partir de incidentes individuais, como a recuperação repetida da mesma etapa de processamento ou o aumento progressivo da duração da recuperação.

### 10.12 Evidências de Recuperação

A observabilidade da recuperação deve permitir demonstrar que os mecanismos de recuperação se comportam conforme projetado.

Cenários de laboratório podem introduzir intencionalmente falhas controladas e utilizar evidências de observabilidade retidas para demonstrar:

- detecção de falhas;
- início da recuperação;
- escopo correto da recuperação;
- progressão da recuperação;
- conclusão bem-sucedida;
- validação pós-recuperação;
- restauração do comportamento esperado de processamento.

Essas evidências conectam a arquitetura operacional de observabilidade à estratégia de testes de resiliência da plataforma.

A observabilidade não comprova resiliência apenas porque existe telemetria de recuperação.

A resiliência é demonstrada quando testes controlados, estado autoritativo, dados resultantes e evidências de observabilidade mostram, em conjunto, que o comportamento esperado de recuperação ocorreu.

---

## 11. Retenção, Evidências e Validação

As informações de observabilidade devem permanecer disponíveis por um período apropriado à sua finalidade operacional, investigativa, de validação, segurança e arquitetura.

Nem toda telemetria exige o mesmo período de retenção ou durabilidade.

A plataforma deve preservar evidências históricas suficientes para investigar eventos relevantes, compreender o comportamento do processamento ao longo do tempo, validar cenários de recuperação e falha e demonstrar que as garantias arquiteturais se comportam conforme projetado.

A retenção deve permanecer proporcional ao valor, à sensibilidade, ao volume e ao custo das informações que estão sendo preservadas.

### 11.1 Categorias de Retenção

Diferentes categorias de informações de observabilidade podem exigir estratégias de retenção diferentes.

Essas categorias podem incluir:

- *logs* operacionais;
- eventos estruturados;
- métricas;
- histórico de execuções;
- histórico de alertas;
- evidências de falhas;
- evidências de rejeições;
- histórico de recuperação;
- resultados de certificação;
- evidências de validação;
- medições de infraestrutura e recursos.

Os requisitos de retenção devem refletir a finalidade de cada categoria, em vez de aplicar um único período de retenção a todos os dados de observabilidade.

### 11.2 Retenção Operacional

As evidências operacionais devem permanecer disponíveis por tempo suficiente para sustentar investigações e *troubleshooting* de rotina.

O período necessário depende de fatores como:

- frequência de processamento;
- atraso na detecção de falhas;
- práticas de suporte operacional;
- comportamento da carga de trabalho;
- janela esperada de investigação;
- volume de armazenamento;
- custo operacional.

Evidências que desaparecem antes que um problema operacional seja normalmente investigado fornecem valor limitado para diagnóstico.

### 11.3 Retenção Histórica

Informações selecionadas de observabilidade podem exigir retenção mais longa para sustentar análises históricas.

Evidências históricas podem ser úteis para:

- desenvolvimento de linhas de base;
- análise de tendências;
- identificação de falhas recorrentes;
- análise de capacidade;
- comparação da duração do processamento;
- análise da atualidade;
- análise da taxa de rejeição;
- comportamento do *backlog*;
- performance da recuperação;
- evolução arquitetural.

A retenção histórica deve, preferencialmente, concentrar-se em informações que permaneçam significativas ao longo do tempo, em vez de preservar indefinidamente todos os detalhes de diagnóstico disponíveis.

### 11.4 Retenção de Evidências

As evidências produzidas especificamente para validar o comportamento arquitetural podem ter requisitos de retenção diferentes daqueles da telemetria operacional de rotina.

Exemplos podem incluir evidências que demonstrem:

- processamento bem-sucedido;
- comportamento controlado de falhas;
- isolamento de falhas;
- comportamento de *checkpoints*;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- recuperação de *backlog*;
- certificação;
- o próprio comportamento da observabilidade.

Essas evidências podem ser retidas como parte dos artefatos de validação em laboratório, mesmo quando a telemetria subjacente de alto volume for retida por um período mais curto.

### 11.5 As Evidências Devem Ser Reproduzíveis

As afirmações arquiteturais devem, preferencialmente, ser sustentadas, quando viável, por cenários de validação repetíveis, em vez de capturas de tela isoladas ou observações selecionadas manualmente.

As evidências devem, preferencialmente, preservar contexto suficiente para compreender:

- qual cenário foi executado;
- qual comportamento era esperado;
- quais condições foram introduzidas;
- qual escopo de processamento estava envolvido;
- quais observações foram coletadas;
- qual estado resultante foi produzido;
- se o comportamento esperado foi demonstrado.

Uma captura de tela pode contribuir para as evidências, mas a saída visual, por si só, não deve, preferencialmente, ser tratada como prova suficiente quando o estado subjacente puder ser validado mais diretamente.

### 11.6 As Evidências Devem Ser Correlacionadas

As evidências de validação devem estar conectadas à execução ou ao cenário que as produziu.

Quando aplicável, as evidências retidas devem, preferencialmente, preservar:

- identificação do cenário ou teste;
- identificadores de execução;
- escopo de processamento;
- *timestamps* relevantes;
- eventos observados;
- métricas relevantes;
- informações de falha;
- informações de recuperação;
- resultados de validação;
- estado autoritativo resultante.

Isso permite que evidências de diferentes componentes sejam avaliadas como parte do mesmo cenário arquitetural.

### 11.7 Validação da Observabilidade

A própria arquitetura de observabilidade deve ser testada.

Não é suficiente verificar apenas se os mecanismos de processamento e recuperação funcionam.

A validação controlada deve, preferencialmente, determinar se as evidências operacionais relevantes são produzidas quando esperado.

Exemplos incluem verificar se:

- o início e a conclusão da execução são observáveis;
- falhas produzem evidências explícitas;
- novas tentativas podem ser distinguidas;
- atividades de recuperação são identificáveis;
- o escopo de processamento pode ser correlacionado;
- *backlog* e *lag* tornam-se visíveis;
- a degradação da atualidade pode ser detectada;
- uma falha de certificação é distinguível de uma falha de processamento;
- alertas relevantes são gerados;
- a resolução torna-se visível após a recuperação.

Um mecanismo de observabilidade que funciona apenas durante o processamento normal, mas deixa de fornecer evidências durante as condições de falha que deveria diagnosticar, não atende ao seu propósito arquitetural.

### 11.8 Injeção de Falhas e Cenários Controlados

Quando seguro e viável no ambiente de laboratório, falhas controladas devem, preferencialmente, ser introduzidas para validar o comportamento da observabilidade.

Os cenários podem incluir:

- interrupção de um componente de processamento;
- interrupção temporária de um consumidor;
- introdução de falhas controladas de processamento;
- produção de registros inválidos;
- atraso do processamento *downstream*;
- criação de *backlog*;
- acionamento de comportamento de novas tentativas;
- início de *replay* ou reprocessamento;
- execução de cenários controlados de *backfill* ou *rebuild*.

O propósito da injeção de falhas não é simular todos os possíveis incidentes corporativos.

É demonstrar que condições representativas de falha e recuperação produzem as evidências observáveis esperadas.

### 11.9 Evidências Esperadas

Os cenários de validação devem, preferencialmente, definir as evidências esperadas antes da execução, quando viável.

Por exemplo, espera-se que uma interrupção controlada de um consumidor produza:

1. redução ou interrupção do consumo;
2. aumento do *lag* do consumidor;
3. atraso visível no processamento;
4. um sinal operacional, caso a condição definida de alerta seja atingida;
5. retomada do consumo após a restauração;
6. redução do *backlog*;
7. eventual restauração da atualidade esperada.

Definir as evidências esperadas antes do teste reduz o risco de interpretar, posteriormente, qualquer telemetria observada como prova de que a arquitetura se comportou corretamente.

### 11.10 Completude das Evidências

Não se deve presumir que uma única fonte de telemetria forneça evidências arquiteturais completas.

Dependendo do cenário, a validação pode exigir a combinação de:

- estado autoritativo de processamento;
- *logs*;
- eventos operacionais;
- métricas;
- *checkpoints*;
- *offsets* ou *lag* do Kafka;
- dados persistidos;
- resultados de certificação;
- metadados de recuperação;
- estado *downstream*.

A observabilidade contribui com evidências para o processo de validação, mas não substitui a validação direta do estado resultante da plataforma.

### 11.11 Retenção e Segurança

As informações de observabilidade retidas permanecem sujeitas ao modelo de segurança e governança da plataforma.

A retenção deve considerar:

- sensibilidade;
- controle de acesso;
- exposição de dados pessoais ou de negócio;
- requisitos de auditoria;
- requisitos de exclusão;
- local de armazenamento;
- período de retenção;
- descarte seguro.

Os dados de observabilidade não devem se tornar um repositório secundário não controlado de informações sensíveis da origem.

Uma retenção mais longa aumenta tanto o valor analítico quanto a responsabilidade de governança.

### 11.12 Retenção e Custo

A retenção de observabilidade consome armazenamento e pode introduzir custos adicionais de processamento, transporte, indexação e operação.

A arquitetura deve equilibrar:

- valor para diagnóstico;
- valor histórico;
- requisitos de validação;
- requisitos de segurança;
- volume de armazenamento;
- custo de processamento;
- complexidade operacional.

A telemetria detalhada de alto volume pode ser retida por períodos mais curtos, enquanto medições resumidas ou evidências selecionadas de validação permanecem disponíveis por mais tempo.

Os períodos exatos de retenção são decisões de implantação e podem evoluir à medida que a carga de trabalho da plataforma e os requisitos operacionais se tornem mensuráveis.

### 11.13 Evidências como Entregável Arquitetural

Para o Atlas Engineering, evidências selecionadas de observabilidade fazem parte da validação arquitetural da plataforma.

Quando o projeto afirmar que um comportamento relevante foi implementado e validado, as evidências de laboratório que o sustentam devem, preferencialmente, ser preservadas em uma forma que possa ser revisada.

O objetivo é distinguir entre:

**comportamento projetado** — o que a arquitetura diz que deve acontecer;

**comportamento implementado** — o que a plataforma é capaz de executar;

**comportamento validado** — o que os testes controlados e as evidências resultantes demonstram que realmente aconteceu.

A observabilidade fornece uma parte importante das evidências que conectam esses três níveis.

---

## 12. Limites Arquiteturais e Princípios de Encerramento

A observabilidade é uma capacidade arquitetural transversal da plataforma Atlas Engineering.

Ela fornece as evidências operacionais necessárias para compreender o comportamento do processamento, identificar falhas e atrasos, investigar condições inesperadas, observar atividades de recuperação, avaliar a atualidade dos dados e validar se comportamentos arquiteturais relevantes operam conforme projetado.

A observabilidade não substitui as responsabilidades das arquiteturas de processamento, confiabilidade, segurança, governança ou qualidade de dados.

### 12.1 Limite de Processamento

**Fluxo e Processamento de Dados** define como os dados se movimentam e são transformados através da plataforma.

A observabilidade expõe evidências sobre esse comportamento.

Ela pode mostrar:

- se o processamento foi iniciado;
- se o processamento progrediu;
- quanto tempo o processamento levou;
- qual escopo foi processado;
- onde o processamento foi interrompido;
- qual resultado foi observado.

Ela não define, de forma independente, a ordem de processamento, a semântica de transformação, o comportamento de *checkpoints* ou o estado autoritativo de processamento.

### 12.2 Limite de Confiabilidade e Recuperação

**Confiabilidade e Recuperação** define a semântica de falhas, o estado durável, *checkpoints*, *replay*, reprocessamento, *backfill*, *rebuild*, recuperação de *backlog* e as garantias de recuperação da plataforma.

A observabilidade torna esses comportamentos visíveis e mensuráveis.

Ela fornece evidências que ajudam a responder a questões como:

- A falha foi detectada?
- Qual escopo de processamento foi afetado?
- A recuperação foi iniciada?
- Como a recuperação progrediu?
- O processamento foi retomado?
- O estado esperado foi restaurado?

A observabilidade não fornece, por si só, a garantia de recuperação.

### 12.3 Limite de Segurança e Governança

**Segurança e Governança** define os controles que regem identidade, acesso, segredos, informações sensíveis, retenção, auditabilidade, privacidade e responsabilidades de governança relacionadas.

A observabilidade opera dentro desses controles.

*Logs*, métricas, eventos, *dashboards*, evidências retidas e outras formas de telemetria não devem contornar os requisitos de segurança ou governança apenas por serem artefatos operacionais.

Os dados de observabilidade são, por si só, dados sujeitos à governança.

### 12.4 Limite de Testes e Evidências

A observabilidade fornece evidências importantes para testes e validação arquitetural.

A estratégia de testes e evidências define como os cenários são projetados, executados, avaliados e preservados como comprovação do comportamento implementado.

A observabilidade contribui com:

- evidências de execução;
- evidências de falhas;
- evidências de recuperação;
- medições;
- eventos operacionais correlacionados;
- comportamento histórico;
- evidências de alertas e resolução.

Ela não determina, de forma independente, se um teste arquitetural foi aprovado.

A validação deve considerar, em conjunto, o comportamento esperado, o estado autoritativo resultante, os dados resultantes e as evidências de suporte relevantes.

### 12.5 Limite de Tecnologia

A arquitetura de observabilidade define as capacidades e a semântica necessárias, em vez de depender de um único produto de monitoramento ou tecnologia de implementação.

Diferentes componentes podem expor evidências operacionais por meio de mecanismos diferentes.

A implementação pode evoluir à medida que a plataforma introduzir ou alterar tecnologias, desde que os requisitos arquiteturais definidos neste documento continuem sendo atendidos.

Uma tecnologia é, portanto, selecionada para implementar as responsabilidades de observabilidade.

A arquitetura não é definida pela tecnologia selecionada.

### 12.6 Limite entre Laboratório e Ambiente Corporativo

O Atlas Engineering é uma plataforma de laboratório e portfólio projetada para demonstrar princípios arquiteturais orientados à produção.

A implementação em laboratório deve fornecer observabilidade suficiente para validar os comportamentos implementados pelo projeto.

Ela não precisa reproduzir todas as capacidades de um ambiente corporativo de observabilidade de grande porte.

Implantações corporativas podem exigir adicionalmente capacidades como:

- plataformas centralizadas de telemetria;
- infraestrutura de rastreamento distribuído;
- gerenciamento corporativo de incidentes;
- escalonamento de plantão;
- gerenciamento de níveis de serviço;
- retenção de telemetria de longo prazo;
- detecção avançada de anomalias;
- integração com operações de segurança;
- governança operacional em toda a organização.

Essas capacidades podem ampliar a implementação sem alterar os princípios fundamentais de observabilidade definidos aqui.

### 12.7 Princípios de Encerramento

A arquitetura de observabilidade do Atlas Engineering é regida pelos seguintes princípios de encerramento:

1. **O comportamento observável deve ser projetado, não presumido.**
2. **As evidências operacionais devem sustentar a investigação, e não apenas indicar atividade.**
3. **As métricas exigem contexto antes de sustentarem conclusões.**
4. **As falhas devem ser explícitas e correlacionáveis.**
5. **O progresso do processamento deve permanecer visível através dos limites arquiteturais.**
6. **A atualidade dos dados faz parte da saúde operacional.**
7. **A recuperação deve ser observável desde seu início até sua conclusão validada.**
8. **Os alertas devem representar condições operacionais significativas, em vez de maximizar o volume de notificações.**
9. ***Dashboards* resumem e permitem navegar pelas evidências; eles não substituem o diagnóstico.**
10. **A telemetria deve permanecer proporcional, segura, governada e suficientemente durável para sua finalidade.**
11. **As evidências de observabilidade sustentam a validação, mas não substituem o estado autoritativo nem os dados resultantes.**
12. **As afirmações arquiteturais devem, sempre que viável, ser sustentadas por evidências repetíveis.**

O objetivo da observabilidade no Atlas Engineering, portanto, não é simplesmente responder:

**“A plataforma está em execução?”**

É fornecer evidências confiáveis suficientes para responder:

**“A plataforma está processando os dados esperados, na etapa esperada, com o resultado esperado — e, quando isso não ocorre, conseguimos determinar o que aconteceu e verificar se a recuperação restaurou o estado esperado?”**