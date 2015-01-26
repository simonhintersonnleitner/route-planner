class AddLatLocationToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :lat_location, :float
  end
end
