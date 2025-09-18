# 个人记账软件 - Money Trails

这是一个基于Rails开发的个人记账软件，帮助你管理个人财务，跟踪收入和支出。

## 功能特性

### 账户管理
- **资产账户**: 银行卡、现金、支付宝等存款账户
- **负债账户**: 信用卡、花呗、贷款等欠款账户
- 支持添加、编辑、删除账户
- 实时计算账户余额

### 交易记录
- 记录每笔收入和支出
- 支持多种交易类别（餐饮、交通、购物、娱乐等）
- 按日期排序显示交易历史
- 支持正数（收入）和负数（支出）

### 财务概览
- 显示总资产（资产账户余额 - 负债账户余额）
- 账户余额实时计算
- 交易统计（总收入、总支出）

## 数据模型

### Users 表
- `id`: 主键
- `username`: 用户名
- `password_digest`: 加密密码
- `created_at`, `updated_at`: 时间戳

### Accounts 表
- `id`: 主键
- `user_id`: 用户外键
- `name`: 账户名称
- `type`: 账户类型（'asset' 资产 / 'liability' 负债）
- `initial_balance`: 初始余额
- `created_at`, `updated_at`: 时间戳

### Transactions 表
- `id`: 主键
- `user_id`: 用户外键
- `account_id`: 账户外键
- `description`: 交易描述
- `amount`: 交易金额（正数收入，负数支出）
- `category`: 交易类别
- `transaction_date`: 交易日期
- `created_at`: 创建时间

## 使用方法

### 1. 创建账户
1. 访问 `/accounts/new`
2. 填写账户名称（如：招商银行卡、支付宝、花呗）
3. 选择账户类型（资产/负债）
4. 设置初始余额

### 2. 添加交易
1. 在账户列表页面点击"添加交易"
2. 或在账户详情页面点击"添加交易"
3. 填写交易描述、金额、类别和日期
4. 金额：正数表示收入，负数表示支出

### 3. 查看财务概览
- 账户列表页面显示总资产
- 每个账户显示当前余额
- 交易列表显示详细的收支记录

## 余额计算逻辑

### 单个账户余额
```
当前余额 = 初始余额 + SUM(所有交易金额)
```

### 总资产计算
```
总资产 = SUM(所有资产账户余额) - SUM(所有负债账户余额)
```

## 技术实现

### Controller
- `AccountsController`: 管理账户的CRUD操作
- `TransactionsController`: 管理交易的创建和查看

### Helper方法
- `account_balance(account)`: 计算账户余额
- `total_assets(accounts)`: 计算总资产
- `format_currency(amount)`: 格式化金额显示

### 样式
- 响应式设计，支持移动端
- 清晰的视觉层次
- 颜色编码（绿色表示正数，红色表示负数）

## 路由

```ruby
resources :accounts do
  resources :transactions
end
```

- `GET /accounts` - 账户列表
- `GET /accounts/:id` - 账户详情
- `GET /accounts/new` - 新建账户
- `POST /accounts` - 创建账户
- `GET /accounts/:id/edit` - 编辑账户
- `PATCH /accounts/:id` - 更新账户
- `DELETE /accounts/:id` - 删除账户
- `GET /accounts/:account_id/transactions` - 交易列表
- `GET /accounts/:account_id/transactions/new` - 新建交易
- `POST /accounts/:account_id/transactions` - 创建交易

## 安全特性

- 用户只能访问自己的账户和交易
- 强参数验证防止恶意输入
- 密码加密存储
- CSRF保护

## 未来扩展

- 预算管理
- 财务报表和图表
- 数据导出功能
- 定期交易（如工资、房租）
- 多币种支持
