class PremiumTable < Dry::Struct
  transform_keys(&:to_sym)

  attribute :plan_id
  attribute :rating_area_id

  attribute :premium do
    attribute :member_age
    attribute :monthly_premium
  end
end
