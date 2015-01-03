class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :origin
      t.string :destination
      t.text :path
      t.float :distance
      t.integer :hits
      t.timestamps
    end
  end
end
