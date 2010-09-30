
class TrainingSessionController < ApplicationController
#  before_filter :authenticate
  layout "default"
  active_scaffold :training_session do |config|
    config.columns << :dokeos_id
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.create.columns.exclude(col)}
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.update.columns.exclude(col)}
  end
end
