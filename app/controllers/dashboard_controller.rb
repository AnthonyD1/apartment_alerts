class DashboardController < ApplicationController
  decorates_assigned :alerts

  def index
    @q = current_user.alerts.ransack(params[:q])
    @q.sorts =['created_at'] if @q.sorts.blank?
    @pagy, @alerts = pagy(@q.result(distinct: true), items: 10)
  end
end
