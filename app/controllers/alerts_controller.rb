class AlertsController < ApplicationController
  decorates_assigned :craigslist_posts

  def index
  end

  def show
    @alert = Alert.find(params[:id])

    @q = @alert.craigslist_posts.ransack(params[:q])
    @q.sorts = 'date desc' if @q.sorts.empty?
    @craigslist_posts = @q.result
  end

  def new
    @alert = Alert.new
  end

  def create
    @alert = Alert.new(alert_params)

    if @alert.save
      flash[:notice] = 'Alert created successfully.'
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong; please try again.'
      redirect_to new_alert_path
    end
  end

  def refresh
    @alert = Alert.find(params[:id])

    @alert.pull_posts

    redirect_to alert_path(@alert)
  end

  private

  def alert_params
    params.require(:alert).permit(:city, search_params: {}).merge(user_id: current_user.id)
  end

end
