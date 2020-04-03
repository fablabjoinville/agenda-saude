# MESSAGE CHECKLIST

message = <<-MESSAGE
## Hello, hitchhiker. Not that anyone cares about what I say, but please, ensure you did check these things:
- [ ] Run all tests locally
- [ ] If you introduced front-end changes, are there desktop and mobile screenshots attached?
- [ ] Review the added i18n texts and ensure you added i18n keys for all needed cases
- [ ] Do manual tests in the pages affected by the changes you're introducing in this PR
- [ ] Fix all FIXME and remove all TODO comments
- [ ] [Rails Security Checklist](https://github.com/brunofacca/zen-rails-security-checklist)
- [ ] [Rails Style Guide](https://github.com/bbatsov/rails-style-guide)
- [ ] [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
MESSAGE

markdown(message)

# GIT & GITHUB

## Make it more obvious that a pr is a work in progress and shouldn't be merged yet
warn('PR is classed as Work in Progress') if github.pr_title.include?('WIP')

## Warn when there is a big pr
warn('Big PR') if git.lines_of_code > 500

## If these are all empty something has gone wrong, better to raise it in a comment
if git.modified_files.empty? && git.added_files.empty? && git.deleted_files.empty?
  raise('This PR has no changes at all, this is likely an issue during development.')
end

# DATABASE

added_migration = git.added_files.include?('db/migrate/*.rb')
has_schema_changes = git.modified_files.include?('db/schema.rb')

## Added migrations and didn't update schema.rb
if added_migration && !has_schema_changes
  warn('Run `db:migrate` and commit changes of `schema.rb` file!')
end

# TODOS

todoist.warn_for_todos
todoist.print_todos_table

# TESTS

has_app_changes = !git.modified_files.grep(/(lib|app)/).empty?
has_test_changes = !git.modified_files.grep(/(spec|test)/).empty?

## Changed the code, but didn't added or updated a test case?
if has_app_changes && !has_test_changes
  message = <<-MESSAGE
I think you ought to know I'm feeling very depressed with the fact that you didn't add any test case.
That's OK as long as you're refactoring existing code.
  MESSAGE

  warn(message.strip)
end

# CODE COVERAGE
simplecov.report('coverage/coverage.json')
