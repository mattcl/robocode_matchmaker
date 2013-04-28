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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130428063519) do

  create_table "battle_configurations", :force => true do |t|
    t.string   "description"
    t.integer  "num_bots"
    t.integer  "width"
    t.integer  "height"
    t.integer  "num_rounds"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "bots", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "jar_file_file_name"
    t.string   "jar_file_content_type"
    t.integer  "jar_file_file_size"
    t.datetime "jar_file_updated_at"
    t.string   "base_name",             :default => "", :null => false
    t.integer  "entries_count",         :default => 0
  end

  create_table "bots_categories", :id => false, :force => true do |t|
    t.integer "bot_id"
    t.integer "category_id"
  end

  add_index "bots_categories", ["bot_id", "category_id"], :name => "index_bots_categories_on_bot_id_and_category_id"
  add_index "bots_categories", ["category_id", "bot_id"], :name => "index_bots_categories_on_category_id_and_bot_id"

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "battle_size",             :default => 0, :null => false
    t.integer "battle_configuration_id"
  end

  create_table "entries", :force => true do |t|
    t.integer  "bot_id"
    t.integer  "match_id"
    t.integer  "rank"
    t.integer  "total_score"
    t.integer  "survival"
    t.integer  "survival_bonus"
    t.integer  "bullet_damage"
    t.integer  "bullet_bonus"
    t.integer  "ram_damage"
    t.integer  "ram_bonus"
    t.integer  "firsts"
    t.integer  "seconds"
    t.integer  "thirds"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "matches", :force => true do |t|
    t.integer  "category_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username",               :default => "", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
