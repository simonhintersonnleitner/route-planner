class AddMaxPetrolToPriceData < ActiveRecord::Migration
  def change
    add_column :price_data, :max_petrol, :float
  end
end
