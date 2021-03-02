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

ActiveRecord::Schema.define(version: 2021_03_02_145723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "ubs_id"
    t.integer "patient_id"
    t.datetime "check_in"
    t.datetime "check_out"
    t.boolean "second_dose", default: false
    t.string "suspend_reason"
    t.string "vaccine_name"
    t.integer "status", default: 0
    t.index ["ubs_id"], name: "index_appointments_on_ubs_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.bigint "parent_group_id"
    t.index ["parent_group_id"], name: "index_groups_on_parent_group_id"
  end

  create_table "groups_patients", id: false, force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "group_id", null: false
    t.index ["group_id", "patient_id"], name: "index_groups_patients_on_group_id_and_patient_id"
    t.index ["patient_id", "group_id"], name: "index_groups_patients_on_patient_id_and_group_id"
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
    t.bigint "last_appointment_id"
    t.string "specific_comorbidity", default: ""
    t.index ["cpf"], name: "index_patients_on_cpf", unique: true
    t.index ["last_appointment_id"], name: "index_patients_on_last_appointment_id"
    t.index ["main_ubs_id"], name: "index_patients_on_main_ubs_id"
  end

  create_table "time_slot_generation_configs", primary_key: "ubs_id", id: :serial, force: :cascade do |t|
    t.text "content"
  end

  create_table "time_slot_generator_executions", primary_key: "date", id: :date, force: :cascade do |t|
    t.text "status"
    t.text "details"
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
    t.boolean "open_saturday", default: false
    t.string "saturday_shift_start", default: "9:00"
    t.string "saturday_break_start", default: "12:30"
    t.string "saturday_break_end", default: "13:30"
    t.string "saturday_shift_end", default: "17:00"
    t.integer "appointments_per_time_slot", default: 1
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

  add_foreign_key "appointments", "ubs"
  add_foreign_key "patients", "appointments", column: "last_appointment_id"
  add_foreign_key "patients", "ubs", column: "main_ubs_id"
  add_foreign_key "ubs", "users"
end
