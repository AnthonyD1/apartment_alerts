class AlertDecorator < ApplicationDecorator
  delegate_all

  def search_param_tags
    model.filtered_search_params.except('postedToday')
  end
end
