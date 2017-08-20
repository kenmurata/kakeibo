class CreateBalanceClasses < ActiveRecord::Migration
  def change
    create_table :balance_classes do |t|
      
      t.boolean :balance_type, null: false, default: false
      t.string :balance_class, null: false

      t.timestamps null: false
    end
  end
end
