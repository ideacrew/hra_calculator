class HraDetermination
  include Mongoid::Document
  include Mongoid::Timestamps

  field :tenant_key,   type: Symbol
  field :state_name,   type: String
  field :zipcode,   type: String
  field :county,   type: String
  field :dob,   type: Date
  field :household_frequency,   type: String
  field :household_amount,   type: Float
  field :hra_type,   type: Symbol
  field :start_month,   type: Date
  field :end_month,   type: Date
  field :hra_frequency,   type: String
  field :hra_amount,   type: Float
  field :member_premium,   type: Float
  field :age,   type: Integer
  field :hra_cost,   type: Float
  field :hra_determination,   type: String
  field :rating_area_id,   type: BSON::ObjectId
  field :service_area_ids,   type: Array
  field :hios_id,   type: String
  field :plan_name,   type: String
  field :carrier_name,   type: String
  field :expected_contribution, type: Float
end