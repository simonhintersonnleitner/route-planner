class CreatePriceData < ActiveRecord::Migration
  def change
    create_table :price_data do |t|
      t.integer :cityFk
      t.float :minDiesel
      t.float :minPetrol
      t.float :averageDiesel
      t.float :averagePertrol

      t.timestamps
    end
  end
end
