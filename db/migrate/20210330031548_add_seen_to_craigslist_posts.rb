class AddSeenToCraigslistPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :craigslist_posts, :seen, :boolean
  end
end
