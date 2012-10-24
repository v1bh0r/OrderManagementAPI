class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :null => false
      t.float :price, :null => false

      t.timestamps
    end

    add_index :products, :name, :unique => true
  end
end
