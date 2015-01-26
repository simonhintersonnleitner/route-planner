class CreatePriceData < ActiveRecord::Migration
  def change
    create_table :price_data do |t|
      t.integer :cityFk
      t.float :min_diesel
      t.float :min_petrol
      t.float :average_diesel
      t.float :average_pertrol

      t.timestamps
    end
  end
end
