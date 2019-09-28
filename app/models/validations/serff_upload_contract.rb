module Validations
  class SerffUploadContract < ::Dry::Validation::Contract
    params do
      required(:service_area)
      required(:plan)
      required(:rate)
    end

    rule(:service_area) do
      file_format = ::File.extname(value)
      key.failure("must be of format .xlsx and not #{file_format}") if file_format != ".xlsx"
    end

    rule(:plan) do
      file_format = ::File.extname(value)
      key.failure("must be of format .xml and not #{file_format}") if file_format != ".xml"
    end

    rule(:rate) do
      file_format = ::File.extname(value)
      key.failure("must be of format .xml and not #{file_format}") if file_format != ".xml"
    end
  end
end
