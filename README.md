# README
## Requirements
* Ruby version: 3.4.5

## local deployment
### Setup
```shell
  gem
  rails db:migrate
  rails s
```

### create test data
#### 使用方法
创建测试数据：
```shell
   rails test_data:create
   rails test_data:enhance
```
查看数据摘要：
```shell
   rails test_data:summary
   rails test_data:test_growth
```
清除测试数据：
```shell
   rails test_data:clear
```
生成的测试数据包括
- 测试用户：
  - 邮箱：test@example.com
  - 密码：password123
  - 姓名：测试用户
  - 用户名：testuser
- 5个账户：
  - 支票账户（资产）：初始余额 5,000
  - 储蓄账户（资产）：初始余额 20,000
  - 投资账户（资产）：初始余额 50,000
  - 信用卡（负债）：初始余额 -2,000
  - 房贷（负债）：初始余额 -300,000
  - 30笔交易记录：过去30天的随机交易数据
  - 8个快照：过去8周每周的财务快照

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

- add admin
```shell
    rails g migration AddAdminToUsers admin:boolean
    rails db:migrate
    rails dbconsole
    UPDATE users SET admin=true WHERE users.id=1
    .quit
```
