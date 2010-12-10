class TrainingCourseResult < ActiveRecord::Base

  fields do
    score :float
    progress :float
    attempts :float
    total_time :float
    last_login :date
    timestamps
  end

  belongs_to :training_course
  belongs_to :dokeos_user
  belongs_to :training_session
end

