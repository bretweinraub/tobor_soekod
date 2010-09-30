class CreateTrainingCourses < ActiveRecord::Migration
  def self.up
    create_table :training_courses do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :training_courses
  end
end
