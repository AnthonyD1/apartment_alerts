class CraigslistPost < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }
  scope :favorite, -> { where(favorite: true) }
  scope :not_favorite, -> { where(favorite: false) }
  scope :user, -> (user_id) { joins(:alert).where('alerts.user_id = ?', user_id) }

  delegate :city, to: :alert

  belongs_to :alert
  counter_culture :alert,
    column_name: proc { |model| model.deleted_at? ? nil : 'craigslist_posts_count' },
    column_names: { CraigslistPost.active => :craigslist_posts_count }

  validates :post, presence: true
  validates :price, presence: true
  validates :date, presence: true
  validates :title, presence: true
  validates :link, presence: true

  def parsed_post
    Nokogiri::XML(self[:post])
  end

  def update_deleted_at
    update_attribute(:deleted_at, DateTime.current)
  end

  def self.batch_delete(posts, soft_delete: true)
    if soft_delete
      posts.update_all(deleted_at: DateTime.current)
    else
      posts.delete_all
    end

    self.counter_culture_fix_counts
  end
end
