class CreateReferenceCities < ActiveRecord::Migration
  def change
    create_table :reference_cities do |t|
      t.string :region
      t.string :state
      t.string :name
      t.float :latNorthEast
      t.float :lngNorthEast
      t.float :latSouthWest
      t.float :lngSouthWest

      t.timestamps
    end
  end
end
