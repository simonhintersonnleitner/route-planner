class RenameUsersRoutesTable < ActiveRecord::Migration
  def self.up
    rename_table :users_routes, :routes_users
  end

 def self.down
    rename_table :routes_users, :users_routes
 end
end
