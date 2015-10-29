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

ActiveRecord::Schema.define(version: 20151028105818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id"
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "agent_contracts", force: :cascade do |t|
    t.integer  "agent_id"
    t.integer  "contract_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agent_contracts", ["agent_id"], name: "index_agent_contracts_on_agent_id", using: :btree
  add_index "agent_contracts", ["contract_id"], name: "index_agent_contracts_on_contract_id", using: :btree

  create_table "agents", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "town",       limit: 30
    t.string   "address",    limit: 255
    t.text     "contacts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname",  limit: 255
  end

  create_table "bapps", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "description",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "purpose"
    t.string   "apptype",          limit: 255
    t.string   "version_app",      limit: 255
    t.string   "directory_app",    limit: 255
    t.string   "distribution_app", limit: 255
    t.string   "executable_file",  limit: 255
    t.string   "licence",          limit: 255
    t.string   "source_app",       limit: 255
    t.text     "note"
  end

  create_table "bproce_bapps", force: :cascade do |t|
    t.integer  "bproce_id"
    t.integer  "bapp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "apurpose"
  end

  create_table "bproce_contracts", force: :cascade do |t|
    t.integer  "bproce_id"
    t.integer  "contract_id"
    t.string   "purpose",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bproce_contracts", ["bproce_id"], name: "index_bproce_contracts_on_bproce_id", using: :btree
  add_index "bproce_contracts", ["contract_id"], name: "index_bproce_contracts_on_contract_id", using: :btree

  create_table "bproce_documents", force: :cascade do |t|
    t.integer  "bproce_id"
    t.integer  "document_id"
    t.string   "purpose",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bproce_documents", ["bproce_id"], name: "index_bproce_documents_on_bproce_id", using: :btree
  add_index "bproce_documents", ["document_id"], name: "index_bproce_documents_on_document_id", using: :btree

  create_table "bproce_iresources", force: :cascade do |t|
    t.integer  "bproce_id"
    t.integer  "iresource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "rpurpose"
  end

  add_index "bproce_iresources", ["bproce_id"], name: "index_bproce_iresources_on_bproce_id", using: :btree
  add_index "bproce_iresources", ["iresource_id"], name: "index_bproce_iresources_on_iresource_id", using: :btree

  create_table "bproce_workplaces", force: :cascade do |t|
    t.integer  "bproce_id"
    t.integer  "workplace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bproces", force: :cascade do |t|
    t.string   "shortname",   limit: 255
    t.string   "name",        limit: 255
    t.string   "fullname",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "goal"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "user_id"
    t.text     "description"
    t.date     "checked_at"
  end

  add_index "bproces", ["depth"], name: "index_bproces_on_depth", using: :btree
  add_index "bproces", ["lft"], name: "index_bproces_on_lft", using: :btree
  add_index "bproces", ["parent_id"], name: "index_bproces_on_parent_id", using: :btree
  add_index "bproces", ["rgt"], name: "index_bproces_on_rgt", using: :btree

  create_table "business_roles", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.integer  "bproce_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "features"
  end

  add_index "business_roles", ["bproce_id"], name: "index_business_roles_on_bproce_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "cat_table",  limit: 255
    t.string   "cat_type",   limit: 255
    t.string   "cat_name",   limit: 255
    t.integer  "sortorder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contract_scans", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "contract_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scan_file_name",    limit: 255
    t.string   "scan_content_type", limit: 255
    t.integer  "scan_file_size"
    t.datetime "scan_updated_at"
  end

  add_index "contract_scans", ["contract_id"], name: "index_contract_scans_on_contract_id", using: :btree

  create_table "contracts", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "number",         limit: 20
    t.string   "name",           limit: 255
    t.string   "status",         limit: 30
    t.date     "date_begin"
    t.date     "date_end"
    t.text     "description"
    t.text     "text"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "condition"
    t.text     "check"
    t.integer  "agent_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "contract_type",  limit: 255
    t.string   "contract_place", limit: 255
    t.integer  "payer_id"
  end

  add_index "contracts", ["agent_id"], name: "index_contracts_on_agent_id", using: :btree
  add_index "contracts", ["owner_id"], name: "index_contracts_on_owner_id", using: :btree
  add_index "contracts", ["parent_id"], name: "index_contracts_on_parent_id", using: :btree
  add_index "contracts", ["payer_id"], name: "index_contracts_on_payer_id", using: :btree
  add_index "contracts", ["rgt"], name: "index_contracts_on_rgt", using: :btree

  create_table "directives", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "number",     limit: 255
    t.date     "approval"
    t.text     "name"
    t.string   "note",       limit: 255
    t.string   "body",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "annotation"
    t.string   "status",     limit: 255
    t.text     "action"
  end

  create_table "document_directives", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "directive_id"
    t.string   "note",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_directives", ["document_id", "directive_id"], name: "index_document_directives_on_document_id_and_directive_id", unique: true, using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "filename",                   limit: 255
    t.text     "description"
    t.string   "status",                     limit: 255
    t.integer  "status_id"
    t.integer  "owner_id"
    t.string   "part",                       limit: 255
    t.date     "approved"
    t.string   "place",                      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bproce_id"
    t.string   "eplace",                     limit: 255
    t.string   "approveorgan",               limit: 255
    t.integer  "dlevel"
    t.integer  "responsible"
    t.string   "note",                       limit: 255
    t.string   "document_file_file_name",    limit: 255
    t.string   "document_file_content_type", limit: 255
    t.integer  "document_file_file_size"
    t.datetime "document_file_updated_at"
    t.string   "document_file_fingerprint",  limit: 255
  end

  add_index "documents", ["id"], name: "index_documents_on_id", unique: true, using: :btree

  create_table "iresources", force: :cascade do |t|
    t.string   "level",         limit: 255
    t.string   "label",         limit: 255
    t.string   "location",      limit: 255
    t.string   "alocation",     limit: 255
    t.integer  "volume"
    t.text     "note"
    t.string   "access_read",   limit: 255
    t.string   "access_write",  limit: 255
    t.string   "access_other",  limit: 255
    t.string   "risk_category", limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iresources", ["label"], name: "index_iresources_on_label", unique: true, using: :btree
  add_index "iresources", ["user_id"], name: "index_iresources_on_user_id", using: :btree

  create_table "letter_appendixes", force: :cascade do |t|
    t.integer  "letter_id"
    t.string   "name",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "appendix_file_name",    limit: 255
    t.string   "appendix_content_type", limit: 255
    t.integer  "appendix_file_size"
    t.datetime "appendix_updated_at"
  end

  add_index "letter_appendixes", ["letter_id"], name: "index_letter_appendixes_on_letter_id", using: :btree

  create_table "letters", force: :cascade do |t|
    t.string   "regnumber",       limit: 10
    t.date     "regdate"
    t.string   "number",          limit: 30
    t.date     "date"
    t.string   "subject",         limit: 200
    t.string   "source",          limit: 20
    t.text     "sender"
    t.text     "body"
    t.date     "duedate"
    t.integer  "status"
    t.text     "result"
    t.integer  "letter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.integer  "in_out",                      default: 1, null: false
    t.date     "completion_date"
  end

  add_index "letters", ["author_id"], name: "index_letters_on_author_id", using: :btree
  add_index "letters", ["date"], name: "index_letters_on_date", using: :btree
  add_index "letters", ["letter_id"], name: "index_letters_on_letter_id", using: :btree
  add_index "letters", ["number"], name: "index_letters_on_number", using: :btree
  add_index "letters", ["regnumber"], name: "index_letters_on_regnumber", using: :btree
  add_index "letters", ["status"], name: "index_letters_on_status", using: :btree

  create_table "metric_values", force: :cascade do |t|
    t.integer  "metric_id"
    t.datetime "dtime"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metric_values", ["metric_id"], name: "index_metric_values_on_metric_id", using: :btree

  create_table "metrics", force: :cascade do |t|
    t.integer  "bproce_id"
    t.string   "name",        limit: 200
    t.string   "shortname",   limit: 30
    t.text     "description"
    t.text     "note"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metrics", ["bproce_id"], name: "index_metrics_on_bproce_id", using: :btree

  create_table "requirements", force: :cascade do |t|
    t.string   "label",      limit: 255
    t.date     "date"
    t.date     "duedate"
    t.string   "source",     limit: 255
    t.text     "body"
    t.integer  "status"
    t.text     "result"
    t.integer  "letter_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requirements", ["author_id"], name: "index_requirements_on_author_id", using: :btree
  add_index "requirements", ["date"], name: "index_requirements_on_date", using: :btree
  add_index "requirements", ["label"], name: "index_requirements_on_label", using: :btree
  add_index "requirements", ["letter_id"], name: "index_requirements_on_letter_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "bproce_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note",        limit: 255
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description"
    t.date     "duedate"
    t.text     "result"
    t.integer  "status"
    t.date     "completion_date"
    t.integer  "letter_id"
    t.integer  "requirement_id"
    t.integer  "author_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "tasks", ["author_id"], name: "index_tasks_on_author_id", using: :btree
  add_index "tasks", ["duedate"], name: "index_tasks_on_duedate", using: :btree
  add_index "tasks", ["letter_id"], name: "index_tasks_on_letter_id", using: :btree
  add_index "tasks", ["name"], name: "index_tasks_on_name", unique: true, using: :btree
  add_index "tasks", ["requirement_id"], name: "index_tasks_on_requirement_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "shortname",   limit: 255
    t.string   "name",        limit: 255
    t.text     "description"
    t.text     "note"
    t.text     "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "terms", ["name"], name: "index_terms_on_name", unique: true, using: :btree
  add_index "terms", ["shortname"], name: "index_terms_on_shortname", unique: true, using: :btree

  create_table "user_business_roles", force: :cascade do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note",             limit: 255
    t.integer  "user_id",                      null: false
    t.integer  "business_role_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_business_roles", ["business_role_id"], name: "index_user_business_roles_on_business_role_id", using: :btree
  add_index "user_business_roles", ["user_id"], name: "index_user_business_roles_on_user_id", using: :btree

  create_table "user_documents", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "document_id"
    t.integer  "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_documents", ["document_id"], name: "index_user_documents_on_document_id", using: :btree
  add_index "user_documents", ["user_id"], name: "index_user_documents_on_user_id", using: :btree

  create_table "user_letters", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "letter_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_letters", ["letter_id"], name: "index_user_letters_on_letter_id", using: :btree
  add_index "user_letters", ["user_id"], name: "index_user_letters_on_user_id", using: :btree

  create_table "user_requirements", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "requirement_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_requirements", ["requirement_id"], name: "index_user_requirements_on_requirement_id", using: :btree
  add_index "user_requirements", ["user_id"], name: "index_user_requirements_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note",       limit: 255
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "user_tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.integer  "status"
    t.date     "review_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_tasks", ["task_id"], name: "index_user_tasks_on_task_id", using: :btree
  add_index "user_tasks", ["user_id"], name: "index_user_tasks_on_user_id", using: :btree

  create_table "user_workplaces", force: :cascade do |t|
    t.date     "date_from"
    t.date     "date_to"
    t.string   "note",         limit: 255
    t.integer  "user_id"
    t.integer  "workplace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_workplaces", ["user_id"], name: "index_user_workplaces_on_user_id", using: :btree
  add_index "user_workplaces", ["workplace_id"], name: "index_user_workplaces_on_workplace_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.string   "username",               limit: 255
    t.string   "displayname",            limit: 255
    t.string   "department",             limit: 255
    t.string   "position",               limit: 255
    t.string   "office",                 limit: 255
    t.string   "phone",                  limit: 255
    t.string   "remember_token",         limit: 255
    t.boolean  "active",                             default: true
    t.string   "middlename",             limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workplaces", force: :cascade do |t|
    t.string   "designation", limit: 255
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.boolean  "typical"
    t.string   "location",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "switch",      limit: 255
    t.integer  "port"
  end

  add_foreign_key "tasks", "letters"
  add_foreign_key "tasks", "requirements"
  add_foreign_key "user_tasks", "tasks"
  add_foreign_key "user_tasks", "users"
end
