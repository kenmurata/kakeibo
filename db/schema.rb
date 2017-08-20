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

ActiveRecord::Schema.define(version: 20170817073534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "asset_type",             null: false
    t.integer  "value",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "balance_classes", force: :cascade do |t|
    t.boolean  "balance_type",  default: false, null: false
    t.string   "balance_class",                 null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "balances", force: :cascade do |t|
    t.string   "column",                        null: false
    t.integer  "value",         default: 0,     null: false
    t.boolean  "balance_type",  default: false, null: false
    t.text     "subject"
    t.time     "date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "balance_date"
    t.string   "date_month"
    t.string   "balance_class"
  end

  create_table "system_configs", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
