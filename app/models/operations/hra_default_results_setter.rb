module Operations
  class HraDefaultResultsSetter
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call
      hra_results = ::HraResults.new({
        tax_credit: tax_credit,
        market_place: market_place,
        help_text_1: help_text_1,
        help_text_2: help_text_2,
        short_term_plan: short_term_plan,
        minimum_essential_coverage: minimum_essential_coverage,
        minimum_essential_coverage_link: minimum_essential_coverage_link,
        enroll_without_aptc: enroll_without_aptc,
        help_text_3: help_text_3,
        help_text_4: help_text_4
      })

      Success(hra_results)
    end
  end
end
