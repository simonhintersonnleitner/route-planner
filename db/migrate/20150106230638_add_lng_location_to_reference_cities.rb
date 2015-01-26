class AddLngLocationToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :lng_location, :float
  end
end
