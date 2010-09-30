class TrainingSession < ActiveRecord::Base

#  hobo_model # Don't put anything above this

  fields do
    training_session_name :string, :limit => 256
    dokeos_id :integer
    
    timestamps
  end

  has_many :training_session_assocs, :foreign_key => "training_session_id"
  has_many :training_session_users, :foreign_key => "training_session_id"
  has_many :trainings, :through => :training_session_assocs

  index [:dokeos_id], {:unique => true, :name => 'training_session_uk1'}


end
