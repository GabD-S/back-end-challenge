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

ActiveRecord::Schema[7.2].define(version: 2025_10_21_120738) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aulas", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "start_time", null: false
    t.integer "duration", null: false
    t.string "teacher_name", null: false
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_aulas_on_category_id"
    t.index ["start_time"], name: "index_aulas_on_start_time"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "aula_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aula_id"], name: "index_enrollments_on_aula_id"
    t.index ["user_id", "aula_id"], name: "index_enrollments_on_user_id_and_aula_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.date "birth_date"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "aulas", "categories"
  add_foreign_key "enrollments", "aulas"
  add_foreign_key "enrollments", "users"
end
