class AddMaxDieselToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :max_diesel, :float
  end
end
