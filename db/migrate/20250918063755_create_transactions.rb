class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :description
      t.decimal :amount
      t.string :category
      t.date :transaction_date

      t.timestamps
    end
  end
end
