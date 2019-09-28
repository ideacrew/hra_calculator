module Transactions
  class UploadSerffTemplate
    include Dry::Transaction

    step :unzip_serff
    step :fetch_files
    step :validate
    step :persist

    private

    def unzip_serff(input)
      # TODO: Unzip serff zip
      output = input
      Success(output)
    end

    def fetch(input)
      # TODO: Pull files from the input
      input

      Success(
        {
          service_area: service_area_file,
          rate: rate_file,
          plan: plan_file
        }
      )
    end

    def validate(input)
      result = ::Validations::SerffUploadContract.new.call(input)

      if output.failure?
        result = output.to_h
        result[:errors] = []
        output.errors.to_h.each_pair do |keyy, val|
          result[:errors] << "#{keyy.to_s} #{val.first}"
        end
        Failure(result)
      else
        Success(output)
      end
    end

    def persist(input)
      # TODO: Call the service that creates service area, plan and rates.
      Success(input)
    end
  end
end
