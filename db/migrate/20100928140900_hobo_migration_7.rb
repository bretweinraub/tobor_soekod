class HoboMigration7 < ActiveRecord::Migration
  def self.up
    add_column :dokeos_users, :dokeos_user_name, :string, :length => 256
  end

  def self.down
    remove_column :dokeos_users, :dokeos_user_name
  end
end
