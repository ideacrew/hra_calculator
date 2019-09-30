class HraResults < Dry::Struct
  transform_keys(&:to_sym)

  attribute :page_title, Types::String
  attribute :a_tax_credit, Types::String
  attribute :off_market, Types::String
  attribute :results_page_help_text_1, Types::String
  attribute :results_page_help_text_2, Types::String
  attribute :answer_no, Types::String
  attribute :aca_compliant, Types::String
  attribute :mininum_essential_coverage, Types::String
  attribute :mininum_essential_coverage_link, Types::String
  attribute :short_term_plan, Types::String
  attribute :colors, Types::Array  
end
