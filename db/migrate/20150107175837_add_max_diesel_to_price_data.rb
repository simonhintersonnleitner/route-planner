class AddMaxDieselToPriceData < ActiveRecord::Migration
  def change
    add_column :price_data, :max_diesel, :float
  end
end
