
# Health Reimbursement Arrangement (HRA). A way for small employers to offer health insurance
# benefits to their employees
class Hra < Dry::Struct
  transform_keys(&:to_sym)

  HraMap = { ichra: "Individual Coverage HRA", qsehra: "Qualified Small Employer"  }

  attribute :kind, Types::String # :ichra or :qsehra
  attribute :effective_start_date, Types::Date
  attribute :effective_end_date, Types::Date
  attribute :reimburse_amount, Types::Float
  attribute :reimburse_frequency, Types::Float
  attribute :cost, Types::Float
  attribute :determination, Types::String
end
