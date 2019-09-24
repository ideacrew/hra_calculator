
# Health Reimbursement Arrangement (HRA). A way for small employers to offer health insurance
# benefits to their employees
class Hra < Dry::Struct
  transform_keys(&:to_sym)

  HraMap = { ichra: "Individual Coverage HRA", qsehra: "Qualified Small Employer"  }

  attribute :kind, Types::String # :ichra or :qsehra
  attribute :benefit_year_id, Types::String
  attribute :effective_date, Types::Date
  attribute :monthly_reimburse_amount, Types::Float

end