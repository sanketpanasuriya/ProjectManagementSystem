# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_05_084839) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "costs", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "total_cost"
    t.index ["project_id"], name: "index_costs_on_project_id"
  end

  create_table "hours", force: :cascade do |t|
    t.datetime "starting"
    t.datetime "ending"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_hours_on_task_id"
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "project_id"
    t.string "title"
    t.text "description"
    t.string "issue_type"
    t.string "status"
    t.bigint "creator_id"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["creator_id"], name: "index_issues_on_creator_id"
    t.index ["deleted_at"], name: "index_issues_on_deleted_at"
    t.index ["employee_id"], name: "index_issues_on_employee_id"
    t.index ["project_id"], name: "index_issues_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "status", null: false
    t.date "endingdate", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", null: false
    t.bigint "client_id", null: false
    t.text "reviews"
    t.integer "rating"
    t.datetime "deleted_at"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["creator_id"], name: "index_projects_on_creator_id"
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "role_type"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "sprints", force: :cascade do |t|
    t.bigint "project_id"
    t.string "title"
    t.date "expected_end_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sprints_on_deleted_at"
    t.index ["project_id"], name: "index_sprints_on_project_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.bigint "sprint_id"
    t.bigint "user_id"
    t.date "due_date"
    t.string "status"
    t.date "status_update_date"
    t.text "description"
    t.string "task_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_tasks_on_deleted_at"
    t.index ["sprint_id"], name: "index_tasks_on_sprint_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delete_user", default: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "costs", "projects"
  add_foreign_key "hours", "tasks"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users", column: "creator_id"
  add_foreign_key "issues", "users", column: "employee_id"
  add_foreign_key "projects", "users", column: "client_id"
  add_foreign_key "projects", "users", column: "creator_id"
  add_foreign_key "sprints", "projects"
  add_foreign_key "tasks", "sprints"
  add_foreign_key "tasks", "users"
end
