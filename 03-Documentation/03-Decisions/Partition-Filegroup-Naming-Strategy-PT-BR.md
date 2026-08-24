# Estratégia de Nomenclatura dos *Filegroups* de Particionamento

## Status

Aceito

## Contexto

O Atlas Commerce utiliza uma estratégia de particionamento baseada em tempo, projetada para simular o ciclo de vida de um grande banco de dados transacional.

Os dados particionados são organizados de forma que a estrutura física de armazenamento permaneça independente do período de negócio atualmente mapeado para ela.

Uma opção de nomenclatura inicialmente considerada para os *filegroups* (grupos de arquivos) de particionamento foi associar diretamente o nome do *filegroup* ao período de negócio, por exemplo:

- `FG_2024`
- `FG_2025`
- `FG_2026`

Essa abordagem oferece excelente identificação visual quando os *filegroups* são criados inicialmente. Entretanto, ela introduz um problema de ciclo de vida no longo prazo.

Se um *filegroup* originalmente associado a 2024 for posteriormente reutilizado para armazenar dados de outro período, o nome `FG_2024` deixará de descrever corretamente sua finalidade atual.

Por exemplo:

```text
FG_2024 -> atualmente armazena dados de 2027
```

Embora tecnicamente válido, isso cria metadados enganosos e aumenta o custo cognitivo da administração do banco de dados.

O identificador físico de armazenamento deve, portanto, permanecer estável, enquanto o significado temporal dos dados é determinado pela arquitetura de particionamento.

## Renomeação de *Filegroups* no SQL Server

O SQL Server permite renomear um *filegroup* existente por meio de `ALTER DATABASE`.

Exemplo:

```sql
ALTER DATABASE [AtlasCommerce]
MODIFY FILEGROUP [FG_2024] NAME = [FG_2027];
```

Portanto, uma estratégia de nomenclatura baseada em períodos poderia, teoricamente, ser mantida renomeando os *filegroups* sempre que sua função de armazenamento fosse alterada.

Entretanto, renomear um *filegroup* não renomeia nem atualiza automaticamente:

- nomes lógicos dos arquivos do banco de dados;
- nomes físicos dos arquivos MDF/NDF;
- *scripts* externos de *deployment* (implantação);
- *scripts* de manutenção;
- configurações de monitoramento;
- *jobs* (tarefas agendadas) do SQL Server Agent;
- documentação;
- outras automações que possam referenciar o nome anterior do *filegroup*.

Isso poderia resultar em configurações tecnicamente válidas, porém operacionalmente confusas, como:

```text
Filegroup      : FG_2027
Arquivo lógico : AtlasCommerce_2024
Arquivo físico : AtlasCommerce_2024.ndf
```

Manter nomes temporais introduziria, portanto, trabalho operacional adicional sem proporcionar um benefício arquitetural correspondente.

## Decisão

Os *filegroups* de particionamento utilizarão identificadores estruturais neutros que descrevem sua função física sem codificar o período de negócio armazenado neles.

Para a arquitetura atual de particionamento de `sales`, os *filegroups* implementados estão organizados como:

- `FG_SALES_LEGACY`
- `FG_SALES_PART_01` até `FG_SALES_PART_37`
- `FG_SALES_FUTURE`

Os *filegroups* numerados `FG_SALES_PART_*` representam espaços físicos de armazenamento, e não anos ou meses específicos.

`FG_SALES_LEGACY` e `FG_SALES_FUTURE` possuem funções estruturais explícitas para dados fora dos limites de particionamento atualmente definidos.

A relação temporal entre os dados e o armazenamento é definida pela *partition function* (função de particionamento) e pelo *partition scheme* (esquema de particionamento):

- `PF_SALES_MONTHLY`
- `PS_SALES_MONTHLY`

Conceitualmente:

```text
Período de negócio
        |
        v
PF_SALES_MONTHLY
        |
        v
PS_SALES_MONTHLY
        |
        v
FG_SALES_LEGACY
FG_SALES_PART_01 ... FG_SALES_PART_37
FG_SALES_FUTURE
```

Isso separa o ciclo de vida do armazenamento físico do calendário de negócio, mantendo estável a nomenclatura dos *filegroups* à medida que os mapeamentos de particionamento evoluem.

## Justificativa

Um *filegroup* é infraestrutura.

Um período de negócio é metadado temporal.

Acoplar os dois cria uma relação de nomenclatura que pode se tornar incorreta quando a estrutura física de armazenamento é reutilizada para outro período.

O uso de nomes estruturais neutros para os *filegroups* permite que a arquitetura física de armazenamento permaneça estável enquanto o mapeamento temporal evolui independentemente por meio da *partition function* e do *partition scheme*.

Na arquitetura atual de particionamento de `sales`, nomes como:

- `FG_SALES_PART_01`
- `FG_SALES_PART_02`
- `FG_SALES_PART_03`

identificam espaços físicos de armazenamento sem sugerir que esses espaços pertençam permanentemente a um ano ou mês específico.

Da mesma forma, `FG_SALES_LEGACY` e `FG_SALES_FUTURE` descrevem funções estruturais, e não períodos fixos do calendário.

A relação oficial entre um período de negócio e sua localização física de armazenamento é, portanto, mantida por:

- `PF_SALES_MONTHLY`;
- `PS_SALES_MONTHLY`.

Isso mantém estável a nomenclatura da infraestrutura, evita renomeações desnecessárias à medida que os mapeamentos de particionamento evoluem e impede que significados temporários relacionados ao tempo de negócio sejam incorporados a identificadores físicos permanentes.

## Alternativas Consideradas

### *Filegroups* baseados em períodos

Exemplo:

```text
FG_2024
FG_2025
FG_2026
```

Vantagens:

- Identificação visual imediata do período de negócio inicialmente associado a cada *filegroup*
- Relação simples entre período e armazenamento durante o *deployment* inicial

Desvantagens:

- Os nomes podem se tornar incorretos quando o armazenamento físico é reutilizado
- Exige renomeação periódica dos *filegroups* para preservar a precisão semântica
- Os nomes lógicos e físicos dos arquivos podem se tornar inconsistentes com o *filegroup* renomeado
- *Scripts* externos, automações, monitoramento e documentação operacional podem manter nomes obsoletos
- Acopla a infraestrutura física à semântica temporal do negócio

Decisão: Rejeitada.

### *Filegroups* estruturais neutros

Implementação atual:

```text
FG_SALES_LEGACY
FG_SALES_PART_01
FG_SALES_PART_02
...
FG_SALES_PART_37
FG_SALES_FUTURE
```

Vantagens:

- Nomes estruturais estáveis durante todo o ciclo de vida do banco de dados
- Mantém o armazenamento físico independente do significado temporal de negócio
- Evita renomeações periódicas da infraestrutura à medida que os mapeamentos de particionamento evoluem
- Suporta a arquitetura atual de particionamento mensal sem incorporar anos ou meses aos nomes dos *filegroups*
- Reduz a ambiguidade operacional em ambientes de longa duração

Desvantagens:

- O período de negócio associado a um *filegroup* numerado não é imediatamente visível apenas pelo nome do *filegroup*
- Os administradores precisam consultar a *partition function* e o *partition scheme* para determinar o mapeamento atual

Decisão: Aceita.

## Consequências

A *partition function* e o *partition scheme* são as fontes oficiais para determinar como os períodos de negócio são mapeados para os *filegroups* físicos.

Para a arquitetura atual de particionamento de `sales`, essa responsabilidade pertence a:

- `PF_SALES_MONTHLY`;
- `PS_SALES_MONTHLY`.

A validação do *deployment* já verifica a consistência estrutural da arquitetura de particionamento, incluindo:

- *filegroups* de particionamento obrigatórios;
- arquivos do banco de dados associados a esses *filegroups*;
- configuração da *partition function*;
- sequência esperada dos *boundaries* (valores de limite);
- configuração do *partition scheme*;
- mapeamento entre destinos e *filegroups*;
- configuração de `NEXT USED`.

Como os nomes dos *filegroups* numerados intencionalmente não codificam um período de negócio, os administradores devem utilizar os metadados de particionamento quando precisarem determinar a relação atual entre períodos, partições e armazenamento físico.

Consultas operacionais adicionais de diagnóstico podem expor informações como:

- número da partição;
- valores de *boundary*;
- *filegroup*;
- quantidade de linhas;
- período de negócio representado por cada partição.

Esses diagnósticos melhoram a visibilidade operacional sem incorporar significados transitórios relacionados ao tempo de negócio à nomenclatura permanente da infraestrutura.