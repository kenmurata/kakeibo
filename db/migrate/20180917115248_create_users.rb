class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :line_id, null: false
      t.string :name, null: false
      t.string :mailaddress
      t.integer :group_id, null: false
      t.timestamps null: false
    end
  end
end
