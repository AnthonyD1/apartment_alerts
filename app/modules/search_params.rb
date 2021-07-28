module SearchParams
  Params = %i[query hasPic search_distance postal min_price max_price min_bedrooms max_bedrooms min_bathrooms max_bathrooms minSqft maxSqft pets_cat pets_dog is_furnished no_smoking wheelchaccess ev_charging application_fee broker_fee]

  def method_missing(method, *args, &block)
    if Params.include?(method)
      search_params.dig(method)
    else
      super
    end
  end
end
