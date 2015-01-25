class AddOpenToGarages < ActiveRecord::Migration
  def change
    add_column :garages, :open, :text
  end
end
