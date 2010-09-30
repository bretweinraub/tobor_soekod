
class UserView < ActiveRecord::Base
  set_primary_key "view_name"
  set_table_name :user_views
end
