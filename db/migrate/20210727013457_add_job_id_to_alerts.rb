class AddJobIdToAlerts < ActiveRecord::Migration[6.1]
  def change
    add_column :alerts, :job_id, :integer
  end
end
