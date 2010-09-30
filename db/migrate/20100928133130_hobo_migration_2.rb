class HoboMigration2 < ActiveRecord::Migration
  def self.up
    add_column :training_session_assocs, :training_id, :integer
    add_column :training_session_assocs, :training_session_id, :integer

    add_column :trainings, :training_code, :string, :length => 64
    add_column :trainings, :lang, :string, :length => 32
    add_column :trainings, :dokeos_id, :integer
    add_column :trainings, :trainer, :string, :length => 32

    add_index :training_session_assocs, [:training_id]
    add_index :training_session_assocs, [:training_session_id]
  end

  def self.down
    remove_column :training_session_assocs, :training_id
    remove_column :training_session_assocs, :training_session_id

    remove_column :trainings, :training_code
    remove_column :trainings, :lang
    remove_column :trainings, :dokeos_id
    remove_column :trainings, :trainer

    remove_index :training_session_assocs, :name => :index_training_session_assocs_on_training_id rescue ActiveRecord::StatementInvalid
    remove_index :training_session_assocs, :name => :index_training_session_assocs_on_training_session_id rescue ActiveRecord::StatementInvalid
  end
end
