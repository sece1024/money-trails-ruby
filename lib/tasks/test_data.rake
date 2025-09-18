namespace :test_data do
  desc "Create test user with accounts, transactions and snapshots"
  task create: :environment do
    puts "Creating comprehensive test data..."

    # 创建测试用户
    user = User.find_or_create_by(email_address: "test@example.com") do |u|
      u.password = "password123"
      u.password_confirmation = "password123"
      u.first_name = "测试"
      u.last_name = "用户"
      u.username = "testuser"
    end

    puts "Created test user: #{user.email_address}"

    # 创建更多资产账户
    checking_account = user.accounts.find_or_create_by(name: "招商银行储蓄卡") do |account|
      account.account_type = "asset"
      account.initial_balance = 8500.00
    end

    savings_account = user.accounts.find_or_create_by(name: "建设银行定期存款") do |account|
      account.account_type = "asset"
      account.initial_balance = 50000.00
    end

    investment_account = user.accounts.find_or_create_by(name: "支付宝余额宝") do |account|
      account.account_type = "asset"
      account.initial_balance = 25000.00
    end

    stock_account = user.accounts.find_or_create_by(name: "华泰证券股票账户") do |account|
      account.account_type = "asset"
      account.initial_balance = 80000.00
    end

    crypto_account = user.accounts.find_or_create_by(name: "币安加密货币") do |account|
      account.account_type = "asset"
      account.initial_balance = 15000.00
    end

    # 创建更多负债账户
    credit_card_1 = user.accounts.find_or_create_by(name: "招商银行信用卡") do |account|
      account.account_type = "liability"
      account.initial_balance = -3500.00
    end

    credit_card_2 = user.accounts.find_or_create_by(name: "建设银行信用卡") do |account|
      account.account_type = "liability"
      account.initial_balance = -1800.00
    end

    mortgage = user.accounts.find_or_create_by(name: "工商银行房贷") do |account|
      account.account_type = "liability"
      account.initial_balance = -450000.00
    end

    car_loan = user.accounts.find_or_create_by(name: "汽车贷款") do |account|
      account.account_type = "liability"
      account.initial_balance = -120000.00
    end

    puts "Created accounts: #{user.accounts.count} accounts"

    # 定义真实的交易数据模板
    transaction_templates = {
      # 收入类交易
      income: [
        { category: "工资", amount_range: [ 8000, 12000 ], frequency: 0.8, accounts: [ checking_account ] },
        { category: "奖金", amount_range: [ 2000, 8000 ], frequency: 0.1, accounts: [ checking_account ] },
        { category: "投资收益", amount_range: [ 500, 3000 ], frequency: 0.3, accounts: [ stock_account, investment_account ] },
        { category: "兼职收入", amount_range: [ 800, 2500 ], frequency: 0.2, accounts: [ checking_account ] },
        { category: "加密货币收益", amount_range: [ 200, 1500 ], frequency: 0.15, accounts: [ crypto_account ] },
        { category: "理财收益", amount_range: [ 100, 800 ], frequency: 0.4, accounts: [ savings_account, investment_account ] }
      ],
      # 支出类交易
      expense: [
        { category: "餐饮", amount_range: [ 30, 200 ], frequency: 0.9, accounts: [ credit_card_1, credit_card_2 ] },
        { category: "购物", amount_range: [ 100, 2000 ], frequency: 0.4, accounts: [ credit_card_1, credit_card_2 ] },
        { category: "交通", amount_range: [ 20, 150 ], frequency: 0.7, accounts: [ credit_card_1, checking_account ] },
        { category: "娱乐", amount_range: [ 50, 500 ], frequency: 0.3, accounts: [ credit_card_1, credit_card_2 ] },
        { category: "医疗", amount_range: [ 100, 1000 ], frequency: 0.1, accounts: [ checking_account, credit_card_1 ] },
        { category: "教育", amount_range: [ 200, 1500 ], frequency: 0.05, accounts: [ checking_account ] },
        { category: "房租", amount_range: [ 3000, 5000 ], frequency: 0.8, accounts: [ checking_account ] },
        { category: "水电费", amount_range: [ 200, 600 ], frequency: 0.6, accounts: [ checking_account ] },
        { category: "通讯费", amount_range: [ 50, 200 ], frequency: 0.8, accounts: [ credit_card_1 ] },
        { category: "保险", amount_range: [ 300, 800 ], frequency: 0.2, accounts: [ checking_account ] },
        { category: "房贷还款", amount_range: [ 3500, 4500 ], frequency: 0.8, accounts: [ checking_account ] },
        { category: "车贷还款", amount_range: [ 2000, 2500 ], frequency: 0.8, accounts: [ checking_account ] }
      ]
    }

    # 生成过去12个月的数据
    start_date = 12.months.ago.to_date
    end_date = Date.current

    transaction_count = 0

    (start_date..end_date).each do |date|
      # 跳过未来日期
      next if date > Date.current

      # 根据日期类型调整交易频率
      day_factor = case date.wday
      when 0, 6 then 0.3  # 周末交易较少
      when 1 then 0.8     # 周一交易较多
      else 0.6            # 工作日
      end

      # 生成收入交易
      transaction_templates[:income].each do |template|
        if rand < template[:frequency] * day_factor
          account = template[:accounts].sample
          amount = rand(template[:amount_range][0]..template[:amount_range][1])

          # 避免重复创建同一天的相同交易
          next if user.transactions.exists?(
            account: account,
            transaction_date: date,
            category: template[:category]
          )

          user.transactions.create!(
            account: account,
            description: "#{template[:category]} - #{date.strftime('%Y-%m-%d')}",
            amount: amount,
            category: template[:category],
            transaction_date: date
          )
          transaction_count += 1
        end
      end

      # 生成支出交易
      transaction_templates[:expense].each do |template|
        if rand < template[:frequency] * day_factor
          account = template[:accounts].sample
          amount = -rand(template[:amount_range][0]..template[:amount_range][1])

          # 避免重复创建同一天的相同交易
          next if user.transactions.exists?(
            account: account,
            transaction_date: date,
            category: template[:category]
          )

          user.transactions.create!(
            account: account,
            description: "#{template[:category]} - #{date.strftime('%Y-%m-%d')}",
            amount: amount,
            category: template[:category],
            transaction_date: date
          )
          transaction_count += 1
        end
      end
    end

    puts "Created transactions: #{transaction_count} transactions"

    # 创建更频繁的快照数据（每周一次，过去52周）
    # 但需要按时间顺序创建，确保资产增长趋势正确
    snapshot_count = 0
    snapshot_dates = []

    # 生成52周的日期（从最早到最新）
    52.times do |i|
      date = (51 - i).weeks.ago.to_date
      snapshot_dates << date
    end

    # 按时间顺序创建快照
    snapshot_dates.sort.each do |date|
      # 避免重复创建同一天的快照
      next if user.snapshots.exists?(snapshot_date: date)

      snapshot = Snapshot.create_or_update_for_date(user, date)
      snapshot_count += 1
    end

    puts "Created snapshots: #{snapshot_count} snapshots"

    puts "\n=== Test Data Summary ==="
    puts "User: #{user.email_address} (password: password123)"
    puts "Accounts: #{user.accounts.count}"
    puts "Transactions: #{user.transactions.count}"
    puts "Snapshots: #{user.snapshots.count}"
    puts "Current total assets: #{Snapshot.calculate_total_asset(user)}"

    puts "\nAccount Details:"
    user.accounts.each do |account|
      balance = account.initial_balance + account.transactions.sum(:amount)
      transaction_count = account.transactions.count
      puts "  - #{account.name} (#{account.account_type}): #{balance} (#{transaction_count} transactions)"
    end

    puts "\nTransaction Categories:"
    user.transactions.group(:category).count.sort_by { |k, v| -v }.each do |category, count|
      puts "  - #{category}: #{count} transactions"
    end

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

      puts "\nTransaction Categories:"
      test_user.transactions.group(:category).count.sort_by { |k, v| -v }.each do |category, count|
        puts "  - #{category}: #{count} transactions"
      end

      puts "\nMonthly Transaction Count:"
      test_user.transactions.group_by { |t| t.transaction_date.strftime("%Y-%m") }.each do |month, transactions|
        puts "  - #{month}: #{transactions.count} transactions"
      end
    else
      puts "No test user found. Run 'rails test_data:create' first."
    end
  end

  desc "Generate additional realistic data for charts"
  task enhance: :environment do
    puts "Enhancing test data for better chart visualization..."

    test_user = User.find_by(email_address: "test@example.com")
    unless test_user
      puts "No test user found. Run 'rails test_data:create' first."
      return
    end

    # 添加一些特殊的交易模式来创建更有趣的图表
    special_transactions = [
      # 大额投资
      { date: 6.months.ago, category: "股票投资", amount: -15000, account: "华泰证券股票账户" },
      { date: 4.months.ago, category: "基金投资", amount: -8000, account: "支付宝余额宝" },
      { date: 2.months.ago, category: "加密货币投资", amount: -5000, account: "币安加密货币" },

      # 大额收入
      { date: 3.months.ago, category: "年终奖", amount: 25000, account: "招商银行储蓄卡" },
      { date: 1.month.ago, category: "项目奖金", amount: 12000, account: "招商银行储蓄卡" },

      # 大额支出
      { date: 8.months.ago, category: "旅游", amount: -8000, account: "招商银行信用卡" },
      { date: 5.months.ago, category: "电子产品", amount: -3500, account: "建设银行信用卡" },
      { date: 3.months.ago, category: "家具", amount: -6000, account: "招商银行信用卡" }
    ]

    special_transactions.each do |txn_data|
      account = test_user.accounts.find_by(name: txn_data[:account])
      next unless account

      # 避免重复创建
      next if test_user.transactions.exists?(
        account: account,
        transaction_date: txn_data[:date],
        category: txn_data[:category]
      )

      test_user.transactions.create!(
        account: account,
        description: "#{txn_data[:category]} - #{txn_data[:date].strftime('%Y-%m-%d')}",
        amount: txn_data[:amount],
        category: txn_data[:category],
        transaction_date: txn_data[:date]
      )
    end

    # 重新生成快照以确保数据一致性
    test_user.snapshots.destroy_all

    # 按时间顺序重新生成快照
    snapshot_dates = []
    52.times do |i|
      date = (51 - i).weeks.ago.to_date
      snapshot_dates << date
    end

    snapshot_dates.sort.each do |date|
      Snapshot.create_or_update_for_date(test_user, date)
    end

    puts "Enhanced test data with special transactions"
    puts "Total transactions: #{test_user.transactions.count}"
    puts "Total snapshots: #{test_user.snapshots.count}"
  end

  desc "Test snapshot growth pattern"
  task test_growth: :environment do
    test_user = User.find_by(email_address: "test@example.com")
    unless test_user
      puts "No test user found. Run 'rails test_data:create' first."
      return
    end

    puts "=== Snapshot Growth Analysis ==="
    snapshots = test_user.snapshots.order(:snapshot_date)

    if snapshots.count > 1
      puts "First snapshot: #{snapshots.first.snapshot_date} - #{snapshots.first.total_asset}"
      puts "Last snapshot: #{snapshots.last.snapshot_date} - #{snapshots.last.total_asset}"
      puts "Growth: #{snapshots.last.total_asset - snapshots.first.total_asset}"

      puts "\nRecent snapshots (last 10):"
      snapshots.last(10).each do |snapshot|
        puts "  #{snapshot.snapshot_date}: #{snapshot.total_asset}"
      end
    else
      puts "Not enough snapshots to analyze growth"
    end
  end
end
