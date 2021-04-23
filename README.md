# Agenda Saúde

[![Maintainability](https://api.codeclimate.com/v1/badges/e426b0c2af754e57dd10/maintainability)](https://codeclimate.com/github/MakersNetwork/agenda-saude/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e426b0c2af754e57dd10/test_coverage)](https://codeclimate.com/github/MakersNetwork/agenda-saude/test_coverage)
![GitHub issues](https://img.shields.io/github/issues/makersnetwork/agenda-saude)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/makersnetwork/agenda-saude/main)
![Discord](https://img.shields.io/discord/713401243271168023)
![Open Collective backers and sponsors](https://img.shields.io/opencollective/all/makersnetwork)

**Agenda Saúde** é um projeto de código aberto desenvolvido de forma colaborativa para fornecer
um sistema de [agendamento de vacinação e exames](https://vacinajoinville.com.br/) de COVID-19 para a prefeituras, foi criado inicialmente para atender a prefeitura da cidade de Joinville-SC.
O sistema pode ser usado livremente, respeitando a [licença de uso](https://github.com/MakersNetwork/agenda-saude/blob/main/LICENSE), para gerenciar a fila de vacinação em outras cidades.

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

- Ruby `>= 3.0.1
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

Depois de clonar o repositório, você pode executar o seguinte no diretório da aplicação:

```sh
docker-compose up
```

E acesse no ambiente local [http://localhost:4000](http://localhost:4000).

### Instalando manualmente

Caso você queira instalar manualmente todas as dependências no seu ambiente GNU/Linux,
precisará executar os seguintes comandos:

```sh
apt-get update
apt-get postgresql postgresql-contrib postgresql-server-dev-all cmake nodejs libpq-dev
gem install bundler
```

Para instalar as bibliotecas e configurar o banco de dados execute:

```sh
bundle install
bin/rails db:setup
```

E acesse no ambiente local [http://localhost:3000](http://localhost:3000):

```sh
bundle exec rails server
```

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

## Deploy

Apenas pessoas autorizadas podem fazer o deploy. É necessário adicionar o remote da Heroku:

```sh
git remote set-url origin git@github.com:MakersNetwork/agenda-saude.git
git remote add heroku https://git.heroku.com/agendamento-covid.git
```

Deve ficar parecido com o exemplo abaixo:

``` sh
git remote -v
heroku https://git.heroku.com/agendamento-covid.git (fetch)
heroku https://git.heroku.com/agendamento-covid.git (push)
origin  git@github.com:MakersNetwork/agenda-saude.git (fetch)
origin  git@github.com:MakersNetwork/agenda-saude.git (push)
```

Para fazer deploy da aplicação:

```sh
git push heroku main
```

## Contribuindo

Este projeto existe graças a todas as pessoas que contribuem. Fique a vontade para contribuir! Essas aqui são boas [issues](https://github.com/MakersNetwork/agenda-saude/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) para começar! Quer conversar com o time? Estamos no [Discord](https://discord.gg/fcYkv9RvN7).

### Contribuição Financeira

Deseja contribuir financeiramente? Acesse nosso [Open Collective](https://opencollective.com/makersnetwork). Nossos financiadores:

[![Financial Contributors - Individuals](https://opencollective.com/makersnetwork/individuals.svg?width=890)](https://opencollective.com/makersnetwork)

## Time

Esse projeto existe graças ao esforço e dedicação dessas pessoas:

**desenvolvimento**

[![Code Contribotors](https://opencollective.com/makersnetwork/contributors.svg?width=890&button=false)](https://github.com/makersnetwork/agenda-saude/graphs/contributors)

**design**

[![gisele](https://user-images.githubusercontent.com/4171/112643532-38084e00-8e23-11eb-9ca6-4f947241dbac.png)](https://www.linkedin.com/in/gisele-votre-235323115/) [![gus](https://user-images.githubusercontent.com/4171/112643538-39397b00-8e23-11eb-826b-3612f8e8d9b4.png)](https://www.linkedin.com/in/olagus/)

**Empresas parceiras**

[![Magrathea](https://user-images.githubusercontent.com/4171/112638262-d42f5680-8e1d-11eb-8dc5-157198ad6bef.png)](http://magrathealabs.com)

## Licença

[MIT](https://github.com/remarkablemark/html-react-parser/blob/master/LICENSE)
