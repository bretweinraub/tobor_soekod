class TrainingCourse < ActiveRecord::Base

  fields do
    training_course_name :string, :length => 256
    course_type :string, :length => 16
    timestamps
  end

  has_many :training_course_results
  belongs_to :training

  def to_label
    training_course_name
  end
  
  index [:training_course_name,:training_id], {:unique => true, :name => 'training_course_uk1'}

end
