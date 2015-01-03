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

ActiveRecord::Schema.define(version: 20150103093224) do

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
  end

  create_table "routes", force: true do |t|
    t.string   "origin"
    t.string   "destination"
    t.text     "path"
    t.float    "distance",    limit: 24
    t.integer  "hits"
    t.datetime "created_at"
    t.datetime "updated_at"
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
