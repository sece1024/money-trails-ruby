module TransactionsHelper
  # 获取交易类别的显示颜色
  def category_color(category)
    colors = {
      "餐饮" => "#FF6B6B",
      "交通" => "#4ECDC4",
      "购物" => "#45B7D1",
      "娱乐" => "#96CEB4",
      "医疗" => "#FFEAA7",
      "教育" => "#DDA0DD",
      "工资" => "#98D8C8",
      "奖金" => "#F7DC6F",
      "投资" => "#BB8FCE",
      "其他" => "#85C1E9"
    }
    colors[category] || "#95A5A6"
  end

  # 格式化交易日期
  def format_transaction_date(date)
    date.strftime("%Y年%m月%d日")
  end

  # 获取交易类型的显示文本
  def transaction_type_display(amount)
    amount >= 0 ? "收入" : "支出"
  end

  # 获取交易类型的CSS类
  def transaction_type_class(amount)
    amount >= 0 ? "income" : "expense"
  end

  # 计算交易对账户余额的影响
  def balance_impact(transaction)
    transaction.account.initial_balance +
    transaction.account.transactions.where("transaction_date <= ?", transaction.transaction_date).sum(:amount)
  end
end
