class CraigslistPostParams
  attr_accessor :post

  def initialize(post)
    @post = post
  end

  def call
    {
      post: post,
      title: title,
      link: link,
      post_id: post_id,
      date: date,
      price: price,
      hood: hood,
      bedrooms: bedrooms,
      square_feet: square_feet
    }
  end

  def title
    post.css('.result-title').text
  end

  def link
    post.css('.result-title').attribute('href').text
  end

  def post_id
    post.css('.result-title').attribute('data-id').text.to_i
  end

  def date
    raw_date = post.css('.result-date').attribute('title').text
    DateTime.parse(raw_date)
  end

  def price
    raw_price = post.css('.result-price').text
    raw_price.gsub(/[$,]/, '').to_i
  end

  def hood
    post.css('.result-hood').text
  end

  def bedrooms
    return nil unless housing_info.any? { |ele| ele.include?('br') }

    housing_info.first.gsub(/[br]/, '').to_i
  end

  def square_feet
    return nil unless housing_info.any? { |ele| ele.include?('ft') }

    housing_info.last.gsub(/[ft]/, '').to_i
  end

  private

  def housing_info
    housing_info_array = post.css('.housing').children
    return [] if housing_info_array.first.blank?

    if housing_info_array.first.text.include?('-')
      housing_info_array.first.text.split('-').map(&:strip)
    else
      [housing_info_array.first.text.strip]
    end
  end
end
