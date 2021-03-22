class AddUniquenessConstraintToCraigslistPosts < ActiveRecord::Migration[6.1]
  def change
    add_index :craigslist_posts, :post_id, unique: true
  end
end
