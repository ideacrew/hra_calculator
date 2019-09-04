class Member < Dry::Struct
  transform_keys(&:to_sym)

  attribute :date_of_birth, Types::Date
  attribute :gross_income, Types::Float
  attribute :income_year, Types::Integer
  attribute :site_address

  attribute :email

end

class SiteAddress < Dry::Struct

  # Use Dry-Validation contract with macros to do conditional validation

  # these are optional values
  attribute :address_1
  attribute :address_2

  # county is necessary to disambiguate if zip code is in more that one county
  attribute :county

  # these are required values
  attribute :state
  attribute :zip_code
end

# Health Reimbursement Arrangement (HRA). A way for small employers to offer health insurance
# benefits to their employees
class Hra < Dry::Struct
  transform_keys(&:to_sym)

  HraMap = { ichra: "Individual Coverage HRA", qsehra: "Qualified Small Employer"  }

  attribute :kind # :ichra or :qsehra
  attribute :benefit_year_id
  attribute :effective_date
  attribute :monthly_reimburse_amount

end

class BenefitYear < Dry::Struct
  transform_keys(&:to_sym)

  attribute :expected_contribution # .0986 in 2020
  attribute :calendar_year, Types::Integer
end

class Plan < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id

  attribute :premium_table_ids
  attribute :service_area_ids

end

class PremiumTable < Dry::Struct
  transform_keys(&:to_sym)

  attribute :plan_id
  attribute :rating_area_id
  attribute :member_age
  attribute :premium_cost
  
end

class UsState < Dry::Struct
  transform_keys(&:to_sym)

end

class UsCounty < Dry::Struct
  transform_keys(&:to_sym)

end

class ZipCode < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id

end

# Plan designation for State's geographic rating areas
# Subject to change based on question posed to SBEs
class LowCostReferencePlan < Dry::Struct

  # Kinds = [:lowest_cost_silver_plan, :second_lowest_cost_silver_plan]
  # Make an enumerated Type
  attribute :kind, Types::LowCostPlan

  attribute :service_area_ids
  attribute :rating_area_ids

end

# Geography where Plans are available
class ServiceArea < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id
  attribute :us_state_id
  attribute :us_county_ids
  attribute :rating_area_ids

end

# Geography within a Service Area where premium rates may be assigned
class RatingArea < Dry::Struct
  transform_keys(&:to_sym)

  attribute :rating_area_id

  attribute :benefit_year_id
  attribute :service_area_id
  attribute :county_ids
  attribute :zip_code_ids

end

# Locations Operation
# Inject SiteAddress
module Locations::Operations
  class SearchForServiceArea
    include Dry::Transaction::Operation

    def call(rating_area)

    end
  end
end

# Locations Operation
# Inject SiteAddress
module Locations::Operations
  class SearchForRatingArea
    include Dry::Transaction::Operation

    def call(site_address)

    end
  end
end

class HraAffordabilityDetermination

  attribute :timestamp
  attribute :benefit_year
  attribute :member
  attribute :hra
  attribute :low_cost_reference_plan
  attribute :hra_cost
  attribute :expected_contribution

end


# Transaction
class DetermineAffordability

  # Dependency Injection
  # - BenefitYear
  # - Member
  # - Hra
  # - LowCostReferencePlan

  def call(params)
    step :find_member_premium
    step :calculate_hra_cost
    step :calculate_expected_contribution
    step :determine_affordability
  end

  def find_member_premium

  end

  def calculate_hra_cost
    low_cost_reference_plan. hra.monthly_reimburse_amount
  end

  def calculate_expected_contribution
    benefit_year.expected_contribution * member.gross_income
  end

  def determine_affordability
    expected_contribution >= hra_cost ? :unaffordable : :affordable
  end


class Employer < Dry::Struct
  transform_keys(&:to_sym)

  attribute :county
  attribute :state
  attribute :zip_code

end

end
