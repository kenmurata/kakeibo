class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      
      t.string :name, null: false
      t.string :asset_type, null: false
      t.integer :value, null: false, default: 0
      
      t.timestamps null: false
    end
  end
end
