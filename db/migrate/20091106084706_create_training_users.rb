class CreateTrainingUsers < ActiveRecord::Migration
  def self.up
    create_table :training_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :training_users
  end
end
