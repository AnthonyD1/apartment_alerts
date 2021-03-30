class CraigslistPostsController < ApplicationController
  before_action :set_craigslist_post, only: %i(update destroy)

  def update
    if @post.update(post_params)
      flash[:notice] = 'Post updated'
      redirect_to alert_path(@post.alert)
    else
      flash[:error] = 'Could not update post'
      redirect_to alert_path(@post.alert)
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = 'Post deleted.'
      redirect_to alert_path(@post.alert)
    else
      flash[:error] = 'Could not delete post.'
      redirect_to alert_path(@post.alert)
    end
  end

  private

  def set_craigslist_post
    @post = CraigslistPost.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:seen)
  end
end
