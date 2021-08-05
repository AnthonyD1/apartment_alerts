class AddDeletedAtToCraigslistPost < ActiveRecord::Migration[6.1]
  def change
    add_column :craigslist_posts, :deleted_at, :datetime
  end
end
