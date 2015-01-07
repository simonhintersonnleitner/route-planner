class AddColumnsToGarages < ActiveRecord::Migration
  def change
    add_column :garages, :address, :text
    add_column :garages, :opening, :text
  end
end
