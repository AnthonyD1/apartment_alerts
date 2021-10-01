class CraigslistPost < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }

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
end
