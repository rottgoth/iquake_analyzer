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

ActiveRecord::Schema.define(version: 2018_05_12_192040) do

  create_table "earthquakes", force: :cascade do |t|
    t.string "usgs_id", null: false
    t.string "place"
    t.string "city"
    t.datetime "happened_at"
    t.integer "timezone"
    t.decimal "magnitude", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["happened_at"], name: "index_earthquakes_on_happened_at"
    t.index ["usgs_id"], name: "index_earthquakes_on_usgs_id"
  end

end
