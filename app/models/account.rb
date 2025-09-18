class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :account_type, presence: true, inclusion: { in: %w[asset liability] }
  validates :initial_balance, presence: true, numericality: true

  enum :account_type, { asset: "asset", liability: "liability" }
end
