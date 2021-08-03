class AlertsController < ApplicationController
  before_action :load_alert, only: %i[show edit update destroy refresh]
  before_action :check_user_authorization, only: %i[show edit update]
  decorates_assigned :craigslist_posts, :alert

  def index
  end

  def show
    parse_ransack_multiple_sort_params_to_array

    @q = @alert.craigslist_posts.ransack(params[:q])
    @q.sorts = ['favorite desc', 'date desc'] if @q.sorts.empty?
    @pagy, @craigslist_posts = pagy(@q.result, items: 15)
  end

  def new
    @alert = Alert.new(search_params: {})
  end

  def create
    @alert = Alert.new(alert_params)

    if @alert.save
      redirect_to root_path, flash: { success: 'Alert created successfully.' } 
    else
      render :new
    end
  end

  def destroy
    respond_to do |format|
      if @alert.destroy
        format.html { redirect_to(root_path, notice: 'Alert deleted.') }
        format.js
      else
        format.html { redirect_to(root_path, notice: 'Alert could not be deleted.') }
      end
    end
  end

  def edit
  end

  def update
    if @alert.update(alert_params)
      redirect_to alert_path(@alert), flash: { success: 'Alert updated successfully.' }
    else
      render :new
    end
  end

  def refresh
    @alert.refresh

    redirect_to alert_path(@alert)
  end

  private

  def load_alert
    @alert = Alert.find(params[:id])
  end

  def check_user_authorization
    if current_user != @alert.user
      redirect_to root_path, alert: 'You do not have permission.'
    end
  end

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
    @alert_params = params.require(:alert).permit(:name, :city, :emails_enabled, search_params: {}).merge(user_id: current_user.id)
    @alert_params[:search_params].merge!('postedToday' => '1')
    @alert_params
  end
end
