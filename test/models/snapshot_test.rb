require "test_helper"

class SnapshotTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @account = accounts(:one)
  end

  test "should calculate total asset correctly" do
    # 创建一个新的测试用户来避免fixture干扰
    test_user = User.create!(
      email_address: "test@example.com",
      password_digest: BCrypt::Password.create("password"),
      first_name: "Test",
      last_name: "User"
    )

    # 创建资产账户和负债账户
    asset_account = test_user.accounts.create!(
      name: "银行账户",
      account_type: "asset",
      initial_balance: 10000
    )

    liability_account = test_user.accounts.create!(
      name: "信用卡",
      account_type: "liability",
      initial_balance: 2000
    )

    # 添加一些交易
    asset_account.transactions.create!(
      description: "工资",
      amount: 5000,
      category: "收入",
      transaction_date: Date.current,
      user: test_user
    )

    liability_account.transactions.create!(
      description: "购物",
      amount: 500,
      category: "支出",
      transaction_date: Date.current,
      user: test_user
    )

    # 计算总资产
    total_asset = Snapshot.calculate_total_asset(test_user)
    expected_total = (10000 + 5000) - (2000 + 500) # 15000 - 2500 = 12500
    assert_equal expected_total, total_asset
  end

  test "should create or update snapshot for date" do
    snapshot = Snapshot.create_or_update_for_date(@user, Date.current)

    assert snapshot.persisted?
    assert_equal Date.current, snapshot.snapshot_date
    assert_equal @user, snapshot.user
    assert snapshot.total_asset.present?
  end

  test "should validate uniqueness of snapshot date per user" do
    # 使用一个没有现有快照的用户来避免fixture干扰
    test_user = User.create!(
      email_address: "uniqueness_test@example.com",
      password_digest: BCrypt::Password.create("password"),
      first_name: "Uniqueness",
      last_name: "Test"
    )

    Snapshot.create!(
      user: test_user,
      snapshot_date: Date.current,
      total_asset: 10000
    )

    duplicate_snapshot = Snapshot.new(
      user: test_user,
      snapshot_date: Date.current,
      total_asset: 15000
    )

    assert_not duplicate_snapshot.valid?
    assert_includes duplicate_snapshot.errors[:snapshot_date], "has already been taken"
  end

  test "should validate presence of required fields" do
    snapshot = Snapshot.new
    assert_not snapshot.valid?

    assert_includes snapshot.errors[:user], "must exist"
    assert_includes snapshot.errors[:snapshot_date], "can't be blank"
    assert_includes snapshot.errors[:total_asset], "can't be blank"
  end
end
