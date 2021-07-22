class AddEmailsEnabledToAlerts < ActiveRecord::Migration[6.1]
  def change
    add_column :alerts, :emails_enabled, :boolean
  end
end
