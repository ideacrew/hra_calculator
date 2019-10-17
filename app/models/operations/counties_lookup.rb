module Operations
  class CountiesLookup
    include Dry::Transaction::Operation

    def call(input_hash)
      counties = ::Locations::CountyZip.where(state: input_hash[:tenant].to_s.upcase, zip: input_hash[:hra_zipcode]).pluck(:county_name).uniq
      counties.sort!
      Success({counties: counties})
    end
  end
end
