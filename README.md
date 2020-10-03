# Agenda Vacina

> **master** Projeto original para agendamento de vacinação

> **master-covid** Fork para agendamento de exames de COVID-19

## Índice

- [Dependências](#dependencias)
- [Desenvolvimento](#desenvolvimento
- [Style Guides](#style-guides)
- [Deploy](#deploy)

## Dependências

- Ruby >= 2.6.5
- Node >= 13.2.0
- PostgreSQL 12.1

**Ubuntu**

```sh
apt-get update
apt-get postgresql postgresql-contrib postgresql-server-dev-all cmake node libpq-dev
gem install bundler
```

**MacOS**

```sh
brew update
brew install postgres node
gem install bundler
```

## Desenvolvimento

```sh
bundle install
cp config/database.yml.example config/database.yml
bin/rails db:setup
```

Acesse no ambiente local  [http://localhost:3000](http://localhost:3000):

```sh
bundle exec rails serve
```

Para verificar o estilo do código:

```sh
bundle exec rubocop
```

Para executar os testes:

```sh
bundle exec rails test
```

## Style Guides

- [Ruby style guide](https://github.com/bbatsov/ruby-style-guide)
- [Rails style guide](https://github.com/bbatsov/rails-style-guide)
- [JavaScript style guide](https://github.com/airbnb/javascript)

## deploy

É necessário modificar os _remotes_ para refletir as duas aplicações na Heroku:

```sh
git remote set-url origin git@github.com:magrathealabs/agenda-saude-joinville.git
git remote add vacina https://git.heroku.com/agendamento-vacina.git
git remote add covid https://git.heroku.com/agendamento-covid.git
```

Deve ficar parecido com o exemplo abaixo:

> git remote -v
> covid https://git.heroku.com/agendamento-covid.git (fetch)
> covid https://git.heroku.com/agendamento-covid.git (push)
> origin  git@github.com:magrathealabs/agenda-saude-joinville.git (fetch)
> origin  git@github.com:magrathealabs/agenda-saude-joinville.git (push)
> vacina  https://git.heroku.com/agendamento-vacina.git (fetch)
> vacina  https://git.heroku.com/agendamento-vacina.git (push)

Para fazer deploy da branch da agenda de vacinação:

```sh
git push vacina master:master
```

Para fazer deploy da branch da agenda de covid:

```sh
git push covid master-covid:master
```
