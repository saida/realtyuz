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

ActiveRecord::Schema.define(:version => 20110419085307) do

  create_table "accounts", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.string   "password_reset_code",       :limit => 40
    t.integer  "enabled",                                  :default => 1
    t.datetime "deleted_at"
    t.integer  "user_id"
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true

  create_table "agencies", :force => true do |t|
    t.string   "agency_name"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.string   "contact_fname"
    t.string   "contact_lname"
    t.integer  "region_id"
    t.integer  "city_id"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "art_categories", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.integer  "account_id"
    t.integer  "acategory_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachings_count",  :default => 0
    t.datetime "created_at"
    t.datetime "data_updated_at"
    t.string   "description"
  end

  create_table "attachings", :force => true do |t|
    t.integer  "attachable_id"
    t.integer  "asset_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "attachings", ["asset_id"], :name => "index_attachings_on_asset_id"
  add_index "attachings", ["attachable_id"], :name => "index_attachings_on_attachable_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.integer  "region_id"
    t.string   "city_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["region_id"], :name => "fki_city_region_id"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "account_id",                     :default => 0,  :null => false
  end

  add_index "comments", ["account_id"], :name => "fk_comments_account"

  create_table "districts", :force => true do |t|
    t.integer  "city_id"
    t.string   "district_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "districts", ["city_id"], :name => "fki_district_city_id"

  create_table "documents", :force => true do |t|
    t.integer  "account_id"
    t.string   "dtype"
    t.string   "title"
    t.text     "description"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materials", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metro_properties", :force => true do |t|
    t.integer  "metro_id"
    t.integer  "property_id"
    t.integer  "transport_id"
    t.integer  "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metros", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.integer  "city_id"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_listings", :force => true do |t|
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_listings_properties", :force => true do |t|
    t.integer  "property_id"
    t.integer  "my_listings_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "account_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "region_id"
    t.integer  "city_id"
    t.integer  "ptype_id"
    t.decimal  "minprice"
    t.decimal  "maxprice"
    t.integer  "pcategory_id"
    t.integer  "minarea"
    t.integer  "maxarea"
    t.integer  "material_id"
    t.integer  "floor"
    t.integer  "floors"
    t.integer  "room_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", :force => true do |t|
    t.integer  "seller_id"
    t.integer  "city_id"
    t.integer  "district_id"
    t.integer  "ptype_id"
    t.decimal  "area"
    t.integer  "price"
    t.integer  "floor"
    t.integer  "floors"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.integer  "room_id"
    t.integer  "category_id"
    t.integer  "material_id"
    t.float    "longitude"
    t.float    "latitude"
    t.text     "details"
    t.text     "address"
  end

  add_index "properties", ["city_id"], :name => "fki_propety_city_id"
  add_index "properties", ["district_id"], :name => "fki_property_district_id"
  add_index "properties", ["room_id"], :name => "fki_property_room_id"
  add_index "properties", ["seller_id"], :name => "fki_property_user_id"

  create_table "ptypes", :force => true do |t|
    t.string   "ptype_name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.string   "region_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_properties", :force => true do |t|
    t.integer  "school_id"
    t.integer  "property_id"
    t.integer  "transport_id"
    t.integer  "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.integer  "city_id"
    t.integer  "district_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stype"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "transports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "utype_id"
    t.integer  "broker_id"
    t.string   "fname"
    t.string   "lname"
    t.string   "mobphone"
    t.string   "workphone"
    t.string   "email"
    t.string   "website"
    t.string   "cotitle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "isCorporate"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "agency_id"
  end

  create_table "utypes", :force => true do |t|
    t.string   "usertype"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "vote",                        :default => 0
    t.datetime "created_at",                                  :null => false
    t.string   "voteable_type", :limit => 15, :default => "", :null => false
    t.integer  "voteable_id",                 :default => 0,  :null => false
    t.integer  "account_id",                  :default => 0,  :null => false
  end

  add_index "votes", ["account_id"], :name => "fk_votes_account"

end
