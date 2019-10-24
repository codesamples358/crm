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

ActiveRecord::Schema.define(version: 2019_02_05_111422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calls", force: :cascade do |t|
    t.string "uuid"
    t.string "caller"
    t.string "caller_name"
    t.string "from_domain"
    t.string "to"
    t.string "to_domain"
    t.string "gateway"
    t.datetime "time"
    t.integer "duration"
    t.integer "billsec"
    t.string "hangup_cause"
    t.string "call_type"
    t.string "status"
    t.bigint "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caller"], name: "index_calls_on_caller"
    t.index ["player_id"], name: "index_calls_on_player_id"
    t.index ["to"], name: "index_calls_on_to"
    t.index ["uuid"], name: "index_calls_on_uuid", unique: true
  end

  create_table "corp_pack_services", force: :cascade do |t|
    t.bigint "corp_pack_id"
    t.bigint "service_id"
    t.decimal "cost"
    t.decimal "price"
    t.boolean "ordered"
    t.boolean "confirmed"
    t.text "comment"
    t.date "remind_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["corp_pack_id"], name: "index_corp_pack_services_on_corp_pack_id"
    t.index ["service_id"], name: "index_corp_pack_services_on_service_id"
  end

  create_table "corp_packs", force: :cascade do |t|
    t.integer "manager_id"
    t.string "mode"
    t.string "status"
    t.string "prepayment_type"
    t.decimal "prepayment_sum"
    t.date "prepayment_deadline"
    t.string "payment_type"
    t.date "date"
    t.time "time"
    t.datetime "datetime"
    t.bigint "player_id"
    t.text "comment"
    t.string "game_center"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "call_id"
    t.datetime "prepayed_at"
    t.string "info_source"
    t.index ["call_id"], name: "index_corp_packs_on_call_id"
    t.index ["player_id"], name: "index_corp_packs_on_player_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "phone2"
    t.string "email"
    t.boolean "receive_email"
    t.boolean "receive_sms"
    t.boolean "blacklist"
    t.boolean "male"
    t.string "info_source"
    t.string "city"
    t.text "comment"
    t.string "child_name"
    t.date "child_birth_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["phone"], name: "index_players_on_phone", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "corp_pack_services", "corp_packs"
  add_foreign_key "corp_pack_services", "services"
end
