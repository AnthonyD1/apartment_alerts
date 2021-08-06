class AlertDecorator < ApplicationDecorator
  delegate_all

  BOOLEAN_TAGS = HashWithIndifferentAccess.new({ hasPic: 'has pics', pets_cat: 'cat friendly', pets_dog: 'dog friendly', is_furnished: 'furnished', no_smoking: 'non smoking', wheelchaccess: 'wheelchair access', ev_charging: 'ev charging', application_fee: 'application fee', broker_fee: 'broker fee' })
  COMPOUND_TAGS = %i[min_price max_price min_bedrooms max_bedrooms min_bathrooms max_bathrooms minSqft maxSqft]

  def search_param_tags
    tags = model.filtered_search_params.except(:postedToday)

    regular_tags = tags.except(*COMPOUND_TAGS).map do |key, value|
      if BOOLEAN_TAGS.keys.include?(key)
        BOOLEAN_TAGS[key]
      else
        "#{key.to_s.humanize.downcase}: #{value}"
      end
    end

    [format(tags, :price), format(tags, :bedrooms), format(tags, :bathrooms), format(tags, :Sqft), regular_tags].flatten.compact
  end

  private

  def format(tags, key)
    return if tags.keys.grep(/#{key}/).blank?

    min_key = key == :Sqft ? "min#{key.to_s}" : "min_#{key.to_s}"
    max_key = key == :Sqft ? "max#{key.to_s}" : "max_#{key.to_s}"
    min_value = tags[min_key] || 0
    max_value = tags[max_key] || 'infinity'

    "#{key.to_s}: #{min_value} - #{max_value}"
  end
end

