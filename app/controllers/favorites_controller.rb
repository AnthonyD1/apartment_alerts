class FavoritesController < ApplicationController
  decorates_assigned :craigslist_posts

  def index
    @q = CraigslistPost.active.favorite.user(current_user.id).ransack(params[:q])
    @pagy, @craigslist_posts = pagy(@q.result, items: 15)
  end
end
