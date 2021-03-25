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
      post_id: post_id.to_i,
      date: DateTime.parse(date),
      price: price.gsub(/[$,]/, '').to_i,
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
    return nil unless housing_info.any? { |ele| ele.include?('br') }

    housing_info.first.gsub(/[br]/, '').to_i
  end

  def square_feet
    return nil unless housing_info.any? { |ele| ele.include?('ft') }

    housing_info.last.gsub(/[ft]/, '').to_i
  end

  private

  def housing_info
    return [] if post.css('.housing').children.first.blank?

    post.css('.housing').children.first.text.split('-').map(&:strip)
  end
end
