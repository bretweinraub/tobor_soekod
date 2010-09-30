class TrainingSessionUser < ActiveRecord::Base

  fields do
    timestamps
  end

  belongs_to :dokeos_user
  belongs_to :training_session
  
  index [:dokeos_user_id,:training_session_id], {:unique => true, :name => 'training_session_user_uk1'}

end
