class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.float :price
      t.float :tax_rate
      t.boolean :discount

      t.timestamps
    end
  end
end
