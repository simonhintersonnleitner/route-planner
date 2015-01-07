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

ActiveRecord::Schema.define(version: 20150107175837) do

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
    t.integer  "cityFk"
    t.float    "minDiesel",      limit: 24
    t.float    "minPetrol",      limit: 24
    t.float    "averageDiesel",  limit: 24
    t.float    "averagePertrol", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "maxPetrol",      limit: 24
    t.float    "maxDiesel",      limit: 24
  end

  create_table "reference_cities", force: true do |t|
    t.string   "region"
    t.string   "state"
    t.string   "name"
    t.float    "latNorthEast", limit: 24
    t.float    "lngNorthEast", limit: 24
    t.float    "latSouthWest", limit: 24
    t.float    "lngSouthWest", limit: 24
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

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
