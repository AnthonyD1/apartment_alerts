class PullPostsJob < ApplicationJob
  queue_as :pull_posts

  def perform(alert)
    alert.refresh
  end
end
