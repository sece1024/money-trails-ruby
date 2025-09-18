class CreateSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :snapshots do |t|
      t.references :user, null: false, foreign_key: true
      t.date :snapshot_date
      t.decimal :total_asset

      t.timestamps
    end
  end
end
