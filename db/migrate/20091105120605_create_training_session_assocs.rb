class CreateTrainingSessionAssocs < ActiveRecord::Migration
  def self.up
    create_table :training_session_assocs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :training_session_assocs
  end
end
