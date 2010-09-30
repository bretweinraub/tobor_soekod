class HoboMigration3 < ActiveRecord::Migration
  def self.up
    add_index :training_session_assocs, [:training_id, :training_session_id], :unique => true, :name => 'training_session_assoc_uk1'
  end

  def self.down
    remove_index :training_session_assocs, :name => :training_session_assoc_uk1 rescue ActiveRecord::StatementInvalid
  end
end
