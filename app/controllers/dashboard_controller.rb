class DashboardController < ApplicationController

  def index
    @alerts = Alert.where(user_id: current_user)
  end
end
