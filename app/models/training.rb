class Training < ActiveRecord::Base

  # hobo_model # Don't put anything above this

  fields do
    training_name :string, :length => 256
    training_code :string, :length => 64
    lang :string, :length => 32
    dokeos_id :integer
    trainer :string, :length => 32
    timestamps
  end

end
