class HoboMigration1 < ActiveRecord::Migration
  def self.up
    drop_table :dokeos_users
    drop_table :training_session_users
    drop_table :training_users
    drop_table :training_courses
    drop_table :training_course_results
    drop_table :all_results_vs

    add_column :training_sessions, :dokeos_id, :integer

    add_index :training_sessions, [:dokeos_id], :unique => true, :name => 'training_session_uk1'
  end

  def self.down
    remove_column :training_sessions, :dokeos_id

    create_table "dokeos_users", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "training_session_users", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "training_users", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "training_courses", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "training_course_results", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "all_results_vs", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    remove_index :training_sessions, :name => :training_session_uk1 rescue ActiveRecord::StatementInvalid
  end
end
