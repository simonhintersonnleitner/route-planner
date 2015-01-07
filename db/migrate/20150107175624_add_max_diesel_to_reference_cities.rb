class AddMaxDieselToReferenceCities < ActiveRecord::Migration
  def change
    add_column :reference_cities, :maxDiesel, :float
  end
end
