class Alert < ApplicationRecord
  include SearchParams

  scope :ten_most_recent, -> { order(updated_at: :desc).last(10) }

  belongs_to :user
  has_many :craigslist_posts, dependent: :destroy

  serialize :search_params

  validates :name, presence: true
  validates :city, presence: true
  validates :search_params, presence: true

  def refresh
    pull_posts
    enqueue_pull_posts_job
    return if new_posts.count.zero?

    update_average_post_time
    update_craigslist_posts
    mark_unseen
    send_new_posts_email
  end

  def pull_posts
    @posts ||= CraigslistQuery.new(city: city, search_params: filtered_search_params).posts
    touch(:last_pulled_at)
  end

  def average_post_price
    return if craigslist_posts_count.zero?

    craigslist_posts.active.pluck(:price).sum / craigslist_posts_count
  end

  def median_post_price
    size = craigslist_posts_count
    sorted_prices = craigslist_posts.active.pluck(:price).sort
    mid = size / 2

    if size % 2 == 1
      (sorted_prices[mid] + sorted_prices[mid - 1]) / 2
    else
      sorted_prices[mid]
    end
  end

  def max_post_price
    craigslist_posts.active.pluck(:price).sort.max
  end

  def min_post_price
    craigslist_posts.active.pluck(:price).sort.min
  end

  def filtered_search_params
    temp = search_params.reject { |k,v| v.to_i.zero? }
    temp.merge!(query: search_params[:query]) if search_params[:query].present?
    temp.merge!(postedToday: '1')
    temp
  end

  def repull_delay
    average_post_time.zero? ? 1.hour.seconds : average_post_time.seconds
  end

  def next_pull_time
    return DateTime.current + repull_delay if last_pulled_at.blank?

    last_pulled_at + repull_delay
  end

  def enqueue_pull_posts_job
    Delayed::Job.find(job_id).destroy if job_id.present?

    job = PullPostsJob.set(wait: repull_delay).perform_later(self)

    update_column(:job_id, job.provider_job_id)
  end

  def mark_seen
    self.update_column(:seen, true) if seen.blank?
  end

  def mark_unseen
    self.update_column(:seen, false) if seen
  end

  def delete_non_favorite_posts
    posts = craigslist_posts.not_favorite

    CraigslistPost.batch_delete(posts, soft_delete: false)
  end

  private

  def send_new_posts_email
    return unless emails_enabled?

    AlertMailer.with(user: self.user, alert: self, new_posts: new_posts).new_posts_email.deliver_later
  end

  def update_craigslist_posts
    self.craigslist_posts << new_posts
  end

  def update_average_post_time
    return if new_posts.count <= 1

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
    @new_posts ||= @posts.select { |post| deduped_post_ids.include?(post.post_id) }
  end

  def deduped_post_ids
    new_post_ids = @posts.pluck(:post_id)
    @duplicate_post_ids ||= craigslist_posts.where(post_id: new_post_ids).pluck(:post_id)

    new_post_ids - @duplicate_post_ids
  end
end
