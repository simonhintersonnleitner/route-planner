class AddLngLocationToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :lngLocation, :float
  end
end
