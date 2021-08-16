# Agenda Saúde

[![Maintainability](https://api.codeclimate.com/v1/badges/e426b0c2af754e57dd10/maintainability)](https://codeclimate.com/github/MakersNetwork/agenda-saude/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e426b0c2af754e57dd10/test_coverage)](https://codeclimate.com/github/MakersNetwork/agenda-saude/test_coverage)
![GitHub issues](https://img.shields.io/github/issues/makersnetwork/agenda-saude)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/makersnetwork/agenda-saude/main)
![Discord](https://img.shields.io/discord/713401243271168023)
![Open Collective backers and sponsors](https://img.shields.io/opencollective/all/makersnetwork)

**Agenda Saúde** é um projeto de código aberto desenvolvido de forma colaborativa para fornecer
um sistema de [agendamento de vacinação e exames](https://vacinajoinville.com.br/) de COVID-19 para prefeituras. Atualmente está em uso pela secretaria de saúde da prefeitura de Joinville/SC. O sistema pode ser usado livremente, respeitando a [licença de uso](https://github.com/MakersNetwork/agenda-saude/blob/main/LICENSE), para gerenciar a fila de vacinação em outras cidades.

Conheça detalhes do projeto na nossa [página institucional](https://agendasaude.joinville.br).

Quer saber como implantar na sua cidade? Veja nosso [fórum](https://github.com/MakersNetwork/agenda-saude/discussions/250). Tire qualquer [dúvida](https://github.com/MakersNetwork/agenda-saude/discussions) sobre o projeto. [Sugira](https://github.com/MakersNetwork/agenda-saude/issues) melhorias. Fique a vontade para [contribuir](#contribuindo)!

- [Dependências](#dependencias)
- [Desenvolvimento](#desenvolvimento)
- [Testes](#testes)
- [Style Guides](#style-guides)
- [Deploy](#deploy)
- [Contribuindo](contribuindo)
- [Licença](licenca)

## Dependências

Este projeto usa o framework de desenvolvimento Web Ruby on Rails e possui as seguintes
dependências:

- Ruby `>= 3.0.1`
- Node `>= 13.2.0`
- PostgreSQL `== 12.1`
- Install Docker ([documentação](https://docs.docker.com/install/overview/))
- Install Docker Compose ([documentação](https://docs.docker.com/compose/install/))

## Desenvolvimento

Se você quiser executar este projeto no seu ambiente de desenvolvimento,
você deve clonar este código-fonte, compilá-lo e executá-lo localmente.

Existem duas formas de configurar o projeto no seu ambiente. Usando o
[Docker Compose](#docker-compose) ou
[instalando manualmente as dependências](#instalando-manualmente).

### Docker Compose

A forma mais fácil de executar este projeto no seu ambiente é usando o
Docker Compose, ferramenta responsável por criar um ambiente virtualizado e
instalar todas as outras dependências.

Após clonar o repositório, você pode executar os seguintes comandos no diretório da aplicação:

```sh
docker-compose up --build
docker-compose run web rails db:migrate
```

E acesse no ambiente local [http://localhost:3000](http://localhost:3000).

Obs.: Você pode omitir a opção `--build` depois de fazer o build da aplicação pela primeira vez. Dessa forma, subir o docker-compose fica consideravelmente mais rápido. Porém, quando há mudanças no Gemfile, é aconselhável executar com `--build` novamente.

### Instalando manualmente

Caso você queira instalar manualmente todas as dependências no seu ambiente GNU/Linux,
precisará executar os seguintes comandos:

```sh
apt update
apt install postgresql postgresql-contrib postgresql-server-dev-all cmake nodejs libpq-dev
gem install bundler
```

Para instalar as bibliotecas execute:

```sh
bundle install
```

Para configurar o banco de dados execute:

```sh
cp .env.db.sample .env
source .env
bin/rails db:setup
```

E acesse no ambiente local [http://localhost:3000](http://localhost:3000):

```sh
bundle exec rails server
```

#### Problemas conhecidos

Caso você configure seu PostgreSQL localmente para não usar nenhuma senha, é provavável que precise [alterar o método de autenticação](https://stackoverflow.com/a/23377623/2761861)

## Testes

Para executar os testes da aplicação e verificar se tudo está funcionando como
esperado execute:

```sh
bundle exec rspec
```

## Style Guides

- [Ruby style guide](https://github.com/bbatsov/ruby-style-guide)
- [Rails style guide](https://github.com/bbatsov/rails-style-guide)
- [JavaScript style guide](https://github.com/airbnb/javascript)

Você pode verificar se o código está em conformidade com os padrões do projeto
executando o robocop e corrigindo qualquer alerta evidenciado:

```sh
bundle exec rubocop
```

## Contribuindo

Este projeto existe graças a todas as pessoas que contribuem. Fique a vontade para contribuir! Essas aqui são boas [issues](https://github.com/MakersNetwork/agenda-saude/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) para começar! Quer conversar com o time? Estamos no [Discord](https://discord.gg/fcYkv9RvN7).

### Contribuição Financeira

Deseja contribuir financeiramente? Acesse nossa [página institucional](https://agendasaude.joinville.br). Caso sua contribuição seja menor que 500 reais, use o nosso [Open Collective](https://opencollective.com/makersnetwork). Nossos financiadores:

[![Financial Contributors - Individuals](https://opencollective.com/makersnetwork/individuals.svg?width=891)](https://opencollective.com/makersnetwork)

## Time

Esse projeto existe graças ao esforço e dedicação dessas pessoas:

**desenvolvimento**

[![Code Contribotors](https://opencollective.com/makersnetwork/contributors.svg?width=891&button=false)](https://github.com/makersnetwork/agenda-saude/graphs/contributors)

**design**

[![gisele](https://user-images.githubusercontent.com/4171/112643532-38084e00-8e23-11eb-9ca6-4f947241dbac.png)](https://www.linkedin.com/in/gisele-votre-235323115/) [![gus](https://user-images.githubusercontent.com/4171/112643538-39397b00-8e23-11eb-826b-3612f8e8d9b4.png)](https://www.linkedin.com/in/olagus/)

**Empresas parceiras**

[![Magrathea](https://user-images.githubusercontent.com/4171/112638262-d42f5680-8e1d-11eb-8dc5-157198ad6bef.png)](http://magrathealabs.com)

## Licença

[MIT](https://github.com/remarkablemark/html-react-parser/blob/master/LICENSE)
