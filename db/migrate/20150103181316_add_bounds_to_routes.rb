class AddBoundsToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :bounds, :text
  end
end
