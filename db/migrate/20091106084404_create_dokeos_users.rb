class CreateDokeosUsers < ActiveRecord::Migration
  def self.up
    create_table :dokeos_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :dokeos_users
  end
end
