class CreateSystemConfigs < ActiveRecord::Migration
  def change
    create_table :system_configs do |t|

      t.string :name, null: false
      t.string :value, null: false
      t.timestamps null: false
    end
  end
end
