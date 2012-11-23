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

ActiveRecord::Schema.define(:version => 20121122095343) do

  create_table "bapps", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "purpose"
    t.string   "apptype"
  end

  create_table "bproce_bapps", :force => true do |t|
    t.integer  "bproce_id"
    t.integer  "bapp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "apurpose"
  end

  create_table "bproce_workplaces", :force => true do |t|
    t.integer  "bproce_id"
    t.integer  "workplace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bproces", :force => true do |t|
    t.string   "shortname"
    t.string   "name"
    t.string   "fullname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "goal"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "user_id"
  end

  create_table "business_roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "bproce_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "features"
  end

  add_index "business_roles", ["bproce_id"], :name => "index_business_roles_on_bproce_id"

  create_table "categories", :force => true do |t|
    t.string   "cat_table"
    t.string   "cat_type"
    t.string   "cat_name"
    t.integer  "sortorder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directives", :force => true do |t|
    t.string   "title"
    t.string   "number"
    t.date     "approval"
    t.string   "name"
    t.string   "note"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "annotation"
  end

  create_table "document_directives", :force => true do |t|
    t.integer  "document_id"
    t.integer  "directive_id"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_directives", ["document_id", "directive_id"], :name => "index_document_directives_on_document_id_and_directive_id", :unique => true

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.string   "filename"
    t.string   "description"
    t.string   "status"
    t.string   "part"
    t.date     "approved"
    t.string   "place"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.integer  "bproce_id"
    t.string   "eplace"
    t.string   "approveorgan"
    t.integer  "dlevel"
    t.integer  "responsible"
    t.integer  "owner_id"
  end

  add_index "documents", ["id"], :name => "index_documents_on_id", :unique => true

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "staffs", :force => true do |t|
    t.string   "fullname"
    t.string   "position"
    t.boolean  "supervisor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_business_roles", :force => true do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note"
    t.integer  "user_id",          :null => false
    t.integer  "business_role_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_business_roles", ["business_role_id"], :name => "index_user_business_roles_on_business_role_id"
  add_index "user_business_roles", ["user_id"], :name => "index_user_business_roles_on_user_id"

  create_table "user_roles", :force => true do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note"
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "user_workplaces", :force => true do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note"
    t.integer  "user_id"
    t.integer  "workplace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_workplaces", ["user_id"], :name => "index_user_workplaces_on_user_id"
  add_index "user_workplaces", ["workplace_id"], :name => "index_user_workplaces_on_workplace_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.string   "displayname"
    t.string   "department"
    t.string   "position"
    t.string   "office"
    t.string   "phone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workplaces", :force => true do |t|
    t.string   "designation"
    t.string   "name"
    t.string   "description"
    t.boolean  "typical"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
