class AddColumnToBalance < ActiveRecord::Migration
  def up
    add_column :balances, :date_month, :string
  end
end
