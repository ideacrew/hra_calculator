module Validations
  class CountyZipFileContract < ::Dry::Validation::Contract
    params do
      required(:county_zip_file)
    end

    rule(:county_zip_file) do
      if !File.file?(value)
        key.failure('is not a file, please upload a file')
      else
        file_format = ::File.extname(value)
        key.failure("must be of format .xlsx and not #{file_format}") if file_format != ".xlsx"
      end
    end
  end
end
