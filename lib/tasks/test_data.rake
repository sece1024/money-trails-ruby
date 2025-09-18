namespace :test_data do
  desc "Create test user with accounts, transactions and snapshots"
  task create: :environment do
    puts "Creating test data..."

    # 创建测试用户
    user = User.find_or_create_by(email_address: "test@example.com") do |u|
      u.password = "password123"
      u.password_confirmation = "password123"
      u.first_name = "测试"
      u.last_name = "用户"
      u.username = "testuser"
    end

    puts "Created test user: #{user.email_address}"

    # 创建资产账户
    checking_account = user.accounts.find_or_create_by(name: "支票账户") do |account|
      account.account_type = "asset"
      account.initial_balance = 5000.00
    end

    savings_account = user.accounts.find_or_create_by(name: "储蓄账户") do |account|
      account.account_type = "asset"
      account.initial_balance = 20000.00
    end

    investment_account = user.accounts.find_or_create_by(name: "投资账户") do |account|
      account.account_type = "asset"
      account.initial_balance = 50000.00
    end

    # 创建负债账户
    credit_card = user.accounts.find_or_create_by(name: "信用卡") do |account|
      account.account_type = "liability"
      account.initial_balance = -2000.00
    end

    mortgage = user.accounts.find_or_create_by(name: "房贷") do |account|
      account.account_type = "liability"
      account.initial_balance = -300000.00
    end

    puts "Created accounts: #{user.accounts.count} accounts"

    # 创建一些交易记录（过去30天）
    30.times do |i|
      date = i.days.ago.to_date

      # 随机选择账户和交易类型
      accounts = [ checking_account, savings_account, investment_account, credit_card ]
      account = accounts.sample

      # 根据账户类型决定交易金额
      if account.asset?
        amount = rand(100..2000)
        categories = [ "工资", "投资收益", "奖金", "兼职收入", "其他收入" ]
      else
        amount = -rand(50..500)
        categories = [ "购物", "餐饮", "交通", "娱乐", "其他支出" ]
      end

      category = categories.sample
      description = "#{category} - #{date.strftime('%Y-%m-%d')}"

      # 避免重复创建同一天的交易
      next if user.transactions.exists?(account: account, transaction_date: date)

      user.transactions.create!(
        account: account,
        description: description,
        amount: amount,
        category: category,
        transaction_date: date
      )
    end

    puts "Created transactions: #{user.transactions.count} transactions"

    # 创建快照数据（每周一次，过去8周）
    8.times do |i|
      date = (i * 7).days.ago.to_date

      # 避免重复创建同一天的快照
      next if user.snapshots.exists?(snapshot_date: date)

      snapshot = Snapshot.create_or_update_for_date(user, date)
      puts "Created snapshot for #{date}: #{snapshot.total_asset}"
    end

    puts "Created snapshots: #{user.snapshots.count} snapshots"

    puts "\n=== Test Data Summary ==="
    puts "User: #{user.email_address} (password: password123)"
    puts "Accounts: #{user.accounts.count}"
    puts "Transactions: #{user.transactions.count}"
    puts "Snapshots: #{user.snapshots.count}"
    puts "Current total assets: #{Snapshot.calculate_total_asset(user)}"

    puts "\nYou can now login with:"
    puts "Email: #{user.email_address}"
    puts "Password: password123"
  end

  desc "Clear all test data"
  task clear: :environment do
    puts "Clearing test data..."

    test_user = User.find_by(email_address: "test@example.com")
    if test_user
      test_user.destroy!
      puts "Deleted test user and all associated data"
    else
      puts "No test user found"
    end
  end

  desc "Show test data summary"
  task summary: :environment do
    test_user = User.find_by(email_address: "test@example.com")

    if test_user
      puts "=== Test Data Summary ==="
      puts "User: #{test_user.email_address}"
      puts "Accounts: #{test_user.accounts.count}"
      puts "Transactions: #{test_user.transactions.count}"
      puts "Snapshots: #{test_user.snapshots.count}"
      puts "Current total assets: #{Snapshot.calculate_total_asset(test_user)}"

      puts "\nAccounts:"
      test_user.accounts.each do |account|
        balance = account.initial_balance + account.transactions.sum(:amount)
        puts "  - #{account.name} (#{account.account_type}): #{balance}"
      end
    else
      puts "No test user found. Run 'rails test_data:create' first."
    end
  end
end
