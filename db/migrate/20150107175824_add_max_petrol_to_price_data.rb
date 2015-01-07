class AddMaxPetrolToPriceData < ActiveRecord::Migration
  def change
    add_column :price_data, :maxPetrol, :float
  end
end
