class DokeosUser < ActiveRecord::Base

  fields do
    dokeos_user_name :string, :length => 256
    first_name :string, :length => 128
    last_name :string, :length => 128
    code  :string, :length => 32
    dokeos_id :integer
    email  :string, :length => 65
    timestamps
  end

  def to_label
    dokeos_user_name
  end

  has_many :training_course_results

end
