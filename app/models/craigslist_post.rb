class CraigslistPost < ApplicationRecord
  belongs_to :alert

  validates :post, presence: true

  def post
    Nokogiri::XML(self[:post])
  end
end
