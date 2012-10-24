class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :order_date, :null => false
      t.string :status, :null => false, :default => 'DRAFT'

      t.timestamps
    end
  end
end
