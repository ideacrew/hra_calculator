module Validations
  class HraContract < Dry::Validation::Contract
    params do
      required(:state).filled(:string)
      required(:zipcode).filled(:integer)
      required(:county).value(:string)
      required(:dob).value(:date)
      required(:household_frequency).filled(:string)
      required(:household_amount).filled(:float)
      required(:hra_type).value(:string)
      required(:start_month).value(:integer)
      required(:end_month).value(:integer)
      required(:hra_frequency).value(:string)
      required(:hra_amount).value(:float)
    end

    rule(:state) do
      state = 'Maryland' # TODO: read the state from the settings
      key.failure("State must be #{state}") if value != state
    end

    rule(:zipcode) do
      zip = ::Locations::CountyZip.where(zip: value).first
      key.failure('Zipcode must be within the state') if zip.nil?
    end

    # TODO: Add a validation to verify if the given county is mapped to the Zip Code.

    rule(:county) do
      zip = ::Locations::CountyZip.where(county_name: value).first
      key.failure('County must be within the state') if zip.nil?
    end

    rule(:dob) do
      key.failure('DOB cannot exist in future') if value > Date.today
    end

    rule(:household_frequency) do
      frequencies = ['monthly', 'annually']
      key.failure('Enter a value which is monthly or annually') unless frequencies.include?(value)
    end

    rule(:household_amount) do
      key.failure('Enter a value which is valid and positive') if value.negative?
    end

    rule(:hra_type) do
      hra_types = ['ichra', 'qsehra']
      key.failure('Hra type must be ichra/qsehra') unless hra_types.include?(value.downcase)
    end

    rule(:start_month) do
      key.failure('must be greater than 18') if value < 1
    end

    # TODO: Add a validation to verify if the end_date > start_date

    rule(:end_month) do
      key.failure('must be greater than 18') if value > 12
    end

    rule(:hra_frequency) do
      frequencies = ['monthly', 'annually']
      key.failure('Enter a value which is monthly or annually') unless frequencies.include?(value)
    end

    rule(:hra_amount) do
      key.failure('Enter a value which is valid and positive') if value.negative?
    end
  end
end
