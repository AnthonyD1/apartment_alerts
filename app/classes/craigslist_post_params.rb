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
      bedrooms: bedrooms.gsub(/[br]/, '').to_i,
      square_feet: square_feet.gsub(/[ft]/, '').to_i
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
    return '' if housing_info.nil?

    housing_info.text.split('-').map(&:strip).first
  end

  def square_feet
    return '' if housing_info.nil?

    housing_info.text.split('-').map(&:strip).last
  end

  private

  def housing_info
    post.css('.housing').children.first
  end

end
