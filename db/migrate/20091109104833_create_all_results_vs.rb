class CreateAllResultsVs < ActiveRecord::Migration
  def self.up
    create_table :all_results_vs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :all_results_vs
  end
end
