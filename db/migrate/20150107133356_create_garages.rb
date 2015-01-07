class CreateGarages < ActiveRecord::Migration
  def change
    create_table :garages do |t|
      t.float :lat
      t.float :lng
      t.text :description
      t.float :price_die
      t.float :price_sup

      t.timestamps
    end
  end
end
