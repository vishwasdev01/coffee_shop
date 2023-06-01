class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.float :total
      t.boolean :completed

      t.timestamps
    end
  end
end
