class RemovesUniquenessConstraintFromCraigslistPosts < ActiveRecord::Migration[6.1]
  def change
    remove_index :craigslist_posts, :post_id, unique: true
  end
end
