class CraigslistPostDecorator < ApplicationDecorator
  delegate_all

  def price
    h.number_to_currency(model.price, precision: 0)
  end

  def square_feet
    return '' if model.square_feet.blank?

    model.square_feet.to_s << ' ft'
  end

  def date
    model.date.strftime("%m-%d-%Y %I:%M:%S %P")
  end

  def hood
    model.hood.delete('()').strip.titleize
  end

  def bedrooms
    return '' if model.bedrooms.blank?

    model.bedrooms.to_s << ' br'
  end
end
