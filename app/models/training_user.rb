class TrainingUser < ActiveRecord::Base

  fields do
    timestamps
  end

  belongs_to :dokeos_user
  belongs_to :training

  index [:dokeos_user_id,:training_id], {:unique => true, :name => 'training_user_uk1'}
end
