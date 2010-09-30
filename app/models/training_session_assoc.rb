class TrainingSessionAssoc < ActiveRecord::Base

  # hobo_model # Don't put anything above this

  fields do
    timestamps
  end

  belongs_to :training
  belongs_to :training_session

  index [:training_id,:training_session_id], {:unique => true, :name => "training_session_assoc_uk1"}

end
