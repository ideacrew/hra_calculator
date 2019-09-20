module Validations
  class HraContract < Dry::Validation::Contract
    include ::SettingsHelper

    params do
      required(:state).filled(:string)
      required(:zipcode).filled(:string)
      required(:county).value(:string)
      required(:dob).value(:date)
      required(:household_frequency).filled(:string)
      required(:household_amount).filled(:float)
      required(:hra_type).value(:string)
      # required(:start_month).value(:date)
      # required(:end_month).value(:date)
      required(:start_month).value(:string)
      required(:end_month).value(:string)
      required(:hra_frequency).value(:string)
      required(:hra_amount).value(:float)
    end

    rule(:state) do
      key.failure("State must be #{state_full_name}") if value != state_full_name
    end

    rule(:county, :zipcode) do
      county_zips = ::Locations::CountyZip.where(county_name: values[:county].titleize)
      if validate_county && county_zips.blank?
        key.failure('Entered county is invalid')
      elsif validate_zipcode && county_zips.where(zip: values[:zipcode]).blank?
        key.failure('Entered zip and county combination does not exist for zipcode')
      end
    end

    rule(:dob) do
      begin
        values.data[:dob] = Date.strptime(value.to_s, '%Y-%m-%d')
        key.failure('DOB cannot exist in future') if value > Date.today
      rescue
        key.failure('DOB is not in a valid format')
      end
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

    rule(:end_month, :start_month) do
      begin
        values.data[:end_month] = Date.strptime(values[:end_month], '%Y-%m-%d')
        values.data[:start_month] = Date.strptime(values[:start_month], '%Y-%m-%d')
        key.failure('end month must be after start month') if values[:end_month] < values[:start_month]
      rescue
        key.failure('End Month or Start Month is not in a valid format')
      end
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
