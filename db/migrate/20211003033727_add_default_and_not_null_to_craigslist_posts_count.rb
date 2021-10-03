class AddDefaultAndNotNullToCraigslistPostsCount < ActiveRecord::Migration[6.1]
  def change
    change_column :alerts, :craigslist_posts_count, :integer, default: 0
    change_column_null :alerts, :craigslist_posts_count, false
  end
end
