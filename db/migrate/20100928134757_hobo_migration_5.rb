class HoboMigration5 < ActiveRecord::Migration
  def self.up
    add_column :trainings, :training_name, :string, :length => 256

    add_column :training_courses, :training_course_name, :string, :length => 256

    add_index :training_courses, [:training_course_name, :training_id], :unique => true, :name => 'training_course_uk1'
  end

  def self.down
    remove_column :trainings, :training_name

    remove_column :training_courses, :training_course_name

    remove_index :training_courses, :name => :training_session_uk1 rescue ActiveRecord::StatementInvalid
  end
end
