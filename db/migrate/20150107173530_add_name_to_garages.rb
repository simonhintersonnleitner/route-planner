class AddNameToGarages < ActiveRecord::Migration
  def change
    add_column :garages, :name, :string
  end
end
