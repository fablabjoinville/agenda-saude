# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_02_042929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.bigint "patient_id", null: false
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "ubs_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["ubs_id"], name: "index_appointments_on_ubs_id"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_neighborhoods_on_name", unique: true
  end

  create_table "neighborhoods_ubs", id: false, force: :cascade do |t|
    t.bigint "ubs_id", null: false
    t.bigint "neighborhood_id", null: false
    t.index ["neighborhood_id", "ubs_id"], name: "index_neighborhoods_ubs_on_neighborhood_id_and_ubs_id"
    t.index ["ubs_id", "neighborhood_id"], name: "index_neighborhoods_ubs_on_ubs_id_and_neighborhood_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "email", default: ""
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", default: "", null: false
    t.string "cpf", default: "", null: false
    t.string "mother_name", default: "", null: false
    t.string "birth_date"
    t.string "phone"
    t.string "other_phone"
    t.string "sus"
    t.string "neighborhood"
    t.string "fake_mothers", default: [], array: true
    t.integer "login_attempts", default: 0
    t.boolean "bedridden", default: false
    t.bigint "main_ubs_id"
    t.boolean "chronic"
    t.integer "target_audience"
    t.string "public_place"
    t.string "place_number"
    t.datetime "last_appointment"
    t.index ["cpf"], name: "index_patients_on_cpf", unique: true
    t.index ["main_ubs_id"], name: "index_patients_on_main_ubs_id"
  end

  create_table "ubs", force: :cascade do |t|
    t.string "name"
    t.string "neighborhood"
    t.bigint "user_id", null: false
    t.string "shift_start"
    t.string "shift_end"
    t.string "break_start"
    t.string "break_end"
    t.integer "slot_interval_minutes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone"
    t.string "address", default: ""
    t.string "cnes"
    t.boolean "active", default: false
    t.boolean "open_saturday"
    t.string "saturday_shift_start"
    t.string "saturday_break_start"
    t.string "saturday_break_end"
    t.string "saturday_shift_end"
    t.index ["cnes"], name: "index_ubs_on_cnes", unique: true
    t.index ["user_id"], name: "index_ubs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", default: "", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appointments", "patients"
  add_foreign_key "appointments", "ubs"
  add_foreign_key "patients", "ubs", column: "main_ubs_id"
  add_foreign_key "ubs", "users"
end
