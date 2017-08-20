class ChangeColumnToBalance < ActiveRecord::Migration
  def up
    add_column :balances, :balance_date, :date
  end
  
  def down
    del_column :balances, :date, :time
  end
end
