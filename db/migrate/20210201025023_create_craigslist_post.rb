class CreateCraigslistPost < ActiveRecord::Migration[6.1]
  def change
    create_table :craigslist_posts do |t|
      t.string :post

      t.timestamps
    end
  end
end
