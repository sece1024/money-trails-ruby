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
    rails console
    User.create! email_address: "sece1024@gmail.com", password: "sece", password_confirmation: "sece"
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
- security
```shell
    brakeman
    bundle exec brakeman
```

- notification
```shell
    rails generate migration AddInventoryCountToProducts inventory_count:integer
#    rails destroy migration AddInventoryCountToProducts
    rails db:migrate
```

- subscribers
```shell
    rails generate model Subscriber product:belongs_to email 
    rails db:migrate
```

- email
```shell
    rails g mailer Product in_stock
    product = Product.first
    subscriber = product.subscribers.find_or_create_by(email: "subscriber@example.org")
    ProductMailer.with(product: product, subscriber: subscriber).in_stock.deliver_later
```

- add names to users
```shell
    rails g migration AddNamesToUsers first_name:string last_name:string
    rails db:migrate
```

- email update
```shell
    rails g migration AddUnconfirmedEmailToUsers unconfirmed_email:string
    rails db:migrate
```

- email confirmation
```shell
    rails generate mailer User email_confirmation
    rails db:migrate
```
