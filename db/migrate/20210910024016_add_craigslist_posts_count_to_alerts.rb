class AddCraigslistPostsCountToAlerts < ActiveRecord::Migration[6.1]
  def change
    add_column :alerts, :craigslist_posts_count, :integer
  end
end
