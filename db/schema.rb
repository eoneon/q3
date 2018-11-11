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

ActiveRecord::Schema.define(version: 20181109003054) do

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

  create_table "certificates", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dimensions", force: :cascade do |t|
    t.string "name"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "element_groups", force: :cascade do |t|
    t.bigint "element_kind_id"
    t.string "elementable_type"
    t.bigint "elementable_id"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_kind_id"], name: "index_element_groups_on_element_kind_id"
    t.index ["elementable_type", "elementable_id"], name: "index_element_groups_on_elementable_type_and_elementable_id"
  end

  create_table "element_kinds", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "elements", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.integer "sort"
    t.bigint "element_kind_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_kind_id"], name: "index_elements_on_element_kind_id"
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

  create_table "invoices", force: :cascade do |t|
    t.string "name"
    t.integer "invoice_number"
    t.bigint "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_invoices_on_supplier_id"
  end

  create_table "item_types", force: :cascade do |t|
    t.integer "sort"
    t.hstore "properties"
    t.bigint "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "category_id"
    t.index ["artist_id"], name: "index_item_types_on_artist_id"
    t.index ["category_id"], name: "index_item_types_on_category_id"
    t.index ["properties"], name: "index_item_types_on_properties", using: :gist
  end

  create_table "items", force: :cascade do |t|
    t.integer "sku"
    t.integer "retail"
    t.bigint "artist_id"
    t.hstore "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.bigint "invoice_id"
    t.string "title"
    t.index ["artist_id"], name: "index_items_on_artist_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["invoice_id"], name: "index_items_on_invoice_id"
    t.index ["properties"], name: "index_items_on_properties", using: :gist
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

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "value_groups", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "value_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_value_groups_on_item_id"
    t.index ["value_id"], name: "index_value_groups_on_value_id"
  end

  create_table "values", force: :cascade do |t|
    t.string "name"
    t.hstore "properties"
    t.bigint "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_values_on_field_id"
    t.index ["properties"], name: "index_values_on_properties", using: :gist
  end

  add_foreign_key "elements", "element_kinds"
  add_foreign_key "field_groups", "categories", column: "fieldable_id"
  add_foreign_key "field_groups", "fields"
  add_foreign_key "invoices", "suppliers"
  add_foreign_key "item_types", "artists"
  add_foreign_key "items", "artists"
  add_foreign_key "items", "categories"
  add_foreign_key "value_groups", "\"values\"", column: "value_id"
  add_foreign_key "value_groups", "items"
  add_foreign_key "values", "fields"
end
