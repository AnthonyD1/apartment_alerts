class CraigslistPost < ApplicationRecord
  belongs_to :alert

  validates :post, presence: true

  def parsed_post
    Nokogiri::XML(self[:post])
  end
end
