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

ActiveRecord::Schema.define(version: 20140511163612) do

  create_table "auths", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "third_party",     default: false
  end

  add_index "auths", ["email"], name: "index_auths_on_email"
  add_index "auths", ["uid", "provider"], name: "index_auths_on_uid_and_provider", unique: true
  add_index "auths", ["uid"], name: "index_auths_on_uid"
  add_index "auths", ["user_id", "provider"], name: "index_auths_on_user_id_and_provider", unique: true

  create_table "gifts", force: true do |t|
    t.integer  "gifter_id"
    t.integer  "giftee_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gifts", ["giftee_id", "gifter_id", "group_id"], name: "index_gifts_on_giftee_id_and_gifter_id_and_group_id", unique: true
  add_index "gifts", ["giftee_id"], name: "index_gifts_on_giftee_id"
  add_index "gifts", ["gifter_id"], name: "index_gifts_on_gifter_id"

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.date     "select_date"
    t.date     "open_date"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "invites", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",          default: false
    t.boolean  "guest",          default: false
    t.string   "remember_token"
  end

end
