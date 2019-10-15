# frozen_string_literal: true

class HraAffordabilityDetermination < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year, BenefitYear
  attribute :tenant, Tenant
  attribute :member, Member
  attribute :low_cost_reference_plan, LowCostReferencePlan
  attribute :hra, Hra
end
