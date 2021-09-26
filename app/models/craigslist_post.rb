class CraigslistPost < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }

  belongs_to :alert, counter_cache: true

  validates :post, presence: true
  validates :price, presence: true
  validates :date, presence: true
  validates :title, presence: true
  validates :link, presence: true

  def parsed_post
    Nokogiri::XML(self[:post])
  end
end
