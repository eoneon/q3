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

ActiveRecord::Schema.define(version: 20180826235618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "artists", force: :cascade do |t|
    t.integer "artist_id"
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["properties"], name: "index_artists_on_properties", using: :gist
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "fields"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dimensions", force: :cascade do |t|
    t.string "name"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "field_groups", force: :cascade do |t|
    t.bigint "field_id"
    t.bigint "fieldable_id"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fieldable_type"
    t.index ["field_id"], name: "index_field_groups_on_field_id"
    t.index ["fieldable_id"], name: "index_field_groups_on_fieldable_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name"
    t.string "field_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.string "categorizable_type"
    t.bigint "categorizable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort"
    t.index ["categorizable_type", "categorizable_id"], name: "index_sub_categories_on_categorizable_type_and_categorizable_id"
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  add_foreign_key "field_groups", "categories", column: "fieldable_id"
  add_foreign_key "field_groups", "fields"
end
