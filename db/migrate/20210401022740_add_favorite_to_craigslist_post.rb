class AddFavoriteToCraigslistPost < ActiveRecord::Migration[6.1]
  def change
    add_column :craigslist_posts, :favorite, :boolean, default: false
  end
end
