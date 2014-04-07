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

ActiveRecord::Schema.define(version: 20140404191352) do

  create_table "employees", force: true do |t|
    t.string   "userid"
    t.string   "password_digest"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "employees", ["remember_token"], name: "index_employees_on_remember_token"
  add_index "employees", ["userid"], name: "index_employees_on_userid", unique: true

  create_table "events", force: true do |t|
    t.string   "event_type"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["employee_id", "created_at"], name: "index_events_on_employee_id_and_created_at"

end
