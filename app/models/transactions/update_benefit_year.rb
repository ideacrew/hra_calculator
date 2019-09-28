module Transactions
  class UpdateBenefitYear
    include Dry::Transaction

    step :validate
    step :persist

    private

    def validate(input)
      @benefit_year = ::Enterprises::BenefitYear.find(input[:benefit_year_id])

      if @benefit_year.blank?
        Failure({errors: ["Unable to find benefit year record with id: #{input[:benefit_year_id]}"]})
      else
        Success(input)
      end
    end

    def persist(input)
      @benefit_year.assign_attributes(input.to_h.except(:benefit_year_id))

      if @benefit_year.save
        Success(@benefit_year)
      else
        Failure({errors: @benefit_year.errors.full_messages})
      end
    end
  end
end
