class AddColumnClassToBalance < ActiveRecord::Migration
  def up
    add_column :balances, :balance_class, :string
  end
end
