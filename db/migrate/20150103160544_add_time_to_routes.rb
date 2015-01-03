class AddTimeToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :time, :float
  end
end
