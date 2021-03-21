class Alert < ApplicationRecord
  belongs_to :user
  has_many :craigslist_posts, dependent: :destroy

  serialize :search_params

  validates :city, presence: true
  validates :search_params, presence: true

  def pull_posts
    @posts ||= CraigslistQuery.new(city: city, search_params: search_params).posts

    p '#' * 100
    p new_posts
    p '#' * 100
    self.craigslist_posts << new_posts
  end

  private

  def new_posts
    @posts - self.craigslist_posts
  end
end
