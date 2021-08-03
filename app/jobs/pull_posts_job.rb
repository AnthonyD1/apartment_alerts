class PullPostsJob < ApplicationJob
  queue_as :pull_posts

  def perform(alert)
    alert.refresh

    PullPostsJob.set(wait: alert.repull_delay).perform_later(alert)
  end
end
