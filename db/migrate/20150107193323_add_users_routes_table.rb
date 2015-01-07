class AddUsersRoutesTable < ActiveRecord::Migration
  def change
    create_table :users_routes, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :route, index: true
    end
  end
end
