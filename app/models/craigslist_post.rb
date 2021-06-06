class CraigslistPost < ApplicationRecord
  belongs_to :alert

  validates :post, presence: true

  # TODO: Store in database. Make sure not to pull html page upon creation, otherwise
  # could be costly when creating dozens of posts at a time. Consider only pulling when
  # filtering relies on info in the description.
  def description
    parsed_description = parsed_html.css('#postingbody')
    qrcode_div = parsed_description.css('.print-qrcode-container')

    (parsed_description.children - qrcode_div).text.strip
  end

  def post
    Nokogiri::XML(self[:post])
  end

  private

  def html
    `torify curl "#{link}"`
  end

  def parsed_html
    @parsed_html ||= Nokogiri::HTML(html)
  end
end
