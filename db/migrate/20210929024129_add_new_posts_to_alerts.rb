class AddNewPostsToAlerts < ActiveRecord::Migration[6.1]
  def change
    add_column :alerts, :seen, :boolean, default: true
  end
end
