class AddMaxPetrolToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :max_petrol, :float
  end
end
