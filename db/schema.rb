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

ActiveRecord::Schema.define(version: 20150724162803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "issues", force: true do |t|
    t.integer  "retro_id"
    t.string   "issue_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "votes_count", default: 0
  end

  create_table "outstandings", force: true do |t|
    t.string   "description"
    t.integer  "retro_id"
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.boolean  "complete"
  end

  create_table "outstandings_users", id: false, force: true do |t|
    t.integer "outstanding_id"
    t.integer "user_id"
  end

  add_index "outstandings_users", ["outstanding_id", "user_id"], name: "index_outstandings_users_on_outstanding_id_and_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retros", force: true do |t|
    t.datetime "meeting_date"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "status",          default: 0
    t.integer  "discussed_index"
    t.integer  "discussed_type"
    t.integer  "good_icon"
    t.integer  "meh_icon"
    t.integer  "bad_icon"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  create_table "votes", force: true do |t|
    t.integer  "issue_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "retro_id"
  end

  add_index "votes", ["issue_id"], name: "index_votes_on_issue_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree

end
