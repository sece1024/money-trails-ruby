class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :account

  validates :description, presence: true
  validates :amount, presence: true, numericality: true
  validates :category, presence: true
  validates :transaction_date, presence: true
end
