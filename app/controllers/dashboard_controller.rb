class DashboardController < ApplicationController

  def index
    @alerts = current_user.alerts
  end
end
