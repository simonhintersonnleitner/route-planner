class AddMaxDieselToPriceData < ActiveRecord::Migration
  def change
    add_column :price_data, :maxDiesel, :float
  end
end
