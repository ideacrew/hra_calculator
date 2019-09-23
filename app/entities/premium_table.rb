class PremiumTable < Dry::Struct
  transform_keys(&:to_sym)

  attribute :plan_id, Types::String
  attribute :rating_area_id, Types::String

  attribute :premium do
    attribute :member_age, Types::Integer
    attribute :monthly_premium, Types::Integer
  end
end
