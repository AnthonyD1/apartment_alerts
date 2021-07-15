# Preview all emails at http://localhost:3000/rails/mailers/alert
class AlertPreview < ActionMailer::Preview
  def new_posts_email
    AlertMailer.with(user: User.first, alert: Alert.first, new_posts: CraigslistPost.last(5)).new_posts_email
  end
end
