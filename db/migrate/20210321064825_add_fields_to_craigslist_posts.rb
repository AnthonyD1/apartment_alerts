class AddFieldsToCraigslistPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :craigslist_posts, :title, :string
    add_column :craigslist_posts, :link, :string
    add_column :craigslist_posts, :post_id, :integer
    add_column :craigslist_posts, :date, :datetime
    add_column :craigslist_posts, :price, :integer
    add_column :craigslist_posts, :hood, :string
    add_column :craigslist_posts, :bedrooms, :integer
    add_column :craigslist_posts, :square_feet, :integer
  end
end
