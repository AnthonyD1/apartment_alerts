class ChangeCraigslistPostPostIdToBigint < ActiveRecord::Migration[6.1]
  def change
    change_column :craigslist_posts, :post_id, :bigint
  end
end
