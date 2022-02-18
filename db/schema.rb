# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_18_023251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tour_id", null: false
    t.index ["tour_id"], name: "index_images_on_tour_id"
  end

  create_table "tours", force: :cascade do |t|
    t.string "agent_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "agent_phone"
    t.string "agent_email"
    t.string "agent_url"
    t.string "brokerage_name"
    t.string "brokerage_address"
    t.string "listing_address"
    t.boolean "show_price"
    t.integer "price"
    t.string "mls"
    t.string "tax"
    t.integer "built"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.string "size"
    t.boolean "lot_or_maint"
    t.float "lot_maint"
    t.text "description"
    t.text "style"
    t.integer "property_type"
    t.integer "num_of_pics"
    t.integer "print_job_id"
    t.string "brokerage_brand"
    t.string "broker_logo"
    t.integer "cotala_tour_id"
  end

  add_foreign_key "images", "tours"
end
