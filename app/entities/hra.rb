
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