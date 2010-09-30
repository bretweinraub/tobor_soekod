
class AllResultsVController < ApplicationController
#  before_filter :authenticate
  layout "default"
  active_scaffold :all_results_v do |config|
    config.actions.add :export
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.create.columns.exclude(col)}
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.update.columns.exclude(col)}
  end
end
