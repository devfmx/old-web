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

ActiveRecord::Schema.define(version: 20140602225507) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.integer "user_id"
  end

  add_index "admin_users", ["user_id"], name: "admin_users_user_id_fk", using: :btree

  create_table "applications", force: true do |t|
    t.integer  "user_id"
    t.integer  "batch_id"
    t.text     "application_answers"
    t.boolean  "accepted",            default: false
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applications", ["batch_id"], name: "applications_batch_id_fk", using: :btree
  add_index "applications", ["user_id"], name: "applications_user_id_fk", using: :btree

  create_table "batches", force: true do |t|
    t.string   "name",                                  null: false
    t.integer  "batch_size",                            null: false
    t.boolean  "active",                default: false, null: false
    t.date     "starts_at",                             null: false
    t.date     "ends_at",                               null: false
    t.text     "application_questions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "url"
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.string   "secret"
    t.string   "handle"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "identities_user_id_fk", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "admin_users", "users", name: "admin_users_user_id_fk"

  add_foreign_key "applications", "batches", name: "applications_batch_id_fk"
  add_foreign_key "applications", "users", name: "applications_user_id_fk"

  add_foreign_key "identities", "users", name: "identities_user_id_fk"

end
