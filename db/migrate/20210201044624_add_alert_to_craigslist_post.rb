class AddAlertToCraigslistPost < ActiveRecord::Migration[6.1]
  def change
    add_reference :craigslist_posts, :alert, null: false, foreign_key: true
  end
end
