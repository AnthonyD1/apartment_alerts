class CraigslistPostDecorator < ApplicationDecorator
  delegate_all

  def price
    h.number_to_currency(model.price, precision: 0)
  end

  def square_feet
    model.square_feet.to_s << ' ft'
  end

  def date
    cst_time = model.date.in_time_zone('Central Time (US & Canada)')
    cst_time.strftime("%m-%d-%Y %I:%M:%S %P")
  end

  def hood
    model.hood.delete('()').strip.titleize
  end

  def bedrooms
    model.bedrooms.to_s << ' br'
  end
end
