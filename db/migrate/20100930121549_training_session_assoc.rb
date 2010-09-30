class TrainingSessionAssoc < ActiveRecord::Migration
  def self.up
      execute "ALTER TABLE training_session_assocs ADD CONSTRAINT training_session_assocs_fk_trainings_training_id FOREIGN KEY (training_id) REFERENCES trainings(id)"
      execute "ALTER TABLE training_session_assocs ADD CONSTRAINT training_session_assocs_fk_training_sessions_training_session_id FOREIGN KEY (training_session_id) REFERENCES training_sessions(id)"
  end

  def self.down
      execute "alter table training_session_assocs DROP CONSTRAINT training_session_assocs_fk_trainings_training_id"
      execute "alter table training_session_assocs DROP CONSTRAINT training_session_assocs_fk_training_sessions_training_session_id"
    end
end
