class PullPostsJob < ApplicationJob

  def perform(alert)
    alert.pull_posts

    PullPostsJob.set(wait: alert.average_post_time).perform_later(alert)
  end
end
