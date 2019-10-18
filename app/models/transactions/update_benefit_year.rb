module Transactions
  class UpdateBenefitYear
    include Dry::Transaction

    step :validate
    step :persist

    private

    def validate(input)
      if input["enterprises_enterprise"]["value"].blank? || input["admin"]["benefit_year"].blank?
        Failure({errors: ["Missing Year/Value}"]})
      else
        Success(input)
      end
    end

    def persist(input)
      @benefit_year = ::Enterprises::BenefitYear.where(calendar_year: input["admin"]["benefit_year"]).first || ::Enterprises::BenefitYear.new(calendar_year: input["admin"]["benefit_year"], enterprise_id:  input["enterprise_id"])
      if @benefit_year.update_attributes(expected_contribution: input["enterprises_enterprise"]["value"])
        Success(@benefit_year)
      else
        Failure({errors: ["Failed to save benefit year"]})
      end
    end
  end
end
