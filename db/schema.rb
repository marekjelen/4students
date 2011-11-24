# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 44) do

  create_table "club_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image"
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "active"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "club_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "active"
    t.integer  "category_id"
    t.boolean  "public"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked"
  end

  create_table "feed_entries", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "link"
    t.string   "guid"
    t.datetime "published",   :limit => 255
    t.string   "author"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_readers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.boolean  "read",       :default => false
    t.boolean  "delete",     :default => false
    t.boolean  "bookmark",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_subscribtions", :force => true do |t|
    t.integer  "feed_id"
    t.integer  "user_id"
    t.string   "url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.text     "description"
    t.text     "url"
    t.string   "lang"
    t.datetime "lastUpdate"
    t.datetime "lastFetch"
    t.integer  "ttl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "active"
    t.integer  "type_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["owner_id", "owner_type", "active", "type_id"], :name => "index_groups_on_owner_id_and_owner_type_and_active_and_type_id"
  add_index "groups", ["owner_id", "owner_type"], :name => "index_groups_on_owner_id_and_owner_type"

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.binary   "options"
    t.boolean  "show",        :default => true
  end

  create_table "history_publics", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_publics", ["user_id", "type", "active"], :name => "index_history_publics_on_user_id_and_type_and_active"
  add_index "history_publics", ["user_id", "type"], :name => "index_history_publics_on_user_id_and_type", :unique => true

  create_table "history_types", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_types", ["name"], :name => "index_history_types_on_name", :unique => true

  create_table "mail_folders", :force => true do |t|
    t.string   "title"
    t.string   "type"
    t.integer  "parent_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.string   "body"
    t.integer  "folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "invitation"
  end

  add_index "memberships", ["group_id", "user_id", "active"], :name => "index_memberships_on_group_id_and_user_id_and_active"

  create_table "oauth_access_tokens", :force => true do |t|
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",        :default => false
    t.datetime "expire"
    t.string   "request_token"
    t.string   "verifier"
    t.integer  "user_id"
    t.integer  "consumer_id"
  end

  create_table "oauth_consumers", :force => true do |t|
    t.string   "key"
    t.string   "secret"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_request_tokens", :force => true do |t|
    t.string   "token"
    t.string   "secret"
    t.binary   "request"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "group_id"
    t.integer  "right_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.boolean  "active"
    t.boolean  "granted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["group_id", "right_id", "object_id", "object_type"], :name => "complex_index", :unique => true

  create_table "profile_items", :force => true do |t|
    t.integer  "section_id"
    t.string   "title"
    t.string   "type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_items", ["section_id"], :name => "index_profile_items_on_section_id"

  create_table "profile_sections", :force => true do |t|
    t.integer  "profile_id"
    t.string   "title"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_sections", ["profile_id"], :name => "index_profile_sections_on_profile_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "resources", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "active"
    t.text     "searchable"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.string   "keyword"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rights", ["keyword"], :name => "index_rights_on_keyword", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "storage_files", :force => true do |t|
    t.string   "name"
    t.string   "file"
    t.string   "type"
    t.integer  "folder_id"
    t.integer  "size"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "storage_folders", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.boolean  "active",     :default => false
    t.string   "code"
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.integer  "version"
    t.string   "display"
    t.string   "avatar"
    t.string   "status",     :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["username", "password"], :name => "index_users_on_username_and_password"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
