module Operations
  class InitializeHra
    include Dry::Transaction::Operation

    def call(params)
      hra_obj = ::HraAffordabilityDetermination.new(params)

      Success(hra_obj)
    end
  end
end
