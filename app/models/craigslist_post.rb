class CraigslistPost < ApplicationRecord
  validates :post, presence: true

  def title
    post.css('.result-title').text
  end

  def link
    post.css('.result-title').attribute('href').text
  end

  def id
    post.css('.result-title').attribute('data-id').text
  end

  def date
    post.css('.result-date').attribute('title').text
  end

  def price
    post.css('.result-price').text
  end

  def hood
    post.css('.result-hood').text
  end

  def bedrooms
    post.css('.housing').children.first.text.split('-').map(&:strip).first
  end

  def square_feet
    post.css('.housing').children.first.text.split('-').map(&:strip).last
  end

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
