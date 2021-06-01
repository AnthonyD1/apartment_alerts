class AddAveragePostTimeFieldsToAlerts < ActiveRecord::Migration[6.1]
  def change
    add_column :alerts, :average_post_time, :integer, default: 0
    add_column :alerts, :average_post_time_count, :integer, default: 0
  end
end
