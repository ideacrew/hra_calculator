class ConfigurationsController < ApplicationController
  def counties
    counties_lookup = ::Operations::CountiesLookup.new.call(params.permit!['hra_zipcode'])
    render plain: {status: "success", data: counties_lookup.success.to_h}.to_json, content_type: 'application/json'
  end

  def default_configuration
    hra_default_setter = ::Operations::HraDefaultSetter.new.call
    render plain: {status: "success", data: hra_default_setter.success.to_h}.to_json, content_type: 'application/json'
  end
end
