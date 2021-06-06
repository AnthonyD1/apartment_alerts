class PullPostsJob < ApplicationJob

  def perform(alert)
    alert.pull_posts

    PullPostsJob.set(wait: alert.repull_delay).perform_later(alert)
  end
end
