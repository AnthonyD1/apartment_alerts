class CraigslistPostsController < ApplicationController
  before_action :set_craigslist_post, only: %i(update destroy favorite)

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to(alert_path(@post.alert), notice: 'Post updated') }
        format.js
      else
        format.html { redirect_to(alert_path(@post.alert), error: 'Could not update post') }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @post.destroy
        format.html { redirect_to(alert_path(@post.alert), notice: 'Post deleted.') }
        format.js
      else
        format.html { redirect_to(alert_path(@post.alert), notice: 'Could not delete post.') }
      end
    end
  end

  def favorite
    respond_to do |format|
      if @post.toggle(:favorite).save
        format.html { redirect_to(alert_path(@post.alert), notice: 'Post favorited.') }
        format.js
      else
        format.html { redirect_to(alert_path(@post.alert), notice: 'Post could not be favorited.') }
      end
    end
  end

  def batch_delete
    posts = CraigslistPost.where(id: batch_delete_params[:posts])
    alert_id = posts.first.alert_id

    if posts.delete_all
      redirect_to(alert_path(alert_id), notice: 'Posts deleted.')
    else
      redirect_to(alert_path(alert_id), notice: 'Posts could not be deleted.')
    end
  end

  private

  def set_craigslist_post
    @post = CraigslistPost.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:seen, :favorite)
  end

  def batch_delete_params
    params.permit(posts: [])
  end
end
