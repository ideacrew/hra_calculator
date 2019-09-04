# frozen_string_literal: true

module Locations
  module Validation
    SiteAddressContract = ApplicationContract.build do

      params do
        required(:state).value(:string)
        required(:zip_code).value(:string)

        optional(:county).value(:string)
        optional(:address_1).maybe(:string)
        optional(:address_2).maybe(:string)
      end
    end
  end
end

