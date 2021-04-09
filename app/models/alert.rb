class Alert < ApplicationRecord
  belongs_to :user
  has_many :craigslist_posts, dependent: :destroy

  serialize :search_params

  validates :city, presence: true
  validates :search_params, presence: true

  def pull_posts
    @posts ||= CraigslistQuery.new(city: city, search_params: search_params).posts

    self.craigslist_posts << new_posts
  end

  def average_price
    craigslist_posts.pluck(:price).sum / craigslist_posts.count
  end

  def median_price
    size = craigslist_posts.size
    sorted_prices = craigslist_posts.pluck(:price).sort
    mid = size / 2

    if size % 2 == 1
      (sorted_prices[mid] + sorted_prices[mid - 1]) / 2
    else
      sorted_prices[mid]
    end
  end

  def max_price
    craigslist_posts.pluck(:price).sort.max
  end

  def min_price
    craigslist_posts.pluck(:price).sort.min
  end

  private

  def new_posts
    @posts.select { |post| deduped_post_ids.include?(post.post_id) }
  end

  def deduped_post_ids
    post_ids = @posts.pluck(:post_id)
    existing_post_ids = self.craigslist_posts.pluck(:post_id)

    post_ids - existing_post_ids
  end
end
