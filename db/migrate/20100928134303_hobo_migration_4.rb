class HoboMigration4 < ActiveRecord::Migration
  def self.up
    create_table :training_course_results do |t|
      t.float    :score
      t.float    :progress
      t.float    :attempts
      t.float    :total_time
      t.date     :last_login
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :training_course_id
      t.integer  :dokeos_user_id
    end
    add_index :training_course_results, [:training_course_id]
    add_index :training_course_results, [:dokeos_user_id]

    create_table :training_users do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :dokeos_user_id
      t.integer  :training_id
    end
    add_index :training_users, [:dokeos_user_id]
    add_index :training_users, [:training_id]
    add_index :training_users, [:dokeos_user_id, :training_id], :unique => true, :name => 'training_user_uk1'

    create_table :training_courses do |t|
      t.string   :course_type, :length => 16
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :training_id
    end
    add_index :training_courses, [:training_id]

    create_table :training_session_users do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :dokeos_user_id
      t.integer  :training_session_id
    end
    add_index :training_session_users, [:dokeos_user_id]
    add_index :training_session_users, [:training_session_id]
    add_index :training_session_users, [:dokeos_user_id, :training_session_id], :unique => true, :name => 'training_session_user_uk1'

    create_table :dokeos_users do |t|
      t.string   :first_name, :length => 128
      t.string   :last_name, :length => 128
      t.string   :code, :length => 32
      t.integer  :dokeos_id
      t.string   :email, :length => 65
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :training_course_results
    drop_table :training_users
    drop_table :training_courses
    drop_table :training_session_users
    drop_table :dokeos_users
  end
end
