class CreateTrainingCourseResults < ActiveRecord::Migration
  def self.up
    create_table :training_course_results do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :training_course_results
  end
end
