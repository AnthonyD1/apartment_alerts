class DashboardController < ApplicationController
  decorates_assigned :alerts

  def index
    @pagy, @alerts = pagy(current_user.alerts, items: 10)
  end
end
