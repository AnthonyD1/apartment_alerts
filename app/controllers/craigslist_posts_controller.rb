class CraigslistPostsController < ApplicationController
  def destroy
    @post = CraigslistPost.find(params[:id])

    if @post.destroy
      flash[:notice] = 'Post deleted.'
      redirect_to alert_path(@post.alert)
    else
      flash[:error] = 'Could not delete post.'
      redirect_to alert_path(@post.alert)
    end
  end
end
