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

ActiveRecord::Schema.define(version: 2016_12_28_100456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "agent_contracts", id: :serial, force: :cascade do |t|
    t.integer "agent_id"
    t.integer "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_agent_contracts_on_agent_id"
    t.index ["contract_id"], name: "index_agent_contracts_on_contract_id"
  end

  create_table "agents", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "town", limit: 30
    t.string "address", limit: 255
    t.text "contacts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shortname", limit: 30
    t.text "note"
  end

  create_table "bapps", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "purpose"
    t.string "apptype"
    t.string "version_app"
    t.string "directory_app"
    t.string "distribution_app"
    t.string "executable_file"
    t.string "licence"
    t.string "source_app"
    t.text "note"
  end

  create_table "bproce_bapps", id: :serial, force: :cascade do |t|
    t.integer "bproce_id"
    t.integer "bapp_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "apurpose"
  end

  create_table "bproce_contracts", id: :serial, force: :cascade do |t|
    t.integer "bproce_id"
    t.integer "contract_id"
    t.string "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bproce_id"], name: "index_bproce_contracts_on_bproce_id"
    t.index ["contract_id"], name: "index_bproce_contracts_on_contract_id"
  end

  create_table "bproce_documents", id: :serial, force: :cascade do |t|
    t.integer "bproce_id"
    t.integer "document_id"
    t.string "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bproce_id"], name: "index_bproce_documents_on_bproce_id"
    t.index ["document_id"], name: "index_bproce_documents_on_document_id"
  end

  create_table "bproce_iresources", id: :serial, force: :cascade do |t|
    t.integer "bproce_id"
    t.integer "iresource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "rpurpose"
    t.index ["bproce_id"], name: "index_bproce_iresources_on_bproce_id"
    t.index ["iresource_id"], name: "index_bproce_iresources_on_iresource_id"
  end

  create_table "bproce_workplaces", id: :serial, force: :cascade do |t|
    t.integer "bproce_id"
    t.integer "workplace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bproces", id: :serial, force: :cascade do |t|
    t.string "shortname"
    t.string "name"
    t.string "fullname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "goal"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.integer "user_id"
    t.text "description"
    t.date "checked_at"
    t.index ["depth"], name: "index_bproces_on_depth"
    t.index ["lft"], name: "index_bproces_on_lft"
    t.index ["parent_id"], name: "index_bproces_on_parent_id"
    t.index ["rgt"], name: "index_bproces_on_rgt"
  end

  create_table "business_roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "bproce_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "features"
    t.index ["bproce_id"], name: "index_business_roles_on_bproce_id"
  end

  create_table "contract_scans", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "scan_file_name"
    t.string "scan_content_type"
    t.integer "scan_file_size"
    t.datetime "scan_updated_at"
    t.index ["contract_id"], name: "index_contract_scans_on_contract_id"
  end

  create_table "contracts", id: :serial, force: :cascade do |t|
    t.integer "owner_id"
    t.string "number", limit: 20
    t.string "name", limit: 255
    t.string "status", limit: 30
    t.date "date_begin"
    t.date "date_end"
    t.text "description"
    t.text "text"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "condition"
    t.text "check"
    t.integer "agent_id"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.string "contract_type"
    t.string "contract_place"
    t.integer "payer_id"
    t.index ["agent_id"], name: "index_contracts_on_agent_id"
    t.index ["owner_id"], name: "index_contracts_on_owner_id"
    t.index ["parent_id"], name: "index_contracts_on_parent_id"
    t.index ["payer_id"], name: "index_contracts_on_payer_id"
    t.index ["rgt"], name: "index_contracts_on_rgt"
  end

  create_table "directives", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "number"
    t.date "approval"
    t.text "name"
    t.string "note"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "annotation"
    t.string "status"
    t.text "action"
  end

  create_table "document_directives", id: :serial, force: :cascade do |t|
    t.integer "document_id"
    t.integer "directive_id"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "directive_id"], name: "index_document_directives_on_document_id_and_directive_id", unique: true
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "filename"
    t.text "description"
    t.string "status"
    t.integer "status_id"
    t.integer "owner_id"
    t.string "part"
    t.date "approved"
    t.string "place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bproce_id"
    t.string "eplace"
    t.string "approveorgan"
    t.integer "dlevel"
    t.integer "responsible"
    t.string "note"
    t.string "document_file_file_name"
    t.string "document_file_content_type"
    t.integer "document_file_file_size"
    t.datetime "document_file_updated_at"
    t.string "document_file_fingerprint"
    t.text "text"
    t.index ["id"], name: "index_documents_on_id", unique: true
  end

  create_table "iresources", id: :serial, force: :cascade do |t|
    t.string "level"
    t.string "label"
    t.string "location"
    t.string "alocation"
    t.integer "volume"
    t.text "note"
    t.string "access_read"
    t.string "access_write"
    t.string "access_other"
    t.string "risk_category"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_iresources_on_label", unique: true
    t.index ["user_id"], name: "index_iresources_on_user_id"
  end

  create_table "letter_appendixes", id: :serial, force: :cascade do |t|
    t.integer "letter_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "appendix_file_name"
    t.string "appendix_content_type"
    t.integer "appendix_file_size"
    t.datetime "appendix_updated_at"
    t.index ["letter_id"], name: "index_letter_appendixes_on_letter_id"
  end

  create_table "letters", id: :serial, force: :cascade do |t|
    t.string "regnumber", limit: 10
    t.date "regdate"
    t.string "number", limit: 30
    t.date "date"
    t.string "subject", limit: 200
    t.string "source", limit: 20
    t.text "sender"
    t.text "body"
    t.date "duedate"
    t.integer "status"
    t.text "result"
    t.integer "letter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.integer "in_out", default: 1, null: false
    t.date "completion_date"
    t.index ["author_id"], name: "index_letters_on_author_id"
    t.index ["date"], name: "index_letters_on_date"
    t.index ["letter_id"], name: "index_letters_on_letter_id"
    t.index ["number"], name: "index_letters_on_number"
    t.index ["regnumber"], name: "index_letters_on_regnumber"
    t.index ["status"], name: "index_letters_on_status"
  end

  create_table "metric_values", id: :serial, force: :cascade do |t|
    t.integer "metric_id"
    t.datetime "dtime"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_id"], name: "index_metric_values_on_metric_id"
  end

  create_table "metrics", id: :serial, force: :cascade do |t|
    t.integer "bproce_id"
    t.string "name", limit: 200
    t.string "shortname", limit: 30
    t.text "description"
    t.text "note"
    t.integer "depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mtype", limit: 10
    t.text "msql"
    t.string "mhash", limit: 32
    t.index ["bproce_id"], name: "index_metrics_on_bproce_id"
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.integer "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "requirements", id: :serial, force: :cascade do |t|
    t.string "label"
    t.date "date"
    t.date "duedate"
    t.string "source"
    t.text "body"
    t.integer "status"
    t.text "result"
    t.integer "letter_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_requirements_on_author_id"
    t.index ["date"], name: "index_requirements_on_date"
    t.index ["label"], name: "index_requirements_on_label"
    t.index ["letter_id"], name: "index_requirements_on_letter_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "bproce_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.date "duedate"
    t.text "result"
    t.integer "status"
    t.date "completion_date"
    t.integer "letter_id"
    t.integer "requirement_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_tasks_on_author_id"
    t.index ["duedate"], name: "index_tasks_on_duedate"
    t.index ["letter_id"], name: "index_tasks_on_letter_id"
    t.index ["name"], name: "index_tasks_on_name", unique: true
    t.index ["requirement_id"], name: "index_tasks_on_requirement_id"
  end

  create_table "terms", id: :serial, force: :cascade do |t|
    t.string "shortname"
    t.string "name"
    t.text "description"
    t.text "note"
    t.text "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_terms_on_name", unique: true
    t.index ["shortname"], name: "index_terms_on_shortname", unique: true
  end

  create_table "user_business_roles", id: :serial, force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.string "note"
    t.integer "user_id", null: false
    t.integer "business_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_role_id"], name: "index_user_business_roles_on_business_role_id"
    t.index ["user_id"], name: "index_user_business_roles_on_user_id"
  end

  create_table "user_documents", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "document_id"
    t.integer "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_user_documents_on_document_id"
    t.index ["user_id"], name: "index_user_documents_on_user_id"
  end

  create_table "user_letters", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "letter_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["letter_id"], name: "index_user_letters_on_letter_id"
    t.index ["user_id"], name: "index_user_letters_on_user_id"
  end

  create_table "user_requirements", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "requirement_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["requirement_id"], name: "index_user_requirements_on_requirement_id"
    t.index ["user_id"], name: "index_user_requirements_on_user_id"
  end

  create_table "user_roles", id: :serial, force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.string "note"
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "user_tasks", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
    t.integer "status"
    t.date "review_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_user_tasks_on_task_id"
    t.index ["user_id"], name: "index_user_tasks_on_user_id"
  end

  create_table "user_workplaces", id: :serial, force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.string "note"
    t.integer "user_id"
    t.integer "workplace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_workplaces_on_user_id"
    t.index ["workplace_id"], name: "index_user_workplaces_on_workplace_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "username"
    t.string "displayname"
    t.string "department"
    t.string "position"
    t.string "office"
    t.string "phone"
    t.string "remember_token"
    t.boolean "active", default: true
    t.string "middlename"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workplaces", id: :serial, force: :cascade do |t|
    t.string "designation"
    t.string "name"
    t.string "description"
    t.boolean "typical"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "switch"
    t.integer "port"
  end

  add_foreign_key "tasks", "letters"
  add_foreign_key "tasks", "requirements"
  add_foreign_key "user_tasks", "tasks"
  add_foreign_key "user_tasks", "users"
end
