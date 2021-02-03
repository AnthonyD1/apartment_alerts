class AlertsController < ApplicationController
  def index
  end

  def show
    @alert = Alert.find(params[:id])
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

  private

  def alert_params
    search_params = params.require(:alert)[:search_params].permit!
    params.require(:alert).permit(:city).merge(search_params: search_params, user_id: current_user.id)
  end

end
