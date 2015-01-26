class CreatePriceData < ActiveRecord::Migration
  def change
    create_table :price_data do |t|
      t.integer :city_fk
      t.float :min_diesel
      t.float :min_petrol
      t.float :average_diesel
      t.float :average_petrol
      t.timestamps
    end
  end
end
