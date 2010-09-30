class CreateTrainingSessionUsers < ActiveRecord::Migration
  def self.up
    create_table :training_session_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :training_session_users
  end
end
