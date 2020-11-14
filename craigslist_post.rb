class CraigslistPost

  def initialize(post)
    @post = post
  end

  def title
    @post.css('.result-title').text
  end

  def link
    @post.css('.result-title').attribute('href').text
  end

  def id
    @post.css('.result-title').attribute('data-id').text
  end

  def date
    @post.css('.result-date').attribute('title').text
  end

  def price
    @post.css('.result-price').text
  end

  def hood
    @post.css('.result-hood').text
  end

  def bedrooms
    @post.css('.housing').children.first.text.split('-').map(&:strip).first
  end

  def square_ft
    @post.css('.housing').children.first.text.split('-').map(&:strip).second
  end
end
