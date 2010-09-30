
class DokeosUserController < ApplicationController
#  before_filter :authenticate
  layout "default"
  active_scaffold :dokeos_user do |config|
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.create.columns.exclude(col)}
    [:is_deleted,:updated_dt,:inserted_dt].each {|col| config.update.columns.exclude(col)}

    config.columns << :dokeos_id
  end
end
