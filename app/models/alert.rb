class Alert < ApplicationRecord
  has_many :craigslist_posts

  serialize :search_params

  validates :city, presence: true
  validates :search_params, presence: true

  def pull_posts
    @posts ||= CraigslistQuery.new(city: city, search_params: search_params).posts

    self.craigslist_posts = @posts
  end
  # TODO: Need to only add the new posts that match criteria to association.
end
