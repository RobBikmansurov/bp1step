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

ActiveRecord::Schema.define(version: 20131029154413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bapps", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "purpose"
    t.string   "apptype"
    t.string   "version_app"
    t.string   "directory_app"
    t.string   "distribution_app"
    t.string   "executable_file"
    t.string   "licence"
    t.string   "source_app"
    t.text     "note"
  end

  create_table "bproce_bapps", force: true do |t|
    t.integer  "bproce_id"
    t.integer  "bapp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "apurpose"
  end

  create_table "bproce_documents", force: true do |t|
    t.integer  "bproce_id"
    t.integer  "document_id"
    t.string   "purpose"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "bproce_documents", ["bproce_id"], name: "index_bproce_documents_on_bproce_id", using: :btree
  add_index "bproce_documents", ["document_id"], name: "index_bproce_documents_on_document_id", using: :btree

  create_table "bproce_iresources", force: true do |t|
    t.integer  "bproce_id"
    t.integer  "iresource_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "rpurpose"
  end

  add_index "bproce_iresources", ["bproce_id"], name: "index_bproce_iresources_on_bproce_id", using: :btree
  add_index "bproce_iresources", ["iresource_id"], name: "index_bproce_iresources_on_iresource_id", using: :btree

  create_table "bproce_workplaces", force: true do |t|
    t.integer  "bproce_id"
    t.integer  "workplace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bproces", force: true do |t|
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
    t.text     "description"
  end

  create_table "business_roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "bproce_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "features"
  end

  add_index "business_roles", ["bproce_id"], name: "index_business_roles_on_bproce_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "cat_table"
    t.string   "cat_type"
    t.string   "cat_name"
    t.integer  "sortorder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directives", force: true do |t|
    t.string   "title"
    t.string   "number"
    t.date     "approval"
    t.string   "name"
    t.string   "note"
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "annotation"
  end

  create_table "document_directives", force: true do |t|
    t.integer  "document_id"
    t.integer  "directive_id"
    t.string   "note"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "document_directives", ["document_id", "directive_id"], name: "index_document_directives_on_document_id_and_directive_id", unique: true, using: :btree

  create_table "documents", force: true do |t|
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
    t.integer  "owner_id"
    t.integer  "responsible"
    t.string   "note"
    t.string   "document_file_file_name"
    t.string   "document_file_content_type"
    t.integer  "document_file_file_size"
    t.datetime "document_file_updated_at"
    t.string   "document_file_fingerprint"
  end

  add_index "documents", ["id"], name: "index_documents_on_id", unique: true, using: :btree

  create_table "iresources", force: true do |t|
    t.string   "level"
    t.string   "label"
    t.string   "location"
    t.string   "alocation"
    t.integer  "volume"
    t.text     "note"
    t.string   "access_read"
    t.string   "access_write"
    t.string   "access_other"
    t.string   "risk_category"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "iresources", ["label"], name: "index_iresources_on_label", unique: true, using: :btree
  add_index "iresources", ["user_id"], name: "index_iresources_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "note"
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "terms", force: true do |t|
    t.string   "shortname"
    t.string   "name"
    t.text     "description"
    t.text     "note"
    t.text     "source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "terms", ["name"], name: "index_terms_on_name", unique: true, using: :btree
  add_index "terms", ["shortname"], name: "index_terms_on_shortname", unique: true, using: :btree

  create_table "user_business_roles", force: true do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note"
    t.integer  "user_id",          null: false
    t.integer  "business_role_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "user_business_roles", ["business_role_id"], name: "index_user_business_roles_on_business_role_id", using: :btree
  add_index "user_business_roles", ["user_id"], name: "index_user_business_roles_on_user_id", using: :btree

  create_table "user_roles", force: true do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note"
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "user_workplaces", force: true do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note"
    t.integer  "user_id"
    t.integer  "workplace_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_workplaces", ["user_id"], name: "index_user_workplaces_on_user_id", using: :btree
  add_index "user_workplaces", ["workplace_id"], name: "index_user_workplaces_on_workplace_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                              default: "",   null: false
    t.string   "encrypted_password",     limit: 128, default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
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
    t.string   "remember_token"
    t.boolean  "active",                             default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workplaces", force: true do |t|
    t.string   "designation"
    t.string   "name"
    t.string   "description"
    t.boolean  "typical"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "switch"
    t.integer  "port"
  end

end
