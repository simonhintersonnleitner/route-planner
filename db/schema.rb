# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150107194250) do

  create_table "garages", force: true do |t|
    t.string   "lat"
    t.string   "lng"
    t.text     "description"
    t.float    "price_die",   limit: 24
    t.float    "price_sup",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.text     "opening"
    t.string   "name"
  end

  create_table "price_data", force: true do |t|
    t.integer  "city_fk"
    t.float    "min_diesel",     limit: 24
    t.float    "min_super",      limit: 24
    t.float    "max_diesel",     limit: 24
    t.float    "max_super",      limit: 24
    t.float    "average_diesel", limit: 24
    t.float    "average_super",  limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reference_cities", force: true do |t|
    t.string   "region"
    t.string   "state"
    t.string   "name"
    t.float    "lat_north_east", limit: 24
    t.float    "lng_north_east", limit: 24
    t.float    "lat_south_west", limit: 24
    t.float    "lng_south_west", limit: 24
    t.float    "lat_location",   limit: 24
    t.float    "lng_location",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lngLocation",  limit: 24
    t.float    "latLocation",  limit: 24
    t.float    "maxDiesel",    limit: 24
    t.float    "maxPetrol",    limit: 24
  end

  create_table "routes", force: true do |t|
    t.string   "origin"
    t.string   "destination"
    t.text     "path"
    t.float    "distance",    limit: 24
    t.integer  "hits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "time",        limit: 24
    t.text     "bounds"
  end

  create_table "routes_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "route_id"
  end

  add_index "routes_users", ["route_id"], name: "index_routes_users_on_route_id", using: :btree
  add_index "routes_users", ["user_id"], name: "index_routes_users_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
