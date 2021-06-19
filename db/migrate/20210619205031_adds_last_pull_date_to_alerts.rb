class AddsLastPullDateToAlerts < ActiveRecord::Migration[6.1]
  def change
    add_column :alerts, :last_pulled_at, :datetime
  end
end
