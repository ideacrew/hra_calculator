module Transactions
  class CountyZipFile
    include Dry::Transaction

    step :validate
    step :persist

    private

    def validate(input)
      result = ::Validations::CountyZipFileContract.new.call(input)

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
      # TODO: Call the service that creates countyzips and rating areas.
      Success(input)
    end
  end
end
