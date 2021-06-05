class Alert < ApplicationRecord
  belongs_to :user
  has_many :craigslist_posts, dependent: :destroy

  serialize :search_params

  validates :city, presence: true
  validates :search_params, presence: true

  def pull_posts
    @posts ||= CraigslistQuery.new(city: city, search_params: filtered_search_params).posts

    update_average_post_time if new_posts.count > 1

    self.craigslist_posts << new_posts
  end

  def average_price
    return if craigslist_posts.count.zero?
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

  def filtered_search_params
    search_params.reject { |k,v| v.to_i.zero? }
  end

  private

  def update_average_post_time
    return if new_posts.count < 1

    old_average       = average_post_time
    old_count         = average_post_time_count
    new_posts_average = calc_average_post_time(new_posts)
    new_posts_count   = new_posts.count - 1
    total_count       = old_count + new_posts_count

    new_average = ((old_average * old_count) + (new_posts_average * new_posts_count)) / total_count

    update_columns(average_post_time: new_average, average_post_time_count: total_count)
  end

  def calc_average_post_time(posts)
    return 0 if posts.count < 1

    sorted_posts = posts.pluck(:date).sort

    (sorted_posts.max - sorted_posts.min) / (posts.count - 1)
  end

  def new_posts
    @posts.select { |post| deduped_post_ids.include?(post.post_id) }
  end

  def deduped_post_ids
    new_post_ids = @posts.pluck(:post_id)
    duplicate_post_ids ||= CraigslistPost.where(post_id: new_post_ids).pluck(:post_id)

    new_post_ids - duplicate_post_ids
  end
end
