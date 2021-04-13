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

  private

  def set_craigslist_post
    @post = CraigslistPost.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:seen, :favorite)
  end
end
