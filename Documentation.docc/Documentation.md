# ``Pokedex``

Uma aplicação SwiftUI para explorar, consultar e registrar Pokémon capturados a partir dos dados públicos da PokeAPI.

## Visão Geral

O **Pokedex** é um projeto de aplicativo iOS desenvolvido em SwiftUI que organiza informações de Pokémon por região, apresenta uma listagem visual em grade, permite consultar detalhes individuais e registra localmente os Pokémon capturados pelo usuário. A proposta combina uma experiência lúdica, inspirada no universo Pokémon, com uma estrutura de código simples, modular e adequada para estudo de arquitetura em aplicativos Swift modernos.

A aplicação utiliza a [PokeAPI](https://pokeapi.co/) como fonte de dados remota. Por meio dela, o projeto obtém regiões, Pokédex regionais, espécies, identificadores, imagens, tipos, altura, peso e variações visuais dos Pokémon. A comunicação com a API é realizada de forma assíncrona, utilizando `async` e `await`, o que torna o carregamento de dados mais claro e alinhado às práticas contemporâneas da linguagem Swift.

Além da consulta remota, o projeto também utiliza SwiftData para persistir os Pokémon capturados. Dessa forma, o estado de captura permanece disponível entre execuções do aplicativo, permitindo que a interface diferencie visualmente os Pokémon já registrados daqueles ainda não capturados.

## Objetivos do Projeto

O projeto tem como objetivo demonstrar, em um contexto prático e reconhecível, como construir um aplicativo SwiftUI com consumo de API, navegação entre views, carregamento assíncrono de dados, persistência local e componentes visuais reutilizáveis.

Entre seus objetivos principais estão:

- Apresentar Pokémon agrupados por regiões oficiais, como Kanto, Johto, Hoenn, Sinnoh, Unova, Kalos, Alola, Galar e Paldea.
- Permitir a busca textual por nome dentro da região selecionada.
- Exibir cartões com sprite e nome de cada Pokémon.
- Mostrar detalhes individuais, incluindo imagem oficial, número, tipos, altura e peso.
- Alternar entre arte normal e arte shiny quando disponível.
- Oferecer uma interação de captura com animação de Poké Ball.
- Persistir localmente os Pokémon capturados por meio de SwiftData.

## Estrutura Arquitetural

A organização do projeto segue uma separação por responsabilidade, facilitando a leitura, manutenção e evolução do código. Os arquivos estão distribuídos em grupos que representam componentes visuais, modelos de dados, serviços, stores, view models e views.

### Aplicação e Entrada Principal

A estrutura principal do aplicativo está definida em ``PokedexApp``. Esse ponto de entrada configura a cena principal com ``ContentView`` e registra o container SwiftData para o modelo ``CapturedPokemon``.

A ``ContentView`` inicializa a experiência principal exibindo a região de Kanto por padrão. A partir dela, o usuário acessa a listagem regional, altera a região selecionada, pesquisa Pokémon e navega para detail views.

### Camada de Serviço

A classe ``PokeAPIService`` concentra a comunicação com a PokeAPI. Ela implementa um serviço singleton responsável por montar URLs, executar requisições HTTP, validar respostas, decodificar JSON e expor métodos específicos para obtenção de regiões, listas regionais e detalhes de Pokémon.

O serviço também contém regras de adequação dos dados retornados pela API. Algumas regiões exigem tratamento específico, como Kalos, cuja Pokédex é composta por divisões central, costeira e montanhosa. O projeto combina essas listas, remove duplicidades e aplica filtros por intervalo de geração para manter uma experiência de navegação coerente com cada região.

Os erros de rede e decodificação são representados pelo enum ``PokeAPIError``, que diferencia URL inválida, resposta inválida e falha de decodificação.

### Modelos de Dados

Os modelos representam tanto os dados remotos da PokeAPI quanto os dados locais persistidos pelo aplicativo.

``Region`` e ``RegionResponse`` descrevem as regiões retornadas pela API. ``NamedAPIResource`` representa recursos nomeados, compostos por `name` e `url`, padrão frequente nas respostas da PokeAPI. Sua extensão oferece a propriedade `idFromURL`, que extrai o identificador numérico a partir da URL do recurso.

``PokedexResponse`` e ``PokemonEntry`` representam a estrutura de uma Pokédex regional. Cada entrada possui um número e uma referência à espécie do Pokémon. O projeto também define uma entrada placeholder para apoiar estados visuais de carregamento.

``PokemonDetail``, ``PokemonTypeEntry``, ``PokemonType`` e ``PokemonSprites`` modelam os detalhes individuais de um Pokémon, incluindo tipos, altura, peso e imagens oficiais. Como a PokeAPI utiliza nomes de chaves em snake case e alguns campos com hífen, os modelos empregam `CodingKeys` quando necessário para preservar uma decodificação correta.

``CapturedPokemon`` é o modelo SwiftData usado para persistência local. Ele armazena nome, identificador e URL da imagem do Pokémon capturado. O atributo `name` é marcado como único, evitando duplicidade lógica no armazenamento.

### View Models

Os view models organizam o estado de carregamento e fazem a ponte entre views e serviços.

``RegionPokemonViewModel`` é responsável por carregar regiões disponíveis e Pokémon da região selecionada. Durante o carregamento, ele preenche a grade com placeholders para que a interface apresente uma resposta visual imediata.

``PokemonDetailViewModel`` carrega os dados completos de um Pokémon selecionado. Ele mantém o detalhe atual e o estado de carregamento, permitindo que a detail view reaja corretamente enquanto aguarda a resposta da API.

``PokemonListViewModel`` e ``RegionsViewModel`` oferecem estruturas adicionais para carregamento de listas de Pokémon por região e regiões disponíveis. Esses tipos preservam uma separação clara entre obtenção de dados e apresentação visual.

### Views e Componentes Visuais

A tela ``RegionPokemonView`` é o principal espaço de navegação do aplicativo. Ela apresenta os Pokémon em uma `LazyVGrid`, permite filtrar por texto com `.searchable`, disponibiliza um menu de regiões na toolbar e navega para ``PokemonDetailView`` quando o usuário seleciona um cartão.

A opacidade dos cartões comunica o estado de captura: Pokémon já capturados aparecem com destaque completo, enquanto os ainda não capturados aparecem parcialmente transparentes. Essa escolha visual transforma a coleção em um progresso observável pelo usuário.

``PokemonCardView`` encapsula a apresentação básica de um Pokémon na grade. Ele mostra a imagem via `AsyncImage`, o nome capitalizado e um estado alternativo de carregamento. O componente ``SkeletonRectangle`` fornece uma animação de carregamento visual, útil para indicar que o conteúdo ainda está sendo obtido.

``PokemonDetailView`` apresenta a ficha individual do Pokémon. Ela exibe a arte oficial, permite alternar para a versão shiny, mostra número, tipos, altura e peso, além de oferecer o botão de captura. A view consulta o SwiftData por meio de `@Query`, identificando se o Pokémon já está capturado e desabilitando a ação quando necessário.

``CaptureView`` implementa a experiência interativa de captura. A view exibe uma Poké Ball carregada remotamente e utiliza gesto de arraste para simular o lançamento. Quando o gesto alcança o progresso necessário, a captura é confirmada e o callback recebido pela view é executado. Esse fluxo conecta a animação visual à persistência realizada na detail view.

## Fluxo de Uso

Ao abrir o aplicativo, o usuário visualiza inicialmente a região de Kanto. A lista de Pokémon é carregada de forma assíncrona e exibida em grade. O usuário pode escolher outra região pelo menu superior ou pesquisar um Pokémon pelo nome.

Ao tocar em um cartão, o aplicativo abre a detail view correspondente. Nessa view, o usuário visualiza informações mais completas e pode alternar entre a imagem normal e a versão shiny. Caso o Pokémon ainda não tenha sido capturado, o botão de captura apresenta uma animação em tela cheia. Após a confirmação do gesto, o Pokémon é salvo localmente com SwiftData e passa a aparecer como capturado nas próximas consultas.

## Persistência Local

A persistência é centralizada no modelo ``CapturedPokemon``. O container SwiftData é configurado no ponto de entrada do aplicativo, permitindo que as views acessem o contexto de modelo por meio do ambiente.

Quando uma captura é concluída, ``PokemonDetailView`` cria uma instância de ``CapturedPokemon``, insere o objeto no contexto e salva a alteração. A listagem regional consulta os registros persistidos e monta um conjunto de identificadores capturados, usado para refletir o estado da coleção diretamente na interface.

## Carregamento e Experiência do Usuário

O projeto utiliza diferentes estratégias para manter a interface responsiva durante operações assíncronas. Nas listagens, placeholders preservam a estrutura da grade enquanto os dados são carregados. Nos cartões, ``SkeletonRectangle`` comunica visualmente que o conteúdo está em progresso. Na detail view, um `ProgressView` é exibido até que as informações completas estejam disponíveis.

Essas decisões contribuem para uma experiência mais fluida, evitando views vazias e tornando o tempo de espera compreensível para o usuário.

## Considerações Técnicas

O projeto adota SwiftUI como tecnologia principal de interface e SwiftData para persistência. A comunicação com a API utiliza `URLSession` e decodificação com `JSONDecoder`. O uso de `@MainActor` nos view models garante que as atualizações de estado observadas pela interface ocorram na thread principal.

Embora alguns view models utilizem `ObservableObject` e `@Published`, a estrutura geral do projeto já se apoia em recursos modernos da plataforma, como navegação declarativa, tarefas assíncronas com `.task`, imagens remotas com `AsyncImage` e persistência declarativa com `@Model` e `@Query`.

## Pasta de Elementos do Projeto

Esta seção reúne os principais elementos do código em grupos temáticos. A ideia é facilitar a navegação pela documentação, mostrando de forma simples onde cada parte do aplicativo se encaixa.

### Início do Aplicativo

Elementos responsáveis por abrir o app, configurar a janela principal e preparar a persistência local.

- ``PokedexApp``
- ``ContentView``

### Comunicação com a PokeAPI

Elementos que cuidam das requisições de rede, da leitura das respostas da API e do tratamento de possíveis falhas durante o carregamento dos dados.

- ``PokeAPIService``
- ``PokeAPIError``

### Dados e Representações

Modelos que descrevem os Pokémon, regiões, detalhes, sprites e registros persistidos. Eles formam a base estrutural para que o aplicativo consiga transformar respostas da API em informações utilizáveis pela interface.

- ``CapturedPokemon``
- ``Pokemon``
- ``PokemonDetail``
- ``PokemonSprites``
- ``NamedAPIResource``
- ``PokedexResponse``
- ``Region``
- ``RegionDetailResponse``

### View Models

Objetos responsáveis por carregar dados, guardar estados temporários e entregar às views as informações prontas para apresentação.

- ``RegionPokemonViewModel``
- ``PokemonDetailViewModel``
- ``PokemonListViewModel``
- ``RegionsViewModel``

### User Views

Views que compõem a experiência principal do app: listagem regional, ficha detalhada do Pokémon e animação de captura.

- ``RegionPokemonView``
- ``PokemonDetailView``
- ``CaptureView``

### Componentes Reutilizáveis

Pequenas peças visuais usadas para manter a interface consistente, como cartões de Pokémon e elementos de carregamento.

- ``PokemonCardView``
- ``SkeletonRectangle``
