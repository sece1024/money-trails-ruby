class Snapshot < ApplicationRecord
  belongs_to :user

  validates :snapshot_date, presence: true
  validates :total_asset, presence: true, numericality: true
  validates :snapshot_date, uniqueness: { scope: :user_id }

  scope :recent, -> { order(snapshot_date: :desc) }
  scope :for_date, ->(date) { where(snapshot_date: date) }

  # 计算用户的总资产
  def self.calculate_total_asset(user)
    asset_accounts = user.accounts.asset
    liability_accounts = user.accounts.liability

    total_assets = asset_accounts.sum do |account|
      account.initial_balance + account.transactions.sum(:amount)
    end

    total_liabilities = liability_accounts.sum do |account|
      account.initial_balance + account.transactions.sum(:amount)
    end

    total_assets - total_liabilities
  end

  # 创建或更新指定日期的快照
  def self.create_or_update_for_date(user, date = Date.current)
    total_asset = calculate_total_asset(user)

    snapshot = find_or_initialize_by(user: user, snapshot_date: date)
    snapshot.total_asset = total_asset
    snapshot.save!
    snapshot
  end

  # 为所有用户创建今日快照
  def self.create_daily_snapshots
    User.find_each do |user|
      create_or_update_for_date(user, Date.current)
    end
  end

  # 为所有用户创建每周快照（每周一）
  def self.create_weekly_snapshots
    return unless Date.current.monday?

    User.find_each do |user|
      create_or_update_for_date(user, Date.current)
    end
  end

  # 为所有用户创建每月快照（每月1号）
  def self.create_monthly_snapshots
    return unless Date.current.day == 1

    User.find_each do |user|
      create_or_update_for_date(user, Date.current)
    end
  end
end
