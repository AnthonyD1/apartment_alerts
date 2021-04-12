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
    respond_to do |format|
      if @post.destroy
        format.html { redirect_to alert_path(@post.alert), notice: 'Post deleted.' }
        format.js
      else
        format.html { redirect_to alert_path(@post.alert), notice: 'Could not delete post.' }
        format.js
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
