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

ActiveRecord::Schema.define(version: 20150819053414) do

  create_table "answers", force: :cascade do |t|
    t.integer "user_profile_id",    limit: 4,   null: false
    t.integer "to_user_profile_id", limit: 4,   null: false
    t.boolean "correct",                        null: false
    t.string  "answer",             limit: 255
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "profile_images", force: :cascade do |t|
    t.integer  "user_profile_id", limit: 4,   null: false
    t.string   "image",           limit: 255, null: false
    t.string   "situation",       limit: 255, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "answer_name", limit: 255
    t.string   "gender",      limit: 255
    t.integer  "joined_year", limit: 4
    t.text     "detail",      limit: 65535
    t.integer  "project_id",  limit: 4
    t.integer  "group_id",    limit: 4
  end

  add_index "user_profiles", ["group_id"], name: "index_user_profiles_on_group_id", using: :btree
  add_index "user_profiles", ["project_id"], name: "index_user_profiles_on_project_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "token",                  limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, length: {"email"=>191}, using: :btree

end
