class HraResults < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :tax_credit, Types::String
  attribute :market_place, Types::String
  attribute :help_text_1, Types::String
  attribute :help_text_2, Types::String
  attribute :short_term_plan, Types::String
  attribute :minimum_essential_coverage, Types::String
  attribute :minimum_essential_coverage_link, Types::String
  attribute :enroll_without_aptc, Types::String
  attribute :help_text_3, Types::String
  attribute :help_text_4, Types::String
  attribute :help_text_5, Types::String
end
