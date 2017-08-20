class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      
      t.string :column, null: false
      t.integer :value, null: false, default: 0
      t.boolean :balance_type, null: false, default: false
      t.text :subject
      t.time :date

      t.timestamps null: false
    end
  end
end
