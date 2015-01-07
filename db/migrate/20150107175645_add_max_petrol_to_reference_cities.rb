class AddMaxPetrolToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :maxPetrol, :float
  end
end
