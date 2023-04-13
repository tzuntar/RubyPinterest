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

ActiveRecord::Schema[7.0].define(version: 2023_04_13_064823) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "boards_pins", id: false, force: :cascade do |t|
    t.bigint "board_id", null: false
    t.bigint "pin_id", null: false
    t.index ["board_id", "pin_id"], name: "index_boards_pins_on_board_id_and_pin_id"
    t.index ["pin_id", "board_id"], name: "index_boards_pins_on_pin_id_and_board_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pin_id"], name: "index_bookmarks_on_pin_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "feeds", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "recommendations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feeds_on_user_id"
  end

  create_table "pins", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_pins_on_user_id"
  end

  create_table "pins_tags", id: false, force: :cascade do |t|
    t.bigint "pin_id", null: false
    t.bigint "tag_id", null: false
    t.index ["pin_id", "tag_id"], name: "index_pins_tags_on_pin_id_and_tag_id"
    t.index ["tag_id", "pin_id"], name: "index_pins_tags_on_tag_id_and_pin_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "boards", "users"
  add_foreign_key "boards_pins", "boards"
  add_foreign_key "boards_pins", "pins"
  add_foreign_key "bookmarks", "pins"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "feeds", "users"
  add_foreign_key "pins", "users"
  add_foreign_key "pins_tags", "pins"
  add_foreign_key "pins_tags", "tags"
end
