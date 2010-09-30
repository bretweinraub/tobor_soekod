class HoboMigration6 < ActiveRecord::Migration
  def self.up
    add_column :training_sessions, :training_session_name, :string, :limit => 256
  end

  def self.down
    remove_column :training_sessions, :training_session_name
  end
end
