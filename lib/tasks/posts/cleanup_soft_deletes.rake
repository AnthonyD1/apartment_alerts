namespace :posts do
  desc "permanently destroys all soft deleted posts"
  task cleanup_soft_deletes: :environment do
    soft_deleted_posts = CraigslistPost.where.not(deleted_at: nil)

    CraigslistPost.batch_delete(soft_deleted_posts, soft_delete: false)
  end
end
