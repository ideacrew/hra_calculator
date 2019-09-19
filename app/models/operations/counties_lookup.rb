module Operations
  class CountiesLookup
    include Dry::Transaction::Operation

    def call(zipcode)
      counties = ::Locations::CountyZip.where(zip: zipcode).pluck(:county_name).uniq
      Success({counties: counties})
    end
  end
end
