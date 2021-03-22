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
