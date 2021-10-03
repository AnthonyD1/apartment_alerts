class AlertMailer < ApplicationMailer
  default from: 'apartmentalertsupdates@gmail.com'

  def new_posts_email
    @user = params[:user]
    @alert = params[:alert]
    @new_posts = params[:new_posts]

    mail(to: @user.email, subject: "New Listings Found for #{@alert.name}")
  end
end
