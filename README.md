# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: 3.4.5

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## codesnippet
- create model
```shell
    rails generate model Product name:string
    rails db:migrate
```
- console
```shell
    rails console
```
- generate controller
```shell
    rails generate controller Products index --skip-routes
```

- authentication
```shell
    rails generate authentication
    rails db:migrate
    rails console & User.create! email_address: "you@example.org", password: "s3cr3t", password_confirmation: "s3cr3t"
```

- cache
```shell
    rails dev:cache
```

- rich text
```shell
    bin/rails action_text:install
    bundle install
    bin/rails db:migrate

```

- rubocop
```shell
    rubocop
    rubocop -a
```
