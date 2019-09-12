module Locations
  class RatingArea

    include Mongoid::Document
    include Mongoid::Timestamps

    field :county_zip_ids, type: Array
    field :exchange_provided_code, type: String
    field :active_year, type: Integer
    field :covered_states, type: Array

  end
end