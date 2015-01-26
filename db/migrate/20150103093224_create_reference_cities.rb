class CreateReferenceCities < ActiveRecord::Migration
  def change
    create_table :reference_cities do |t|
      t.string :region
      t.string :state
      t.string :name
      t.float :lat_north_east
      t.float :lng_north_east
      t.float :lat_south_west
      t.float :lng_south_west

      t.timestamps
    end
  end
end
