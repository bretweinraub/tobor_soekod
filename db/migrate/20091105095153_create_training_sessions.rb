class CreateTrainingSessions < ActiveRecord::Migration
  def self.up
    create_table :training_sessions do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :training_sessions
  end
end
