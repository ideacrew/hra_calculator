module Validations
  class HraContract < Dry::Validation::Contract
    include ::SettingsHelper
    extend ::SettingsHelper

    params do
      required(:state).filled(:string)
      optional(:zipcode).filled(:string)
      optional(:county).value(:string)
      required(:dob).value(:date)
      required(:household_frequency).filled(:string)
      required(:household_amount).filled(:float)
      required(:hra_type).value(:string)
      required(:start_month).value(:date)
      required(:end_month).value(:date)
      required(:hra_frequency).value(:string)
      required(:hra_amount).value(:float)
    end

    rule(:state) do
      key.failure("must be #{state_full_name}") if value != state_full_name
    end

    if validate_county && !offerings_constrained_to_zip_codes
      rule(:county) do
        county_zips = ::Locations::CountyZip.where(county_name: values[:county].titleize)
        key.failure('is invalid') if county_zips.blank?
      end
    end

    if validate_county && offerings_constrained_to_zip_codes
      rule(:county, :zipcode) do
        county_zips = ::Locations::CountyZip.where(county_name: values[:county].titleize)
        if county_zips.blank?
          key.failure('is invalid')
        elsif county_zips.where(zip: values[:zipcode]).blank?
          key.failure('does not exist for zipcode')
        end
      end
    end

    rule(:dob) do
      key.failure('cannot be in the future') if value > Date.today
    end

    rule(:household_frequency) do
      frequencies = ['monthly', 'annually']
      key.failure('should be either monthly or annually') unless frequencies.include?(value)
    end

    rule(:household_amount) do
      key.failure('should be valid and positive') if value.negative?
    end

    rule(:hra_type) do
      hra_types = ['ichra', 'qsehra']
      key.failure('must be ichra/qsehra') unless hra_types.include?(value.downcase)
    end

    rule(:end_month, :start_month) do
      if values[:end_month] < values[:start_month]
        key.failure('must be after start_month')
      elsif (((values.data[:end_month].to_time - values.data[:start_month].to_time)/1.month.second).to_i > 12)
        key.failure('Please enter a valid end month, the effective period cannot be greater than 12 months')
      end
    end

    rule(:hra_frequency) do
      frequencies = ['monthly', 'annually']
      key.failure('should be either monthly or annually') unless frequencies.include?(value)
    end

    rule(:hra_amount) do
      key.failure('should be valid and positive') if value.negative?
    end
  end
end
