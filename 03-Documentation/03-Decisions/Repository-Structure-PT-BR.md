# Estrutura do Repositório

## *Status*

Aceito

## Contexto

O Atlas Engineering foi criado do zero para simular a implementação e a evolução de uma plataforma de dados empresarial real.

Espera-se que o repositório evolua ao longo do tempo à medida que múltiplas tecnologias, ambientes, bancos de dados, *scripts*, documentação, testes e outros artefatos técnicos sejam introduzidos.

Uma estrutura de repositório definida é, portanto, necessária para manter uma separação clara de responsabilidades, fornecer locais previsíveis para os artefatos do projeto e evitar que o repositório se torne cada vez mais difícil de navegar à medida que a plataforma cresce.

Estabelecer e preservar essa organização melhora a consistência, a facilidade de localização dos artefatos, a manutenibilidade e a capacidade de evoluir áreas individuais da plataforma sem perder a estrutura geral do projeto.

## Decisão

O Atlas Engineering utilizará uma estrutura de repositório modular e orientada por responsabilidades.

Os artefatos do projeto são organizados hierarquicamente para que cada diretório tenha uma finalidade técnica clara e os artefatos relacionados permaneçam agrupados na área responsável por eles.

A raiz do repositório versionado é:

```text
01-Enterprise-Data-Platform
```

Sua estrutura atual está separada em:

```text
01-Enterprise-Data-Platform
|
+-- 01-Source
+-- 02-Database
+-- 03-Documentation
+-- 04-Scripts
+-- 05-Tests
```

Esses diretórios representam responsabilidades distintas:

- `01-Source` — artefatos de código-fonte da aplicação ou da plataforma, quando necessários;
- `02-Database` — arquivos físicos de dados e de log do banco de dados utilizados pelo ambiente local;
- `03-Documentation` — documentação técnica, arquitetural, de negócio, padrões, decisões, ambiente e aprendizado;
- `04-Scripts` — *scripts* técnicos executáveis organizados por responsabilidade;
- `05-Tests` — artefatos de teste associados à plataforma.

A documentação técnica é organizada adicionalmente por finalidade:

```text
03-Documentation
|
+-- 01-Environment
+-- 02-Standards
+-- 03-Decisions
+-- 04-Architecture
+-- 05-Business
+-- 06-Learning
```

Os *scripts* executáveis são igualmente separados por responsabilidade técnica. Dentro do *deployment* (implantação) do banco de dados, diretórios numerados são utilizados quando a sequência possui significado operacional, enquanto nomes descritivos são utilizados para artefatos que não exigem uma ordem de execução.

Instaladores de suporte e ferramentas de desenvolvimento utilizados para reproduzir ou preparar o ambiente local do projeto são mantidos fora do repositório versionado. Esses recursos locais não fazem parte da implementação da plataforma e não são enviados ao controle de versão.

A estrutura do repositório pode evoluir à medida que o Atlas Engineering cresce, mas os princípios de separação de responsabilidades, localização previsível dos artefatos e sequenciamento significativo serão preservados.

## Consequências

### Positivas

- Separação clara de responsabilidades entre as áreas do repositório.
- Locais previsíveis para os artefatos técnicos.
- Navegação e localização mais fáceis à medida que o projeto cresce.
- A documentação pode evoluir independentemente, permanecendo organizada junto à implementação.
- Os artefatos de *deployment* do banco de dados podem ser separados por responsabilidade técnica e sequência de execução.
- Novas tecnologias e componentes da plataforma podem ser introduzidos sem exigir a reorganização de áreas não relacionadas do repositório.
- A estrutura fornece uma base consistente para futuros colaboradores e ambientes.

### Negativas

- Exige disciplina para manter os artefatos em seus locais definidos.
- As convenções estruturais devem ser mantidas à medida que novas áreas são introduzidas.
- A hierarquia adicional aumenta o número de diretórios em comparação com um repositório mais simples.
- Alterações em nomes ou locais de diretórios já estabelecidos podem exigir atualizações em *scripts*, documentação, automações ou outras referências.

## Alternativas Consideradas

### Estrutura de repositório *flat* (plana)

Foi considerada uma estrutura mais simples na qual a maioria dos artefatos do projeto seria armazenada na raiz do repositório ou próxima a ela.

Vantagens:

- Menor esforço inicial de configuração.
- Menos diretórios para criar e manter.
- Navegação simples enquanto o projeto contém apenas uma pequena quantidade de artefatos.

Desvantagens:

- As responsabilidades tornam-se cada vez mais misturadas à medida que o repositório cresce.
- Documentação, *scripts*, artefatos de banco de dados, testes e futuros componentes da plataforma tornam-se mais difíceis de localizar e gerenciar.
- A ordem de execução e a responsabilidade técnica tornam-se menos visíveis.
- O crescimento de uma área aumenta a complexidade organizacional do repositório como um todo.
- Reestruturações futuras tornam-se mais disruptivas depois que *scripts*, documentação e automações passam a depender dos caminhos estabelecidos.

Decisão: Rejeitada.

### Estrutura modular orientada por responsabilidades

Foi considerada uma estrutura hierárquica na qual os artefatos são agrupados de acordo com a responsabilidade técnica.

Vantagens:

- Separação clara entre implementação da plataforma, documentação, *scripts*, testes e artefatos de banco de dados.
- Locais previsíveis para artefatos relacionados.
- Suporta sequenciamento significativo quando a ordem de execução é relevante.
- Permite que áreas individuais do Atlas Engineering evoluam sem exigir a reorganização de áreas não relacionadas.
- Fornece uma base organizacional escalável à medida que tecnologias e componentes adicionais da plataforma são introduzidos.

Desvantagens:

- Exige maior organização inicial.
- Introduz uma hierarquia adicional de diretórios.
- Exige disciplina contínua para preservar a consistência estrutural à medida que o projeto evolui.

Decisão: Aceita.