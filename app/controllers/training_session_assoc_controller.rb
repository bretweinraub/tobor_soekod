
class TrainingSessionAssocController < ApplicationController
#  before_filter :authenticate
  layout "default"
  active_scaffold :training_session_assoc do |config|
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.create.columns.exclude(col)}
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.update.columns.exclude(col)}
  end
end
