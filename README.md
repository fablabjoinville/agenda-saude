# template-rails

- [Dependencies](#dependencies)
- [Development](#development)
- [Staging](#staging)
- [Style Guides](#style-guides)
- [Defaults](#defaults)

## Dependencies

Created with command `rails new rails-template --database=postgresql --skip-turbolinks --webpack=react --skip_coffee`.

Things you need to install to run this project:

- Ruby >= 2.6.5
- Node >= 13.2.0
- PostgreSQL 12.1

**Ubuntu**

```sh
apt-get update
apt-get postgresql postgresql-contrib postgresql-server-dev-all cmake node
gem install bundler
```

**MacOS**

```sh
brew update
brew install postgres node
gem install bundler
```

## Development

### Setup

```sh
bundle install
cp config/database.yml.example config/database.yml
bin/rails db:setup
```

Run the local server at [http://localhost:3000](http://localhost:3000) with:

```sh
bundle exec rails serve
```

Check code style with:

```sh
bundle exec rubocop
```

Run tests with:

```sh
bundle exec rails test
```

Use guard to run tests and check code style as you code:

```sh
bundle exec guard
```

You can check test coverage information by running the test suite and looking into `coverage/` folder:

```sh
bundle exec rails test
open coverage/index.html
```

## Staging

We're using Heroku as Staging environment. Take a look in the
[documentation](https://devcenter.heroku.com/articles/getting-started-with-rails5) to setup Heroku in your machine.

```sh
git push heroku master
heroku run rails db:migrate
```

## Style Guides

- [Ruby style guide](https://github.com/bbatsov/ruby-style-guide)
- [Rails style guide](https://github.com/bbatsov/rails-style-guide)
- [JavaScript style guide](https://github.com/airbnb/javascript)

## Defaults

This project come with some defaults preconfigured:

**Active Admin**

This is an administration framework that automatically generate scaffold UIs. Take a look in the [docs](https://activeadmin.info/index.html).

To register new models use:

```sh
rails generate active_admin:resource [ModelName]
```

This creates a file at `app/admin/model_names.rb` for configuring the resource.
Refresh the web browser to see the interface.

**Authentication**

It has Devise installed and configured with `User` model, i18n files and the
internationalized views for English and Brazilian Portuguese.

Go to [Model documentation](https://github.com/plataformatec/devise#configuring-models) to
see the available model configurations and [Controller documentation](https://github.com/plataformatec/devise#controller-filters-and-helpers)
to see the avaliable configurations for controllers.

**Tests**

[RSpec](https://github.com/rspec/rspec-rails) is installer and configured. All tests are located on the `spec` directory.
It also comes with [faker](https://github.com/faker-ruby/faker), [factory boy](https://github.com/thoughtbot/factory_bot),
[shoulda-matchers](), [database_rewinder](), [ruby-prof](), [timecop](), [vcr](), [webmock](),
[simplecov] support.

**Code Quality**

`rubocop` is configured with default Ruby and Rails linting and best practices. Take a look in all
[Rals cops](https://github.com/rubocop-hq/rubocop-rails/tree/master/lib/rubocop/cop/rails) available.

`guard` is configured to support live file reloads for Rails, RSpec and Rubocop.

**Danger**

Config for [Danger](http://danger.systems/ruby/) with support for SimpleCov. Take a look on `Dangerfile` for details.
Review your Dangerfile and change the checks for your needs. Also, config the needed environment variables
in your CI:

```sh
DANGER_GITHUB_API_TOKEN: XXX
```

Take a look in the project [documentation](http://danger.systems/).

**Pronto**

Run it with `pronto run .`.

If you want to use Pronto in your CI, please config the needed environment variables. Bellow is an example:

```sh
PRONTO_GITHUB_ACCESS_TOKEN: XXX
PRONTO_PULL_REQUEST_ID: "$(echo $CIRCLE_PULL_REQUEST | grep -o -E '[0-9]+')"
PRONTO_GITHUB_SLUG: "${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}"
PRONTO_FORMAT: "%{msg} [%{runner}:%{level}]"
PRONTO_VERBOSE: true
```

Take a look in the project [documentation](https://github.com/prontolabs/pronto).
