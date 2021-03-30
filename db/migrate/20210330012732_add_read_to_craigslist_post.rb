class AddReadToCraigslistPost < ActiveRecord::Migration[6.1]
  def change
    add_column :craigslist_posts, :read, :boolean
  end
end
