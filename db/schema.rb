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

ActiveRecord::Schema.define(:version => 20100930121549) do

  create_table "dokeos_users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "code"
    t.integer  "dokeos_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dokeos_user_name"
  end

  create_table "training_course_results", :force => true do |t|
    t.float    "score"
    t.float    "progress"
    t.float    "attempts"
    t.float    "total_time"
    t.date     "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_course_id"
    t.integer  "dokeos_user_id"
  end

  add_index "training_course_results", ["dokeos_user_id"], :name => "index_training_course_results_on_dokeos_user_id"
  add_index "training_course_results", ["training_course_id"], :name => "index_training_course_results_on_training_course_id"

  create_table "training_courses", :force => true do |t|
    t.string   "course_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_id"
    t.string   "training_course_name"
  end

  add_index "training_courses", ["training_course_name", "training_id"], :name => "training_course_uk1", :unique => true
  add_index "training_courses", ["training_id"], :name => "index_training_courses_on_training_id"

  create_table "training_session_assocs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_id"
    t.integer  "training_session_id"
  end

  add_index "training_session_assocs", ["training_id", "training_session_id"], :name => "training_session_assoc_uk1", :unique => true
  add_index "training_session_assocs", ["training_id"], :name => "index_training_session_assocs_on_training_id"
  add_index "training_session_assocs", ["training_session_id"], :name => "index_training_session_assocs_on_training_session_id"

  create_table "training_session_users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dokeos_user_id"
    t.integer  "training_session_id"
  end

  add_index "training_session_users", ["dokeos_user_id", "training_session_id"], :name => "training_session_user_uk1", :unique => true
  add_index "training_session_users", ["dokeos_user_id"], :name => "index_training_session_users_on_dokeos_user_id"
  add_index "training_session_users", ["training_session_id"], :name => "index_training_session_users_on_training_session_id"

  create_table "training_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dokeos_id"
    t.string   "training_session_name", :limit => 256
  end

  add_index "training_sessions", ["dokeos_id"], :name => "training_session_uk1", :unique => true

  create_table "training_users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dokeos_user_id"
    t.integer  "training_id"
  end

  add_index "training_users", ["dokeos_user_id", "training_id"], :name => "training_user_uk1", :unique => true
  add_index "training_users", ["dokeos_user_id"], :name => "index_training_users_on_dokeos_user_id"
  add_index "training_users", ["training_id"], :name => "index_training_users_on_training_id"

  create_table "trainings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "training_code"
    t.string   "lang"
    t.integer  "dokeos_id"
    t.string   "trainer"
    t.string   "training_name"
  end

end
