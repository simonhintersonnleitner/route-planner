class AddLatLocationToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :latLocation, :float
  end
end
