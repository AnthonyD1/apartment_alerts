class AlertsController < ApplicationController
  decorates_assigned :craigslist_posts

  def index
  end

  def show
    @alert = Alert.find(params[:id])

    parse_ransack_multiple_sort_params_to_array

    @q = @alert.craigslist_posts.ransack(params[:q])
    @q.sorts = ['favorite desc', 'date desc'] if @q.sorts.empty?
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

  def parse_ransack_multiple_sort_params_to_array
    return if params[:q].blank?
    # In order to persist sorts when using a ransack search field we need
    # to store them in a hidden field in the `search_form_for`. This stored
    # value is always a string, so multi sorts will be turned from an Array to
    # a String.
    # Ex. ['favorites dec', 'date desc'] --> 'favorite desc date desc'
    # We need to turn it back to an array before ransack happens.
    if params[:q][:s].is_a?(String)
      params[:q][:s] = params[:q][:s].split(' ').each_slice(2).to_a.map { |a| a.join(' ') }
    end
  end

  def alert_params
    params.require(:alert).permit(:city, search_params: {}).merge(user_id: current_user.id)
  end

end
