module AccountsHelper
  # 计算单个账户的当前余额
  def account_balance(account)
    account.initial_balance + account.transactions.sum(:amount)
  end

  # 计算总资产（所有资产账户余额 - 所有负债账户余额）
  def total_assets(accounts)
    asset_balance = accounts.where(account_type: "asset").sum { |account| account_balance(account) }
    liability_balance = accounts.where(account_type: "liability").sum { |account| account_balance(account) }
    asset_balance - liability_balance
  end

  # 格式化金额显示
  def format_currency(amount)
    number_to_currency(amount, unit: "¥", precision: 2)
  end

  # 获取账户类型的显示文本
  def account_type_display(type)
    type == "asset" ? "资产" : "负债"
  end

  # 获取账户类型的CSS类
  def account_type_class(type)
    type == "asset" ? "asset-account" : "liability-account"
  end

  # 获取金额的CSS类（正数/负数）
  def amount_class(amount)
    amount >= 0 ? "positive" : "negative"
  end
end
