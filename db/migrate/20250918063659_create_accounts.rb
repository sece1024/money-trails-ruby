class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :type
      t.decimal :initial_balance

      t.timestamps
    end
  end
end
