class ChangeColumnFormatInGarages < ActiveRecord::Migration
  def up
    change_column :garages, :lat, :string
    change_column :garages, :lng, :string
  end

  def down
    change_column :garages, :lat, :float
    change_column :garages, :lng, :float
  end
end
