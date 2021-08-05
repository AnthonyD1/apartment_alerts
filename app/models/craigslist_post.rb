class CraigslistPost < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }

  belongs_to :alert

  validates :post, presence: true

  def parsed_post
    Nokogiri::XML(self[:post])
  end
end
