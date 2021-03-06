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

ActiveRecord::Schema.define(:version => 20131208185212) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "user_type"
  end

  create_table "people", :force => true do |t|
    t.string "username"
    t.string "given_name"
    t.string "family_name"
    t.string "email_address"
    t.string "user_type"
    t.string "department_ou"
    t.string "faculty_code"
  end

  create_table "properties", :force => true do |t|
    t.string  "name"
    t.string  "value"
    t.integer "property_type_id"
  end

  add_index "properties", ["value", "property_type_id"], :name => "index_properties_on_value_and_property_type_id", :unique => true

  create_table "property_types", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  add_index "property_types", ["name"], :name => "index_property_types_on_name"

  create_table "role_types", :force => true do |t|
    t.string "name"
  end

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "role_type_id"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"

  create_table "searches", :force => true do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "user_type"
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username",                               :null => false
    t.string   "email",               :default => "",    :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "guest",               :default => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
