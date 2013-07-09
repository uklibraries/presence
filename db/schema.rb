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

ActiveRecord::Schema.define(:version => 20130709121922) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "user_type"
  end

  create_table "formats", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "package_subject_vocabularies", :force => true do |t|
    t.integer  "package_id"
    t.integer  "subject_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "package_subject_vocabularies", ["package_id"], :name => "index_package_subject_vocabularies_on_package_id"
  add_index "package_subject_vocabularies", ["subject_id"], :name => "index_package_subject_vocabularies_on_subject_id"

  create_table "packages", :force => true do |t|
    t.integer  "user_id"
    t.string   "who"
    t.string   "what"
    t.integer  "when"
    t.string   "where"
    t.string   "contributor"
    t.string   "coverage"
    t.string   "creator"
    t.string   "description"
    t.string   "identifier"
    t.string   "language"
    t.string   "publisher"
    t.string   "relation"
    t.string   "rights"
    t.string   "source"
    t.string   "title"
    t.string   "type"
    t.string   "access"
    t.string   "retention"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "format_id"
  end

  add_index "packages", ["format_id"], :name => "index_packages_on_format_id"
  add_index "packages", ["user_id"], :name => "index_packages_on_user_id"

  create_table "packages_subjects", :force => true do |t|
    t.integer "package_id"
    t.integer "subject_id"
  end

  create_table "searches", :force => true do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "user_type"
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "subjects", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subjects", ["user_id"], :name => "index_subjects_on_user_id"

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
    t.string   "username"
    t.integer  "roles_mask",             :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
